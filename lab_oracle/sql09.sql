-- hr 계정으로 접속
-- employees 테이블 사용

-- 1) 부서별 사원수, 급여의 최댓값, 최솟값, 합계, 평균, 중앙값, 
-- 분산, 표준편차를 출력
-- 부서번호 오름차순으로 출력
select department_id, 
       count(*) as CONUTS,
       max(salary) as MAX_SAL,
       min(salary) as MIN_SAL,
       sum(salary) as SUM_SAL,
       round(avg(salary), 2) as AVG_SAL,
       median(salary) as MEDIAN_SAL,
       round(variance(salary)) as VAR_SAL,
       round(stddev(salary)) as STDDEV_SAL
from employees
group by department_id
order by department_id;

-- 2) 직책별 사원수, 급여의 최댓값, 최솟값, 합계, 평균, 중앙값, 
-- 분산, 표준편차를 출력
-- job_id 오름차순으로 출력
select job_id, 
       count(*) as CONUTS,
       max(salary) as MAX_SAL,
       min(salary) as MIN_SAL,
       sum(salary) as SUM_SAL,
       round(avg(salary), 2) as AVG_SAL,
       median(salary) as MEDIAN_SAL,
       round(variance(salary)) as VAR_SAL,
       round(stddev(salary)) as STDDEV_SAL
from employees
group by job_id
order by job_id;

-- 3) 부서별, 직책별 사원수, 급여의 평균을 출력
select department_id, job_id, count(*), avg(salary)
from employees
group by department_id, job_id
order by department_id, job_id;

-- 4) 사번, 이름(first/last name), 입사일, 급여를 출력
-- 입사일 오름차순으로 출력
select employee_id, 
--       concat(concat(first_name, ' '), last_name) as NAME,
       first_name || ' ' || last_name as NAME,
       hire_date,
       salary
from employees
order by hire_date;

-- 5) 입사연도별 사원수, 급여의 최댓값, 최솟값, 평균을 출력.
-- 입사연도 오름차순으로 출력
select to_char(hire_date, 'YYYY') as YEAR,
       count(*) as COUNTS,
       max(salary) as MAX_SAL,
       min(salary) as MIN_SAL,
       round(avg(salary), 2) as AVG_SAL
from employees
group by to_char(hire_date, 'YYYY')
order by YEAR;

-- 6) 수당을 받는 직원들 중에서
-- 직책별 사원수, 연봉의 평균을 출력
-- 연봉 = salary * 12 * (1 + commission_pct)
select job_id, 
       count(*), 
       avg(salary * 12 * (1 + commission_pct))
from employees
where commission_pct is not null
group by job_id;

-- 7) 부서번호가 90번이 아니고 null이 아닌 사원들 중에서
-- 부서별 인원수가 10명 이상인 부서의
-- 부서별 인원수, 급여 최솟값, 최댓값, 평균을 출력
-- 부서번호 오름차순으로 출력
select department_id, count(*), min(salary), max(salary), avg(salary)
from employees
where department_id != 90
group by department_id
--having count(*) >= 10
order by department_id;

-- 8) 각 부서에서 급여가 가장 작은 사원의 부서번호, 사번, 이름, 급여, 출력
-- 부서번호 오름차순으로 출력
select department_id, min(salary)
from employees
group by department_id;

select department_id, employee_id, 
       first_name || ' ' || last_name as NAME,
       salary
from employees
where (department_id, salary) in (
    select department_id, min(salary) from employees
    group by department_id
)
order by department_id;

-- 9) 각 부서에서 급여가 가장 많은 직원의 부서번호, 사번, 이름, 급여, 출력
-- 부서번호 오름차순으로 출력
select department_id, employee_id, 
       first_name || ' ' || last_name as NAME,
       salary
from employees
where (department_id, salary) in (
    select department_id, max(salary) from employees
    group by department_id
)
order by department_id;
