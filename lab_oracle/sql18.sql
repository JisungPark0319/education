-- create table & insert ~ select
-- 테이블의 일부 또는 전체를 복사 새로운 테이블 생성

-- 테이블 이름: ex_emp2
-- 컬럼: 사번, 이름, 급여, 부서번호
-- 테이블 생성 후 insert ~ select 구문을 이용해서 
-- emp에 있는 데이터를 ex_emp2 테이블에 복사
desc emp;
create table ex_emp2 (
    emp_no      number(6),
    emp_name    varchar2(100),
    salary      number(7, 2),
    dept_no     number(2)
);

insert into ex_emp2
select empno, ename, sal, deptno from emp;

-- 테이블의 모든 레코드(행, row)를 삭제
delete from ex_emp2;

-- emp 테이블에서 부서번호가 10 또는 20번인 직원들 정보만 ex_emp2로 복사
insert into ex_emp2
select empno, ename, sal, deptno
    from emp
    where deptno in (10, 20);

select * from ex_emp2;

commit;
-- DDL(Data Definition Language): create -> 자동 커밋
-- DML(Data Manipulation Language): insert, update, delete
--  -> commit을 실행시켜야 영구 저장이 됨.

-- 테이블 이름: ex_emp3
-- 컬럼: 사번, 이름, 부서이름
-- 테이블 ex_emp3을 생성하고, emp, dept 테이블의 데이터를 복사
create table ex_emp3 (
    emp_no      number(4),
    emp_name    varchar2(100),
    dept_name   varchar2(100)
);

-- insert ~ select 구문
-- insert into 테이블1 (컬럼, ... )
-- select 컬럼, ... from 테이블2 [where ... group by ... having ...];
insert into ex_emp3
select e.empno, e.ename, d.dname
from emp e, dept d
where e.deptno = d.deptno;

--delete from ex_emp3;

select * from ex_emp3;
commit;


-- create table ~ as select 구문:
create table ex_emp4 as
select e.empno, e.ename, e.sal, d.dname
from emp e, dept d
where e.deptno = d.deptno;

select * from ex_emp4;

-- 전체 레코드 삭제: delete
delete from ex_emp4;
select * from ex_emp4;
rollback; -- 최종 commit 상태로 되돌리는 기능.
select * from ex_emp4;

-- 테이블 잘라내기: truncate
truncate table ex_emp4;
select * from ex_emp4;
rollback;
select * from ex_emp4;

-- 테이블 데이터베이스에서 삭제: drop
drop table ex_emp4;
select * from ex_emp4;  -- 오류 발생
