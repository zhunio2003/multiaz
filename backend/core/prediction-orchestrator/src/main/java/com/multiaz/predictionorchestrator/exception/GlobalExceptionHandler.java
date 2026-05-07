package com.multiaz.predictionorchestrator.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(ModelNotFoundException.class)
  public ResponseEntity<String> handlerModelNotFoundException(ModelNotFoundException ex) {
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Model is no FOUND");
  }  

  @ExceptionHandler(ModelNotActiveException.class)
  public ResponseEntity<String> handlerModelNotActimeException(ModelNotActiveException ex) {
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Model is no ACTIVE");
  }

  @ExceptionHandler(AiServiceException.class)
  public ResponseEntity<String> handlerAiServiceException(AiServiceException ex) {
    return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body("IA SERVICE ERROR");
  }
    
    
}