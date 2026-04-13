package com.multiaz.authservice.security;

import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.multiaz.authservice.model.User;

import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService {

  private static final long ACCESS_TOKEN_EXPIRATION = 1000L * 60 * 15;
  private static final long REFRESH_TOKEN_EXPIRATION = 1000L * 60 * 60 * 24 * 7;
  
  @Value("${jwt.secret}")
  private String secretString;

  private SecretKey getSignKey() {
    return Keys.hmacShaKeyFor(Decoders.BASE64.decode(secretString));
  }

  public String generateAccessToken(User user) {
    return buildToken(user, ACCESS_TOKEN_EXPIRATION);
  }

  public String generateRefreshToken(User user) {
    return buildToken(user, REFRESH_TOKEN_EXPIRATION);
  }

  private String buildToken(User user, long expiration) {

    Date now = new Date();
    Date expireDate = new Date(now.getTime() + expiration);

    return Jwts.builder()
      .subject(user.getId().toString())
      .claim("email", user.getEmail())
      .claim("role", user.getRoles().iterator().next().getName())
      .issuedAt(now)
      .expiration(expireDate)
      .signWith(getSignKey())
      .compact();
    
  }
  
  public boolean validateToken(String token) {

    try {
        Jwts.parser()
          .verifyWith(getSignKey())
          .build()
          .parseSignedClaims(token);

        return true;
    } catch (JwtException | IllegalArgumentException e) {
        return false;
    }
  }
}
