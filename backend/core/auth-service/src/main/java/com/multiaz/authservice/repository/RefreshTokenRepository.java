package com.multiaz.authservice.repository;

import org.springframework.data.repository.CrudRepository;

import com.multiaz.authservice.model.RefreshToken;

public interface RefreshTokenRepository extends CrudRepository<RefreshToken, String> {

}
