package com.multiaz.predictionorchestrator.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.multiaz.predictionorchestrator.model.Prediction;

public interface PredictionRepository extends JpaRepository<Prediction, UUID> {

    
} 
