package com.ios.datelog.global.response;

import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import com.ios.datelog.global.response.code.BaseResponseCode;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@JsonPropertyOrder({"isSuccess", "timestamp", "code", "httpStatus", "message", "data"})
public class ErrorResponse<T> extends BaseResponse {
    private final int httpStatus;
    private final T data;

    @Builder
    private ErrorResponse(T data, String code, String message, int httpStatus) {
        super(false, code, message);
        this.data = data;
        this.httpStatus = httpStatus;
    }

    // 추가 데이터 없이 표준 코드+메시지만 담는 단순한 에러 응답
    public static ErrorResponse<?> from(BaseResponseCode baseResponseCode) {
        return new ErrorResponse<>(null, baseResponseCode.getCode(), baseResponseCode.getMessage(),
                baseResponseCode.getHttpStatus());
    }

    // data 는 null이지만, ErrorResponse<T> 라벨을 유지해 호출부가 타입 캐스팅 없이 변수 및 파라미터에 담을 수 있게 함
    public static <T> ErrorResponse<T> of(BaseResponseCode baseResponseCode, String message) {
        return new ErrorResponse<>(null, baseResponseCode.getCode(), message, baseResponseCode.getHttpStatus());
    }

    // message와 함께 T 타입의 data를 담아 ErrorResponse<T>로 반환
    public static <T> ErrorResponse<T> of(BaseResponseCode baseResponseCode, String message, T data) {
        return new ErrorResponse<>(data, baseResponseCode.getCode(), message, baseResponseCode.getHttpStatus());

    }
}
