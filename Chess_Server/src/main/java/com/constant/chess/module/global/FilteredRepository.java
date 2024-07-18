package com.constant.chess.module.global;

import org.springframework.data.jpa.repository.JpaRepository;

public interface FilteredRepository extends JpaRepository<FilteredDao, Long> {
    FilteredDao findByKey(String key);
}
