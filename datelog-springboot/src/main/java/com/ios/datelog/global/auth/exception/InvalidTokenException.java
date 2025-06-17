package com.ios.datelog.global.auth.exception;


import com.ios.datelog.global.exception.BaseException;

public class InvalidTokenException extends BaseException {
    public InvalidTokenException() {
        super(AuthErrorCode.INVALID_TOKEN_401);
    }
}