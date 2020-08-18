package io.roach.data.jooq;

import java.math.BigDecimal;
import java.util.List;

import org.jooq.DSLContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import io.roach.data.jooq.model.tables.records.AccountRecord;

import static io.roach.data.jooq.model.Tables.ACCOUNT;
import static org.springframework.transaction.annotation.Propagation.MANDATORY;

@Repository
@Transactional(propagation = MANDATORY)
public class JooqAccountRepository implements AccountRepository {
    @Autowired
    private DSLContext dsl;

    @Override
    public Page<AccountRecord> findAll(Pageable pageable) {
        List<AccountRecord> accountRecords = dsl.selectFrom(ACCOUNT).limit(pageable.getPageSize())
                .offset(pageable.getOffset())
                .fetchInto(AccountRecord.class);
        long totalRecords = dsl.fetchCount(dsl.select().from(ACCOUNT));
        return new PageImpl<>(accountRecords, pageable, totalRecords);
    }

    @Override
    public AccountRecord getOne(Long id) {
        return dsl.selectFrom(ACCOUNT).where(ACCOUNT.ID.eq(id)).fetchOne();
    }

    @Override
    public BigDecimal getBalance(Long id) {
        return dsl.select(ACCOUNT.BALANCE)
                .from(ACCOUNT)
                .where(ACCOUNT.ID.eq(id))
                .fetchOne()
                .value1();
    }

    @Override
    public void updateBalance(Long id, BigDecimal balance) {
        dsl.update(ACCOUNT)
                .set(ACCOUNT.BALANCE, ACCOUNT.BALANCE.plus(balance))
                .where(ACCOUNT.ID.eq(id))
                .execute();
    }
}
