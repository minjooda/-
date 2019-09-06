/*
1. 제품 테이블은 제품_ID 컬럼이 ___primary key(기본키)___ 컬럼으로 그 행을 다른 행과 식별할 때 사용된다.
2. 제품 테이블의 제조사 컬럼은 Not Null(NN) 인 것으로 봐서 ______null______ 인 상태일 수가 없다.
3. 고객 테이블에서 다른행과 식별할 때 사용하는 컬럼은 ___고객ID_______ 이다. 
4. 고객 테이블의 전화번호 컬럼의 데이터 타입은 _____varchar2(15)_______ 으로 ______문자열_____형태의 값 ____15___바이트 저장할 수 있으며 NULL 값을 ___가질 수 있다___.
5. 고객 테이블의 가입일 컬럼에 대해 4번 처럼 설명해 보시오.
    -고객 테이블의 가입일 컬럼의 데이터 타입은 DATE으로 날짜/시간 형태로 NULL값을 가질 수 없다. 
6. 주문 테이블은 총 5개 컬럼이 있다. 정수 타입이 __3___개이고 문자열 타입이 __1____개 이고 날짜 타입이 _____1_____개이다.
7. 고객 테이블과 주문테이블은 서로 관계가 있는 테이블입니다.
    부모테이블은 ____고객테이블__________ 이고 자식 테이블은 _____주문테이블_____이다.
    부모테이블의 ___고객ID_______컬럼을 자식테이블의 ____고객ID_______________컬럼이 참조하고 있다.
    고객테이블의 한행의 데이터는 주문테이블의 _______0, 1, n(0~n)_______ 행과 관계가 있을 수 있다.
    주문테이블의 한행은 고객테이블의 ______1______행과 관계가 있을 수 있다.
8. 주문 테이블과 주문_제품 테이블은 서로 관계가 있는 테이블입니다.
    부모 테이블은 ____주문테이블__ 이고 자식 테이블은 ___주문_제품 테이블______이다.
    부모 테이블의 _______주문ID________컬럼을 자식 테이블의 ___주문ID______컬럼이 참조하고 있다.
    주문 테이블의 한행의 데이터는 주문_제품 테이블의 _____0, 1, n(0~n)______ 행과 관계가 있을 수 있다.
    주문_제품 테이블의 한행은 주문 테이블의 _______1_____행과 관계가 있을 수 있다.
9. 제품과 주문_제품은 서로 관계가 있는 테이블입니다. 
    부모 테이블은 ______제품테이블________ 이고 자식 테이블은 ___주문_제품 테이블______이다.
    부모 테이블의 _____제품ID__________컬럼을 자식 테이블의 ________제품ID_______컬럼이 참조하고 있다.
    제품 테이블의 한행의 데이터는 주문_제품 테이블의 _________0, 1, n(0~n)_______ 행과 관계가 있을 수 있다.
    주문_제품 테이블의 한행은 제품 테이블의 _________1_________행과 관계가 있을 수 있다.
*/

-- TODO: 4개의 테이블에 어떤 값들이 있는지 확인.
select * from customers; --고객
select * from orders; --주문
select * from order_items; --주문_제품
select * from products; --제품



-- TODO: 주문 번호가 1인 주문의 주문자 이름, 주소, 우편번호, 전화번호 조회
select cust_name, address, postal_code, phone_number
from customers c, orders o
where c.cust_id = o.cust_id and order_id = 1;

select cust_name, address, postal_code, phone_number
from customers c join orders o on c.cust_id = o.cust_id
where order_id = 1;

-- TODO : 주문 번호가 2인 주문의 주문일, 주문상태, 총금액, 주문고객 이름, 주문고객 이메일 주소 조회
select order_date, order_status, order_total, cust_name, cust_email
from customers c, orders o
where c.cust_id = o.cust_id and order_id = 2;

select order_date, order_status, order_total, cust_name, cust_email
from orders o join customers c on c.cust_id = o.cust_id
where order_id = 2;

-- TODO : 고객 ID가 120인 고객의 이름, 성별, 가입일과 지금까지 주문한 주문정보중 주문_ID, 주문일, 총금액을 조회
select cust_name, gender, join_date, order_id, order_date, order_total
from customers c, orders o
where c.cust_id = o.cust_id and c.cust_id = 120;

select cust_name, gender, join_date, order_id, order_date, order_total
from customers c join orders o on c.cust_id = o.cust_id
where c.cust_id = 120;

-- TODO : 고객 ID가 110인 고객의 이름, 주소, 전화번호, 그가 지금까지 주문한 주문정보중 주문_ID, 주문일, 주문상태 조회
select cust_name, address, phone_number, order_id, order_date, order_status
from customers c, orders o
where c.cust_id = o.cust_id and c.cust_id = 110;


select cust_name, address, phone_number, order_id, order_date, order_status
from customers c join orders o on c.cust_id = o.cust_id
where c.cust_id = 110;

-- TODO : 고객 ID가 120인 고객의 정보와 지금까지 주문한 주문정보를 모두 조회.
select *
from customers c, orders o
where c.cust_id = o.cust_id and c.cust_id = 120;

select *
from customers c join orders o on c.cust_id = o.cust_id
where c.cust_id = 120;

-- TODO : '2017/11/13'(주문날짜) 에 주문된 주문의 주문고객의 고객_ID, 이름, 주문상태, 총금액을 조회
select c.cust_id, cust_name, order_status, order_total
from customers c, orders o
where c.cust_id = o.cust_id and order_date = '2017/11/13';

select c.cust_id, cust_name, order_status, order_total
from customers c join orders o on c.cust_id = o.cust_id
where order_date = '2017/11/13';

-- TODO : 주문상세 ID가 xxxx인 주문제품의 제품이름, 판매가격, 제품가격을 조회.
select product_name, sell_price, price
from order_items o, products p
where o.product_id = p.product_id and o.ordere_item_id = 10;

select product_name, sell_price, price
from order_items o join products p on o.product_id = p.product_id
where o.ordere_item_id = 10;


-- TODO : 주문 ID가 4인 주문의 주문 고객의 이름, 주소, 우편번호, 주문일, 주문상태, 총금액, 주문 제품이름, 제조사, 제품가격, 판매가격, 제품수량을 조회.
select c.cust_name, address, postal_code, order_date, order_status, order_total, product_name, maker, price, sell_price, quantity
from customers c, orders o, order_items oi, products p
where c.cust_id = o.cust_id and
      o.order_id = oi.order_id and
      oi.product_id = p.product_id and
      o.order_id = 4;

select c.cust_name, address, postal_code, order_date, order_status, order_total, product_name, maker, price, sell_price, quantity
from customers c join orders o on c.cust_id = o.cust_id
                 join order_items oi on o.order_id = oi.order_id
                 join products p on oi.product_id = p.product_id
where o.order_id = 4;


-- TODO : 제품 ID가 200인 제품이 2017년에 몇개 주문되었는지 조회.
select count(*) 주문량
from order_items oi, orders o
where oi.order_id = o.order_id and 
      to_char(order_date, 'yyyy') = 2017 and
      product_id = 200;

select count(*) 주문량
from orders o join order_items oi on oi.order_id = o.order_id 
where to_char(order_date, 'yyyy') = 2017 and product_id = 200;

-- TODO : 제품분류별 총 주문량을 조회
select category, sum(oi.quantity) 주문량
from products p, order_items oi
where p.product_id = oi.product_id
group by category;

select category, nvl(sum(oi.quantity), 0) 주문량
from products p left join order_items oi on p.product_id = oi.product_id
group by category;


select decode(grouping_id(category), 0, p.category, '총 주문량') 제품분류,
       sum(oi.quantity) 주문량
from products p, order_items oi
where p.product_id = oi.product_id(+)
group by rollup(category);

insert into products values(600, '새제품', '아이스크림', '메이커1', 3000);
insert into products values(610, '새제품', '아이스크림', '메이커1', 3000);

--natural join: 같은 컬럼명끼리 자동으로 합쳐줌, 같은 컬럼들이 생기지 않음
--              컬럼명만 같고 데이터 타입이 다를 시 오류.
select *
from customers natural join orders; --customers.cust_id = orders.cust_id

select *
from customers join orders using(cust_id);
 
select * from customers cross join orders; --카티션 곱
select * from customers, orders; --조인사용x = 카디션 곱
  