package com.ios.datelog.domain.user.exception;

import com.ios.datelog.global.exception.BaseException;

public class CanNotAccessException extends BaseException {
    public CanNotAccessException() {super(UserErrorCode.CAN_NOT_ACCESS_403);}
}
