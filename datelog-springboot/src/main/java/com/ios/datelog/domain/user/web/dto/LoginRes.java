package com.ios.datelog.domain.user.web.dto;

public record LoginRes(
        String token
) {
    public static LoginRes from(String token) { return new LoginRes(token); }
}
