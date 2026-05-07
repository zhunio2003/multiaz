package com.multiaz.predictionorchestrator.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.multiaz.predictionorchestrator.dto.PredictionRequestDTO;
import com.multiaz.predictionorchestrator.dto.PredictionResponseDTO;
import com.multiaz.predictionorchestrator.service.PredictionService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RestController
@RequestMapping("/predictions")
public class PredictionController {

  private final PredictionService predictionService;

  @PostMapping
  public ResponseEntity<PredictionResponseDTO> predict(@RequestHeader("X-User-Id") String userId, @RequestBody @Valid PredictionRequestDTO dto) {
    PredictionResponseDTO response = predictionService.predict(userId, dto);
    return ResponseEntity.status(HttpStatus.OK).body(response);
  } 
    
}
