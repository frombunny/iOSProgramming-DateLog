package com.ios.datelog.domain.place.exception;

import com.ios.datelog.global.exception.BaseException;

public class PlaceNotFoundException extends BaseException {
    public PlaceNotFoundException() {super(PlaceErrorCode.PLACE_NOT_FOUND_404);}
}
