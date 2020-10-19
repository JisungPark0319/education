-- create table & 제약 조건(constraints)

select * from dept;

-- deptno=50, dname='인사' insert
insert into dept (deptno, dname)
values (50, '인사');  -- insert 성공

-- dname='총무', loc='서울' insert
insert into dept (dname, loc)
values ('총무', '서울');  -- insert 실패: 제약조건 위배

-- deptno=10, dname='IT' insert
insert into dept (deptno, dname)
values (10, 'IT');  -- insert 실패: 고유키 제약조건 위배
-- 고유키(primary key, PK)
-- 테이블에서 고유하게 부여되는 값
-- (1) 반드시 값이 있어야 함.
-- (2) 중복되지 않는 값이어야 함.

-- 테이블 이름: ex01
-- 컬럼: ex_no(숫자), ex_name(문자열), ex_date(날짜)
-- 제약조건: ex_no(unique), ex_name(not null)
create table ex01 (
    ex_no   number(2) unique,
    ex_name varchar2(10) not null,
    ex_date date
);
-- ex_no에는 중복된 값이 저장될 수 없음!
-- ex_name은 반드시 값이 있어야 함!
insert into ex01
values (1, 'aaa', sysdate);

select * from ex01;

-- 31행의 코드를 다시 실행 -> 오류 발생
-- ex_no가 unique라는 제약 조건 위배!

insert into ex01 (ex_no, ex_name) values (2, 'bbb');
insert into ex01 (ex_no) values (3);  -- 실행 오류
-- ex_name이 not null이라는 제약 조건 위배!

insert into ex01 (ex_name) values ('aaa');
-- ex_no는 null이어도 괜찮음.
-- ex_name은 중복되도 괜찮음.

-- 테이블을 생성할 때 제약조건의 이름을 설정하는 방법
-- 테이블 이름: ex02
-- 컬럼
--  (1) col_1: number(2), Primary Key
--  (2) col_2: varchar2(10), Not Null
--  (3) col_3: date, 기본값 - 시스템 현재 시간
create table ex02 (
    col_1 number(2)     constraint pk_ex02 primary key,
    col_2 varchar2(10)  constraint nn_col_2 not null,
    col_3 date          default sysdate
);

insert into ex02
values (1, 'aaa', to_date('1970/01/01', 'YYYY/MM/DD'));

select * from ex02;

insert into ex02 (col_1, col_2)
values (1, 'aaa');  -- PK 위반


insert into ex02 (col_1, col_2)
values (2, 'aaa'); 


-- Table-level 제약 조건
create table ex03 (
    col_1   number(2),
    col_2   varchar2(10),
    col_3   date    default sysdate,
    constraint pk_ex03 primary key (col_1),
    constraint uq_col_2 unique (col_2)
);


-- 테이블 이름: ex04
-- 컬럼:
--  (1) age: number(3), age >= 0
--  (2) gender: varchar2(1), 'M' 또는 'F'
create table ex04 (
    age     number(3)   
            constraint ck_age check(age >= 0),
    gender  varchar2(1) 
            constraint ck_gender check(gender in ('M', 'F'))
);

insert into ex04 values (16, 'M');  -- insert 성공

insert into ex04 values (-1, 'M');  -- ck_age 위배

insert into ex04 (gender) values ('f');  -- ck_gender 위배

select * from ex04;

-- insert ~ select 구문
-- emp 테이블에서 이름, 직책, 급여, 수당을 검색해서
-- bonus 테이블에 insert
-- 수당인 null인 경우는 0으로 대체해서 insert
insert into bonus
select ename, job, sal, nvl(comm, 0) from emp;

select * from bonus;


-- Primary key(고유키)와 Foreign key(외래키)
create table ex_dept (
    deptno  number(2)
            constraint pk_ex_dept primary key,
    dname   varchar2(100)
);

create table ex_emp (
    empno   number(3)
            constraint pk_ex_emp primary key,
    ename   varchar2(100),
    deptno  number(2)
            constraint fk_ex_deptno references ex_dept(deptno)
);

-- ex_dept, ex_emp에 레코드가 1개도 없는 상태
select * from ex_dept;
select * from ex_emp;

-- 사번(100), 이름(홍길동), 부서번호(10) 직원을 insert
insert into ex_emp values (100, '홍길동', 10);
-- ex_dept 테이블에 10번 부서가 없기 때문에 ex_emp 테이블에 insert되지 않음!

insert into ex_dept values (10, 'IT');
-- ex_dept 테이블에 10번 부서를 insert한 후에는
-- ex_emp 테이블에 10번 부서의 직원을 insert할 수 있음!
insert into ex_emp values (100, '홍길동', 10);

insert into ex_emp (empno, ename) values(101, '오쌤');
-- FK인 부서번호 없이(null) insert 가능
select * from ex_emp;

drop table test;