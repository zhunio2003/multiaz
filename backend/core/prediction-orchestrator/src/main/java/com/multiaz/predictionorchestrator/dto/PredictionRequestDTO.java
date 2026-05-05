package com.multiaz.predictionorchestrator.dto;

import java.util.Map;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PredictionRequestDTO {

    @NotBlank
    private String modelId;

    @NotNull
    private Map<String, Object> inputData;

}
