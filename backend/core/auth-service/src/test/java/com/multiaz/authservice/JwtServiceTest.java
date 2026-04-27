package com.multiaz.authservice;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Date;
import java.util.Set;
import java.util.UUID;

import javax.crypto.SecretKey;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import com.multiaz.authservice.model.Role;
import com.multiaz.authservice.model.User;
import com.multiaz.authservice.security.JwtService;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

@ExtendWith(MockitoExtension.class)
public class JwtServiceTest {

  private JwtService jwtService;

  @BeforeEach
  void setup() {
    jwtService = new JwtService();

    ReflectionTestUtils.setField(jwtService, "secretString", "dGVzdFNlY3JldEtleUZvckp3dFRlc3RpbmdQdXJwb3Nlc09ubHkxMjM0NTY3OA==");

  }

  @Test
  void generatedAccessTokenWithCorrectClaims() {

    SecretKey key  = Keys.hmacShaKeyFor(Decoders.BASE64.decode("dGVzdFNlY3JldEtleUZvckp3dFRlc3RpbmdQdXJwb3Nlc09ubHkxMjM0NTY3OA"));

    User user = User.builder()
                  .id(UUID.randomUUID())
                  .name("test")
                  .email("test@gmail.com")
                  .roles(Set.of(Role.builder().name("CUSTOMER").build()))
                .build();

    String token = jwtService.generateAccessToken(user);

    Claims claims = Jwts.parser()
                      .verifyWith(key)
                      .build()
                      .parseSignedClaims(token)
                      .getPayload();
    
    assertEquals(user.getId().toString(), claims.getSubject());
    assertEquals(user.getEmail(), claims.get("email", String.class));

  }

  @Test
  void verifyExpiredTokenDetection() {

    SecretKey key  = Keys.hmacShaKeyFor(Decoders.BASE64.decode("dGVzdFNlY3JldEtleUZvckp3dFRlc3RpbmdQdXJwb3Nlc09ubHkxMjM0NTY3OA"));

    User user = User.builder()
                  .id(UUID.randomUUID())
                  .name("test")
                  .email("test@gmail.com")
                  .roles(Set.of(Role.builder().name("CUSTOMER").build()))
                .build();

    String token = Jwts.builder()
                    .subject(user.getId().toString())
                    .claim("email", user.getEmail())
                    .claim("role", user.getRoles().iterator().next().getName())
                    .issuedAt(new Date())
                    .expiration(new Date(0))
                    .signWith(key)
                    .compact();

    assertFalse(jwtService.validateToken(token));

  }

}
