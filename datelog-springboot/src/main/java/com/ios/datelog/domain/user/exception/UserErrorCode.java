package com.ios.datelog.domain.user.exception;

import com.ios.datelog.global.response.code.BaseResponseCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

import static com.ios.datelog.global.constant.StaticValue.*;

@Getter
@AllArgsConstructor
public enum UserErrorCode implements BaseResponseCode {
    USER_NOT_FOUND_404("USER_NOT_FOUND_404", NOT_FOUND, "존재하지 않는 사용자입니다."),
    USER_ALREADY_EXIST_409("USER_ALREADY_EXIST_409", CONFLICT, "이미 존재하는 사용자입니다.");

    private final String code;
    private final int httpStatus;
    private final String message;
}
