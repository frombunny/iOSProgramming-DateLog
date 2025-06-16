package com.ios.datelog.domain.user.web.controller;

import com.ios.datelog.domain.user.service.UserService;
import com.ios.datelog.domain.user.web.dto.SignUpReq;
import com.ios.datelog.global.response.SuccessResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {
    private final UserService userService;

    @PostMapping
    public ResponseEntity<SuccessResponse<Void>> signUp(@ModelAttribute @Valid SignUpReq signUpReq) throws IOException {
        userService.signUp(signUpReq);
        return ResponseEntity.ok(SuccessResponse.empty());
    }
}
