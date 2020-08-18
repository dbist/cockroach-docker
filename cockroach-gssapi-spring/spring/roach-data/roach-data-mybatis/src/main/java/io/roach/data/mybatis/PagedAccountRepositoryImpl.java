package io.roach.data.mybatis;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.transaction.annotation.Propagation.MANDATORY;

@Repository
@Transactional(propagation = MANDATORY)
public class PagedAccountRepositoryImpl implements PagedAccountRepository {
    @Autowired
    private PagedAccountMapper pagedAccountMapper;

    @Override
    public Page<Account> findAll(Pageable pageable) {
        List<Account> accounts = pagedAccountMapper.findAll(pageable);
        long totalRecords = pagedAccountMapper.countAll();
        return new PageImpl<>(accounts, pageable, totalRecords);

    }
}
