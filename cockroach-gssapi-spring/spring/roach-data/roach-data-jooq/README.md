# Roach Demo Data :: jOOQ

A CockroachDB Spring Boot Demo using [jOOQ](https://www.jooq.org/) for data access.

## Generate jOOQ classes

First create the DB schema:

    create table account
    (
        id      int            not null primary key,
        balance numeric(19, 2) not null,
        name    varchar(128)   not null,
        type    varchar(25)    not null
    );

Then generate code by activating a Maven profile called _generate_:

    mvn -P generate clean install
   
(Note: this will fail with an error when using CRDB even if classes are generated correctly)    

Finally drop the table

    drop table account cascade;
    
