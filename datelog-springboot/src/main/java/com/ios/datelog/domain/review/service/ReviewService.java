package com.ios.datelog.domain.review.service;

import com.ios.datelog.domain.place.entity.Place;
import com.ios.datelog.domain.place.repository.PlaceRepository;
import com.ios.datelog.domain.review.entity.Review;
import com.ios.datelog.domain.review.repository.ReviewRepository;
import com.ios.datelog.domain.review.web.dto.CreateReviewReq;
import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.domain.user.repository.UserRepository;
import com.ios.datelog.global.auth.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ReviewService {
    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final PlaceRepository placeRepository;

    @Transactional
    public void createReview(CreateReviewReq createReviewReq, Long placeId, UserPrincipal userPrincipal){
        User user = userRepository.getUserById(userPrincipal.getId());

        Place place = placeRepository.getPlaceById(placeId);

        Review review = Review.toEntity(user, place, createReviewReq);
        place.addReview(review);
        reviewRepository.save(review);
    }
}
