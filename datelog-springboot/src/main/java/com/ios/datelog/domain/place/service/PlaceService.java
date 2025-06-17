package com.ios.datelog.domain.place.service;

import com.ios.datelog.domain.place.entity.enums.Tag;
import com.ios.datelog.domain.place.repository.PlaceRepository;
import com.ios.datelog.domain.place.web.dto.GetPlaceRes;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlaceService {
    private final PlaceRepository placeRepository;

    public List<GetPlaceRes> getPlaceList(Tag tag){
        return placeRepository.findAllByTag(tag)
                .stream()
                .map(GetPlaceRes::of)
                .collect(Collectors.toList());
    }
}
