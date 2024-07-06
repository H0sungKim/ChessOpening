package com.constant.chess.util;

import com.constant.chess.module.base.CursorInfoDto;
import com.constant.chess.module.base.PageInfoDto;
import com.constant.chess.module.base.RootResponseDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

public class ResponseUtil {
    // Public Inner Class, Struct, Enum, Interface
    // Public Constant
    // Private Constant
    // Public Variable
    // ----------------------------------------------------
    // Private Variable
    private static ResponseUtil instance;

    // ----------------------------------------------------
    // Override Method or Basic Method
    private ResponseUtil() {}

    // ----------------------------------------------------
    // Public Method
    public static ResponseUtil getInstance() {
        if (instance == null) {
            synchronized (ResponseUtil.class) {
                instance = new ResponseUtil();
            }
        }

        return instance;
    }

    public ResponseEntity<RootResponseDto> getResponseEntity(HttpStatus status) {
        RootResponseDto rootResponseDto = getRootResponse(status, null, null, null);
        return new ResponseEntity<RootResponseDto>(rootResponseDto, HttpStatus.valueOf(status.value()));
    }

    public ResponseEntity<RootResponseDto> getResponseEntity(HttpStatus status, Object responseData) {
        RootResponseDto rootResponseDto = getRootResponse(status, responseData, null, null);
        return new ResponseEntity<RootResponseDto>(rootResponseDto, HttpStatus.valueOf(status.value()));
    }

    public ResponseEntity<RootResponseDto> getResponseEntity(
            HttpStatus status, Object responseData, PageInfoDto pageInfoDto) {
        RootResponseDto rootResponseDto = getRootResponse(status, responseData, pageInfoDto, null);
        return new ResponseEntity<RootResponseDto>(rootResponseDto, HttpStatus.valueOf(status.value()));
    }

    public ResponseEntity<RootResponseDto> getResponseEntity(
            HttpStatus status,
            Object responseData,
            PageInfoDto pageInfoDto,
            CursorInfoDto cursorInfoDto) {
        RootResponseDto rootResponseDto =
                getRootResponse(status, responseData, pageInfoDto, cursorInfoDto);
        return new ResponseEntity<RootResponseDto>(rootResponseDto, HttpStatus.valueOf(status.value()));
    }

    public RootResponseDto getRootResponse(
            HttpStatus status,
            Object responseData,
            PageInfoDto pageInfoDto,
            CursorInfoDto cursorInfoDto) {
        return new RootResponseDto(
                status.value(), status.getReasonPhrase(), responseData, pageInfoDto, cursorInfoDto);
    }
}
