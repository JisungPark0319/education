-- sequence
create sequence my_seq;
select my_seq.nextval from dual;

create table ex_test (
    col_1 number(4) 
          constraint pk_test primary key,
    col_2 varchar2(10)
);

insert into ex_test
values (my_seq.nextval, 'abcd');

select * from ex_test;
