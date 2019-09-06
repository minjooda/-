
/* ***********************************************************************************
���̺� ����
- ����
create table ���̺� �̸�(
  �÷� ����
)
<�÷�����>
- �÷���  ������Ÿ��  [default ��]  [��������],...
- ������Ÿ��
    -���ڿ� : char/nchar - ��������, varchar2/nvarchar2/clob - ��������
    -���� : number, number(��ü�ڸ���, �Ҽ����ڸ���)
    -��¥/�ð� : date, timestamp
- default : �⺻��. ���� �Է����� �ʾ��� �� �־��� �⺻��.

<�������� ����>
- primary key(PK) : ��ĺ� �÷�, not null, ���ϰ��� ����(unique)
- unique key(UK)  : ���ϰ��� ������ �÷�, null�� ���� �� �ִ�.
- not null(nn)    : ���� ����� �ȵǴ� �÷�.
- check key(ck)   : �÷��� �� �� �ִ� ���� ������ ���� ����.
- foreign key(FK) : �ٸ� ���̺��� primary key�÷��� ���� ���� �� �ִ� �÷�. 
                    �ٸ� ���̺��� ������ �� ����ϴ� �÷�.
                    
- �÷� ���� ����
    - �÷� ������ ���� ����
- ���̺� ���� ����
    - �÷� �����ڿ� ���� ����

- �⺻ ���� : constraint ���������̸� ��������Ÿ��
- ���̺� ���� ���� ��ȸ
    - USER_CONSTRAINTS ��ųʸ� �信�� ��ȸ
    
���̺� ����
- ����
DROP TABLE ���̺��̸� [CASCADE CONSTRAINTS] --�θ� ���̺� ������ �����ϴ� �ڽ� ���̺��� ���� ������ ����.
*********************************************************************************** */
drop table parent_tb cascade constraints;

--�÷����� �������� ����
create table parent_tb(
    no number constraint parent_tb_pk primary key,
    name varchar2(50) not null, --not null�� �÷� ������ ����.
    birthday date default sysdate, --�⺻��: sysdate, nullable �÷�.
    email varchar2(100) constraint parent_email_uk unique,
    gender char(1) not null constraint parent_gender_ck check(gender in ('M', 'F'))   
);

insert into parent_tb (no, name, email, gender)
values (100, '��ö��', 'abc@naver.com', 'M');

insert into parent_tb (no, name, birthday, email, gender)
values (101, '���缮', null, 'jsy@gmail.com', 'M');

insert into parent_tb (no, name, birthday, email, gender)
values (102, '���缮', null, 'jsy@gmail.com', 'M'); --email�� UK�̱� ������ ������ ���� ���� �� ����.

insert into parent_tb (no, name, birthday, email, gender)
values (103, '�̿���', null, 'young2@gmail.com', 'f'); -- M or F�� ���� �� �ִ�.(��ҹ��� ����)

select * from parent_tb;
select to_char(birthday, 'hh24:mi:ss') from parent_tb;

select * from user_tables; --���̺� ���� ��ȸ
desc parent_tb; --�÷�����

select * from user_constraints
where table_name = 'PARENT_TB'; --��� �������� ���� ��ȸ.

drop table child_tb;
--���̺� ������ �������� ����.
create table child_tb(
    no number,             --PK
    jumin_num char(14),    --UK
    age number not null,   --CK(10~90)
    parent_no number,      --FK
    constraint child_pk primary key(no),
    constraint child_jumin_uk unique(jumin_num),
    constraint child_age_ck check(age between 10 and 90),
    --1. constraint child_parent_fk foreign key(parent_no) references parent_tb
    --2. constraint child_parent_fk foreign key(parent_no) references parent_tb on delete set null
        --on delete set null : �θ� ���̺��� ���� ���� �����Ǹ� null�� ���� ����.
    constraint child_parent_fk foreign key(parent_no) references parent_tb on delete cascade
        --on delete set cascade : �θ� ���̺��� ���� ���� �����Ǹ� �ڽ��� �൵ ���� ����.

);

insert into child_tb values (100, '123456-1234567', 35, 100);
insert into child_tb values (101, null, 15, 100);
insert into child_tb values (102, null, 35, 100); --null���� ���ؼ��� unique�� ����x. null�� �� �� ���� ������ ������ ���� �� �ִ�.
insert into child_tb values (103, '151003-2134587', 5, 100); --age: 10���� 90����...
insert into child_tb values (104, '651113-1125879', 54, 200); --FK: 200�� parent_tb�� ���� ������ error.


select * from child_tb;
delete from parent_tb where no = 100; 

--���̺� ����_TEST word ����
--���ǻ� ���̺� ����.
drop table publisher cascade constraints;
create table publisher(
    publisher_no number not null constraint publisher_pk primary key,
    publisher_name varchar2(50) not null,
    publisher_address varchar2(100),
    publisher_tel varchar2(20) not null
);

--å ���̺� ����.
drop table book;
create table book(
    isbn varchar2(13),
    title varchar2(50) not null,
    author varchar2(50) not null,
    page number(4) not null,
    price number(8) not null,
    publish_date date default sysdate not null ,
    publisher_no number not null,
    constraint book_pk primary key(isbn),
    constraint book_price_ck check(price >= 0),
    constraint book_page_ck check(page >= 0),
    constraint publisher_fk foreign key(publisher_no) references publisher
);

select * from publisher;
select * from book;

/* ************************************************************************************
ALTER : ���̺� ����

�÷� ���� ����

- �÷� �߰�
  ALTER TABLE ���̺��̸� ADD (�߰��� �÷����� [, �߰��� �÷�����])
  - �ϳ��� �÷��� �߰��� ��� ( ) �� ��������

- �÷� ����
  ALTER TABLE ���̺��̸� MODIFY (�������÷���  ���漳�� [, �������÷���  ���漳��])
	- �ϳ��� �÷��� ������ ��� ( )�� ���� ����
	- ����/���ڿ� �÷��� ũ�⸦ �ø� �� �ִ�.
		- ũ�⸦ ���� �� �ִ� ��� : ���� ���� ���ų� ��� ���� ���̷��� ũ�⺸�� ���� ���
	- �����Ͱ� ��� NULL�̸� ������Ÿ���� ������ �� �ִ�. (�� CHAR<->VARCHAR2 �� ����.)

- �÷� ����	
  ALTER TABLE ���̺��̸� DROP COLUMN �÷��̸� [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : �����ϴ� �÷��� Primary Key�� ��� �� �÷��� �����ϴ� �ٸ� ���̺��� Foreign key ������ ��� �����Ѵ�.
	- �ѹ��� �ϳ��� �÷��� ���� ����.
	
  ALTER TABLE ���̺��̸� SET UNUSED (�÷��� [, ..])
  ALTER TABLE ���̺��̸� DROP UNUSED COLUMNS
	- SET UNUSED ������ �÷��� �ٷ� �������� �ʰ� ���� ǥ�ø� �Ѵ�. 
	- ������ �÷��� ����� �� ������ ���� ��ũ���� ����� �ִ�. �׷��� �ӵ��� ������.
	- DROP UNUSED COLUMNS �� SET UNUSED�� �÷��� ��ũ���� �����Ѵ�. 

- �÷� �̸� �ٲٱ�
  ALTER TABLE ���̺��̸� RENAME COLUMN �����̸� TO �ٲ��̸�;

**************************************************************************************  
���� ���� ���� ����
-�������� �߰�
  ALTER TABLE ���̺�� ADD CONSTRAINT �������� ����

- �������� ����
  ALTER TABLE ���̺�� DROP CONSTRAINT ���������̸�
  PRIMARY KEY ����: ALTER TABLE ���̺�� DROP PRIMARY KEY [CASCADE]
	- CASECADE : �����ϴ� Primary Key�� Foreign key ���� �ٸ� ���̺��� Foreign key ������ ��� �����Ѵ�.

- NOT NULL <-> NULL ��ȯ�� �÷� ������ ���� �Ѵ�.
   - ALTER TABLE ���̺�� MODIFY (�÷��� NOT NULL),  - ALTER TABLE ���̺�� MODIFY (�÷��� NULL)  
************************************************************************************ */

--customers copy => cust (not null�� ������ ���� ������ copy�� �ȵ�.)
create table cust as
select * from customers where 1=0; --���� ���� ���̺� Ʋ�� ����.

create table ord as
select * from orders where 1=0;

select * from user_constraints where table_name = 'ORD';

--��������
--CUST: PK
alter table cust add constraint cust_pk primary key(cust_id);
alter table ord add constraint ord_cust_fk foreign key(cust_id) references cust;

--�÷��߰�
alter table cust add (age number default 0 not null);
desc cust;

--�÷�����
alter table cust modify (cust_name null, address null, postal_code null, phone_number not null);
alter table cust modify (cust_name varchar2(100));
alter table cust rename column age to cust_age; --�÷��̸� ����.

--�÷�����
alter table cust drop column cust_age; --�÷� ������ �ϳ����� ���� ����.
--�������� ����
alter table cust drop primary key cascade;


--TODO: emp ���̺��� ī���ؼ� emp2�� ����
drop table emp2;
create table emp2 as
select * from emp where 1=0;

--TODO: gender �÷��� �߰�: type char(1)
alter table emp2 add gender char(1);


--TODO: email �÷� �߰�. type: varchar2(100),  not null  �÷�
alter table emp2 add email varchar2(100) not null;


--TODO: jumin_num(�ֹι�ȣ) �÷��� �߰�. type: char(14), null ���. ������ ���� ������ �÷�.
alter table emp2 add jumin_num char(14) constraint emp_jumin_uk unique;


--TODO: emp_id �� primary key �� ����
--alter table emp2 modify emp_id primary key;
alter table emp2 add primary key(emp_id);

  
--TODO: gender �÷��� M, F �����ϵ���  �������� �߰�
alter table emp2 add constraint emp_gender_ck check( gender in ('M', 'F'));


--TODO: salary �÷��� 0�̻��� ���鸸 ������ �������� �߰�
alter table emp2 add constraint emp_sal_ck check(salary >= 0);

--TODO: email �÷��� null�� ���� �� �ֵ� �ٸ� ��� ���� ���� ������ ���ϵ��� ���� ���� ����
alter table emp2 add constraint emp_email_uk unique(email);


--TODO: emp_name �� ������ Ÿ���� varchar2(100) ���� ��ȯ
alter table emp2 modify emp_name varchar2(100);


-- TODO: job_id�� not null �÷����� ����
alter table emp2 modify job_id not null;


--TODO: dept_id�� not null �÷����� ����
alter table emp2 modify dept_id not null;



--TODO: job_id  �� null ��� �÷����� ����
alter table emp2 modify job_id null;


--TODO: dept_id  �� null ��� �÷����� ����
alter table emp2 modify dept_id null;



--TODO: ������ ������ emp_email_uk ���� ������ ����
alter table emp2 drop constraint emp_email_uk;


--TODO: ������ ������ emp_salary_ck ���� ������ ����
alter table emp2 drop constraint emp_sal_ck;


--TODO: primary key �������� ����
alter table emp2 drop primary key cascade;


--TODO: gender �÷�����
alter table emp2 drop column gender;


--TODO: email �÷� ����
alter table emp2 drop column email;

select * from emp2;
desc emp2;




