-- join

-- emp, dept 테이블에서
-- 사번, 이름, 부서번호, 부서이름 검색
-- 1) Oracle 문법
-- select 컬럼
-- from 테이블1, 테이블2, ...
-- where join 조건;
select e.empno, e.ename, e.deptno, d.dname
from emp e, dept d
where e.deptno = d.deptno;

-- 2) ANSI 표준 문법:
-- select 컬럼, ...
-- from 테이블1 join방식 테이블2 on join조건;
select e.empno, e.ename, e.deptno, d.dname
from emp e inner join dept d
    on e.deptno = d.deptno;
-- inner join에서 inner는 생략 가능.

-- emp, dept 테이블에서
-- 사번, 사원이름, 부서번호, 부서이름 검색
-- emp 테이블에는 없지만, dept 테이블에 있는 부서는 전부 출력
-- 1) Oracle
select e.empno, e.ename, d.deptno, d.dname
from emp e, dept d
where e.deptno(+) = d.deptno;

-- 2) ANSI
select e.empno, e.ename, d.deptno, d.dname
from emp e right outer join dept d
    on e.deptno = d.deptno;
-- left outer join, right outer join에서 outer는 생략 가능    

-- 부서번호, 부서이름, 사원이름 검색. 
-- dept 테이블의 부서번호와 부서이름은 모두 출력.
select d.deptno, d.dname, e.ename
from dept d, emp e
where d.deptno = e.deptno(+);

select d.deptno, d.dname, e.ename
from dept d left join emp e
    on d.deptno = e.deptno;

-- emp, salgrade 테이블에서
-- 사번, 이름, 급여, 급여등급을 검색
-- 1) Oracle
select e.empno, e.ename, e.sal, s.grade
from emp e, salgrade s
where e.sal between s.losal and s.hisal;

-- 2) ANSI
select e.empno, e.ename, e.sal, s.grade
from emp e join salgrade s
    on e.sal between s.losal and s.hisal;
    
-- emp, dept 테이블에서
-- 사번, 사원이름, 부서이름, 급여를 출력
-- 급여가 2000 이상인 사원들만 선택.
-- 1) Oracle
select e.empno, e.ename, d.dname, e.sal
from emp e, dept d
where e.deptno = d.deptno
    and
      e.sal >= 2000;
-- 2) ANSI
select e.empno, e.ename, d.dname, e.sal
from emp e join dept d
    on e.deptno = d.deptno 
where e.sal >= 2000;

-- emp 테이블에서 사번, 이름, 매니저 사번, 매니저 이름 출력
-- 1) Oracle
-- (inner) join
select e1.empno, e1.ename as 사원이름, 
       e1.mgr, e2.ename as 매니저이름
from emp e1, emp e2 
where e1.mgr = e2.empno;
-- left (outer) join
select e1.empno, e1.ename as 사원이름, 
       e1.mgr, e2.ename as 매니저이름
from emp e1, emp e2 
where e1.mgr = e2.empno(+);

-- 2) ANSI
-- inner join
select e1.empno, e1.ename as EMP_NAME,
       e1.mgr, e2.ename as MGR_NAME
from emp e1 join emp e2 on e1.mgr = e2.empno;
-- left outer join
select e1.empno, e1.ename as EMP_NAME,
       e1.mgr, e2.ename as MGR_NAME
from emp e1 left join emp e2 on e1.mgr = e2.empno;

-- Oracle right outer join
select e1.empno, e1.ename as 사원이름, 
       e1.mgr, e2.ename as 매니저이름
from emp e1, emp e2 
where e1.mgr(+) = e2.empno;

-- 사번, 사원이름, 부서이름, 급여, 급여등급 출력
-- 1) Oracle
select e.empno, e.ename, d.dname, e.sal, s.grade
from emp e, dept d, salgrade s
where e.deptno = d.deptno 
    and e.sal between s.losal and s.hisal;
-- 2) ANSI
select e.empno, e.ename, d.dname, e.sal, s.grade
from emp e 
    join dept d on e.deptno = d.deptno
    join salgrade s on e.sal between s.losal and s.hisal;

-- left, right, full outer join 비교
select e1.empno, e1.ename as EMP_NAME,
       e1.mgr, e2.ename as MGR_NAME
from emp e1, emp e2
where e1.mgr = e2.empno(+)
order by e1.empno;
-- 매니저를 갖지 않는(매니저 사번이 없는) KING의 정보도 출력

select e1.empno, e1.ename as EMP_NAME,
       e2.empno, e2.ename as MGR_NAME
from emp e1, emp e2
where e1.mgr(+) = e2.empno
order by e1.empno;
-- 매니저가 아닌 사원들도 출력. 왼쪽 테이블에서 KING이 제외.

select e1.empno, e1.ename as EMP_NAME,
       e2.empno, e2.ename as MGR_NAME
from emp e1 full outer join emp e2
    on e1.mgr = e2.empno
order by e1.empno;

-- full outer join에서 outer는 생략가능.
-- full outer join은 Oracle 문법에서는 제공하지 않음!
-- Oracle에서는 left와 right join의 합집합으로 문장을 만들 수 있음.
select e1.empno, e1.ename as EMP_NAME,
       e1.mgr, e2.ename as MGR_NAME
from emp e1, emp e2
where e1.mgr = e2.empno(+)
union
select e1.empno, e1.ename as EMP_NAME,
       e1.mgr, e2.ename as MGR_NAME
from emp e1, emp e2
where e1.mgr(+) = e2.empno
order by empno;
