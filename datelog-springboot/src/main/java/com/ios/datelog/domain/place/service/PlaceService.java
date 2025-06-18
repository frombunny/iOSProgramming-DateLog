package com.ios.datelog.domain.place.service;

import com.ios.datelog.domain.place.entity.Place;
import com.ios.datelog.domain.place.entity.enums.Tag;
import com.ios.datelog.domain.place.repository.PlaceRepository;
import com.ios.datelog.domain.place.web.dto.GetPlaceDetailRes;
import com.ios.datelog.domain.place.web.dto.GetPlaceRes;
import com.ios.datelog.domain.review.entity.Review;
import com.ios.datelog.domain.review.repository.ReviewRepository;
import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.domain.user.repository.UserRepository;
import com.ios.datelog.global.auth.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlaceService {
    private final PlaceRepository placeRepository;
    private final UserRepository userRepository;
    private final ReviewRepository reviewRepository;

    public List<GetPlaceRes> getPlaceList(Tag tag, String keyword){
        return placeRepository.findAllByTagAndNameContainingIgnoreCase(tag, keyword)
                .stream()
                .map(GetPlaceRes::from)
                .collect(Collectors.toList());
    }

    public List<GetPlaceRes> getRecentPlaceList(UserPrincipal userPrincipal){
        User user = userRepository.getUserById(userPrincipal.getId());

        List<Place> placeList = reviewRepository.findAllByUserOrderByCreatedAtDesc(user)
                .stream()
                .map(Review::getPlace)
                .toList();

        return placeList.stream()
                .map(GetPlaceRes::from)
                .collect(Collectors.toList());
    }

    public GetPlaceDetailRes getPlace(Long placeId){
        Place place = placeRepository.getPlaceById(placeId);
        return GetPlaceDetailRes.from(place);
    }

    public List<GetPlaceRes> getRandomPlaceList(){
        return placeRepository.findRandomFivePlaces().stream()
                .map(GetPlaceRes::from)
                .collect(Collectors.toList());
    }
}
