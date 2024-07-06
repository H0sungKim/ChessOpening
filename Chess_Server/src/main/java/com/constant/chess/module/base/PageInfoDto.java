package com.constant.chess.module.base;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PageInfoDto {
    private int totalPages;
    private int currentPage;
    private long totalRows;
    private int pageSize;
}
