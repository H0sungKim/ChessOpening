package com.constant.chess.module.base;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CursorInfoDto {
    private Long cursor;
    private boolean hasNext;
}
