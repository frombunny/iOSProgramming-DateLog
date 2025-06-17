package com.ios.datelog.global.exception;

import com.ios.datelog.domain.user.exception.UserErrorCode;
import com.ios.datelog.global.auth.exception.AuthErrorCode;
import com.ios.datelog.global.response.ErrorResponse;
import com.ios.datelog.global.response.code.GlobalErrorCode;
import jakarta.security.auth.message.AuthException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.validation.BindException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.support.MissingServletRequestPartException;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    /**
     * javax.validation.Valid or @Validated 으로 binding error 발생시 발생
     * 주로 @RequestBody, @RequestPart 어노테이션에서 발생
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    private ResponseEntity<ErrorResponse<?>> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        log.error("MethodArgumentNotValidException : {}", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.of(GlobalErrorCode.INVALID_HTTP_MESSAGE_BODY,
                e.getFieldError().getDefaultMessage());
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }

    /**
     * binding error 발생 시 BindingException 발생(타입 불일치, 형식 오류, Bean Validation 등)
     */
    @ExceptionHandler(BindException.class)
    private ResponseEntity<ErrorResponse<?>> handleBindException(BindException e) {
        log.error("BindException : {}", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.from(GlobalErrorCode.INVALID_HTTP_MESSAGE_BODY);
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }

    /**
     * enum type이 일치하지 않아 binding하지 못할 경우 발생
     */
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    private ResponseEntity<ErrorResponse<?>> handleMethodArgumentTypeMismatchException(MethodArgumentTypeMismatchException e) {
        log.error("MethodArgumentTypeMismatchException Error : {} ", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.from(GlobalErrorCode.INVALID_HTTP_MESSAGE_BODY);
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }

    /**
     * 지원하지 않는 HTTP 메소드를 호출할 경우 발생
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    private ResponseEntity<ErrorResponse<?>> handleHttpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
        log.error("HttpRequestMethodNotSupportedException Error : {} ", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.from(GlobalErrorCode.INVALID_HTTP_MESSAGE_BODY);
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }

    /**
     * 로그인 시 존재하지 않는 사용자일 때
     */
    @ExceptionHandler(UsernameNotFoundException.class)
    public ResponseEntity<ErrorResponse<?>> handleUsernameNotFound(UsernameNotFoundException e) {
        log.error("UsernameNotFoundException Error : {} ", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.from(UserErrorCode.USER_NOT_FOUND_404);
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }

    /**
     * 로그인 시 비밀번호가 일치하지 않을 떄
     */
    @ExceptionHandler(BadCredentialsException.class)
    private ResponseEntity<ErrorResponse<?>> handleBadCredentialsException(BadCredentialsException e) {
        log.error("BadCredentialsException Error : {} ", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.from(AuthErrorCode.UNAUTHORIZED_401);
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }


    /**
     * Request 값을 읽을 수 없는 경우 발생(JSON 불일치, 데이터 타입 불일치 등)
     */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    private ResponseEntity<ErrorResponse<?>> handleHttpMessageNotReadableException(HttpMessageNotReadableException e) {
        log.error("HttpMessageNotReadableException Error : {} ", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.from(GlobalErrorCode.BAD_REQUEST_ERROR);
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }

    /**
     * 비즈니스 로직 에러 발생
     */
    @ExceptionHandler(BaseException.class)
    private ResponseEntity<ErrorResponse<?>> handleBaseException(BaseException e) {
        log.error("Business Error : {}", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.from(e.getBaseResponseCode());
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }

    /**
     * RequestPart 누락 시 발생
     */
    @ExceptionHandler(MissingServletRequestPartException.class)
    private ResponseEntity<ErrorResponse<?>> handleMissingServletRequestPartException(MissingServletRequestPartException e) {
        log.error("MissingServletRequestParameterException Error : {}", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.of(GlobalErrorCode.BAD_REQUEST_ERROR,
                e.getRequestPartName()+" 파트가 요청에 없습니다.");
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }

    /**
     * 나머지 예외 처리
     */
    @ExceptionHandler(Exception.class)
    private ResponseEntity<ErrorResponse<?>> handleException(Exception e) {
        log.error("Exception Error : {}", e.getMessage(), e);
        ErrorResponse<?> errorResponse = ErrorResponse.from(GlobalErrorCode.SERVER_ERROR);
        return ResponseEntity.status(errorResponse.getHttpStatus()).body(errorResponse);
    }
}
