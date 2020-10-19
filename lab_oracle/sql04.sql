-- SQL 산술 연산(+, -, *, /)
select 1 + 1 from dual;
-- dual: select ~ from 문법에 맞추기 위한 가상의 테이블 이름.

select sysdate from dual;
-- sysdate: 데이터베이스가 설치된 시스템의 시간.

select 100 * 12 + 500 from dual;
select sal * 12 + comm from emp;

-- 문자열 관련 함수
select upper('Hello world') from dual;
select lower('Hello world') from dual;
select initcap('Hello world') from dual;

-- emp 테이블에서 사원이름을 대문자, 소문자로 출력
select upper(ename), lower(ename)
from emp;

-- 이름이 scott인 직원의 레코드를 출력
select *
from emp
where lower(ename) = lower('Scott');

-- 문자열의 길이: length() - 글자 수, lengthb() - 글자 저장에 필요한 바이트 수
select length('hello'), lengthb('hello') from dual;
select length('안녕'), lengthb('안녕') from dual;

-- 부서 테이블에서, 부서이름과 부서이름의 길이를 출력
select dname, length(dname) from dept;

-- substr(문자열, 시작인덱스, 잘라낼 문자 개수)
select substr('Hello world', 1, 5) from dual;
select substr('Hello world', 3, 5) from dual;
-- substr(문자열, 시작인덱스)
select substr('Hello world', 3) from dual;
select substr('Hello world', -3) from dual;

-- concat(문자열1, 문자열2)
select concat('hello', 'world') from dual;
select concat('hello', ' world') from dual;
select concat(concat('hello', ' '), 'world') 
from dual;

-- trim(문자열): 문자열의 시작과 끝에 있는 공백들을 제거.
-- 단어와 단어 사이의 공백들은 제거하지 않음!
select trim('    hello   world    olleh    ') from dual;

-- trim(제거할 문자 from 문자열):
-- 문자열의 시작부분과 끝부분에서 '제거할 문자'들을 삭제.
select trim('h' from 'hhhello hhh world hhh ollehhhh') from dual;

-- lpad(문자열, 자릿수, padding 문자)
-- rpad(문자열, 자릿수, padding 문자)
select lpad('hello', 7, '*'), rpad('hello', 7, '*')
from dual;
select lpad('hello', 4, '*'), rpad('hello', 4, '*')
from dual;

-- 'hello'에서 첫 두글자만 출력, 나머지 세글자는 *로 출력
select rpad(substr('hello', 1, 2), length('hello'), '*')
from dual;

-- 'hello'에서 마지막 두글자만 출력, 나머지 세글자는 *로 출력
select lpad(substr('hello', -2), length('hello'), '*')
from dual;

select rpad('안녕하세요', lengthb('안녕하세요') + 2, '*') 
from dual;

-- 사원 테이블에서 10번 부서에서 근무하는 사원의 사번, 이름, 급여를 검색
-- 사번은 첫 두자리만 출력하고, 나머지 두자리는 *로 출력
-- 이름은 5글자까지만 출력하되, 첫 두글자만 출력하고 나머지는 *로 출력
-- 출력 순서는 사번의 오름차순으로 출력
select rpad(substr(empno, 1, 2), 4, '*') as emp_no, 
       rpad(substr(ename, 1, 2), 5, '*') as emp_name, 
       sal as salary
from emp
where deptno = 10
order by empno;
