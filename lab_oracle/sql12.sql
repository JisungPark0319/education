-- emp 테이블에서 급여(sal) 최댓값을 출력
select max(sal) from emp;

-- 최대 급여를 받는 사원 이름과 급여를 출력
select ename, sal
from emp
where sal = (select max(sal) from emp);

-- JONES의 급여보다 더 많은 월급을 받는 사원들의 이름과 월급을 출력
select sal from emp where ename = 'JONES';
select ename, sal
from emp
where sal > (
    select sal from emp where ename = 'JONES'
);

-- SCOTT과 같은 월급을 받는 사원들의 이름과 월급을 출력
select sal from emp where ename = 'SCOTT';
select ename, sal
from emp
where sal = (
    select sal from emp where ename = 'SCOTT'
);

-- 위 결과에서 SCOTT은 제외하고 출력
select ename, sal
from emp
where sal = (
        select sal from emp where ename = 'SCOTT'
    )
    and ename != 'SCOTT';

-- ALLEN보다 늦게 입사한 사원들의 이름과 입사일을 출력
-- 최근에 입사한 사원부터 출력
select hiredate from emp where ename = 'ALLEN';
select ename, hiredate
from emp
where hiredate > (
    select hiredate from emp where ename = 'ALLEN'
)
order by hiredate desc;

-- SALESMAN 직책에서의 최대 급여보다 많은 급여를 받는 사원들의
-- 이름, 직책, 급여를 출력
select max(sal) from emp where job = 'SALESMAN';
select ename, job, sal
from emp
where sal > (
    select max(sal) from emp where job = 'SALESMAN'
);

-- DALLAS에서 근무하는 사원들의 이름과 급여를 출력
select deptno from dept where loc = 'DALLAS';
select ename, sal
from emp
where deptno = (
    select deptno from dept where loc = 'DALLAS'
);

select e.ename, e.sal
from emp e, dept d
where e.deptno = d.deptno 
    and d.loc = 'DALLAS';

-- 매니저가 KING인 사원들의 이름을 출력
select empno from emp where ename = 'KING';
select ename
from emp
where mgr = (
    select empno from emp where ename = 'KING'
);

-- 직책이 SALESMAN인 사원들과 같은 월급을 받는 사원들의 이름과 급여를 출력
select sal from emp where job = 'SALESMAN';
select ename, sal
from emp
where sal in (
    select sal from emp where job = 'SALESMAN'
);

-- 관리자인 사원들의 이름을 출력
-- 관리자들의 사번
select distinct mgr from emp;
select ename from emp
where empno in (select distinct mgr from emp);

select ename from emp
where empno in (
    select distinct mgr from emp
    where mgr is not null
);

-- 관리자가 아닌 사원들의 이름을 출력
select ename from emp
where empno not in (
    select distinct mgr from emp
    where mgr is not null
);

select ename from emp
where empno not in (
    select distinct nvl(mgr, 0) from emp
);

-- x = null, x != null: 두 비교문은 항상 False. 
-- null인지 비교할 때는  등호나 부등호를 사용하지 않음!
-- x is null, x is not null
-- x in (a, b): (x = a) or (x = b)
-- x not in (a, b): (x != a) and (x != b)

-- 수당을 받지 않는 사원들의 직책을 출력
select distinct job from emp where comm is null;

-- 수당을 받지 않는 사원들의 직책과 같은 직책을 갖는 사원들의 
-- 이름, 직책, 급여를 출력
select ename, job, sal
from emp
where job in (
    select distinct job from emp where comm is null
);
