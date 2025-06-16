package com.ios.datelog.global.external.exception;

import com.ios.datelog.global.response.code.BaseResponseCode;
import lombok.AllArgsConstructor;
import lombok.Getter;

import static com.ios.datelog.global.constant.StaticValue.*;

@Getter
@AllArgsConstructor
public enum ExternalErrorCode implements BaseResponseCode {
    // s3
    FILE_UPLOAD_FAILED_500("FILE_UPLOAD_FAILED_500", INTERNAL_SERVER_ERROR, "파일 업로드에 실패하였습니다.");

    private final String code;
    private final int httpStatus;
    private final String message;
}
