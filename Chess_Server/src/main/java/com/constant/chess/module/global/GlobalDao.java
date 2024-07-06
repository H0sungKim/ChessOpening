package com.constant.chess.module.global;

import javax.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "global")
public class GlobalDao {

    public static final String KEY_ANDROID_MARKET_VERSION = "KEY_ANDROID_MARKET_VERSION";
    public static final String KEY_IOS_MARKET_VERSION = "KEY_IOS_MARKET_VERSION";

    public static final String KEY_ANDROID_MIN_VERSION = "KEY_ANDROID_MIN_VERSION";
    public static final String KEY_IOS_MIN_VERSION = "KEY_IOS_MIN_VERSION";

    public static final String ANDROID_MARKET_VERSION = "1.00.00";
    public static final String IOS_MARKET_VERSION = "1.00.00";

    public static final String ANDROID_MIN_VERSION = "1.00.00";
    public static final String IOS_MIN_VERSION = "1.00.00";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "GLOBAL_ID")
    private Long id;

    @Column(name = "_key")
    private String key;

    @Column(length = 10000)
    private String value;

    public GlobalDao(String key, String value) {
        this.key = key;
        this.value = value;
    }
}
