/* ***********************************************
단일행 함수: 
	- 행별로 처리하는 함수. 문자/숫자/날짜/변환 함수 
	- 단일행은 select, where절에 사용가능
다중행 함수: 
	- 여러행을 묶어서 한번에 처리하는 함수 => 집계함수, 그룹함수라고 한다.
	- 다중행은 where절에는 사용할 수 없다. (sub query 이용) 
* ***********************************************/

/* ***************************************************************************************************************
# 함수 
- 문자열관련 함수
 char_length(v) - v의 글자수 반환
 concat(v1, v2[, ..]) - 값들을 합쳐 하나의 문자열로 반환
 format(숫자, 소수부 자릿수) - 정수부에 단위 구분자 "," 를 표시하고 지정한 소수부 자리까지만 문자열로 만들어 반환
 upper(v), lower(v) - v를 모두 대문자/소문자 로 변환
 insert(기준문자열, 위치, 길이, 삽입문자열): 위치기준으로 변경. 기준문자열의 위치(1부터 시작)에서부터 길이까지 지우고 삽입문자열을 넣는다.
 replace(기준문자열, 원래문자열, 바꿀문자열): 문자열기준으로 변경. 기준문자열의 원래문자열을 바꿀문자열로 바꾼다.
 left(기준문자열, 길이), right(기준문자열, 길이): 기준문자열에서 왼쪽(left), 오른쪽(right)의 길이만큼의 문자열을 반환한다.
 substring(기준문자열, 시작위치, 길이): 기준문자열에서 시작위치부터 길이 개수의 글자 만큼 잘라서 반환한다. 길이를 생략하면 마지막까지 잘라낸다.
 substring_index(기준문자열, 구분자, 개수): 기준문자열을 구분자를 기준으로 나눈 뒤 개수만큼 반환. 개수: 양수 – 앞에서 부터 개수,  음수 – 뒤에서 부터 개수만큼 반환
 ltrim(문자열), rtrim(문자열), trim(문자열): 문자열에서 왼쪽(ltrim), 오른쪽(rtrim), 양쪽(trim)의 공백을 제거한다. 중간공백은 유지
 trim(방향  제거할문자열  from 기준문자열): 기준문자열에서 방향에 있는 제거할문자열을 제거한다.
								   방향: both (앞,뒤), leading (앞), trailing (뒤)
 lpad(기준문자열, 길이, 채울문자열), rpad(기준문자열, 길이, 채울문자열): 기준문자열을 길이만큼 늘린 뒤 남는 길이만큼 채울문자열로 왼쪽(lpad), 오른쪽(rpad)에 채운다.
													   기준문자열 글자수가 길이보다 많을 경우 나머지는 자른다.
*************************************************************************************************************** */

use hr;

-- EMP 테이블에서 직원의 이름(emp_name)을 모두 대문자, 소문자, 이름 글자수를 조회
select emp_name, upper(emp_name), lower(emp_name), char_length(emp_name) as 글자수 
from   emp;

-- 직원 이름(emp_name) 의 자릿수를 15자리로 맞추고 15자가 안되는 이름의 경우  공백을 앞에 붙여 조회.
select emp_name as "name1",
	   lpad(emp_name, 15, '*') as "name2", # emp_name에서 15글자가 안 되면 왼쪽을 '*'로 채워 글자수를 15로 만든다. 
       rpad(emp_name, 15, '*') as "name3" # emp_name에서 15글자가 안 되면 오른쪽을 '*'로 채워 글자수를 15로 만든다.
from   emp;

    
--  EMP 테이블에서 이름(emp_name)이 10글자 이상인 직원들의 이름(emp_name)과 이름의 글자수 조회
select emp_name, char_length(emp_name)
from   emp
where  char_length(emp_name) >= 10; 


-- 연봉(salary)를 소수점 세 자리까지 나타낸다.
select format(salary, 3)
from   emp; 


-- 앞에 달러를 붙인다. 
select concat('$', format(salary, 3)) as salary # 안쪽 format 함수 먼저 실행 -> 바깥 concat 함수 실행
from   emp; 


/* **************************************************************************

- 숫자관련 함수
 abs(값): 절대값 반환
 round(값, 자릿수): 자릿수이하에서 반올림 (양수 - 실수부, 음수 - 정수부, 기본값: 0-0이하에서 반올림이므로 정수로 반올림)
 truncate(값, 자릿수): 자릿수이하에서 절삭-버림(자릿수: 양수 - 실수부, 음수 - 정수부, 기본값: 0)
 ceil(값): 값보다 큰 정수중 가장 작은 정수. 소숫점 이하 올린다. 
 floor(값): 값보다 작은 정수중 가장 작은 정수. 소숫점 이하를 버린다. 내림
 sign(값): 숫자 n의 부호를 정수로 반환(1-양수, 0, -1-음수)
 mod(n1, n2): n1 % n2

************************************************************************** */


-- EMP 테이블에서 각 직원에 대해 직원ID(emp_id), 이름(emp_name), 급여(salary) 그리고 15% 인상된 급여(salary)를 조회하는 질의를 작성하시오.
-- (단, 15% 인상된 급여는 올림해서 정수로 표시하고, 별칭을 "SAL_RAISE"로 지정.)
select emp_id, 
	   emp_name,
       salary,
       ceil(salary * 1.15) as "SAL_RAISE1", # 올림
       floor(salary * 1.15) as "SAL_RAISE2", # 내림
       truncate(salary * 1.15, 0)  as "SAL_RAISE3", # 내림
       ceil(salary * 1.15) - salary
       # "SAL_RAISE" - salary는 안 된다. 기존 컬럼끼리는 연산이 가능하나 별칭으로 만든 건 안 된다. 
from emp;



-- 위의 SQL문에서 인상 급여(sal_raise)와 급여(salary) 간의 차액을 추가로 조회 
-- (직원ID(emp_id), 이름(emp_name), 15% 인상급여, 인상된 급여와 기존 급여(salary)와 차액)



--  EMP 테이블에서 커미션이 있는 직원들의 직원_ID(emp_id), 이름(emp_name), 커미션비율(comm_pct), 커미션비율(comm_pct)을 8% 인상한 결과를 조회.
-- (단 커미션을 8% 인상한 결과는 소숫점 이하 2자리에서 반올림하고 별칭은 comm_raise로 지정)
select emp_id, 
	   emp_name, 
       comm_pct, 
       round(comm_pct * 1.08, 2) as "comm_raise", # 두 번째 자리 이하에서 반올림
       salary,
       round(salary, -3) # round 자릿수가 양수면 소수점 이하, 음수면 정수부분으로 한칸씩 왼쪽으로 간다 
       # 이 경우 천의 자리가 -3번째 이므로 그 이하인 백의 자리에서 반올림 한다.
from   emp
where  comm_pct is not null;


/* ***************************************************************************************************************
- 날짜관련 함수
 
 now(): 현재 datetime
 curdate(): 현재 date
 curtime(): 현재 time
 year(날짜), month(날짜), day(날짜): 날짜 또는 일시의 년, 월, 일 을 반환한다.
 hour(시간), minute(시간), second(시간), microsecond(시간): 시간 또는 일시의 시, 분, 초, 밀리초를 반환한다.
 date(), time(): datetime 에서 날짜(date), 시간(time)만 추출한다.
 
 날짜 연산
 adddate/subdate(DATETIME/DATE/TIME,  INTERVAL 값  단위)
 	- 날짜에서 특정 일시만큼 더하고(add) 빼는(sub) 함수.
    - 단위: MICROSECOND, SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER(분기-3개월), YEAR
 
 datediff(날짜1, 날짜2): 날짜1 – 날짜2한 일수를 반환
 timediff(시간1, 시간2): 시간1-시간2 한 시간을 계산해서 반환 (뺀 결과를 시:분:초 로 반환)
 timestampdiff(계산할대상단위, 시작일시, 끝일시) - 계산대상 단위에 맞춰 계산한 기간을 반환. 끝일시 - 시작일시
 
 dayofweek(날짜): 날짜의 요일을 정수로 반환 (1: 일요일 ~ 7: 토요일)

 date_format(일시, 형식문자열): 일시를 원하는 형식의 문자열로 반환
*************************************************************************************************************** */
-- 실행시점의 일/시를 조회 함수
# from절 없이 쓸 수 있는 예외적인 문법임. 
select now(); # datetime # 2025-04-04 10:37:22
select curdate(); # date # 2025-04-04
select curtime(); # time # 10:37:15

-- 날짜 타입에서 년 월 일 조회
select curdate(), -- date type # 2025-04-04
	   year(curdate()), # 2025
       month(curdate()), # 4
       day(curdate()), # 4
       dayofweek(curdate()); # 6(금요일) # 1(일요일) ~ 7(토요일) 


-- 시간 타입에서 시 분 초 조회
select curtime(), # date
	   hour(curtime()),
       minute(curtime()),
       second(curtime());
       
       
select now(), # datetime # 2025-04-04 10:44:28
	   year(now()), # 2025
       hour(now()); # 10
       
       
-- 특정 기간 만큼 전,후의 일시를 조회
select curdate(), # 2025-04-04
	   adddate(curdate(), interval 3 year), # 3년 후, 2028-04-04
       adddate(curdate(), interval 40 day), # 40일 후, 2025-05-14
       subdate(curdate(), interval 3 year), # 3년 전, 2022-04-04
       adddate(curdate(), interval -3 year) # 3년 전, 2022-04-04 (위와 동일)
       ;
       

-- EMP 테이블에서 부서이름(dept_name)이 'IT'인 직원들의 '입사일(hire_date)로 부터 10일전', 입사일, '입사일로 부터 10일 후' 의 날짜를 조회. 
select hire_date as "입사일",
	   subdate(hire_date, interval 10 day) as "입사 10일 전",
       adddate(hire_Date, interval 10 day) as "입사 10일 후",
       adddate(hire_Date, interval 10 month) as "입사 10개월 후",
       adddate(hire_Date, interval 3 quarter) as "입사 3분기 후",
       adddate(hire_Date, interval 10 week) as "입사 10주 후"
from emp
where dept_name = 'IT';

-- ID(emp_id)가 200인 직원의 이름(emp_name), 입사일(hire_date)를 조회. 입사일은 yyyy년 mm월 dd일 형식으로 출력.
select emp_name,
	   date_format(hire_date, '%Y년 %m월 %d일') # 2003년 09월 17일
from   emp
where  emp_id = 200;

--  각 직원의 이름(emp_name), 근무 개월수 (입사일에서 현재까지의 달 수)를 계산하여 조회. 근무개월수 내림차순으로 정렬.
select emp_name, 
	   hire_date,
       timestampdiff(month, hire_date, curdate()) as "근무 개월 수" # now()도 가능 
from emp
order by timestampdiff(month, hire_date, curdate()) desc;
-- order by "근무 개월 수" desc; (X)

-- 270개월 이상 근무한 직원을 조회하고 싶다. 
select emp_name,
	   hire_date, 
       timestampdiff(month, hire_date, curdate()) as "근무 개월 수"
from   emp
where  timestampdiff(month, hire_date, curdate()) >= 270
order by timestampdiff(month, hire_date, curdate()) desc;


/* *************************************************************************************
함수 - 조건 처리함수
ifnull (기준컬럼(값), 기본값): 기준컬럼(값)이 NULL값이면 기본값을 출력하고 NULL이 아니면 기준컬럼 값을 출력
if (조건수식, 참, 거짓): 조건수식이 True이면 참을 False이면 거짓을 출력한다.
************************************************************************************* */
select ifnull(10, -1); # 10
select ifnull(null, -1); # -1
select if (True, 1, -1); # 1
select if (False, 1, -1); # -1

-- EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 업무(job), 부서(dept_name)을 조회. 부서가 없는 경우 '부서미배치'를 출력.
# null이 있음을 확인
select emp_id,
	   emp_name,
       job,
       dept_name
from   emp
order by dept_name; # null이 있음을 확인

select emp_id,
	   emp_name,
       job,
       ifnull(dept_name, '부서 미배치')  as dept_name
from   emp
order by dept_name desc; # 한글이 맨 뒤로 감 (유니코드 상으로)


-- EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 커미션 (salary * comm_pct)을 조회. 커미션이 없는 직원은 0이 조회되록 한다.
select emp_id,
	   emp_name, 
       salary,
       round(ifnull(salary * comm_pct, 0)) as "comm"
from emp;


-- comm_pct가 없으면 "커미션 없음"을, 있으면 "커미션 있음"으로 출력
select emp_id,
	   emp_name, 
       if(comm_pct is null, "커미션 없음", "커미션 있음")
from   emp;

/***********************************************
함수 - 타입변환함수
cast(값 as 변환할타입)
convert(값, 변환할타입)

변환가능 타입
  - BINARY: binary 데이터로 변환 (blob)
  - SIGNED: 부호있는 정수(64bit)
  - UNSIGNED: 부호없는 정수(64bit)
  - DECIMAL: 실수
  - CHAR: 문자열 타입 
  - DATE: 날짜 
  - TIME: 시간
  - DATATIME: 날짜시간 타입
	- 정수를 날짜, 시간타입으로 변환할 때는 양수만 가능. (음수는 NULL 반환)
***********************************************/
select '10' + '20'; # 30 
# 덧셈은 "숫자 + 숫자"
# mySQL은 "문자 + 문자"일 때 숫자로 형변환을 알아서 한다. (숫자로 바꿀 수 있으면)

select datediff(curdate(), '2025-03-20'); # 앞 날짜가 뒷 날짜로부터 얼마나 지났는지
# curdate()는 날짜형, '2025-03-20'은 문자형임. 
# '2025-03-20'을 날짜로 바꿀 수 있기 때문에 mySQL에서 알아서 형변환을 해준다. 


-- 시간을 정수형태로 변환   
select now(),
	   cast(now() as signed), # 부호가 있는 정수로 바꾼다. 
	   cast(now() as char); 

# 위 코드와 동일
select now(),
	   convert(now(), signed), 
	   convert(now(), char); 
       
       
-- 숫자를 날짜로 변환
select convert('20250404', date), # 2025-04-04
	   convert(20250404, date), # 2025-04-04
	   convert('114928', time); # 11:49:28

-- 숫자를 문자열로 변환
select convert(234.56, char);
select concat('a', 10); # 문자와 숫자를 알아서 문자열로 합친다. 

/* *************************************
CASE 문
case문 동등비교
case 컬럼 when 비교값 then 출력값
              [when 비교값 then 출력값]
              [else 출력값]
              end
              
case문 조건문
case when 조건 then 출력값
       [when 조건 then 출력값]
       [else 출력값]
       end

************************************* */
select dayofweek(curdate()); # 6
# 금요일로 바꾸자.

# 케이스 자체가 컬럼 -> 별칭을 붙여줍시다.
# 콤마 안 써도 됩니다. 
select case dayofweek(curdate()) when 1 then '일요일'
								 when 2 then '월요일'
                                 when 3 then '화요일'
                                 when 4 then '수요일'
                                 when 5 then '목요일'
                                 when 6 then '금요일'
                                 else '토요일'       # when 7 then '토요일'
                                 end as '요일';



-- EMP테이블에서 급여와 급여의 등급을 조회하는데 급여 등급은 10000이상이면 '1등급', 10000미만이면 '2등급' 으로 나오도록 조회
# 범주화
select  salary, # 쉼표 붙이기 # 열 구분
		case when  salary >= 10000 then '1등급'
			 else '2등급' 
             end as "salary grade"
from 	emp;

-- EMP 테이블에서 업무(job)이 'AD_PRES'거나 'FI_ACCOUNT'거나 'PU_CLERK'인 직원들의 ID(emp_id), 이름(emp_name), 업무(job)을 조회.  
-- 업무(job)가 'AD_PRES'는 '대표', 'FI_ACCOUNT'는 '회계', 'PU_CLERK'의 경우 '구매'가 출력되도록 조회
# job만 갖고 하는 동등 비교 => case 수식 when ...
select  emp_id, 
		emp_name,
        case job when 'AD_PRES' then '대표'
				 when 'FI_ACCOUNT' then '회계'
                 when 'PU_CLERK' then '구매'
                 end as 'job'
from    emp
where   job in ('AD_PRES', 'FI_ACCOUNT', 'PU_CLERK', 'IT_PROG');
# 'IT_PROG'는 null로 나온다.
# 'IT_PROG'라고 '그대로' 나오게 할 수는 없을까?

select  emp_id, 
		emp_name,
        case job when 'AD_PRES' then '대표'
				 when 'FI_ACCOUNT' then '회계'
                 when 'PU_CLERK' then '구매'
                 else job # 나머지는 원래 값이 그대로 나가게
                 end as 'job'
from    emp
where   job in ('AD_PRES', 'FI_ACCOUNT', 'PU_CLERK', 'IT_PROG'); 

-- EMP 테이블에서 부서이름(dept_name)과 급여 인상분을 조회.
-- 급여 인상분은 부서이름이 'IT' 이면 급여(salary)에 10%를 'Shipping' 이면 급여(salary)의 20%를 'Finance'이면 30%를 나머지는 0을 출력
select  emp_id, 
		emp_name,
		dept_name,
        salary,
        case dept_name when 'IT' then salary * 0.1 # 같은 행에 있는 salary 사용
					   when 'Shipping' then salary * 0.2
                       when 'Finance' then salary * 0.3
                       else 0
                       end as "Salary Raise"
from emp;
# 급여와 급여 인상분을 합치는 방법?


-- EMP 테이블에서 직원의 ID(emp_id), 이름(emp_name), 급여(salary), 인상된 급여를 조회한다. 
-- 단 급여 인상율은 급여가 5000 미만은 30%, 5000이상 10000 미만는 20% 10000 이상은 10% 로 한다.
# 조건 비교 case when
select  emp_id,
		emp_name,
        salary,
        case when salary < 5000 then salary * 0.3
			 when salary >= 10000 then salary * 0.1
             else salary * 0.2
             end as "Salary Raise"
from	emp;
# 질문! 급여와 급여 인상분을 합치려면?
# case문 한 번 더 쓰기. case when salary < 5000 then salary * 1.3 이런 식으로
# "Salary Raise"의 경우 원래 DB에 있던 열이 아니기 때문에 열끼리 더하는 계산은 할 수 없다. 
