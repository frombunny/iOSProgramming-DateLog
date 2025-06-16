package com.ios.datelog.global.external.exception;

import com.ios.datelog.global.exception.BaseException;

public class FileUploadFailedException extends BaseException {
    public FileUploadFailedException() {super(ExternalErrorCode.FILE_UPLOAD_FAILED_500);}
}
