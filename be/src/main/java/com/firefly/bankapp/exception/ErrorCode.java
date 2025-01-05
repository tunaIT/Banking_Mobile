package com.firefly.bankapp.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ErrorCode {
    USER_EXISTED(1001, "User already existed", HttpStatus.BAD_REQUEST),
    EMAIL_NOT_EXISTED(1001, "Email not already existed", HttpStatus.NOT_FOUND),
    UNCATEGORIZED_EXCEPTION(1002, "Uncategorized exception", HttpStatus.INTERNAL_SERVER_ERROR),
    PERMISSION_NOT_EXISTED(1002, "Permission not already existed", HttpStatus.NOT_FOUND),
    ROLE_NOT_EXISTED(1002, "Role not already existed", HttpStatus.NOT_FOUND),
    OTP_INVALID(1003, "OTP invalid", HttpStatus.FORBIDDEN),
    REPEAT_PASSWORD_INVALID(1003, "Repeat Password not matches", HttpStatus.FORBIDDEN),
    OTP_EXPIRED(1003, "OTP has expired", HttpStatus.FORBIDDEN),
    ;
    private int code;
    private String message;
    private HttpStatusCode httpStatusCode;
    ErrorCode(int code, String message, HttpStatusCode httpStatusCode) {
        this.code = code;
        this.message = message;
        this.httpStatusCode = httpStatusCode;
    }
}
