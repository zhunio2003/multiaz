package com.multiaz.authservice.service;

import java.util.Set;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.multiaz.authservice.dto.AuthResponseDTO;
import com.multiaz.authservice.dto.LoginRequestDTO;
import com.multiaz.authservice.dto.RegisterRequestDTO;
import com.multiaz.authservice.model.Role;
import com.multiaz.authservice.model.User;
import com.multiaz.authservice.repository.RoleRepository;
import com.multiaz.authservice.repository.UserRepository;
import com.multiaz.authservice.security.JwtService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class AuthService {
  
  private final UserRepository userRepository;
  private final RoleRepository roleRepository;
  private final PasswordEncoder passwordEncoder;
  private final JwtService jwtService;

  public AuthResponseDTO register(RegisterRequestDTO dto) {

    if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
      throw new RuntimeException("Email already registered");
    }

    String hashedPassword = passwordEncoder.encode(dto.getPassword());

    Role role = roleRepository.findByName("CUSTOMER")
        .orElseThrow(() -> new RuntimeException("Role not found"));


    User user = User.builder()
      .name(dto.getName())
      .email(dto.getEmail())
      .passwordHash(hashedPassword)
      .roles(Set.of(role))
      .build();
    
    userRepository.save(user);

    return new AuthResponseDTO(
      jwtService.generateAccessToken(user), 
      jwtService.generateRefreshToken(user)
    );
  }


  public AuthResponseDTO login(LoginRequestDTO request) {

    User user = userRepository.findByEmail(request.getEmail()).
      orElseThrow(() -> new BadCredentialsException("Credenciales incorrectas"));

    if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
      throw new BadCredentialsException("Credenciales incorrectas");
    }

    return new AuthResponseDTO(
      jwtService.generateAccessToken(user), 
      jwtService.generateRefreshToken(user)
    );

  }

}
