package com.ios.datelog.domain.review.web.dto;

import com.ios.datelog.domain.review.entity.Review;

import java.time.LocalDateTime;

public record GetReviewRes(
        LocalDateTime reviewDate,
        String username,
        String content
) {
    public static GetReviewRes from(Review review) {
        return new GetReviewRes(review.getCreatedAt(),review.getUser().getNickname(), review.getContent());
    }
}
