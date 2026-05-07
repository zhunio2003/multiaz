package com.multiaz.predictionorchestrator.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ModelDTO {

  private String id;
  private String name;
  private String endpointUrl;
  private String status;  
    
}
