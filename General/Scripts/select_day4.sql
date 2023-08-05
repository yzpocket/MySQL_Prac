#Subquery(서브쿼리)의 사용 방법
##Subquery란??
#서브쿼리란 하나의 SQL 문 내에 있는 또 다른 sql문을 말한다.
#서브쿼리는 위치에 따라 명칭이 다름. FROM절에 사용하는 인라인 뷰(Inline view), SELECT문에 사용하는 스칼라 서브쿼리(Scala Subquery), 
#일반적으로 WHERE절에 사용하는 것을 서브쿼리(Subquery)라고 한다.


#JOIN과 서브쿼리의 차이는 무엇?
#JOIN은 JOIN에 참여하는 모든 테이블이 대등한 관계에 있어, 조인에 참여하는 모든 테이블의 칼럼은 어느 위치에 있어도 자유롭게 사용 가능
#집합 간의 곱의 관계
#따라서 1:N 관계 테이블이 조인하면 1(1*N)레벨의 집합이 생성됨
#서브쿼리는 메인쿼리의 컬럼을 모두 사용할 수 있지만, 메인쿼리는 서브쿼리의 컬럼을 사용할 수 없다.
#서브 쿼리는 서브쿼리 레벨과 상관 없이 항상 메인 쿼리 레벨로 결과 집합이 생성됨

#kakaopay로 결제한 유저들의 정보 보기
select * from users;
select * from orders;

#Join 을 사용하는 경우<<--
select * from orders;
select * from users;
select * from orders
	where payment_method ='kakaopay';
select u.user_id , u.name , u.email  from users u 
	inner join orders o 
	on u.user_id = o.user_id
	where o.payment_method ='kakaopay';



#Where에 들어가는 
#SubQuery를 사용하는 경우
#Where은 조건문이므로 Subquery의 결과를 조건에 활용하는 방식으로 유용하게 사용
#### where FIELD in (subquery) 
#카카오페이로 결제한 주문건 유저들만, 유저 테이블에서 출력해주고 싶을 때
#where 필드명 in (subquery) 이런 방식
select * from users;
select * from orders;
########이 부분이 작동 되는지 확인한다.########
select user_id from orders
	where payment_method ='kakaopay';
######## where field in 이후 조건의 조건 추가한다는 생각으로.
#Subquery 문
select * from users u
	where user_id in(
		select user_id from orders
		where payment_method = 'kakaopay'
	);

#Select에 들어가는 
#SubQuery를 사용하는 경우
#'오늘의 다짐'(comment) 데이터를 보고 싶은데 
#'오늘의 다짐' 좋아요(likes)의 수가, 
#본인이 평소에 받았던 좋아요 수에 비해 얼마나 높고 낮은지가 궁금할 수 있겠죠?
#그럼, 평균을 구해보자.
show tables;
select * from checkins;
##comment, likes 는 checkins 테이블에 있다.
#user_id별 평균 좋아요 갯수는 다음과 같다.
select user_id, round(avg(likes),1) as avg_likes from checkins
	group by user_id;

#포인트 많이 받은 사람들은 like도 많이 받았을까?
#user_id별 포인트는 다음과 같다. 
select user_id, point from point_users;

#그럼 user_id가 공통된다. 따라서 포인트별로 좋아요 갯수와의 연관을 찾아보는 select문을 만들 수 있다. 
select ck.user_id, ck.avg_likes, pu.`point` from point_users pu 
	inner join (select user_id, round(avg(likes),1) as avg_likes from checkins group by user_id) ck
	on pu.user_id = ck.user_id
	order by pu.point desc;
	




#####연습
#전체 유저의 포인트의 평균보다, 큰 유저들의 데이터 추출
#전체 유저의 포인트의 평균부터
#1.포인트 데이터 위치를 찾는다.
select * from users;
show tables;
#2.데이터를 찾았다.
select * from point_users;
#3.포인트의 평균부터 구한다.
select round(avg(`point`),1) as avg_point from point_users;

#4.유저들의 데이터를 찾는다.
show tables;
#5.유저들의 이름, 이메일 등 데이터를 찾았다.
select * from users;

#6.원본 테이블 내 공통분모를 찾는다.
#7. user_id로 합쳐서 볼 수 있다는 것을 파악했다.
select * from users;
select * from point_users;

#8.이제 필요한 데이터의 조건을 생각해본다.
##avg_point보다 큰 유저들의 정보를 알고 싶다.
#avg_point는 point_users pu테이블에 있고,
#user_id별 포인트는 pu테이블
#user_id별 정보(이름)은 users u테이블에 있다. 

#select pu.point_user_id , u.user_id , u.name ,u.email, pu.`point`  from point_users pu
select * from point_users pu
	inner join users u on pu.user_id = u.user_id 
			and point > 
			(
			select round(avg(`point`),1) as avg_point from point_users pu
			inner join users u
				on pu.user_id = u.user_id
				where u.name = '이**'
			)
order by pu.point desc;


#checkins 테이블에 course_id별 평균 likes수 필드 우측에 붙여보기
select round(avg(likes),1) as avg_likes from checkins;
select *, 
	   (
	   select round(avg(likes),1) from checkins c2 
	   where c.course_id=c2.course_id
	   ) as avg_likes
from checkins c;

#과목명별 평균 like수 붙여보기
#과목명은 courses.title
#likes는 checkins.likes

select * from courses cs;
select * from checkins ck1;
select * from checkins ck2;

select cs.title , (select round(avg(ck2.likes),1) from checkins ck2 where ck2.course_id=ck1.course_id) as course_avg 
	from checkins ck1
	inner join courses cs
	on ck1.course_id = cs.course_id
	

#course_id별 유저의 체크인(수강 시작) 개수를 구해보기!
show tables;
select * from courses;
select * from checkins;
select * from users;

	
#1. course_id별 수강 시작 인원
select * from checkins c;
select c.course_id ,count(DISTINCT (user_id)) from checkins c
	group by c.course_id ;

#2.1. course_id별 전체 인원(수강료 지불 인원) orders
select * from orders o ;
select o.course_id, count(user_id) from orders o 
	group by o.course_id  ;

#2.2. course_id별 수강 시작 인원을 전체 인원에 붙이기

select  a.course_id,
		c.title,
		a.cnt_ck,
		b.cnt_usrs,
		round(((a.cnt_ck/b.cnt_usrs)*100),2) as Ratio 
	FROM 
		(
		select c.course_id ,count(DISTINCT (user_id)) cnt_ck from checkins c
		group by c.course_id 
		) as a 
	inner join 
		(
		select o.course_id, count(user_id) cnt_usrs from orders o 
		group by o.course_id
		) as b
		on a.course_id = b.course_id
	inner join
		courses c
		on a.course_id = c.course_id;


## WITH 절로 윗 부분 깔끔하게
# 마치 Subquery문 한덩이를 table1처럼 대명사로 지정하는 것과 같다. 구분하기 쉽다.
  
with table1 as(
	select c.course_id ,count(DISTINCT (user_id)) cnt_ck from checkins c
	group by c.course_id 
), table2 as(
	select o.course_id, count(user_id) cnt_usrs from orders o 
	group by o.course_id
)
select  a.course_id,
		c.title,
		a.cnt_ck,
		b.cnt_usrs,
		round(((a.cnt_ck/b.cnt_usrs)*100),2) as Ratio 
	FROM 
		table1 as a 
	inner join 
		table2 as b
		on a.course_id = b.course_id
	inner join
		courses c
		on a.course_id = c.course_id;
select * from checkins ck;