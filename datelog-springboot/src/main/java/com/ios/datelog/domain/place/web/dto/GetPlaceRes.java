package com.ios.datelog.domain.place.web.dto;

import com.ios.datelog.domain.place.entity.Place;

public record GetPlaceRes(
        Long id,
        String image,
        String name,
        String content
) {
    public static GetPlaceRes of(Place place) {
        return new GetPlaceRes(place.getId(), place.getImage(), place.getName(), place.getContent());
    }
}
