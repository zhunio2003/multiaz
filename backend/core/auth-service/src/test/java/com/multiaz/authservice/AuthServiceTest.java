package com.multiaz.authservice;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.multiaz.authservice.dto.AuthResponseDTO;
import com.multiaz.authservice.dto.LoginRequestDTO;
import com.multiaz.authservice.dto.RegisterRequestDTO;
import com.multiaz.authservice.model.Role;
import com.multiaz.authservice.model.User;
import com.multiaz.authservice.repository.PasswordResetTokenRepository;
import com.multiaz.authservice.repository.RefreshTokenRepository;
import com.multiaz.authservice.repository.RoleRepository;
import com.multiaz.authservice.repository.UserRepository;
import com.multiaz.authservice.security.JwtService;
import com.multiaz.authservice.service.AuthService;

@ExtendWith(MockitoExtension.class)
public class AuthServiceTest {

  @Mock
  private UserRepository userRepository;

  @Mock
  private RefreshTokenRepository refreshTokenRepository;

  @Mock
  private JwtService jwtService;

  @Mock
  private PasswordResetTokenRepository passworfPasswordResetTokenRepository;

  @Mock
  private PasswordEncoder passwordEncoder;

  @Mock
  private RoleRepository roleRepository;

  @Mock
  private JavaMailSender javaMailSender;

  @InjectMocks
  private AuthService authService;

  @Test
  void loginSuccess() {

    Role role = Role.builder().name("CUSTOMER").build();
    User user = User.builder()
                  .id(UUID.randomUUID())
                  .name("tests")
                  .email("test@gmail.com")
                  .passwordHash("hashPassword")
                  .roles(Set.of(role))
                .build();

    LoginRequestDTO dto = LoginRequestDTO.builder()
                            .email("test@gmail.com")
                            .password("hashedPassword")
                          .build();
    
    when(userRepository.findByEmail(anyString())).thenReturn(Optional.of(user));
    when(passwordEncoder.matches(anyString(), anyString())).thenReturn(true);
    when(jwtService.generateAccessToken(any())).thenReturn("accessToken");
    when(jwtService.generateRefreshToken(any())).thenReturn("refreshToken");

    AuthResponseDTO response = authService.login(dto);

    assertNotNull(response);
    assertNotNull(response.getAccessToken());
    assertNotNull(response.getRefreshToken());
  }

  @Test
  void loginEmailInexistent_throwsBadCredentialsException() {

    LoginRequestDTO dto = LoginRequestDTO.builder()
                            .email("test@gmail.com")
                            .password("12345")
                        .build();
    
    when(userRepository.findByEmail(anyString())).thenReturn(Optional.empty());

    assertThrows(BadCredentialsException.class, () -> authService.login(dto));

  }

  @Test
  void loginPasswordIncorrect_throwsBadCredentialsException() {

    LoginRequestDTO dto = LoginRequestDTO.builder()
                            .email("test@gmail.com")
                            .password("12345")
                        .build();
                    
    User user = User.builder()
                  .id(UUID.randomUUID())
                  .name("tests")
                  .email("test@gmail.com")
                  .passwordHash("hashedPassword")
                .build();

    when(userRepository.findByEmail(anyString())).thenReturn(Optional.of(user));
    
    when(passwordEncoder.matches(anyString(), anyString())).thenReturn(false);

    assertThrows(BadCredentialsException.class, () -> authService.login(dto));
  }
  
  @Test
  void registerEmailAlreadyExistsThrowsException() {
      
    User user = User.builder()
                    .id(UUID.randomUUID())
                    .name("tests")
                    .email("test@gmail.com")
                    .passwordHash("hashedPassword")
                  .build();
                  
    RegisterRequestDTO dto = RegisterRequestDTO.builder()
                            .name("test")
                            .email("test@gmail.com")
                            .password("12345")
                        .build();

    
    when(userRepository.findByEmail(anyString())).thenReturn(Optional.of(user));

    assertThrows(RuntimeException.class, () -> authService.register(dto));

  }

  @Test
  void verifiedEncryptedPassword() {

    Role role = Role.builder().name("CUSTOMER").build();
                
    RegisterRequestDTO dto = RegisterRequestDTO.builder()
                            .name("test")
                            .email("test@gmail.com")
                            .password("12345")
                        .build();

    
    when(userRepository.findByEmail(anyString())).thenReturn(Optional.empty());
    when(roleRepository.findByName(anyString())).thenReturn(Optional.of(role));
    when(jwtService.generateAccessToken(any())).thenReturn("accessToken");
    when(jwtService.generateRefreshToken(any())).thenReturn("refreshToken");

    authService.register(dto);

    verify(passwordEncoder).encode("12345");
  }

  

}
