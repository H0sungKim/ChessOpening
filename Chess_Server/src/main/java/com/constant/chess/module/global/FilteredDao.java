package com.constant.chess.module.global;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;



@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "filtered")
public class FilteredDao {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FILTERED_ID")
    private Long id;

    @Column(name = "_key")
    private String key;

    @Column(length = 10000)
    private String value;

    private String memo;
    private String status;
    private LocalDateTime createdDate;

    public FilteredDao(String key, String value, String memo) {
        this.key = key;
        this.value = value;
        this.memo = memo;
        this.createdDate = LocalDateTime.now();
    }
}
