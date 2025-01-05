package com.firefly.bankapp.dao;

import com.firefly.bankapp.entity.ForgotPasswordEntity;
import com.firefly.bankapp.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface ForgotPasswordRepository extends JpaRepository<ForgotPasswordEntity, Integer> {
    @Query("select fp from ForgotPasswordEntity fp where fp.user = ?1 and fp.otp = ?2")
    Optional<ForgotPasswordEntity> findByUserAndOtp(UserEntity user, int otp);
}
