package com.multiaz.authservice.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HexFormat;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.multiaz.authservice.dto.AuthResponseDTO;
import com.multiaz.authservice.dto.LoginRequestDTO;
import com.multiaz.authservice.dto.LogoutRequestDTO;
import com.multiaz.authservice.dto.PasswordRecoverRequestDTO;
import com.multiaz.authservice.dto.PasswordResetRequestDTO;
import com.multiaz.authservice.dto.RefreshRequestDTO;
import com.multiaz.authservice.dto.RegisterRequestDTO;
import com.multiaz.authservice.model.PasswordResetToken;
import com.multiaz.authservice.model.RefreshToken;
import com.multiaz.authservice.model.Role;
import com.multiaz.authservice.model.User;
import com.multiaz.authservice.repository.PasswordResetTokenRepository;
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
  private final PasswordResetTokenRepository passwordResetTokenRepository;
  private final JavaMailSender mailSender;

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
  

  public void recoverPassword(PasswordRecoverRequestDTO dto) {

    Optional<User> userOptional = userRepository.findByEmail(dto.getEmail());

    if(userOptional.isEmpty()) {
      return;
    }

    User user = userOptional.get();
    
    // Generate Token
    SecureRandom random = new SecureRandom();
    byte[] bytes = new byte[32];
    random.nextBytes(bytes);
    String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    
    // Hashear Token 
    String tokenHash;

    try {

      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      byte[] hashBytes = digest.digest(token.getBytes(StandardCharsets.UTF_8));
      tokenHash = HexFormat.of().formatHex(hashBytes);

    } catch (NoSuchAlgorithmException e) {

      throw new RuntimeException("Algorithm not available");

    }

    PasswordResetToken passwordResetToken = PasswordResetToken.builder()
      .tokenHash(tokenHash)
      .userId(user.getId())
      .expiration(LocalDateTime.now().plusMinutes(15))
      .used(false)
      .build();

    passwordResetTokenRepository.save(passwordResetToken);

    try {
      SimpleMailMessage message = new SimpleMailMessage();
      message.setTo(user.getEmail());
      message.setSubject("Recuperacion de contraseña . MultIAZ");
      message.setText("Tu token de recuperacion es " + token);
      mailSender.send(message);

    } catch (MailException e) {
      throw new RuntimeException("Error sending recovery email" + e);
    }

  }

  public void resetPassword(PasswordResetRequestDTO dto) {
    
    // Hashear Token 
    String tokenHash;

    try {

      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      byte[] hashBytes = digest.digest(dto.getToken().getBytes(StandardCharsets.UTF_8));
      tokenHash = HexFormat.of().formatHex(hashBytes);

    } catch (NoSuchAlgorithmException e) {

      throw new RuntimeException("Algorithm not available");

    }

    Optional<PasswordResetToken> passwordResetTokenOptional = passwordResetTokenRepository.findByTokenHash(tokenHash);

    if (passwordResetTokenOptional.isEmpty()) {
      throw new RuntimeException("CODE ERROR");
    }
    
    PasswordResetToken passwordResetToken = passwordResetTokenOptional.get();

    if (passwordResetToken.isUsed()) {
      throw new RuntimeException("EL CODE WAS USED");
    }

    if (LocalDateTime.now().isAfter(passwordResetToken.getExpiration())) {
      throw new RuntimeException("CODE EXPIRATION");
    }

    String hashedPassword = passwordEncoder.encode(dto.getPassword());
    
    User user = userRepository.findById(passwordResetToken.getUserId()).orElseThrow(() -> new RuntimeException("user not found"));
    user.setPasswordHash(hashedPassword);
    userRepository.save(user);
    
    passwordResetToken.setUsed(true);
    passwordResetTokenRepository.save(passwordResetToken);

    List<RefreshToken> refreshTokens = refreshTokenRepository.findByUserId(user.getId());

    refreshTokenRepository.deleteAll(refreshTokens);

  }


}
