package com.multiaz.modelregistry.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.multiaz.modelregistry.model.AiModel;

public interface AiModelRepository extends MongoRepository<AiModel, String> {

}
