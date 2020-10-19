-- update & delete
-- update: 컬럼의 값들 수정(업데이트)
-- delete: 레코드(row)를 삭제.

select * from emp;

-- emp 테이블에서 sal을 100으로 업데이트
update emp
set sal = 100;  -- 테이블의 모든 row의 sal 값을 변경.

rollback;  -- 가장 마지막 commit 상태로 되돌리기.

-- emp 테이블에서 SMITH의 sal는 900으로, comm은 50으로 변경
update emp
set sal = 900, comm = 50
where ename = 'SMITH';

-- emp 테이블에서 10번 부서에서 근무하는 직원들의 급여를 10% 인상.
update emp
set sal = sal * 1.1
where deptno = 10;

select * from emp;

-- emp 테이블에서 평균보다 적은 급여를 받는 직원들의 급여를 10% 인상.
select avg(sal) from emp;
select * from emp where sal < (select avg(sal) from emp);

update emp
set sal = sal * 1.1
where sal < (select avg(sal) from emp);

select * from emp;

-- 매니저가 KING인 직원들은 누구일까요?
select * from emp 
where mgr = (select empno from emp where ename = 'KING');
-- 매지저가 KING인 직원들의 수당을 100으로 업데이트하세요.
update emp
set comm = 100
where mgr = (select empno from emp where ename = 'KING');

select * from emp;


-- RESEARCH 부서에서 근무하는 직원들 누구일까요?
select deptno from dept where dname = 'RESEARCH';
select * from emp
where deptno = (select deptno from dept where dname = 'RESEARCH');

-- RESEARCH 부서에서 근무하는 직원들의 comm을 30으로 업데이트.
update emp
set comm = 30
where deptno = (
    select deptno from dept where dname = 'RESEARCH'
);

-- SCOTT의 급여를 KING의 급여로 업데이트.
select sal from emp where ename = 'KING';

update emp
set sal = (select sal from emp where ename = 'KING')
where ename = 'SCOTT';

select * from emp;

-- SALESMAN 직책의 직원들의 급여를 ALLEN의 급여로 업데이트
update emp
set sal = (select sal from emp where ename = 'ALLEN')
where job = 'SALESMAN';

-- MILLER의 sal=2000, comm=100으로 업데이트
update emp
set sal = 2000, comm = 100
where ename = 'MILLER';

-- MILLER의 sal와 comm을 SMITH의 sal와 comm과 동일하게 업데이트.
select sal, comm from emp where ename = 'SMITH';

update emp
set (sal, comm) = (
    select sal, comm from emp where ename = 'SMITH'
)
where ename = 'MILLER';

-- SMITH의 comm을 null로 업데이트
update emp
set comm = null
where ename = 'SMITH';

-- comm이 null인 직원들의 comm을 -1로 업데이트
update emp
set comm = -1
where comm is null;

-- 10번 부서에서 입사일이 가장 늦은 사원보다 더 늦게 입사한 
-- 사원의 부서를 40번으로 업데이트
select max(hiredate) from emp where deptno = 10;
select * from emp
where hiredate > (
    select max(hiredate) from emp where deptno = 10
);

update emp
set deptno = 40
where hiredate > (
    select max(hiredate) from emp where deptno = 10
);

-- 10번 부서에서 입사일이 가장 늦은 사원보다 더 늦게 입사한 
-- 사원의 부서를 OPERATIONS로 변경
update emp
set deptno = (
    select deptno from dept where dname = 'OPERATIONS'
)
where hiredate > (
    select max(hiredate) from emp where deptno = 10
);

select * from emp;
select * from dept;

commit;

-- SCOTT의 레코드(row)를 삭제
delete from emp where ename = 'SCOTT';

-- 급여등급이 5인 직원들을 emp에서 삭제
-- Hint: 급여등급이 5인 직원들의 사번(empno)를 where 구문에서 사용.
select e.empno
from emp e, salgrade s
where e.sal between s.losal and s.hisal
    and grade = 5;

delete from emp
where empno in (
    select e.empno
    from emp e, salgrade s
    where e.sal between s.losal and s.hisal
        and grade = 5
);

select * from emp;

commit;