-- Oracle 연습 계정 활성화
-- 1) 명령 프롬프트 실행
-- 2) sqlplus를 사용해서 sysdba 권한으로 접속
-- 3) hr 계정의 비밀번호를 hr로 설정, 계정을 unlock(해제)
-- 4) hr 계정으로 접속
-- 5) hr 계정이 가지고 있는 테이블 이름들을 확인
-- 6) hr 계정이 가지고 있는 테이블들의 구조를 확인

-- SQL Developer에서 hr 접속 계정 설정
-- 1) 새 접속(+) 버튼 클릭
-- 2) Name, 사용자 이름, 비밀번호, SID 설정
--    -> 테스트 -> '성공' 확인 후 저장 -> 접속
-- 3) hr 계정이 가지고 있는 테이블 이름들 확인
select * from tab;
select * from user_tables;
select table_name from user_tables;

-- 4) hr 계정이 가지고 있는 테이블들의 구조를 확인
desc countries;
desc departments;
desc employees;

-- employees 테이블에서 first_name이 J로 시작하는 직원들의 
-- 사번, 이름, 성, 부서번호를 검색
-- 사번의 오름차순으로 정렬
select employee_id, first_name, last_name, department_id
from employees
where first_name like 'J%'
order by employee_id;

-- 전화번호가 011로 시작하는 직원들의 
-- 사번, 이름, 전화번호를 이름의 오름차순으로 정렬해서 출력
select employee_id, first_name, phone_number
from employees
where phone_number like '011%'
order by first_name;

-- 매니저 사번이 120인 직원들의 사번, 성, 급여, 입사일을 검색
-- 입사일 오름차순으로 정렬
select employee_id, last_name, salary, hire_date
from employees
where manager_id = 120
order by hire_date;

-- 사번이 120번인 직원의 모든 정보(레코드)를 검색
select * from employees
where employee_id = 120;

-- 급여가 3000 이상 5000 이하인 직원들의 사번, 성, 급여, 부서 번호를 검색
-- 급여 오름차순으로 정렬
select employee_id, last_name, salary, department_id
from employees
where salary between 3000 and 5000
order by salary;

select employee_id, last_name, salary, department_id
from employees
where salary >= 3000 and salary <= 5000
order by salary;

-- 수당을 지급받는 직원들의 사번, 성, 급여, 수당 퍼센트, 1년 연봉를 검색
-- 1년 연봉 = (급여 * 12) * (1 + 수당 퍼센트)
-- 1년 연봉 오름차순으로 정렬
select employee_id, last_name, salary, commission_pct,
       (salary * 12) * (1 + commission_pct) as annual_sal
from employees
where commission_pct is not null
order by annual_sal;


-- 1) employees 테이블에서 사번이 179인 직원의 레코드를 출력
select * from employees where employee_id = 179;

-- 2) 1)에서 찾은 정보를 사용해서, 179번 사원의 직책 이름을 출력
select job_title from jobs where job_id = 'SA_REP';

-- 3) 1)에서 찾은 정보를 사용해서, 179번 사원이 일하는 부서 정보(레코드)를 출력
select * from departments where department_id = 80;

-- 4) 1)에서 찾은 정보를 사용해서, 179번 사원의 매니저의 first/last name을 출력
select first_name, last_name
from employees
where employee_id = 149;

-- 5) 3)에서 찾은 정보를 사용해서, 179번 사원이 일하는 부서의 위치 정보(레코드)를 출력
select * from locations where location_id = 2500;

-- 6) departments 테이블에서 manager_id가 있는 부서의 정보들을 출력
select * from departments where manager_id is not null;

-- 7) departments 테이블에서 부서번호가 20인 부서의 레코드를 출력
select * from departments where department_id = 20;

-- 8) 7)에서 찾은 정보를 사용해서, 20번 부서의 관리자 정보(레코드)를 출력
select * from employees where employee_id = 201;

-- 9) 7)에서 찾은 정보를 사용해서, 20번 부서의 위치 정보 출력
select * from locations where location_id = 1800;

-- 10) 9)에서 찾은 정보를 사용해서, 20번 부서가 있는 나라의 이름을 출력
select country_name from countries where country_id = 'CA';

