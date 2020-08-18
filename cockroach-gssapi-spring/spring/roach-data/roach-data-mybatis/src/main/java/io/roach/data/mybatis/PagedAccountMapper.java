package io.roach.data.mybatis;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.data.domain.Pageable;

@Mapper
public interface PagedAccountMapper {
    @Select("SELECT * FROM account LIMIT #{pageable.pageSize} OFFSET #{pageable.offset}")
    List<Account> findAll(@Param("pageable") Pageable pageable);

    @Select("SELECT count(id) from account")
    long countAll();
}
