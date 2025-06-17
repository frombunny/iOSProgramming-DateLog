package com.ios.datelog.domain.review.repository;

import com.ios.datelog.domain.review.entity.Review;
import com.ios.datelog.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findAllByUserOrderByCreatedAtDesc(User user);
}
