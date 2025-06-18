package com.ios.datelog.domain.place.web.dto;

import com.ios.datelog.domain.place.entity.Place;
import com.ios.datelog.domain.review.entity.Review;
import com.ios.datelog.domain.review.web.dto.GetReviewRes;

import java.util.List;
import java.util.stream.Collectors;

public record GetPlaceDetailRes(
        String name,
        String content,
        String location,
        String image,
        List<GetReviewRes> reviewList
) {
    public static GetPlaceDetailRes from(Place place) {
        return new GetPlaceDetailRes(
                place.getName(),
                place.getContent(),
                place.getLocation(),
                place.getImage(),
                place.getReviews().stream()
                        .map(GetReviewRes::from)
                        .collect(Collectors.toList())
        );
    }
}
