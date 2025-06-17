package com.ios.datelog.domain.place.exception;

import com.ios.datelog.global.response.code.BaseResponseCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

import static com.ios.datelog.global.constant.StaticValue.CONFLICT;
import static com.ios.datelog.global.constant.StaticValue.NOT_FOUND;

@Getter
@AllArgsConstructor
public enum PlaceErrorCode implements BaseResponseCode {
    PLACE_NOT_FOUND_404("PLACE_NOT_FOUND_404", NOT_FOUND, "존재하지 않는 장소입니다.");

    private final String code;
    private final int httpStatus;
    private final String message;
}
