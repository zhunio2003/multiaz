package com.multiaz.authservice.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.multiaz.authservice.dto.AuthResponseDTO;
import com.multiaz.authservice.dto.LoginRequestDTO;
import com.multiaz.authservice.dto.LogoutRequestDTO;
import com.multiaz.authservice.dto.PasswordRecoverRequestDTO;
import com.multiaz.authservice.dto.RefreshRequestDTO;
import com.multiaz.authservice.dto.RegisterRequestDTO;
import com.multiaz.authservice.service.AuthService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RequiredArgsConstructor
@RestController
@RequestMapping("/auth")
public class AuthController {

  private final AuthService authService;

  @PostMapping("/register")
  public ResponseEntity<AuthResponseDTO> register(@Valid @RequestBody RegisterRequestDTO dto) {
      
    AuthResponseDTO response = authService.register(dto);
      return ResponseEntity.status(HttpStatus.CREATED).body(response);
  } 

  @PostMapping("/login")
  public ResponseEntity<AuthResponseDTO> login(@Valid @RequestBody LoginRequestDTO dto) {
      
    AuthResponseDTO response = authService.login(dto);
      
      return ResponseEntity.status(HttpStatus.OK).body(response);
  }

  @PostMapping("/logout")
  public ResponseEntity<Void> logout(@Valid @RequestBody LogoutRequestDTO dto) {
      
    authService.logout(dto);    

    return ResponseEntity.ok().build();

  }

  @PostMapping("/refresh")
  public ResponseEntity<AuthResponseDTO> refreshToken(@Valid @RequestBody RefreshRequestDTO dto) {
      
    AuthResponseDTO response = authService.refreshToken(dto);    

    return ResponseEntity.status(HttpStatus.OK).body(response);

  }

  @PostMapping("/recover")
  public ResponseEntity<Void> recoverPassword(@RequestBody PasswordRecoverRequestDTO dto) {
      
    authService.recoverPassword(dto);
      
    return ResponseEntity.ok().build();
  }
  
  
}
