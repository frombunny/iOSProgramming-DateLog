package com.ios.datelog.domain.user.exception;

import com.ios.datelog.global.exception.BaseException;

public class UserNotFoundException extends BaseException {
    public UserNotFoundException() {super(UserErrorCode.USER_NOT_FOUND_404);}
}
