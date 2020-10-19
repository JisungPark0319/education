-- 1) emp 테이블과 똑같은 구조(컬럼이름, 데이터 타입)을 갖는 테이블을
-- emp_test라는 이름으로 생성.
desc emp;
--create table emp_test (
--    컬럼이름    데이터타입,
--    ...
--);
--create table emp_test as
--select * from emp;
--select * from emp_test;
--delete from emp_test;

drop table emp_test;

create table emp_test as
select * from emp where empno = -1;

select * from emp_test;

-- 2) emp_test 테이블에 etc라는 이름의 컬럼을 추가.
-- 데이터 타입은 최대 20 bytes 문자열.
desc emp_test;

alter table emp_test add etc varchar2(20);

-- 3) etc 컬럼이 100 bytes 까지의 문자열을 저장할 수 있도록 수정.
alter table emp_test modify etc varchar2(100);
desc emp_test;

-- 4) etc 컬럼의 이름을 remark로 변경.
alter table emp_test rename column etc to remark;
desc emp_test;

-- 5) emp 테이블의 모든 데이터를 emp_test에 복사.
-- remark 컬럼의 값은 null이어야 함.
insert into emp_test (empno, ename, job, mgr, hiredate, sal, comm, deptno)
select * from emp;

select * from emp_test;

-- 6) emp_test 테이블의 empno 컬럼에 고유키(primary key) 제약조건을 추가.
alter table emp_test add constraint pk_emp_test primary key (empno);

-- 7) emp_test 테이블의 deptno 컬럼에 외래키(foreign key) 제약조건을 추가.
-- dept 테이블의 deptno를 참조.
alter table emp_test 
add constraint fk_test_deptno foreign key (deptno) references dept(deptno);

-- 8) emp_test 테이블의 ename 컬럼에 not null 제약조건을 추가.
alter table emp_test modify ename varchar2(10) not null;

alter table emp_test drop constraint SYS_C0011155;  -- 제약조건 삭제.

alter table emp_test 
add constraint nn_test_ename check (ename is not null);

-- 9) emp_test 테이블을 삭제.
drop table emp_test;
