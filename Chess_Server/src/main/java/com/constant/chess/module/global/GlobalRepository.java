package com.constant.chess.module.global;

import org.springframework.data.jpa.repository.JpaRepository;

public interface GlobalRepository extends JpaRepository<GlobalDao, Long> {
    GlobalDao findByKey(String key);
}
