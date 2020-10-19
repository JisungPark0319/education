-- create table & constraint 연습

-- 쇼핑몰의 고객 정보 테이블: customers
-- 컬럼:
--  1) customer_id: 고객 아이디. 8 ~ 20 bytes의 문자열.
--  2) customer_pw: 고객 비밀번호. 8 ~ 20 bytes의 문자열.
--  3) customer_email: 고객 이메일. 100 bytes까지 가능한 문자열.
--  4) customer_gender: 고객 성별. 1자리 정수.
--  5) customer_age: 고객 나이. 3자리 정수
-- 제약조건:
--  1) customer_id: Primary Key
--  2) customer_pw: Not Null
--  3) customer_gender: 0, 1, 2만 가능.
--  4) customer_age: 0 ~ 200까지 가능. 기본값은 0.
create table customers (
    customer_id     varchar2(20) 
            constraint pk_customers primary key
            constraint ck_cust_id check(lengthb(customer_id) >= 8),
    customer_pw     varchar2(20)
            constraint nn_cust_pw not null
            constraint ck_cust_pw check(lengthb(customer_pw) >= 8),
    customer_email  varchar2(100),
    customer_gender number(1)
            constraint ck_cust_gender check(customer_gender in (0, 1, 2)),
    customer_age    number(3) default 0
            constraint ck_cust_age check(customer_age between 0 and 200)
);

-- drop table customers;

desc customers;

create table customers2 (
    customer_id     varchar2(20),
    customer_pw     varchar2(20) not null,
    customer_email  varchar2(100),
    customer_gender number(1),
    customer_age    number(3) default 0,
    
    constraint pk_customers2 primary key (customer_id),
    constraint ck_cust_id2 check(lengthb(customer_id) >= 8),
    constraint ck_cust_pw2 check(lengthb(customer_pw) >= 8),
    constraint ck_cust_gender2 check(customer_gender in (0, 1, 2)),
    constraint ck_cust_age2 check(customer_age between 0 and 200)
);


-- 쇼핑몰의 주문 테이블: orders
-- 컬럼:
--  1) order_id: 주문번호, 12자리 정수.
--  2) order_date: 주문 날짜/시간. 기본값은 현재시간.
--  3) order_method: 주문 방법. 8 bytes 문자열.
--  4) customer_id: 주문 고객 아이디. 8 ~ 20 bytes의 문자열.
-- 제약조건:
--  1) order_id: Primary Key.
--  2) order_method: 'direct' 또는 'online'.
--  3) customer_id: Foreign Key.
create table orders (
    order_id        number(12)
        constraint pk_orders primary key,
    order_date      date default sysdate,
    order_method    varchar2(8)
        constraint ck_order_method check(order_method in ('direct', 'online')),
    customer_id     varchar2(20)
        constraint fk_cust_id references customers(customer_id)
);

create table orders2 (
    order_id        number(12),
    order_date      date default sysdate,
    order_method    varchar2(8),
    customer_id     varchar2(20),
    
    constraint pk_orders2 primary key (order_id),
    constraint ck_order_method2 check(order_method in ('direct', 'online')),
    constraint fk_cust_id2 foreign key (customer_id) 
            references customers(customer_id)
);

-- 주문 상품 정보 테이블: order_items
-- 컬럼:
--  1) order_id: 주문번호. 12자리 정수.
--  2) prodcut_id: 상품번호. 10자리 정수.
--  3) qauntity: 주문 상품 수량. 4자리 정수. 기본값 0.
--  4) price: 상품 가격. 10자리 정수.
-- 제약조건: (order_id, product_id): Primary Key
create table order_items (
    order_id    number(12),
    product_id  number(10),
    quantity    number(4) default 0,
    price       number(10),
    
    constraint pk_order_items primary key (order_id, product_id)
);

insert into customers (customer_email, customer_id, customer_pw)
values ('test@test.com', 'test1234', 'test!@#$');

insert into customers (customer_id, customer_pw, customer_gender)
values ('admin1234', 'admin!@#$', 1);

-- user_constraints: 제약조건들을 관리하는 메타 테이블
desc user_constraints;

-- 제약조건 이름, 타입, 조건을 검색
select constraint_name, constraint_type, search_condition 
from user_constraints;

-- 제약조건 이름을 알고 있을 때 제약조건 내용(타입, 조건)을 검색
select constraint_name, constraint_type, search_condition 
from user_constraints
where constraint_name = 'CK_CUST_GENDER';

select * from customers;
commit;

insert into orders (order_id)
values (10000);

insert into orders (order_id, customer_id)
values (10001, 'test1234');

select * from orders;
commit;

insert into order_items
values (10000, 123, 1, 1000);

insert into order_items
values (10000, 456, 2, 15000);

insert into order_items
values (10001, 123, 1, 1000);

select * from order_items;
