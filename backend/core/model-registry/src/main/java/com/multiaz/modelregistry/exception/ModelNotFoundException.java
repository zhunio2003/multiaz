package com.multiaz.modelregistry.exception;

public class ModelNotFoundException extends RuntimeException {

  public ModelNotFoundException(String id) {
    super("Model not found with id: " + id);
  }

}
