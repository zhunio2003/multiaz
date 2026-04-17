package com.multiaz.authservice.service;

import java.time.LocalDateTime;
import java.util.Set;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.multiaz.authservice.dto.AuthResponseDTO;
import com.multiaz.authservice.dto.LoginRequestDTO;
import com.multiaz.authservice.dto.LogoutRequestDTO;
import com.multiaz.authservice.dto.RefreshRequestDTO;
import com.multiaz.authservice.dto.RegisterRequestDTO;
import com.multiaz.authservice.model.RefreshToken;
import com.multiaz.authservice.model.Role;
import com.multiaz.authservice.model.User;
import com.multiaz.authservice.repository.RefreshTokenRepository;
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
  private final RefreshTokenRepository refreshTokenRepository;

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

    String access = jwtService.generateAccessToken(user);
    String refresh = jwtService.generateRefreshToken(user);

    createAndSaveRefreshToken(user, refresh);

    return AuthResponseDTO.builder()
      .accessToken(access)
      .refreshToken(refresh)
      .build();

  }


  public AuthResponseDTO login(LoginRequestDTO request) {

    User user = userRepository.findByEmail(request.getEmail()).
      orElseThrow(() -> new BadCredentialsException("Credenciales incorrectas"));

    if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
      throw new BadCredentialsException("Credenciales incorrectas");
    }

    String access = jwtService.generateAccessToken(user);
    String refresh = jwtService.generateRefreshToken(user);

    createAndSaveRefreshToken(user, refresh);

    return AuthResponseDTO.builder()
      .accessToken(access)
      .refreshToken(refresh)
      .build();

  }

  public void logout(LogoutRequestDTO dto) {
      
    refreshTokenRepository.findById(dto.getRefreshToken()).ifPresent(token -> {
      token.setUsed(true);
      refreshTokenRepository.save(token);
    });
      
  }

  public AuthResponseDTO refreshToken(RefreshRequestDTO dto) {

    RefreshToken refreshToken = refreshTokenRepository.findById(dto.getRefreshToken()).
      orElseThrow(() -> new RuntimeException("Refresh Token no found"));

    if (refreshToken.isUsed()) {
      throw new RuntimeException("Refresh Token already used");      
    }

    refreshToken.setUsed(true);

    refreshTokenRepository.save(refreshToken);

    User user = userRepository.findById(refreshToken.getUserId()).
      orElseThrow(() -> new RuntimeException("User not found"));

    String access = jwtService.generateAccessToken(user);
    String refresh = jwtService.generateRefreshToken(user);

    createAndSaveRefreshToken(user, refresh);

    return AuthResponseDTO.builder()
      .accessToken(access)
      .refreshToken(refresh)
      .build();
    
  }

  private void createAndSaveRefreshToken(User user, String token) {

    RefreshToken refreshToken = RefreshToken.builder()
      .id(token)
      .userId(user.getId())
      .expiresAt(LocalDateTime.now().plusDays(7))
      .used(false)
      .build();
    
      refreshTokenRepository.save(refreshToken);

  }

}
