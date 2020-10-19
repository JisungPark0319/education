-- 서브 쿼리(Sub Query)

-- 전체 직원의 급여 평균보다 더 많은 급여를 받는 직원들의 레코드 검색
-- 1) 전체 직원의 급여 평균
select avg(sal) from emp;
-- 2) 평균보다 급여가 많은 직원
select * from emp
where sal > 2073;

select * from emp
where sal > (select avg(sal) from emp);

-- ALLEN보다 적은 급여를 받는 직원의 사번, 이름, 급여를 출력
select empno, ename, sal
from emp
where sal < (
    select sal from emp where ename = 'ALLEN'
);

-- ALLEN보다 수당을 더 많이 받는 직원의 사번, 이름, 급여, 수당을 출력.
select empno, ename, sal, comm
from emp
where comm > (
    select comm from emp where ename = 'ALLEN'
);

-- 연봉 = sal * 12 + comm, comm이 null은 0으로 처리.
-- WARD의 연봉보다 많은 연봉을 받는 직원들의 사번, 이름, 급여, 수당, 연봉 출력
-- 출력은 연봉 오름차순으로.
select empno, ename, sal, comm, 
       sal * 12 + nvl(comm, 0) as ANNUAL_SAL
from emp
where sal * 12 + nvl(comm, 0) > (
    select sal * 12 + nvl(comm, 0) 
    from emp
    where ename = 'WARD'
)
order by ANNUAL_SAL;

-- ALLEN과 직책이 같은 직원들의 레코드를 출력.
select * 
from emp
where job = (
    select job from emp where ename = 'ALLEN'
);

-- 직책이 SALESMAN인 직원들의 최고 급여보다 더 많은 급여를 받는 직원들의
-- 사번, 이름, 급여, 직책을 출력
select empno, ename, sal, job
from emp
where sal > (
    select max(sal) from emp where job = 'SALESMAN'
);

-- 부서별 급여가 가장 적은 직원의 레코드를 출력
-- 1) 부서별 급여 최솟값
select min(sal) from emp group by deptno order by deptno;
-- 2) 급여가 950, 800, 1300인 직원들의 정보
select * from emp
where sal = 950 or sal = 800 or sal = 1300;

select * from emp
where sal in (950, 800, 1300);

select * from emp
where sal in (
    select min(sal) from emp
    group by deptno
);

select * from emp
where (deptno, sal) in (
    select deptno, min(sal) from emp
    group by deptno
);
select deptno, sal from emp;

-- 각 부서에서 최대 급여를 받는 직원들의 정보
select * from emp
where (deptno, sal) in (
    select deptno, max(sal) from emp
    group by deptno
);

-- 20번 부서에서 근무하는 사원들 중
-- 30번에 없는 직책을 가진 직원들의 정보를 출력
select job from emp where deptno = 30;
select distinct job from emp where deptno = 30;
select job from emp
where job not in (
    select distinct job from emp where deptno = 30
);

select *
from emp
where deptno = 20
    and
      job not in (
        select distinct job from emp where deptno = 30
      );