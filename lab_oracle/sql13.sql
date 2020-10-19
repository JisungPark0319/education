-- hr 계정으로 접속

-- 직원 이름(이름 성)과 부서이름을 출력
select e.first_name || ' ' || e.last_name as NAME,
       d.department_name
from employees e, departments d
where e.department_id = d.department_id;

select e.first_name || ' ' || e.last_name as NAME,
       d.department_name
from employees e join departments d
    on e.department_id = d.department_id;

-- 위 결과에서 부서번호가 없는 직원도 출력
select e.first_name || ' ' || e.last_name as NAME,
       d.department_name
from employees e, departments d
where e.department_id = d.department_id(+);

select e.first_name || ' ' || e.last_name as NAME,
       d.department_name
from employees e left join departments d
    on e.department_id = d.department_id;

-- 직원 이름(이름 성)과 직책이름을 출력
select e.first_name || ' ' || e.last_name as NAME,
       j.job_title
from employees e, jobs j
where e.job_id = j.job_id;

select e.first_name || ' ' || e.last_name as NAME,
       j.job_title
from employees e join jobs j
    on e.job_id = j.job_id;

-- 직원의 이름, 그 직원이 근무하는 도시 이름을 출력
-- employees, departments, locations를 join
select e.first_name || ' ' || e.last_name as NAME,
       l.city
from employees e, departments d, locations l
where e.department_id = d.department_id
      and
      d.location_id = l.location_id;

-- 직원 이름, 근무 도시 이름, 근무 국가를 출력
-- employees, departments, locations, countries를 join
select e.first_name || ' ' || e.last_name as NAME,
       l.city,
       c.country_name
from employees e, departments d, locations l, countries c
where e.department_id = d.department_id
      and
      d.location_id = l.location_id
      and
      l.country_id = c.country_id;


-- 2008년도에 입사한 직원들의 이름
select first_name || ' ' || last_name as NAME
from employees
--where to_char(hire_date, 'YYYY') = '2008';
where hire_date between to_date('2008/01/01', 'YYYY/MM/DD') 
                and to_date('2008/12/31', 'YYYY/MM/DD');

-- 2008년도에 입사한 직원들의 부서번호, 부서별 인원수
select department_id, count(*)
from employees
where to_char(hire_date, 'YYYY') = '2008'
group by department_id;

-- 2008년도에 입사한 직원들의 부서이름, 부서별 인원수
select d.department_name, count(*)
from employees e, departments d
where e.department_id = d.department_id
    and
      to_char(e.hire_date, 'YYYY') = '2008'
group by d.department_name;

select d.department_name, count(*)
from employees e inner join departments d
        on e.department_id = d.department_id
where to_char(e.hire_date, 'YYYY') = '2008'
group by d.department_name;

-- 2008년도에 입사한 직원들의 부서이름, 부서별 인원수
-- 단, 부서별 인원수가 5명 이상인 경우만 출력.
select d.department_name, count(*)
from employees e, departments d
where e.department_id = d.department_id
    and
      to_char(e.hire_date, 'YYYY') = '2008'
group by d.department_name
having count(*) >= 5;

select d.department_name, count(*)
from employees e inner join departments d
        on e.department_id = d.department_id
where to_char(e.hire_date, 'YYYY') = '2008'
group by d.department_name
having count(*) >= 5;

-- employees 테이블에서
-- 부서번호, 부서별 급여의 합계를 출력
select department_id, sum(salary) as SUM_SAL
from employees
group by department_id
order by SUM_SAL;

-- 부서별 급여 합계의 최댓값을 출력
select max(sum(salary))
from employees
group by department_id;

-- 부서별 급여 합계가 최대인 부서의 부서번호와 급여합계를 출력
select department_id, sum(salary) as SUM_SAL
from employees
group by department_id
having sum(salary) = (
    select max(sum(salary))
    from employees
    group by department_id
);

-- 부서별 급여 합계가 최대인 부서의 부서이름과 급여합계를 출력
select d.department_name, sum(e.salary) as SUM_SAL
from employees e, departments d
where e.department_id = d.department_id
group by d.department_name
having sum(e.salary) = (
    select max(sum(salary))
    from employees
    group by department_id
);

select d.department_name, sum(e.salary) as SUM_SAL
from employees e join departments d
    on e.department_id = d.department_id
group by d.department_name
having sum(e.salary) = (
    select max(sum(salary))
    from employees
    group by department_id
);

-- 사번, 국가이름, 급여를 출력
-- employees, departments, locations, countries 테이블 조인
select e.employee_id, c.country_name, e.salary
from employees e, departments d, locations l, countries c
where e.department_id = d.department_id
    and d.location_id = l.location_id
    and l.country_id = c.country_id;

select e.employee_id, c.country_name, e.salary
from employees e 
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id;
    
-- 국가이름, 국가별 급여 합계를 출력
select c.country_name, sum(e.salary)
from employees e, departments d, locations l, countries c
where e.department_id = d.department_id
    and d.location_id = l.location_id
    and l.country_id = c.country_id
group by c.country_name;

select c.country_name, sum(e.salary)
from employees e 
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name;

-- 사번, 직책 이름과, 급여를 출력
select e.employee_id, j.job_title, e.salary
from employees e, jobs j
where e.job_id = j.job_id;

select e.employee_id, j.job_title, e.salary
from employees e join jobs j
    on e.job_id = j.job_id;

-- 직책 이름과, 직책 이름별 급여의 합계를 출력
select j.job_title, sum(e.salary)
from employees e, jobs j
where e.job_id = j.job_id
group by j.job_title;

select j.job_title, sum(e.salary)
from employees e join jobs j
    on e.job_id = j.job_id
group by j.job_title;

-- 국가이름, 직책이름, 국가별 직책별 급여 합계를 출력
select c.country_name, j.job_title, sum(e.salary)
from employees e, jobs j, departments d, locations l, countries c
where e.job_id = j.job_id
    and e.department_id = d.department_id
    and d.location_id = l.location_id
    and l.country_id = c.country_id
group by c.country_name, j.job_title
order by c.country_name, j.job_title;

select c.country_name, j.job_title, sum(e.salary)
from employees e
    join jobs j on e.job_id = j.job_id
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name, j.job_title
order by c.country_name, j.job_title;

-- 국가이름, 직책이름, 국가별 직책별 급여 합계를 출력
-- 미국에서 (==> where)
-- 국가별 직책별 급여 합계가 50,000 이상인 (==> having)
-- 레코드만 출력
select c.country_name, j.job_title, sum(e.salary)
from employees e
    join jobs j on e.job_id = j.job_id
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    join countries c on l.country_id = c.country_id
group by c.country_name, j.job_title
having sum(e.salary) >= 50000
order by c.country_name, j.job_title;