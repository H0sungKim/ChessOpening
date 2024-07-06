package com.constant.chess.module.base;

import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface
@Data
@AllArgsConstructor
public class RootResponseDto {
    @ApiModelProperty(example = "숫자 결과값 200은 성공")
    private int responseCode;

    @ApiModelProperty(example = "text message로 된 response 값")
    private String responseMessage;

    @ApiModelProperty(example = "실제 데이타")
    private Object responseData;

    @ApiModelProperty(example = "offset 기반의 Pagination")
    private PageInfoDto pageInfo;

    @ApiModelProperty(example = "cursor 기반의 Pagination")
    private CursorInfoDto cursorInfo;

    public RootResponseDto(HHResponseCode code) {
        super();
        this.responseCode = code.getStatusCode();
        this.responseMessage = code.getStatusMessage();
        this.responseData = null;
        this.pageInfo = null;
        this.cursorInfo = null;
    }
}
