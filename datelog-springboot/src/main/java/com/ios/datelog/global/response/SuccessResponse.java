package com.ios.datelog.global.response;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import com.ios.datelog.global.response.code.BaseResponseCode;
import com.ios.datelog.global.response.code.GlobalSuccessCode;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@JsonPropertyOrder({"isSuccess", "timestamp", "code", "httpStatus", "message", "data"})
public class SuccessResponse<T> extends BaseResponse {
    private final int httpStatus;
    private final T data;

    @Builder
    private SuccessResponse(T data, BaseResponseCode baseResponseCode) {
        super(true, baseResponseCode.getCode(), baseResponseCode.getMessage());
        this.data = data;
        this.httpStatus = baseResponseCode.getHttpStatus();
    }

    // 단순 200 응답
    public static <T> SuccessResponse<T> from(T data) {
        return new SuccessResponse<>(data, GlobalSuccessCode.SUCCESS_OK);
    }

    // 커스텀 성공 응답
    public static <T> SuccessResponse<T> of(T data, BaseResponseCode baseResponseCode) {
        return new SuccessResponse<>(data, baseResponseCode);
    }

    // 데이터 없이 성공 응답
    public static <T> SuccessResponse<T> empty(){
        return new SuccessResponse<>(null, GlobalSuccessCode.SUCCESS_OK);
    }
}
