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
public class ChessController {
    // Public Inner Class, Struct, Enum, Interface
    @Data
    @NoArgsConstructor
    public static class DataSetRequestDto {
        private String key;
        private String value;
        private String memo;
    }

    @Data
    @NoArgsConstructor
    public static class DataGetRequestDto {
        private String key;
    }
    // Public Constant
    // Private Constant
    private final RawRepository rawRepository;
    private final FilteredRepository filteredRepository;
    // Public Variable

    // Private Variable
    // Override Method or Basic Method
    // Public Method
    @ApiOperation(value = "Chess - 업데이트 API", notes = "해당하는 key에 value를 저장합니다.")
    @PostMapping("user/raw/set")
    public ResponseEntity<RootResponseDto> setRaw(
            @RequestBody DataSetRequestDto dataSetRequestDto)
            throws IOException {
        RawDao rawDao = rawRepository.findByKey(dataSetRequestDto.key);
        if (rawDao == null) {
            rawRepository.save(
                    new RawDao(
                            dataSetRequestDto.key, dataSetRequestDto.value, dataSetRequestDto.memo));
        } else {
            rawDao.setValue(dataSetRequestDto.value);
            rawDao.setMemo(dataSetRequestDto.memo);
            rawRepository.save(rawDao);
        }
        return ResponseUtil.getInstance().getResponseEntity(HttpStatus.OK);
    }

    @ApiOperation(value = "Chess - get API", notes = "해당하는 key에 value를 읽어옵니다.")
    @PostMapping("user/raw/get")
    public ResponseEntity<RootResponseDto> getRaw(
            @RequestBody DataGetRequestDto dataGetRequestDto)
            throws IOException {
        RawDao rawDao = rawRepository.findByKey(dataGetRequestDto.getKey());
        if (rawDao == null) {
            throw new HHRestApiException(HHResponseCode.NO_KEY);
        } else {
            return ResponseUtil.getInstance().getResponseEntity(HttpStatus.OK, rawDao.getValue());
        }
    }

    @ApiOperation(value = "Chess - 업데이트 API", notes = "해당하는 key에 value를 저장합니다.")
    @PostMapping("user/filtered/set")
    public ResponseEntity<RootResponseDto> setFiltered(
            @RequestBody DataSetRequestDto dataSetRequestDto)
            throws IOException {
        FilteredDao filteredDao = filteredRepository.findByKey(dataSetRequestDto.key);
        if (filteredDao == null) {
            filteredRepository.save(
                    new FilteredDao(
                            dataSetRequestDto.key, dataSetRequestDto.value, dataSetRequestDto.memo));
        } else {
            filteredDao.setValue(dataSetRequestDto.value);
            filteredDao.setMemo(dataSetRequestDto.memo);
            filteredRepository.save(filteredDao);
        }
        return ResponseUtil.getInstance().getResponseEntity(HttpStatus.OK);
    }

    @ApiOperation(value = "Chess - get API", notes = "해당하는 key에 value를 읽어옵니다.")
    @PostMapping("user/filtered/get")
    public ResponseEntity<RootResponseDto> getFiltered(
            @RequestBody DataGetRequestDto dataGetRequestDto)
            throws IOException {
        FilteredDao filteredDao = filteredRepository.findByKey(dataGetRequestDto.getKey());
        if (filteredDao == null) {
            throw new HHRestApiException(HHResponseCode.NO_KEY);
        } else {
            return ResponseUtil.getInstance().getResponseEntity(HttpStatus.OK, filteredDao.getValue());
        }
    }
    // Private Method


}
