package com.ios.datelog.domain.place.web.controller;

import com.ios.datelog.domain.place.entity.enums.Tag;
import com.ios.datelog.domain.place.repository.PlaceRepository;
import com.ios.datelog.domain.place.service.PlaceService;
import com.ios.datelog.domain.place.web.dto.GetPlaceDetailRes;
import com.ios.datelog.domain.place.web.dto.GetPlaceRes;
import com.ios.datelog.global.auth.UserPrincipal;
import com.ios.datelog.global.response.SuccessResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/place")
public class PlaceController {
    private final PlaceService placeService;

    @GetMapping
    public ResponseEntity<SuccessResponse<List<GetPlaceRes>>> getPlaceListByTag(
            @RequestParam(required = false) Tag tag,
            @RequestParam(required = false, defaultValue = "") String keyword){
        List<GetPlaceRes> getPlaceResList = placeService.getPlaceList(tag, keyword);
        return ResponseEntity.ok(SuccessResponse.from(getPlaceResList));
    }

    @GetMapping("{placeId}")
    public ResponseEntity<SuccessResponse<GetPlaceDetailRes>> getPlace(
            @PathVariable final Long placeId
    ){
        GetPlaceDetailRes getPlaceDetailRes = placeService.getPlace(placeId);
        return ResponseEntity.ok(SuccessResponse.from(getPlaceDetailRes));
    }

    @GetMapping("/recent")
    public ResponseEntity<SuccessResponse<List<GetPlaceRes>>> getRecentPlaceList(
            @AuthenticationPrincipal UserPrincipal userPrincipal){
        List<GetPlaceRes> getPlaceResList = placeService.getRecentPlaceList(userPrincipal);
        return ResponseEntity.ok(SuccessResponse.from(getPlaceResList));
    }

    @GetMapping("/recommend")
    public ResponseEntity<SuccessResponse<List<GetPlaceRes>>> getRecommendPlaceList(){
        List<GetPlaceRes> getPlaceResList = placeService.getRandomPlaceList();
        return ResponseEntity.ok(SuccessResponse.from(getPlaceResList));
    }
}
