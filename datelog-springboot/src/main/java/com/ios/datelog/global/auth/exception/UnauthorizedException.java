package com.ios.datelog.global.auth.exception;

import com.ios.datelog.global.exception.BaseException;

public class UnauthorizedException extends BaseException {
    public UnauthorizedException() {super(AuthErrorCode.UNAUTHORIZED_401);}
}
