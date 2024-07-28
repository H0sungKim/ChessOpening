package com.constant.chess.module.global;

import javax.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "raw")
public class RawDao {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RAW_ID")
    private Long id;

    @Column(name = "_key")
    private String key;

    @Column(length = 10000)
    private String value;

    private String memo;
    private String status;
    private LocalDateTime createdDate;

    public RawDao(String key, String value, String memo) {
        this.key = key;
        this.value = value;
        this.memo = memo;
        this.createdDate = LocalDateTime.now();
    }
}
