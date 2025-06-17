package com.ios.datelog.global.auth.exception;


import com.ios.datelog.global.exception.BaseException;

public class CanNotAccessException extends BaseException {
    public CanNotAccessException() { super(AuthErrorCode.CAN_NOT_ACCESS_403); }
}
