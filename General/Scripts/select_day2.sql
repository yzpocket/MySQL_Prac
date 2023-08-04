#column의 갯수 얻기
select * from orders;
select COUNT(*) from orders
	where course_title = '웹개발 종합반';
	
##Group By 써보기
select name, COUNT(*) from users 
	group by name;
	
#Group By는 "~ 별로 구분해라."라는 말로 해석하면 좋다.

##Order By 써보기
##Order By는 내림차순(desc==default), 오름차순(asc)으로 재정렬 할 수 있다.
select name, COUNT(*) from users
	group by name
	ORDER by name;
	
#users 테이블에서 '신' 씨를 가진 데이터만 불러와서 개수 살펴보기
select name, COUNT(*) from users
	where name like '신__'
	group by name;		
	
#주차별 '오늘의 다짐' 개수 구하기
select * from checkins;
select week as 'n주차', COUNT(*) as '오늘의 다짐 갯수' from checkins
	group by week;
	
#주차별 '오늘의 다짐'의 좋아요 최솟값 구하기
select * from checkins;
select week 'n주차', MIN(likes) '좋아요' from checkins
	group by week;
	
#주차별 '오늘의 다짐'의 좋아요 최댓값 구하기
select * from checkins;
select week 'n주차', MAX(likes) '좋아요'  from checkins
	group by week ###################
	order by max(likes) desc;
	
####select 구문의 처리 순서
####FROM > WHERE > GROUP BY > HAVING > SELECT > ORDER BY

#주차별 '오늘의 다짐'의 좋아요 평균값 구하기
select * from checkins;
select week, avg(likes) from checkins
	group by week;
	
#주차별 '오늘의 다짐'의 좋아요 합계 구하기
select * from checkins;
select week, SUM(likes) from checkins
	group by week
	order by sum(likes) asc;
	
#like를 많이 받은 순서대로 '오늘의 다짐'을 출력
select * from checkins;
select comment, likes from checkins
	order by likes desc;
	
#웹개발 종합반의 결제수단별 주문건수 세어보기
show tables;
select * from orders;
select payment_method ,count(payment_method) from orders o 
	where course_title = '웹개발 종합반'
	group by payment_method
	order by COUNT(payment_method) DESC;
	
#문자열을 기준으로 정렬해보기
select * from users;
select * from users
	order by email;

#시간을 기준으로 정렬해보기
select * from users;
select * from users
	order by created_at desc;

#앱개발 종합반의 결제수단별 주문건수 세어보기
select * from orders;
select payment_method ,COUNT(payment_method) from orders
	group by payment_method
	order by COUNT(payment_method) desc;

#[퀴즈] Gmail 을 사용하는 성씨별 회원수 세어보기
select * from users;
select name, COUNT(name) 'Gmail 사용자' from users
	where email like '%gmail%'
	group by name;
	
#course_id별 '오늘의 다짐'에 달린 평균 like 개수 구해보기
select * from checkins;
select course_id, avg(likes) from checkins
	GROUP BY course_id;
	
#네이버 이메일을 사용하여 앱개발 종합반을 신청한 주문의 결제수단별 주문건수 세어보기
select * from orders;
select payment_method, count(payment_method) from orders
	where email like '%@naver.com'
	group by payment_method;

#group by, count, like %, order by asc&desc, min, max, sum