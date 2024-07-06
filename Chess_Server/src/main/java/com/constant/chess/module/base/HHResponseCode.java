package com.constant.chess.module.base;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Getter
@NoArgsConstructor
@AllArgsConstructor
public enum HHResponseCode {
    // Login 관련
    MEMBER_NOT_FOUND(40001, "ERROR_MEMBER_NOT_FOUND"),

    // Security 관련 에러
    REFRESH_TOKEN_EXPIRED(40100, "ERROR_REFRESH_TOKEN_EXPIRED"),

    // Rest API 형식 에러
    ILLEGAL_HEADER(40200, "ERROR_ILLEGAL_HEADER"),
    ILLEGAL_BODY(40201, "ERROR_ILLEGAL_BODY"),

    // Board 관련 에러
    NO_PERMISSION(40300, "ERROR_NO_PERMISSION"),

    // Chatting 관련 에러
    BAN_USER(40400, "BAN_USER"),

    // Club 관련 에러
    ALREADY_REGISTER_CLUB(40500, "ALREADY_REGISTER_CLUB"),
    KICKED_OUT_CLUB(40501, "KICKED_OUT_CLUB"),
    CANNOT_WITHDRAWAL_CLUB(40510, "CANNOT_WITHDRAWAL_CLUB"),
    CANNOT_REMOVE_CLUB(40511, "CANNOT_REMOVE_CLUB"),
    CANNOT_REGISTER_PREVIOUS_REGISTER_CLUB(40512, "CANNOT_REGISTER_PREVIOUS_REGISTER_CLUB"),

    // Global 관련 에러
    NO_KEY(40600, "ERROR_NO_KEY"),

    // ETC
    UNKNOWN_ERROR(41000, "UNKNOWN_ERROR"),
    ;

    private Integer statusCode;
    private String statusMessage;
}
