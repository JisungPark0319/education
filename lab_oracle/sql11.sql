-- scott 계정 사용
-- 모든 문장은 Oracle 문법, ANSI 문법 2가지로 작성

-- 부서번호, 부서이름, 부서별 사원수, 급여 최솟값, 급여 최댓값, 급여 평균 출력.
-- 소숫점이 있는 경우, 소숫점 한자리까지만 출력.
-- 부서번호 순서로 출력.
select e.deptno, d.dname,
       count(*) as 사원수,
       min(e.sal) as 급여최솟값,
       max(e.sal) as 급여최댓값,
       round(avg(e.sal), 1) as 급여평균
from emp e, dept d
where e.deptno = d.deptno
group by e.deptno, d.dname
order by e.deptno;

select e.deptno, d.dname,
       count(*) as 사원수,
       min(e.sal) as 급여최솟값,
       max(e.sal) as 급여최댓값,
       round(avg(e.sal), 1) as 급여평균
from emp e inner join dept d
    on e.deptno = d.deptno
group by e.deptno, d.dname
order by e.deptno;

-- 부서번호, 부서이름, 사번, 이름, 직책, 급여를 출력
-- 부서 테이블에 있는 모든 부서 정보가 출력되어야 함.
-- 부서번호 순서로 출력.
select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from dept d, emp e
where d.deptno = e.deptno(+)  -- left outer join
order by d.deptno;

select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from emp e, dept d
where e.deptno(+) = d.deptno  -- right outer join
order by d.deptno;

select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from dept d left outer join emp e
    on d.deptno = e.deptno
order by d.deptno;

select d.deptno, d.dname, e.empno, e.ename, e.job, e.sal
from emp e right outer join dept d
    on e.deptno = d.deptno
order by d.deptno;

-- 부서번호, 부서이름, 사번, 이름, 매니저사번, 매니저 이름, 급여, 급여 등급 출력.
-- 모든 부서번호 출력 - 40번 부서
-- 매니저가 없는 사원 출력 - KING
-- 출력 순서: 부서 번호 -> 사번
select d.deptno, d.dname, 
       e1.empno, e1.ename, e1.mgr, e2.ename,
       e1.sal, s.grade
from dept d, emp e1, emp e2, salgrade s
where d.deptno = e1.deptno(+)
    and e1.mgr = e2.empno(+)
    and e1.sal between s.losal(+) and s.hisal(+)
order by d.deptno, e1.empno;

select d.deptno, d.dname, 
       e1.empno, e1.ename, e1.mgr, e2.ename,
       e1.sal, s.grade
from dept d 
    left join emp e1 on d.deptno = e1.deptno
    left join emp e2 on e1.mgr = e2.empno
    left join salgrade s on e1.sal between s.losal and s.hisal
order by d.deptno, e1.empno;
    
-- 부서 위치, 부서에서 근무하는 사원수를 출력(inner join)
select d.loc, count(e.empno)
from dept d, emp e
where d.deptno = e.deptno
group by d.loc;

select d.loc, count(e.empno)
from dept d inner join emp e
    on d.deptno = e.deptno
group by d.loc;

-- 위 결과에서 Boston도 출력되도록 수정(outer join)
select d.loc, count(e.empno)
from dept d, emp e
where d.deptno = e.deptno(+)
group by d.loc;

select d.loc, count(e.empno)
from dept d left outer join emp e
    on d.deptno = e.deptno
group by d.loc;

-- 부서 위치, 부서별 급여 합계를 출력(inner join)
select d.loc, sum(e.sal)
from dept d, emp e
where d.deptno = e.deptno
group by d.loc;

select d.loc, sum(e.sal)
from dept d inner join emp e
    on d.deptno = e.deptno
group by d.loc;

-- 위 결과에서 Boston도 출력되도록(outer join)
select d.loc, sum(e.sal)
from dept d, emp e
where d.deptno = e.deptno(+)
group by d.loc;

select d.loc, sum(e.sal)
from dept d left join emp e
    on d.deptno = e.deptno
group by d.loc;

-- 사원이름, 급여, 부서위치, 급여등급을 출력
-- 단, 급여는 3000 이상인 직원들만 출력
-- 사원이름 오름차순 출력
select e.ename, e.sal, d.loc, s.grade
from emp e, dept d, salgrade s 
where e.deptno = d.deptno
    and e.sal between s.losal and s.hisal
    and e.sal >= 3000
order by e.ename;

select e.ename, e.sal, d.loc, s.grade
from emp e 
    join dept d on e.deptno = d.deptno
    join salgrade s on e.sal between s.losal and s.hisal
where e.sal >= 3000
order by e.ename;