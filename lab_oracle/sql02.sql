-- SQL 키워드(desc, select, from, ...) 대/소문자 모두 가능.
-- 테이블 이름, 컬럼 이름들도 대/소문자 모두 가능.
-- 테이블에 저장된 값들은 대/소문자를 구분함.

-- 테이블에서 레코드 검색
-- dept(부서) 테이블에서 deptno(부서 번호)를 검색
select deptno from dept;

-- dept(부서) 테이블에서 dname(부서 이름)을 검색
select dname from dept;

-- 부서 테이블에서 부서 번호와 부서 이름을 검색
select deptno, dname from dept;
select dname, deptno from dept;

-- 테이블의 모든 컬럼을 검색
select * from dept;

-- alias(별명)
-- 컬럼 이름을 테이블의 컬럼 이름과 다르게 원하는 이름으로 출력
-- select 컬럼이름 as 별명, ... from 테이블;
select deptno as 부서번호, dname as 부서이름
from dept;

-- emp 테이블 컬럼이름, 데이터 타입, null 여부 확인
desc emp;
-- empno: 사원번호
-- eanme: 사원이름
-- job: 직책
-- mgr: 매니저의 사원번호
-- hiredate: 입사일
-- sal: 급여
-- comm: 커미션(commission). 특별수당.
-- deptno: 부서번호

-- 1) 사원 테이블에서 전체 컬럼을 검색
select * from emp;

-- 2) 사원 테이블에서 사번, 이름, 부서번호를 검색
select empno, ename, deptno from emp;

-- 3) 사원 테이블에서 이름, 급여, 특별수당을 검색. 각 컬럼의 alias를 설정
select ename as 이름, sal as 급여, comm as 수당
from emp;

-- 4) 사원 테이블에서 이름, 수당, 부서번호를 검색
select ename, comm, deptno
from emp;

select ename, comm, deptno, job
from emp;