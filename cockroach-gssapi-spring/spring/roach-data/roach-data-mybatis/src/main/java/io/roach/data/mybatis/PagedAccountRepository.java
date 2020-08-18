package io.roach.data.mybatis;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface PagedAccountRepository {
    Page<Account> findAll(Pageable pageable);
}
