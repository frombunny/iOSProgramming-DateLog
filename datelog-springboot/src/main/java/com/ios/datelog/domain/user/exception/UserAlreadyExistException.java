package com.ios.datelog.domain.user.exception;

import com.ios.datelog.global.exception.BaseException;

public class UserAlreadyExistException extends BaseException {
    public UserAlreadyExistException() {super(UserErrorCode.USER_ALREADY_EXIST_409);}
}
