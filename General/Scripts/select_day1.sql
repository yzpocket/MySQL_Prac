#[퀴즈] 포인트가 20000점보다 많은 유저만 뽑아보기!
show tables;
select * from users;
select * from orders;
select * from point_users; #<<
select * from point_users 
	where point > 20000;

#[퀴즈] 성이 황씨인 유저만 뽑아보기
select * from users;
select * from users 
	where name like '황%';

#[퀴즈] 웹개발 종합반이면서 결제수단이 CARD인 주문건만 뽑아보기!
select * from orders;
select * from orders 
	where payment_method = 'card';


#[퀴즈] 결제수단이 CARD가 아닌 주문데이터만 추출해보기
select * from orders;
select * from orders 
	where payment_method != 'card';

#[퀴즈] 20000~30000 포인트 보유하고 있는 유저만 추출해보기
select * from users;
select * from point_users;
select * from point_users
	where point
	BETWEEN 20000 and 30000;

#[퀴즈] 이메일이 s로 시작하고 com로 끝나는 유저만 추출해보기
select * from users;
select * from users 
	where email like 's%com';

#[퀴즈] 이메일이 s로 시작하고 com로 끝나면서 성이 이씨인 유저만 추출해보기
select * from users;
select * from users
	where email like 's%com'
	and name like '이%';
	

#성이 남씨인 유저의 이메일만 추출하기
select * from users;
select email  from users
	where name like '남%';

#Gmail을 사용하는 2020/07/12~13에 가입한 유저를 추출하기
select * from users;
select * from users
	where email like '%gmail%'
	and created_at BETWEEN '2020-07-12' and '2020-07-14'; 

#Gmail을 사용하는 2020/07/12~13에 가입한 유저의 수를 세기
select * from users;
select count(*) from users
	where created_at BETWEEN '2020-07-12' and '2020-07-13';
	
#naver 이메일을 사용하면서, 웹개발 종합반을 신청했고 결제는 kakaopay로 이뤄진 주문데이터 추출하기
select * from users;
select * from orders o;
select * from orders
	where email like '%naver%'
	and course_title like '웹개발 종합반'
	and payment_method = 'kakaopay';
