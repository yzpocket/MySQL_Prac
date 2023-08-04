#JOIN 사용해보기
#'오늘의 다짐' 이벤트 당첨자를 선정하여 스타벅스 기프티콘을 지급해야 해요.
select * from users;
select * from checkins;
#두개의 테이블이 합쳐져야 한다. user_id란 부분이 공통부분이기 때문이다.

select * from users u
	join checkins c
	on u.user_id =c.user_id ;
	

#Left Join
select * from users u 
	left join point_users pu  
	on u.user_id = pu.user_id;
	
#Inner Join
select * from users u
inner join point_users p
on u.user_id = p.user_id;

#연습 enrolleds 테이블에 courses 테이블 연결
select * from enrolleds;
select * from courses;
#course_id 가 공통적으로 겹친다. Inner Join으로 확인해보자.
select * from enrolleds e
	Inner Join courses c 
	on e.course_id = c.course_id ;
	
#'오늘의 다짐' 정보에checkins/ 과목 정보를courses/ 연결course_id해/ 과목별title/ '오늘의 다짐'comment 갯수count를 세어보자!
select * from checkins;
select * FROM courses;
select title, count(comment) from checkins ck 
	Left Join courses cs 
	on ck.course_id = cs.course_id 
	group by title;
	
#많은 포인트를 얻은 순서대로 유저 데이터 정렬해서 보기
select * from point_users;
select * from users;
#user_id 겹침 기준
select u.name , pu.`point`  from users u 
	Inner Join point_users pu 
	on u.user_id = pu.user_id
	order by pu.point desc;
	
#네이버 이메일 사용하는 유저의 성씨별 주문건수 세어보기
select * from orders;
select * from users;
select u.name, count(u.name) from orders o 
	Inner Join users u 
	on o.user_id = u.user_id 
	group by u.name;
	
#결제 수단payment_method/별 유저 포인트의 평균값 구해보기
select * from orders;
select * from point_users;
#user_id 기준
select payment_method ,round(avg(pu.`point`),1) from orders o 
	Inner Join point_users pu 
	on o.user_id = pu.user_id
	group by o.payment_method
	order by avg(`point`) desc;
####반올림 round(value,n) <- n자리 까지 표시

#결제하고 시작하지 않은 유저들을 성씨별로 세어보기
select * from users;
select * from enrolleds; #is_registered가 1은 등록, 0은 아님
select u.name, COUNT(u.name)  from users u
	Inner Join enrolleds e
	on u.user_id = e.user_id 
	where e.is_registered = '0'
	group by u.name;

	
#과목 별로 시작하지 않은 유저들을 세어보기
select * from courses;
select * from enrolleds;
select c.title ,count(e.is_registered) from courses c 
	Inner Join enrolleds e 
	on c.course_id = e.course_id
	where e.is_registered = 0
	group by c.title;
	
#웹개발, 앱개발 종합반의 week 별 체크인 수
select * from courses;
select * from checkins;
select c.title, ck.week ,count(c.title) from courses c
	Inner Join checkins ck 
	on c.course_id = ck.course_id 
	group by c.title, ck.week
	order by c.title, ck.week;
	
#위 문제에서, 8월 1일 이후에 구매한 고객
select * from courses;
select * from checkins;
select * from orders;
select  c.title, ck.week ,count(c.title)  from courses c
	Inner Join checkins ck 
	on c.course_id = ck.course_id
	Inner Join orders o 
	on ck.user_id = o.user_id 
	where o.created_at >= '2020-08-01'
	group by c.title, ck.week
	order by c.title, ck.week;
	


## LEFT JOIN을 하면 NULL이 발생 할 수 있다.
####count 은 NULL을 세지 않는다.

#7월10일 ~ 7월19일에 가입한 고객 중,
#포인트를 가진 고객의 숫자, 그리고 전체 숫자, 그리고 비율
select * from users;
select * from point_users;

select count(*) as TotalMember,
	   count(point_user_id) as PointUser,
	   round((count(pu.`point`)/count(*)),2) as RATIO
	from users u
	Left Join point_users pu 
	on u.user_id = pu.user_id
	where u.created_at BETWEEN '2020-07-10' and '2020-07-20';

#enrolled_id별 수강완료(done=1)한 강의 갯수를 세어보고,
# 완료한 강의 수가 많은 순서대로 정렬해보기. 
#user_id도 같이 출력되어야 한다.
select * from enrolleds;
select * from enrolleds_detail; #ed.done <-수강완료된것
select * from users; #e.user_id
#enrolled_id 로 조인
select e.enrolled_id , e.user_id, COUNT(*) as cnt  from enrolleds e 
	inner join enrolleds_detail ed 
	on e.enrolled_id = ed.enrolled_id 
	where ed.done = 1
	group by e.enrolled_id, e.user_id  
	order by cnt desc;


###########UNION 사용해보기#############
##다음 처럼 두개의 정보를 추려 냈다. 기간이 상이하다.
##### 7월 데이터 #####
select '7월' as month, c1.title, c2.week, count(*) as cnt from courses c1
inner join checkins c2 on c1.course_id = c2.course_id
inner join orders o on c2.user_id = o.user_id
where o.created_at < '2020-08-01'
group by c1.title, c2.week
order by c1.title, c2.week;
##### 8월 데이터 #####
select '8월' as month, c1.title, c2.week, count(*) as cnt from courses c1
inner join checkins c2 on c1.course_id = c2.course_id
inner join orders o on c2.user_id = o.user_id
where o.created_at >= '2020-08-01'
group by c1.title, c2.week
order by c1.title, c2.week;


#이것을 7, 8월로 연속된 테이블로 나타내고 싶다. 
#(첫 sql문)union all(두번째 sql문)

(
select '7월' as month, c1.title, c2.week, count(*) as cnt from courses c1
inner join checkins c2 on c1.course_id = c2.course_id
inner join orders o on c2.user_id = o.user_id
where o.created_at < '2020-08-01'
group by c1.title, c2.week
order by c1.title, c2.week
)
union all
(
select '8월' as month, c1.title, c2.week, count(*) as cnt from courses c1
inner join checkins c2 on c1.course_id = c2.course_id
inner join orders o on c2.user_id = o.user_id
where o.created_at >= '2020-08-01'
group by c1.title, c2.week
order by c1.title, c2.week
)
##컬럼명 동일해야 한다.
