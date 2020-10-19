-- 숫자 관련 함수

-- round(): 반올림
select 1234.5678, round(1234.5678),
       round(1234.5678, 1), round(1234.5678, 2),
       round(1234.5678, -1), round(1234.5678, -2)
from dual;

-- trunc(): 버림
select 1234.5678, trunc(1234.5678),
       trunc(1234.5678, 1), trunc(1234.5678, 2),
       trunc(1234.5678, -1), trunc(1234.5678, -2)
from dual;

select 10/3 from dual;

-- mod(): 나눈 나머지
select mod(10, 3) from dual;

-- floor(), ceil()
select floor(3.14), ceil(3.14),
       floor(-3.14), ceil(-3.14),
       trunc(-3.14)
from dual;


-- 데이터 타입 변환 함수
-- to_char(): 문자열을 반환(return)
-- to_number(): 숫자를 반환
-- to_date(): 날짜 타입을 반환

select 'abc' + 'def' from dual;  -- 에러 발생
-- 오라클에서는 산술연산(+, -, *, /)은 숫자 타입만 가능.
-- 문자열과 문자열을 + (또는 -, *, /)할 수 없음.

select '100' + 123 from dual;
-- 원래는 문자열과 숫자의 덧셈이기 때문에 에러가 발생해야 하지만,
-- 오라클이 문자열 '100'을 숫자 100으로 변환한 후 덧셈을 실행함.
-- 오라클 내부에서는 다음과 같은 문장이 실행된 것과 동일.
select to_number('100') + 123 from dual;

select substr(1234, 1, 2) from dual;
-- substr() 함수는 문자열을 잘라주는 함수이므로, 문자열이 있어야 함.
-- 오라클 내부에서는 숫자 1234를 문자열 '1234'로 변환한 후 substr을 실행함.
-- 오라클 내부에서 다음과 같은 문장이 실행된 것과 동일.
select substr(to_char(1234), 1, 2) from dual;

-- 날짜와 to_char()
select sysdate from dual;
-- SQL Developer -> 도구 -> 환경설정 -> 데이터베이스 -> NLS(National Language Support)
-- 설정된 날짜 포맷(형식)으로 화면에 출력
-- 환경 설정과 관계없이 출력되는 포맷을 변경:
select sysdate,
       to_char(sysdate, 'YYYY/MM/DD'),
       to_char(sysdate, 'YYYY-MM-DD'),
       to_char(sysdate, 'RR/MM/DD'),
       to_char(sysdate, 'YY/MM/DD')
from dual;

-- to_char(날짜, '날짜 포맷'): 문자열을 반환
-- to_date('문자열', '날짜 포맷'): 날짜 타입 반환
select to_date('19/07/22', 'YYYY/MM/DD'),
       to_date('19/07/22', 'YY/MM/DD'),
       to_date('19/07/22', 'RR/MM/DD')
from dual;

select to_date('95/07/22', 'YYYY/MM/DD'),
       to_date('95/07/22', 'YY/MM/DD'),
       to_date('95/07/22', 'RR/MM/DD')
from dual;

select to_date('21/07/22', 'YYYY/MM/DD'),
       to_date('21/07/22', 'YY/MM/DD'),
       to_date('21/07/22', 'RR/MM/DD')
from dual;

select to_date('49/07/22', 'YYYY/MM/DD'),
       to_date('49/07/22', 'YY/MM/DD'),
       to_date('49/07/22', 'RR/MM/DD')
from dual;

-- YY: 현재 세기에서 연도 마지막 두자리
-- RR: 1850 ~ 1949, 1950 ~ 2049, 2050 ~ 2149, ....

-- 날짜 관련 함수/기능
-- 날짜 + 숫자 = 날짜
-- 날짜 - 숫자 = 날짜
select sysdate,
       sysdate + 1,
       sysdate - 1
from dual;

-- add_months(날짜, 숫자)
select sysdate,
       add_months(sysdate, 1),
       add_months(sysdate, -1)
from dual;

-- 날짜 - 날짜 = 숫자
select sysdate - (sysdate - 1) from dual;
select sysdate - to_date('2019/07/22', 'YYYY/MM/DD')
from dual;
-- 날짜와 날짜 사이의 일수를 계산: round(날짜 - 날짜), trunc(날짜 - 날짜)

-- months_between(날짜, 날짜): 날짜와 날짜 사이의 개월수
-- emp 테이블에서 사원이름, 입사일, 현재까지의 근무 개월수 출력
-- 근무를 가장 오래한 사원부터 내림차순으로 정렬
select ename, hiredate, 
       trunc(months_between(sysdate, hiredate)) as months
from emp
order by months desc;

-- emp 테이블에서 
-- 사번, 이름, 입사일, 급여, 근무 개월수, 현재까지 받은 총 급여를 출력
-- 급여는 변동이 없다고 가정.
-- 입사일은 년/월/일 출력.
-- 총 급여가 가장 많은 사원부터 내림차순 정렬.
select empno, ename, 
       to_char(hiredate, 'YYYY/MM/DD') as hiredate,
       sal,
       trunc(months_between(sysdate, hiredate)) as months,
       sal * trunc(months_between(sysdate, hiredate)) as total_sal
from emp
order by total_sal desc;

-- 사원 정보를 출력. 입사일 순서로 출력.
select * from emp order by hiredate;

-- 1981년 입사한 사원들의 정보 출력
-- 입사일: 1981/01/01 ~ 1981/12/31
select * from emp
where hiredate between to_date('1981/01/01', 'YYYY/MM/DD')
                    and to_date('1981/12/31', 'YYYY/MM/DD')
order by hiredate;

select to_char(hiredate, 'YYYY') from emp;

select * from emp
where to_char(hiredate, 'YYYY') = '1981'
order by hiredate;

-- last_day(날짜): 날짜가 포함된 달의 마지막 날
select last_day(sysdate) from dual;

-- null 처리 함수
select sal * 12 + comm from emp;

-- nvl(컬럼, null을 대체할 값)
-- nvl2(컬럼, null이 아닐 때 대체할 값, null일 때 대체할 값)
select comm, nvl(comm, -1), nvl2(comm, 'True', 'False')
from emp;

select comm, nvl(comm, -1), nvl2(comm, comm, -1)
from emp;

-- comm이 null인 경우는 0으로 대체해서 1년 연봉을 계산, 출력.
-- 연봉 = sal * 12 + comm
select sal, comm, 
       sal * 12 + nvl(comm, 0) as annual_sal
from emp;
