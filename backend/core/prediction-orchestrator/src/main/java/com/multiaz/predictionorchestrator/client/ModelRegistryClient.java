package com.multiaz.predictionorchestrator.client;

import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import com.multiaz.predictionorchestrator.dto.ModelDTO;

import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;

@RequiredArgsConstructor
@Component
public class ModelRegistryClient {
  private final WebClient.Builder webClientBuilder;
  
  public ModelDTO getModelById(String id) {

    return webClientBuilder
        .baseUrl("lb://model-registry")
        .build()
        .get()
        .uri("/models/" + id)
        .retrieve()
        .onStatus(
          status -> status.value() == 404, 
          response -> Mono.error(new RuntimeException("Model not found:" + id))
        )
        .bodyToMono(ModelDTO.class)
        .block();
  } 
}
