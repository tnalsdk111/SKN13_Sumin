create user 'playdata'@'localhost' identified by '1111';
create user 'playdata'@'%' identified by '1111';

-- 00_ddl.sql
-- 생성된 계정을 확인
select user, host from mysql.user;

-- SQL문 작성: 한 명령문이 끝나면 ; 으로 종료.
-- 실행: control + enter
-- 한줄 주석
# 한줄 주석
/* block 주석 */
-- ctrl + / : 커서가 있는 곳에서 주석을 생성한다. 

-- 계정에 권한을 부여
-- grant 부여할 권한 on 대상 테이블 to 권한부여할 계정
grant all privileges on *.* to playdata@localhost;
grant all privileges on *.* to playdata@'%';
-- *:DB.*:table

########################
# DB 생성
# ######################
create database test_db;

create database hr;

show databases; # 만들어진 DB를 보여준다.

-- grant all privileges on test_db.* to playdata@'%'; 
-- test_db 데이터베이스 안에 있는 모든 테이블에 권한을 준다.
 
 drop database hr; # DB 삭제
 
 use test_db; # 작업할 DB 지정
 -- table 이름 => test_db database의 테이블.
 -- sys.sys_config => 다른 database의 테이블 호출: db이름.테이블이름
 
 ########################
 # 테이블 생성
 ########################
 
-- create table test_db.member();
use test_db; -- database 이름을 명시하지 않으면 test_db이다. 
create table member(
	id varchar(10) primary key, # 최대 10글자까지
    password varchar(10) not null, # 필수 입력
    name varchar(50) not null,
    point int default 1000, # 값을 넣지 않으면 1000을 기본적으로 넣는다.
    email varchar(100) not null unique, # unique: 중복값을 허용하지 않는다. 
    age int check(age > 19),
    join_date timestamp not null default current_timestamp
    -- default current_timestamp: 값이 insert되는 시점을 저장member 
);

-- 테이블들 조회
show tables;

-- 테이블의 컬럼 정보 조회
desc member; 

-- 테이블을 삭제
-- drop table if exists aaaaa; # if exists를 써서 기존에 테이블이 존재한다면 삭제

drop table if exists member;

######################
# insert
######################

-- 모든 컬럼에 값을 다 넣을 경우 컬럼명 생략 
insert into member values ('sumin0121', '1111', '안수민', 5000, 'aaa@naver.com', 22, '2025-04-03 12:16:40');

-- point, join_date: default값, age: null
insert into member (id, password, name, email)
values ('id-200', '2222', '치이카와', 'chi@naver.com'); 

SELECT * FROM member;

insert into member (id, password, name, point, email)
values ('id-300', '3333', '강감찬', null, 'kang@naver,com');

insert into member (id, password, name, email, age)
values ('id-4000', '2222', '우사기', 'usagi@naver.com', 5); 





 