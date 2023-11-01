drop table if exists accounts;

create table accounts (
  id bigint not null,
  balance bigint not null,

  constraint accounts_pk primary key (id)
);