package com.ios.datelog.domain.place.web.controller;

import com.ios.datelog.domain.place.entity.enums.Tag;
import com.ios.datelog.domain.place.service.PlaceService;
import com.ios.datelog.domain.place.web.dto.GetPlaceRes;
import com.ios.datelog.global.response.SuccessResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/place")
public class PlaceController {
    private final PlaceService placeService;

    @GetMapping
    public ResponseEntity<SuccessResponse<List<GetPlaceRes>>> getPlaceListByTag(@RequestParam Tag tag) {
        List<GetPlaceRes> getPlaceResList = placeService.getPlaceList(tag);
        return ResponseEntity.ok(SuccessResponse.from(getPlaceResList));
    }
}
