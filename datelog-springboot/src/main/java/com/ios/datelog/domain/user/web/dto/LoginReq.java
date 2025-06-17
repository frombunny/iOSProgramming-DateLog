package com.ios.datelog.domain.user.web.dto;

public record LoginReq(
        String email,
        String password
) {
}
