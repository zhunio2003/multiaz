package com.multiaz.testservice;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ConfigTestController {

    @Value("${app.message:NO RESPONSE}")
    private String message;

    @GetMapping("/config-test")
    public String getMessage() {
        return this.message;
    }

}