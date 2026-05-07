package com.multiaz.predictionorchestrator.service;

import java.time.LocalDateTime;
import java.util.Map;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.multiaz.predictionorchestrator.client.ModelRegistryClient;
import com.multiaz.predictionorchestrator.dto.ModelDTO;
import com.multiaz.predictionorchestrator.dto.PredictionRequestDTO;
import com.multiaz.predictionorchestrator.dto.PredictionResponseDTO;
import com.multiaz.predictionorchestrator.enums.PredictionStatus;
import com.multiaz.predictionorchestrator.model.Prediction;
import com.multiaz.predictionorchestrator.repository.PredictionRepository;

import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;

@RequiredArgsConstructor
@Service
public class PredictionService {
    
  private final ModelRegistryClient modelRegistryClient;
  private final PredictionRepository predictionRepository;
  private final WebClient.Builder webClientBuilder;

  public PredictionResponseDTO predict(String userId, PredictionRequestDTO dto) {

    ModelDTO model = modelRegistryClient.getModelById(dto.getModelId());

    if (!model.getStatus().equals("ACTIVE")) {
      throw new RuntimeException("Model is not active " + dto.getModelId());  
    }

    Prediction prediction = Prediction.builder()
        .userId(userId)
        .modelId(model.getId())
        .modelName(model.getName())
        .status(PredictionStatus.PENDING)
        .inputData(dto.getInputData())
        .build();

    predictionRepository.save(prediction);

    try {
      // Call IA
      Map<String, Object> aiResult = webClientBuilder
                                              .baseUrl(model.getEndpointUrl())
                                              .build()
                                              .post()
                                              .uri("/prediction/")
                                              .retrieve()
                                              .onStatus(
                                                status -> status.value() == 404,
                                                response -> Mono.error(new RuntimeException("IA not found " + model.getName()))
                                              )
                                              .bodyToMono(new ParameterizedTypeReference<Map<String,Object>>() {})
                                              .block();

      PredictionResponseDTO responseDTO = PredictionResponseDTO.builder()
                                            .modelId(model.getId())
                                            .modelName(model.getName())
                                            .predictionId(prediction.getId().toString())
                                            .status(PredictionStatus.COMPLETED)
                                            .result(aiResult)
                                            .createdAt(prediction.getCreatedAt())
                                            .build();

      prediction.setStatus(PredictionStatus.COMPLETED);
      prediction.setOutputData(responseDTO.getResult());

      return responseDTO;

    } catch (Exception e) {

      prediction.setStatus(PredictionStatus.FAILED);
      throw new RuntimeException("IA service ERROR: " + e.getMessage());

    } finally {

      prediction.setCompletedAt(LocalDateTime.now());
      predictionRepository.save(prediction);

    }

  }

}
