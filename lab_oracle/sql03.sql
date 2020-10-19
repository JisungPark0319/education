-- 중복되지 않는 값 검색
-- 사원 테이블에서 부서번호를 검색
select deptno from emp;
-- 사원 테이블에서 중복되지 않는 부서번호만 검색
select distinct deptno from emp;

-- 사원 테이블에서 직책을 검색
select job from emp;

-- 사원 테이블에서 중복되지 않는 직책을 검색
select distinct job from emp;

-- 사원 테이블에서 중복되지 않는 부서번호, 직책을 검색
select distinct deptno, job
from emp;

-- 테이블에서 특정 조건을 만족하는 레코드(행)들을 검색
-- select 컬럼, ...
-- from 테이블이름
-- where 조건;

-- 사원 테이블에서 부서번호가 30인 사원들의 모든 컬럼 검색
select *
from emp
where deptno = 30;

-- 부서번호가 10인 사원들의 사번, 이름, 직책, 부서번호를 검색
select empno, ename, job, deptno
from emp
where deptno = 10;

-- 직책이 SALESMAN인 직원들의 사번, 이름, 급여, 수당, 직책을 검색
select empno, ename, sal, comm, job
from emp
where job = 'SALESMAN';

-- 오라클에서 문자열은 작은따옴표('')로 묶어줌!
-- 오라클에서 문자열 데이터는 대/소문자를 구별함!
-- 'SALESMAN'과 'salesman'은 다른 문자열.

-- 부서번호가 10이 아닌 직원들의 모든 컬럼 검색
select *
from emp
where deptno != 10;

-- 급여가 1000보다 큰 직원들의 이름, 직책, 급여를 검색
select ename, job, sal
from emp
where sal > 1000;

-- 급여가 3000 이상인 직원들의 이름, 직책, 급여를 검색
select ename, job, sal
from emp
where sal >= 3000;

-- 급여가 2000 이하인 직원들의 모든 컬럼 검색
select * 
from emp
where sal <= 2000;

-- 급여가 1500 이상 3000 이하인 직원들의 모든 컬럼 검색
select *
from emp
where sal >= 1500 and sal <= 3000;

select * 
from emp
where sal between 1500 and 3000;

-- 오름차순/내림차순 정렬해서 검색
-- 사번, 이름, 급여를 검색해서 사번의 오름차순으로 출력
select empno, ename, sal
from emp
order by empno;

-- 사번, 이름, 급여를 검색해서, 사번의 내림차순으로 출력
select empno, ename, sal
from emp
order by empno desc;  -- desc: descending(내림차순), asc: ascending(오름차순)
-- order by에서 오름차순 정렬이 기본값이기 때문에 asc은 생략 가능!

-- 사번, 이름, 급여, 부서번호를 검색해서, 부서번호의 오름차순으로 출력
select empno, ename, sal, deptno
from emp
order by deptno;

-- 부서번호, 사번, 이름, 급여를 검색해서
-- 첫번째 정렬은 부서번호로, 두번째 정렬은 사번으로
select deptno, empno, ename, sal
from emp
order by deptno, empno;

-- 부서 번호가 10 또는 20인 사원들의 부서번호, 이름을 검색
-- 부서 번호, 이름 오름차순을 정렬해서 출력
select deptno, ename
from emp
where deptno = 10 or deptno = 20
order by deptno, ename;

select deptno, ename
from emp
where deptno in (10, 20)
order by deptno, ename;

-- 직책이 'ANALYST' 또는 'MANAGER'인 사원들의 모든 컬럼을 검색
-- 1) or 사용
select * 
from emp
where job = 'ANALYST' or job = 'MANAGER';
-- 2) in 사용
select * 
from emp
where job in ('ANALYST', 'MANAGER');

-- 문자열의 일부가 포함되어 있는지 검사
select *
from emp
where ename like 'S%';

-- 사원 이름이 'A'로 시작하는 사원들의 모든 컬럼 검색
select *
from emp
where ename like 'A%';

-- 사원 이름이 '_ING'인 사원 레코드를 검색
select *
from emp
where ename like '_ING';

select *
from emp
where ename like '_NG';

-- like를 사용할 때
-- %: 몇글자이든 상관 없이 아무 문자로 대체
-- _: 한글자만 아무 문자로 대체

select *
from emp
where ename like '%NG';

-- 이름 중에 'E'가 포함된 사원들의 모든 컬럼 검색
select * 
from emp
where ename like '%E%';

-- 이름 중에 'LL'가 포함된 사원들의 모든 컬럼 검색
select * 
from emp
where ename like '%LL%';

-- 컬럼의 값이 null인지 아닌지를 검사
-- 수당(comm)이 null인 사원들의 레코드를 검색
select *
from emp
where comm is null;

-- 수당이 null이 아닌 사원들의 레코드를 검색
select *
from emp
where comm is not null;

-- 수당이 null이 아니고 급여가 1500 이상인 사원들의 레코드를 검색
select *
from emp
where comm is not null 
    and sal >= 1500;

-- 수당이 없는 직원들 중에서, 매니저가 있고, 
-- 직책이 'MANAGER' 또는 'CLERK'인
-- 직원들의 모든 컬럼을 검색
select * 
from emp
where comm is null
    and mgr is not null
    and job in ('MANAGER', 'CLERK');
