package com.ios.datelog.domain.user.web.dto;

import jakarta.validation.constraints.NotBlank;
import org.springframework.web.multipart.MultipartFile;

public record SignUpReq(
        @NotBlank(message = "닉네임은 필수 항목입니다.")
        String nickname,

        @NotBlank(message = "비밀번호는 필수 항목입니다.")
        String password,

        MultipartFile profileImage,

        @NotBlank(message = "이메일은 필수 항목입니다.")
        String email
) {
}
