-- scott 접속 사용
-- 테이블 이름: call_chicken
-- 컬럼: call_date, call_day, gu, ages, gender, calls
create table call_chicken (
    call_date   date,
    call_day    varchar2(2),
    gu          varchar2(10),
    ages        varchar2(10),
    gender      varchar2(2),
    calls       number(3)
);

desc call_chicken;

select * from call_chicken;
select count(*) from call_chicken;

-- csv(comma-separated values) 파일:
-- 값들이 comma(,)로 분리되어 저장된 텍스트 파일.
-- comma로 값들을 분리하는 경우가 대부분이지만,
-- 때로는 공백(' '), 탭, colon(':' 또는 '::') 등으로 분리하기도 함.

-- call_chicken 테이블에서
-- 1) 통화건수의 최댓값과 최솟값을 찾으세요.
select max(calls), min(calls)
from call_chicken;

select max(call_date), min(call_date)
from call_chicken;

-- 2) 통화건수가 최댓값 또는 최솟값인 경우 모든 컬럼을 출력하세요.
select *
from call_chicken
where calls = (select max(calls) from call_chicken)
      or
      calls = (select min(calls) from call_chicken)
order by calls desc;

select *
from call_chicken
where calls in (
    select max(calls) as CALLS from call_chicken
    union
    select min(calls) as CALLS from call_chicken
)
order by calls desc;

select * from emp
where sal in (select sal from emp where deptno=10);

select deptno, sal from emp where empno=7839;
select * from emp
where sal in (select deptno, sal from emp where empno=7839);

-- 3) 요일별 통화건수의 평균을 출력하세요.
select call_day, round(avg(calls), 1) as AVG_SAL
from call_chicken
group by call_day
order by AVG_SAL desc;

-- 4) 연령대별 통화건수의 평균을 출력하세요.
select ages, round(avg(calls), 1) as AVG_CALLS
from call_chicken
group by ages
order by AVG_CALLS desc;

-- 5) 요일별, 연령대별 통화건수의 평균을 출력하세요.
select call_day, ages, 
       round(avg(calls), 1) as AVG_CALLS
from call_chicken
group by call_day, ages
order by AVG_CALLS desc;

-- 6) 구별, 성별 통화건수의 평균을 출력하세요.
select gu, gender, 
       round(avg(calls), 1) as AVG_CALLS
from call_chicken
group by gu, gender
order by AVG_CALLS desc;

-- 7) 요일별, 구별, 연령대별 통화건수의 평균을 출력하세요.
select call_day, gu, ages,
       round(avg(calls), 1) as AVG_CALLS
from call_chicken
group by call_day, gu, ages
order by AVG_CALLS desc;

-- 모든 출력은 통화건수 평균의 내림차순으로 출력하고,
-- 소숫점 이하 1자리까지만 출력하세요.

