package com.constant.chess.module.global;

import com.constant.chess.exhandler.HHRestApiException;
import com.constant.chess.module.base.HHResponseCode;
import com.constant.chess.module.base.RootResponseDto;
import com.constant.chess.util.ResponseUtil;
import io.swagger.annotations.ApiOperation;
import java.io.IOException;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

// ----------------------------------------------------
// Public Outter Class, Struct, Enum, Interface

@RestController
@RequestMapping("api/v1")
@RequiredArgsConstructor
@Slf4j
public class GlobalController {
    // Public Inner Class, Struct, Enum, Interface
    // Public Constant
    // Private Constant
    private final GlobalRepository globalRepository;
    // Public Variable

    // Private Variable
    // Override Method or Basic Method
    // Public Method
    @ApiOperation(value = "Global - 업데이트 API", notes = "해당하는 key에 value를 저장합니다.")
    @PostMapping("user/global/set")
    public ResponseEntity<RootResponseDto> setGlobal(
            @ModelAttribute GlobalSetRequestDto globalSetRequestDto)
            throws IOException {
        GlobalDao globalDao = globalRepository.findByKey(globalSetRequestDto.key);
        if (globalDao == null) {
            globalRepository.save(
                    new GlobalDao(
                            globalSetRequestDto.key, globalSetRequestDto.value));
        } else {
            globalDao.setValue(globalSetRequestDto.value);
            globalRepository.save(globalDao);
        }
        return ResponseUtil.getInstance().getResponseEntity(HttpStatus.OK);
    }

    @ApiOperation(value = "Global - get API", notes = "해당하는 key에 value를 읽어옵니다.")
    @GetMapping("user/global/get/{key}")
    public ResponseEntity<RootResponseDto> getGlobal(
            @PathVariable("key") String key)
            throws IOException {
        GlobalDao globalDao = globalRepository.findByKey(key);
        if (globalDao == null) {
            throw new HHRestApiException(HHResponseCode.NO_KEY);
        } else {
            return ResponseUtil.getInstance().getResponseEntity(HttpStatus.OK, globalDao.getValue());
        }
    }

    // Private Method

    @Data
    @NoArgsConstructor
    public static class GlobalSetRequestDto {
        private String key;
        private String value;
    }
}
