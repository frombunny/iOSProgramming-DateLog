package com.ios.datelog.global.auth.exception;

import com.ios.datelog.global.response.code.BaseResponseCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

import static com.ios.datelog.global.constant.StaticValue.*;


@Getter
@AllArgsConstructor
public enum AuthErrorCode implements BaseResponseCode {
    INVALID_TOKEN_401("INVALID_TOKEN_401", UNAUTHORIZED, "토큰 값을 확인해주세요."),
    UNAUTHORIZED_401("UNAUTHORIZED_401", UNAUTHORIZED, "인증되지 않은 사용자입니다."),
    CAN_NOT_ACCESS_403("CAN_NOT_ACCESS_403", FORBIDDEN, "접근 권한이 없습니다.");

    private final String code;
    private final int httpStatus;
    private final String message;
}