package com.ios.datelog.domain.record.web.controller;

import com.ios.datelog.domain.record.service.DatelogService;
import com.ios.datelog.domain.record.web.dto.CreateDatelogReq;
import com.ios.datelog.global.auth.UserPrincipal;
import com.ios.datelog.global.response.SuccessResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/datelog")
public class DatelogController {
    private final DatelogService datelogService;

    @PostMapping
    public ResponseEntity<SuccessResponse<Void>> createRecord(@AuthenticationPrincipal UserPrincipal userPrincipal,
                                                              @ModelAttribute @Valid CreateDatelogReq createRecordReq) throws IOException {
        datelogService.createRecord(createRecordReq, userPrincipal);
        return ResponseEntity.ok(SuccessResponse.empty());
    }


}
