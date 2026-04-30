package com.multiaz.modelregistry.model;

import java.time.LocalDateTime;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import com.multiaz.modelregistry.enums.ModelStatus;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(collection = "ai_models")
public class AiModel {

  @Id
  private String id;

  private String name;

  private String description;

  private String type;

  private ModelStatus status;

  private String endpointUrl;

  private String inputSchema;

  private String outputSchema;

  private String version;
  
  @CreatedDate
  private LocalDateTime createdAt;

}
