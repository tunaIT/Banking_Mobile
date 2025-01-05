package com.firefly.bankapp.dao;

import com.firefly.bankapp.entity.UserEntity;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface UserDao extends CrudRepository<UserEntity, Integer> {
    Optional<UserEntity> findByEmail(String email);
    Optional<UserEntity> findByCardNumber(String cardNumber);
    @Modifying
    @Transactional
    @Query("update UserEntity u set u.password = ?2 where u.email = ?1")
    void updatePassword(String email, String newPassword);
}
