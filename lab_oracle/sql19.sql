-- 테이블 수정(alter)
-- alter table 테이블이름 변경할 내용;

-- 변경할 내용:
-- 1) 이름 변경: 컬럼 이름, 제약조건 이름
--  alter table 테이블 rename column A to B;
--  alter table 테이블 rename constraint A to B;
desc ex01;
alter table ex01 
rename column ex_no to ex_id;

select constraint_name from user_constraints;
alter table ex01 
rename constraint SYS_C0011115 to ck_ex_name;

-- 2) 추가: 컬럼, 제약조건
-- alter table 테이블이름 add 컬럼이름 데이터타입;
-- alter table 테이블이름 add constraint 제약조건이름 제약조건 내용;
desc ex01;
alter table ex01 add ex_description varchar2(100);
select * from ex01;

alter table ex01
add constraint uq_ex_desc unique (ex_description);

-- 3) 삭제: 컬럼, 제약조건
-- alter table 테이블이름 drop column 컬럼;
-- alter table 테이블이름 drop constraint 컬럼;
desc ex01;
alter table ex01 drop constraint uq_ex_desc;
alter table ex01 drop column ex_description;

-- 4) 내용 수정: 컬럼
-- alter table 테이블이름 modify 컬럼이름 변경내용;
alter table ex01 modify ex_id number(4);
desc ex01;

-- 제약조건의 내용을 변경:
-- drop constraint 후 add constraint를 수행함.
