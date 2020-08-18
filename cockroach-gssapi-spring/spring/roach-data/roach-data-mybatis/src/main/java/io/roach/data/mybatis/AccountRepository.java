package io.roach.data.mybatis;

import java.math.BigDecimal;

import org.apache.ibatis.annotations.Param;
import org.springframework.data.jdbc.repository.query.Modifying;
import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.transaction.annotation.Propagation.MANDATORY;

@Repository
@Transactional(propagation = MANDATORY)
interface AccountRepository extends CrudRepository<Account, Long>, PagedAccountRepository {
    @Query("SELECT balance FROM account WHERE id = :id")
    BigDecimal getBalance(@Param("id") Long id);

    @Query("UPDATE account SET balance = balance + :balance WHERE id=:id")
    @Modifying
    void updateBalance(@Param("id") Long id, @Param("balance") BigDecimal balance);
}
