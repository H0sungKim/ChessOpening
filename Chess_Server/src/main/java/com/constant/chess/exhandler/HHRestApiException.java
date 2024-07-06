package com.constant.chess.exhandler;

import com.constant.chess.module.base.HHResponseCode;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class HHRestApiException extends RuntimeException {

    private final HHResponseCode hhResponseCode;
}
