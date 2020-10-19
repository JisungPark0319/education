-- 다중행 함수(multi-row function, group function)
-- 여러개의 행이 함수의 인수(argument)로 입력되고,
-- 하나의 값이 반환(출력)되는 함수

select sal from emp order by sal;

-- 합계, 평균, 최댓값, 최솟값, 분산, 표준편차, 중앙값
select sum(sal) as 합계,
       round(avg(sal), 2) as 평균,  -- average, mean
       max(sal) as 최댓값,
       min(sal) as 최솟값,
       round(variance(sal), 2) as 분산,
       round(stddev(sal), 2) as 표준편차,  -- standard deviation
       median(sal) as 중앙값
from emp;

select count(*) from emp;  -- 테이블의 전체 row(레코드) 개수
select count(sal), count(comm) from emp;
-- count(컬럼): null이 아닌 레코드 개수

-- 다중행 함수는 여러개의 행이 결과로 출력되는 변수와는 함께 select 할 수 없음!
select empno from emp;
select count(empno) from emp;
select empno, count(empno) from emp;

-- 날짜 타입도 max, min을 사용할 수 있음.
select max(hiredate), min(hiredate) from emp;

-- 10번 부서 사원들의 급여 평균, 최댓값, 최솟값, 표준편차를 출력
select deptno, sal from emp where deptno = 10;
select 10 as deptno,
       round(avg(sal), 2), max(sal), min(sal), round(stddev(sal), 2)
from emp
where deptno = 10;

-- 20번 부서 사원들의 부서번호, 급여 평균, 최댓값, 최솟값, 표준편차를 출력
select 20 as deptno,
       round(avg(sal), 2), max(sal), min(sal), round(stddev(sal), 2)
from emp
where deptno = 20;

-- 30번 부서 사원들의 부서번호, 급여 평균, 최댓값, 최솟값, 표준편차를 출력
select 30 as deptno,
       round(avg(sal), 2), max(sal), min(sal), round(stddev(sal), 2)
from emp
where deptno = 30;

-- grouping: 전체 데이터를 그룹별로 묶어서 집계(합, 평균, 표준편차, ...)
-- 부서별 급여의 평균
select deptno, sal from emp order by deptno;

select deptno, avg(sal)
from emp
group by deptno
order by deptno;

-- 직책별 급여의 평균, 최댓값, 최솟값, 표준편차 출력
-- 소수점 2자리까지 표현.
select job,
       round(avg(sal), 2) as MEAN,
       max(sal) as MAX, min(sal) as MIN,
       round(stddev(sal), 2) as STD_DEV
from emp
group by job
order by job;
       
-- 입사 연도별 사원수, 급여의 평균, 표준편차 출력. 소수점은 2자리까지.
select to_char(hiredate, 'YYYY') as HIRE_YEAR,
       count(*) as COUNT_EMP,
       round(avg(sal), 2) as MEAN_SAL,
       round(stddev(sal), 2) as STDDEV_SAL
from emp
group by to_char(hiredate, 'YYYY')
order by HIRE_YEAR;

select deptno, job, sal
from emp
order by deptno, job;
-- 부서별, 직책별 급여 최댓값을 출력
select deptno, job, max(sal)
from emp
group by deptno, job
order by deptno, job;

select job, deptno, max(sal)
from emp
group by job, deptno
order by job, deptno;

-- 매니저별 사원수를 출력
select mgr, count(*)
from emp
group by mgr
order by mgr;

-- 매니저별 사원수를 출력, 매니저가 null은 제외.
select mgr, count(*)
from emp
where mgr is not null
group by mgr
order by mgr;

-- 부서별 부서번호, 급여 평균을 출력.
-- 부서별 급여의 평균이 2000 이상인 경우만 출력.
select deptno, avg(sal)
from emp
where avg(sal) >= 2000
group by deptno
order by deptno;
-- ORA-00934: 그룹 함수는 허가되지 않습니다
-- group by를 하기 전에 where절에서 그룹 함수를 사용할 수 없다.
-- group by 이후에 조건을 검사할 때 having 절을 사용
select deptno, avg(sal)
from emp
group by deptno
having avg(sal) >= 2000
order by deptno;

-- select 컬럼, ...
-- from 테이블
-- where 그룹짓기 전에 검사할 조건
-- group by 컬럼, ...
-- having 그룹을 만든 후에 검사할 조건
-- order by 컬럼, ...;

-- 직책별 사원수, 급여 평균, 최댓값, 최솟값 출력
-- 직책별 사원수가 3명 이상인 직책만 출력.
select job, count(*), avg(sal), max(sal), min(sal)
from emp
group by job
having count(*) >= 3;

-- 직책별 사원수를 출력. PRESIDENT는 제외.
select job, count(*)
from emp
where job != 'PRESIDENT'
group by job
order by job;

select job, count(*)
from emp
group by job
having job != 'PRESIDENT'
order by job;
-- 두번째 방법은 첫번째와 동일한 결과를 출력하지만,
-- 검색 성능이 나빠질 수 있다.

-- 직책, 직책별 사원수를 출력
-- 직책이 PRESIDENT는 제외
-- 직책별 사원수가 3명 이상만 출력
-- 출력 순서는 직책 이름 오름차순.
select job, count(*)
from emp
where job != 'PRESIDENT'
group by job
having count(*) >= 3
order by job;

-- 연도, 부서번호, 연도별, 부서별 입사한 사원수를 출력
-- 1980년은 제외
-- 사원수 2명 이상인 경우만 출력
-- 연도 순으로 출력

select to_char(hiredate, 'YYYY') as YEAR,
       deptno,
       count(*) COUNTS
from emp
where to_char(hiredate, 'YYYY') != '1980'
group by to_char(hiredate, 'YYYY'), deptno
having count(*) >= 2
order by YEAR;

-- 수당이 있는 직원수, 수당이 없는 직원수를 출력
select nvl2(comm, 'COMM_YES', 'COMM_NO'), count(*)
from emp
group by nvl2(comm, 'COMM_YES', 'COMM_NO');
