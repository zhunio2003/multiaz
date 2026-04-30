package com.multiaz.modelregistry.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.multiaz.modelregistry.enums.ModelStatus;
import com.multiaz.modelregistry.exception.ModelNotFoundException;
import com.multiaz.modelregistry.model.AiModel;
import com.multiaz.modelregistry.repository.AiModelRepository;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class ModelService {

  private final AiModelRepository aiModelRepository;

  public AiModel save(AiModel model) {
 
    return aiModelRepository.save(model);

  }

  public AiModel findById(String id) {

    return aiModelRepository.findById(id).orElseThrow(
        () -> new ModelNotFoundException(id));
    
  }

  public List<AiModel> findAllByStatus(String status) {

    ModelStatus modelStatus = ModelStatus.valueOf(status);

    return aiModelRepository.findAllByStatus(modelStatus);

  }

}
