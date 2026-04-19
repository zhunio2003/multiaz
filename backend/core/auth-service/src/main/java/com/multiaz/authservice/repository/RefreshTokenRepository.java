package com.multiaz.authservice.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.repository.CrudRepository;

import com.multiaz.authservice.model.RefreshToken;

public interface RefreshTokenRepository extends CrudRepository<RefreshToken, String> {

    List<RefreshToken> findByUserId(UUID userId);

}
