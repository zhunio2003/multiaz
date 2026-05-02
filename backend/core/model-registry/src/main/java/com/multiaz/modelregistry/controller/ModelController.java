package com.multiaz.modelregistry.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.multiaz.modelregistry.model.AiModel;
import com.multiaz.modelregistry.service.ModelService;

import lombok.RequiredArgsConstructor;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;



@RequiredArgsConstructor
@RestController
@RequestMapping("/models")
public class ModelController {

  private final ModelService modelService;

  @PostMapping("")
  public ResponseEntity<AiModel> save(@RequestBody AiModel request) {
      
    AiModel model = modelService.save(request);
      return ResponseEntity.status(HttpStatus.CREATED).body(model);
  }
  
  @GetMapping("/models")
  public ResponseEntity<List<AiModel>> findAllByStatus(@RequestParam String status) {
      List<AiModel> models = modelService.findAllByStatus(status);
      return ResponseEntity.status(HttpStatus.OK).body(models);
  }
  @GetMapping("/{id}")
  public ResponseEntity<AiModel> findById(@PathVariable String id) {
      AiModel model = modelService.findById(id);
      return ResponseEntity.status(HttpStatus.OK).body(model);
  }
  
  

}
