package com.multiaz.predictionorchestrator.dto;

import java.time.LocalDateTime;
import java.util.Map;

import com.multiaz.predictionorchestrator.enums.PredictionStatus;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PredictionResponseDTO {

    private String modelId;
    private LocalDateTime createdAt;
    private PredictionStatus status;
    private String modelName;
    private String predictionId;
    private Map<String, Object> result;

}
