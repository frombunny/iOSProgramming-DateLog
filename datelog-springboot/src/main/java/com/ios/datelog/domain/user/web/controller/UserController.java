package com.ios.datelog.domain.user.web.controller;

import com.ios.datelog.domain.user.service.UserService;
import com.ios.datelog.domain.user.web.dto.SignUpReq;
import com.ios.datelog.global.response.SuccessResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;

    @PostMapping
    public ResponseEntity<SuccessResponse<Void>> signUp(@RequestBody @Valid SignUpReq signUpReq) throws Exception {
        userService.signUp(signUpReq);
        return ResponseEntity.ok(SuccessResponse.empty());
    }
}
