package com.ios.datelog.domain.datelog.web.dto;

import jakarta.validation.constraints.NotBlank;
import org.springframework.web.multipart.MultipartFile;

public record CreateDatelogReq(
        MultipartFile image,

        @NotBlank(message = "장소명은 필수입니다.")
        String name,

        @NotBlank(message = "날짜는 필수입니다.")
        String date,

        String location,

        @NotBlank(message = "제목은 필수입니다.")
        String title,

        String diary
) {}
