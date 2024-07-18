package com.constant.chess.module.global;

import org.springframework.data.jpa.repository.JpaRepository;

public interface RawRepository extends JpaRepository<RawDao, Long> {
    RawDao findByKey(String key);
}
