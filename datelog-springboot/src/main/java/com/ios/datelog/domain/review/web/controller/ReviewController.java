package com.ios.datelog.domain.review.web.controller;

import com.ios.datelog.domain.review.service.ReviewService;
import com.ios.datelog.domain.review.web.dto.CreateReviewReq;
import com.ios.datelog.global.auth.UserPrincipal;
import com.ios.datelog.global.response.SuccessResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/review")
public class ReviewController {
    private final ReviewService reviewService;

    @PostMapping("{placeId}")
    public ResponseEntity<SuccessResponse<?>> createReview(
            @RequestBody CreateReviewReq createReviewReq,
            @PathVariable Long placeId, @AuthenticationPrincipal UserPrincipal userPrincipal){
        reviewService.createReview(createReviewReq, placeId, userPrincipal);
        return ResponseEntity.ok(SuccessResponse.empty());
    }
}
