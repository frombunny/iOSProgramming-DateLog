package com.ios.datelog.domain.record.exception;

import com.ios.datelog.global.exception.BaseException;

public class DatelogNotFoundException extends BaseException {
    public DatelogNotFoundException() {super(DatelogErrorCode.DATELOG_NOT_FOUND_404);}
}
