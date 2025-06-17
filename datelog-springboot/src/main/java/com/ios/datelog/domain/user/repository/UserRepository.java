package com.ios.datelog.domain.user.repository;

import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.domain.user.exception.UserNotFoundException;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByNickname(String nickname);
    Optional<User> findByEmail(String email);

    default User getUserById(Long id) {
        return findById(id).orElseThrow(UserNotFoundException::new);
    }
}
