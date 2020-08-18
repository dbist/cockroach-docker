package io.roach.data.jooq;

import java.math.BigDecimal;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import io.roach.data.jooq.model.tables.records.AccountRecord;

public interface AccountRepository {
    Page<AccountRecord> findAll(Pageable pageable);

    AccountRecord getOne(Long id);

    BigDecimal getBalance(Long id);

    void updateBalance(Long id, BigDecimal balance);
}
