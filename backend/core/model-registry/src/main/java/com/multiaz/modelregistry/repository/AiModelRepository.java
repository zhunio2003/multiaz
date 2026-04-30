package com.multiaz.modelregistry.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.multiaz.modelregistry.enums.ModelStatus;
import com.multiaz.modelregistry.model.AiModel;

public interface AiModelRepository extends MongoRepository<AiModel, String> {
  
  List<AiModel> findAllByStatus(ModelStatus status);

}
