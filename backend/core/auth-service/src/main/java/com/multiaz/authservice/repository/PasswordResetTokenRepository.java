package com.multiaz.authservice.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import com.multiaz.authservice.model.PasswordResetToken;

public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, String> {
    Optional<PasswordResetToken> findByTokenHash(String tokenHash);
}
