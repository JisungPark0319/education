-- 테이블 생성, 데이터 삽입(insert)

-- 테이블 이름: students
-- 컬럼: 
--  sid(숫자, 2자리) - 학생 번호
--  sname(문자, 10 bytes) - 학생 이름
--  birth(날짜) - 학생 생일
create table students (
    sid number(2),
    sname varchar2(10),
    birth date
);

-- 테이블의 구조(컬럼 이름, Null 가능 여부, 데이터 타입) 확인
desc students;

-- 데이터 검색
select * from students;

-- students 테이블에 (1, 오쌤, 2020/7/28) 레코드를 삽입
insert into students (sid, sname, birth)
values (1, '오쌤', sysdate);

-- students 테이블 (2, 홍길동, 2000/1/1) 레코드를 삽입
insert into students
values (2, '홍길동', '2000/1/1');
-- 삽입하려는 레코드가 테이블의 컬럼 개수와 같고, 순서도 같은 경우,
-- insert 문장에서 컬럼 이름들을 생략할 수 있음.

insert into students
values (3, '2000/1/1', '허균');  -- 에러 발생

-- sid=3, sname='허균'을 저장
insert into students (sid, sname)
values (3, '허균');

-- 컬럼 이름과 values는 서로 타입이 같아야 함!
insert into students (sname, sid)
values ('아이티윌', 4);

select * from students;

commit;


-- ssam 접속에서
insert into students values (99, '오정훈', '2000/12/31');
select * from students;
commit;


-- scott 접속에서
-- insert 에러가 발생하는 경우
insert into students
values (1, 'abc');  -- 컬럼 개수와 insert 값의 개수가 달라서

insert into students
values (1, 'abc', sysdate, 100);

insert into students (sid)
values (1000);  -- 컬럼에서 허용하는 숫자의 자릿수보다 더 큰 숫자를 입력 시도

insert into students (sname)
values ('데이터베이스'); -- 컬럼에서 허용하는 글자수(10바이트)보다 더 긴 문자열


