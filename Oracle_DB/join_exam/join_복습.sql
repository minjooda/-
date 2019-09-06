/*
1. ��ǰ ���̺��� ��ǰ_ID �÷��� ___primary key(�⺻Ű)___ �÷����� �� ���� �ٸ� ��� �ĺ��� �� ���ȴ�.
2. ��ǰ ���̺��� ������ �÷��� Not Null(NN) �� ������ ���� ______null______ �� ������ ���� ����.
3. �� ���̺��� �ٸ���� �ĺ��� �� ����ϴ� �÷��� ___��ID_______ �̴�. 
4. �� ���̺��� ��ȭ��ȣ �÷��� ������ Ÿ���� _____varchar2(15)_______ ���� ______���ڿ�_____������ �� ____15___����Ʈ ������ �� ������ NULL ���� ___���� �� �ִ�___.
5. �� ���̺��� ������ �÷��� ���� 4�� ó�� ������ ���ÿ�.
    -�� ���̺��� ������ �÷��� ������ Ÿ���� DATE���� ��¥/�ð� ���·� NULL���� ���� �� ����. 
6. �ֹ� ���̺��� �� 5�� �÷��� �ִ�. ���� Ÿ���� __3___���̰� ���ڿ� Ÿ���� __1____�� �̰� ��¥ Ÿ���� _____1_____���̴�.
7. �� ���̺�� �ֹ����̺��� ���� ���谡 �ִ� ���̺��Դϴ�.
    �θ����̺��� ____�����̺�__________ �̰� �ڽ� ���̺��� _____�ֹ����̺�_____�̴�.
    �θ����̺��� ___��ID_______�÷��� �ڽ����̺��� ____��ID_______________�÷��� �����ϰ� �ִ�.
    �����̺��� ������ �����ʹ� �ֹ����̺��� _______0, 1, n(0~n)_______ ��� ���谡 ���� �� �ִ�.
    �ֹ����̺��� ������ �����̺��� ______1______��� ���谡 ���� �� �ִ�.
8. �ֹ� ���̺�� �ֹ�_��ǰ ���̺��� ���� ���谡 �ִ� ���̺��Դϴ�.
    �θ� ���̺��� ____�ֹ����̺�__ �̰� �ڽ� ���̺��� ___�ֹ�_��ǰ ���̺�______�̴�.
    �θ� ���̺��� _______�ֹ�ID________�÷��� �ڽ� ���̺��� ___�ֹ�ID______�÷��� �����ϰ� �ִ�.
    �ֹ� ���̺��� ������ �����ʹ� �ֹ�_��ǰ ���̺��� _____0, 1, n(0~n)______ ��� ���谡 ���� �� �ִ�.
    �ֹ�_��ǰ ���̺��� ������ �ֹ� ���̺��� _______1_____��� ���谡 ���� �� �ִ�.
9. ��ǰ�� �ֹ�_��ǰ�� ���� ���谡 �ִ� ���̺��Դϴ�. 
    �θ� ���̺��� ______��ǰ���̺�________ �̰� �ڽ� ���̺��� ___�ֹ�_��ǰ ���̺�______�̴�.
    �θ� ���̺��� _____��ǰID__________�÷��� �ڽ� ���̺��� ________��ǰID_______�÷��� �����ϰ� �ִ�.
    ��ǰ ���̺��� ������ �����ʹ� �ֹ�_��ǰ ���̺��� _________0, 1, n(0~n)_______ ��� ���谡 ���� �� �ִ�.
    �ֹ�_��ǰ ���̺��� ������ ��ǰ ���̺��� _________1_________��� ���谡 ���� �� �ִ�.
*/

-- TODO: 4���� ���̺� � ������ �ִ��� Ȯ��.
select * from customers; --��
select * from orders; --�ֹ�
select * from order_items; --�ֹ�_��ǰ
select * from products; --��ǰ



-- TODO: �ֹ� ��ȣ�� 1�� �ֹ��� �ֹ��� �̸�, �ּ�, �����ȣ, ��ȭ��ȣ ��ȸ
select cust_name, address, postal_code, phone_number
from customers c, orders o
where c.cust_id = o.cust_id and order_id = 1;

select cust_name, address, postal_code, phone_number
from customers c join orders o on c.cust_id = o.cust_id
where order_id = 1;

-- TODO : �ֹ� ��ȣ�� 2�� �ֹ��� �ֹ���, �ֹ�����, �ѱݾ�, �ֹ��� �̸�, �ֹ��� �̸��� �ּ� ��ȸ
select order_date, order_status, order_total, cust_name, cust_email
from customers c, orders o
where c.cust_id = o.cust_id and order_id = 2;

select order_date, order_status, order_total, cust_name, cust_email
from orders o join customers c on c.cust_id = o.cust_id
where order_id = 2;

-- TODO : �� ID�� 120�� ���� �̸�, ����, �����ϰ� ���ݱ��� �ֹ��� �ֹ������� �ֹ�_ID, �ֹ���, �ѱݾ��� ��ȸ
select cust_name, gender, join_date, order_id, order_date, order_total
from customers c, orders o
where c.cust_id = o.cust_id and c.cust_id = 120;

select cust_name, gender, join_date, order_id, order_date, order_total
from customers c join orders o on c.cust_id = o.cust_id
where c.cust_id = 120;

-- TODO : �� ID�� 110�� ���� �̸�, �ּ�, ��ȭ��ȣ, �װ� ���ݱ��� �ֹ��� �ֹ������� �ֹ�_ID, �ֹ���, �ֹ����� ��ȸ
select cust_name, address, phone_number, order_id, order_date, order_status
from customers c, orders o
where c.cust_id = o.cust_id and c.cust_id = 110;


select cust_name, address, phone_number, order_id, order_date, order_status
from customers c join orders o on c.cust_id = o.cust_id
where c.cust_id = 110;

-- TODO : �� ID�� 120�� ���� ������ ���ݱ��� �ֹ��� �ֹ������� ��� ��ȸ.
select *
from customers c, orders o
where c.cust_id = o.cust_id and c.cust_id = 120;

select *
from customers c join orders o on c.cust_id = o.cust_id
where c.cust_id = 120;

-- TODO : '2017/11/13'(�ֹ���¥) �� �ֹ��� �ֹ��� �ֹ����� ��_ID, �̸�, �ֹ�����, �ѱݾ��� ��ȸ
select c.cust_id, cust_name, order_status, order_total
from customers c, orders o
where c.cust_id = o.cust_id and order_date = '2017/11/13';

select c.cust_id, cust_name, order_status, order_total
from customers c join orders o on c.cust_id = o.cust_id
where order_date = '2017/11/13';

-- TODO : �ֹ��� ID�� xxxx�� �ֹ���ǰ�� ��ǰ�̸�, �ǸŰ���, ��ǰ������ ��ȸ.
select product_name, sell_price, price
from order_items o, products p
where o.product_id = p.product_id and o.ordere_item_id = 10;

select product_name, sell_price, price
from order_items o join products p on o.product_id = p.product_id
where o.ordere_item_id = 10;


-- TODO : �ֹ� ID�� 4�� �ֹ��� �ֹ� ���� �̸�, �ּ�, �����ȣ, �ֹ���, �ֹ�����, �ѱݾ�, �ֹ� ��ǰ�̸�, ������, ��ǰ����, �ǸŰ���, ��ǰ������ ��ȸ.
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


-- TODO : ��ǰ ID�� 200�� ��ǰ�� 2017�⿡ � �ֹ��Ǿ����� ��ȸ.
select count(*) �ֹ���
from order_items oi, orders o
where oi.order_id = o.order_id and 
      to_char(order_date, 'yyyy') = 2017 and
      product_id = 200;

select count(*) �ֹ���
from orders o join order_items oi on oi.order_id = o.order_id 
where to_char(order_date, 'yyyy') = 2017 and product_id = 200;

-- TODO : ��ǰ�з��� �� �ֹ����� ��ȸ
select category, sum(oi.quantity) �ֹ���
from products p, order_items oi
where p.product_id = oi.product_id
group by category;

select category, nvl(sum(oi.quantity), 0) �ֹ���
from products p left join order_items oi on p.product_id = oi.product_id
group by category;


select decode(grouping_id(category), 0, p.category, '�� �ֹ���') ��ǰ�з�,
       sum(oi.quantity) �ֹ���
from products p, order_items oi
where p.product_id = oi.product_id(+)
group by rollup(category);

insert into products values(600, '����ǰ', '���̽�ũ��', '����Ŀ1', 3000);
insert into products values(610, '����ǰ', '���̽�ũ��', '����Ŀ1', 3000);

--natural join: ���� �÷����� �ڵ����� ������, ���� �÷����� ������ ����
--              �÷��� ���� ������ Ÿ���� �ٸ� �� ����.
select *
from customers natural join orders; --customers.cust_id = orders.cust_id

select *
from customers join orders using(cust_id);
 
select * from customers cross join orders; --īƼ�� ��
select * from customers, orders; --���λ��x = ī��� ��
  