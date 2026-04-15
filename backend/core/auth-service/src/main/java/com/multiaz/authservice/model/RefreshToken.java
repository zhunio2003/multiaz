package com.multiaz.authservice.model;

import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.redis.core.TimeToLive;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@RedisHash("refresh_token")
public class RefreshToken {

  @Id
  private String id;

  private UUID userId;

  private LocalDateTime expiresAt;

  private boolean used;

  @TimeToLive
  private long ttl = 604800L;
}
