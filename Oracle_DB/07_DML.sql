/* *********************************************************************
INSERT �� - �� �߰�
����
 - �����߰� :
   - INSERT INTO ���̺�� (�÷� [, �÷�]) VALUES (�� [, ��[])
   - ��� �÷��� ���� ���� ��� �÷� ���������� ���� �� �� �ִ�.

 - ��ȸ����� INSERT �ϱ� (subquery �̿�)
   - INSERT INTO ���̺�� (�÷� [, �÷�])  SELECT ����
	- INSERT�� �÷��� ��ȸ��(subquery) �÷��� ������ Ÿ���� �¾ƾ� �Ѵ�.
	- ��� �÷��� �� ���� ��� �÷� ������ ������ �� �ִ�.
  
************************************************************************ */

--��� �÷��� ���� ���� ��� �÷� ������ ���� ����.
--��, ���� ������ ���̺� ������ ������ �÷���.
insert into emp (emp_id, emp_name, job_id, mgr_id, hire_date, salary, comm_pct, dept_id) 
       values ('1000', 'JYP', 'IT_PROG', 120, '2019-07-15', 5000, 0.1, 60);

--NULL: null��
--Date: '��/��/��' �̿��� ������ to_date()��ȯ, sysdate: ��������� �Ͻ� ��ȯ�ϴ� �Լ�.
insert into emp values ('1100', 'IU', NULL, 120, to_date('2015/03', 'yyyy/mm'), 5000, 0.1, NULL);

select * from emp order by emp_id desc;

insert into emp (emp_id, emp_name, hire_date) values (1212, 'John', '2013/10/05'); --salary�� not null���� ���� -> �ݵ�� ���� ���� �Ѵ�.(error)
insert into emp (emp_id, emp_name, hire_date, salary) values (1212, 'John', '2013/10/05', 1000000); --salary�� ������: 5�ڸ� -> 7�ڸ� (������ ũ�Ⱑ �÷��� ũ�⺸�� ũ�� ����)

--��������: primary key(�⺻Ű) �÷��� ���� ���� insert����.
--         foreign key(�ܷ�Ű) �÷����� �ݵ�� �θ����̺��� primary key�÷��� �ִ� ���鸸 ���� �� �ִ�.
insert into emp (emp_id, emp_name, hire_date, salary, dept_id) values (1100, 'John', '2013/10/05', 10000, 500);

create table emp2(
    emp_id NUMBER(6),
    emp_name VARCHAR(20),
    salary NUMBER(7,2)
);

--emp���� ��ȸ�� ���� emp2�� insert
insert into emp2 (emp_id, emp_name, salary) 
select emp_id, emp_name, salary
from emp
where dept_id = 10;

select * from emp2;

--TODO: �μ��� ������ �޿��� ���� ��� ���̺� ����.
--      ��ȸ����� insert. ����: �հ�, ���, �ִ�, �ּ�, �л�, ǥ������
drop table salary_stat;
create table salary_stat(
    dept_id NUMBER(6),
    salary_sum NUMBER(15,2),
    salary_avg NUMBER(10,2),
    salary_max number(7,2),
    salary_min number(7,2),
    salary_var number(20,2),
    salary_stddev number(7,2)
);

insert into salary_stat
select dept_id, sum(salary), round(avg(salary), 2), max(salary), min(salary),
       round(variance(salary),2) ,round(stddev(salary),2)
from emp
group by dept_id
order by 1;

select * from salary_stat;

/* *********************************************************************
UPDATE : ���̺��� �÷��� ���� ����
UPDATE ���̺��
SET    ������ �÷� = ������ ��  [, ������ �÷� = ������ ��]
[WHERE ��������]

 - UPDATE: ������ ���̺� ����
 - SET: ������ �÷��� ���� ����
 - WHERE: ������ ���� ����. 
************************************************************************ */



-- ���� ID�� 200�� ������ �޿��� 5000���� ����
update emp
set salary = 5000
where emp_id = 200;

select *
from emp
where emp_id = 200;

rollback;
commit;

-- ���� ID�� 200�� ������ �޿��� 10% �λ��� ������ ����.
update emp
set salary = salary * 1.1
where emp_id = 200;

-- �μ� ID�� 100�� ������ Ŀ�̼� ������ 0.2�� salary�� 3000�� ���� ������ ����.
update emp
set comm_pct = 0.2, salary = salary + 3000
where dept_id = 100;


-- TODO: �μ� ID�� 100�� �������� �޿��� 100% �λ�
update emp
set salary = salary * 2
where dept_id = 100;


-- TODO: IT �μ��� �������� �޿��� 3�� �λ�
update emp
set salary = salary * 3
where dept_id = (select dept_id from dept where dept_name = 'IT');


-- TODO: EMP2 ���̺��� ��� �����͸� MGR_ID�� NULL�� HIRE_DATE �� �����Ͻ÷� COMM_PCT�� 0.5�� ����.
update emp2
set mgr_id = NULL, hire_date = sysdate, comm_pct = 0.5;

/* *********************************************************************
DELETE : ���̺��� ���� ����
���� 
 - DELETE FROM ���̺�� [WHERE ��������]
   - WHERE: ������ ���� ����

!�ڽ����̺��� �����ǰ� �ִ� ���� ������ �� ����.
    -�ڽ����̺��� ���� ���� �����ϰų� �� ���� ���� �� �� ó���Ѵ�.
************************************************************************ */

select * from emp where job_id = 'SA_MAN';

-- TODO: �μ� ID�� ���� �������� ����
delete from emp where job_id is null;


-- TODO: ��� ����(emp.job_id)�� 'SA_MAN'�̰� �޿�(emp.salary) �� 12000 �̸��� �������� ����.
-- �ش� emp_id�� mgr_id�� ���� -> ���� �����ϴ� mgr_id ���� ���� �� ����.
delete from emp where salary < 12000 and job_id = 'SA_MAN';

update emp
set mgr_id = null
where emp_id in (select emp_id from emp where mgr_id in (148, 149)); --�����ϰ� �ִ� ������ null�� ����


-- TODO: comm_pct �� null�̰� job_id �� IT_PROG�� �������� ����
delete from emp where comm_pct is null and job_id = 'IT_PROG';

rollback;


create table emp_copy
as
select * from emp;

delete from emp_copy;
select * from emp_copy;
rollback;

--truncate table ���̺��; => DDL��, �ڵ�Ŀ��.
--��ü �����͸� ���� (delete from ���̺��;)
--!rollback�� �̿��� ������ �ȵȴ�.
truncate table emp_copy;

drop table emp_copy;

/*
�ַ� DML(insert, update, delete)
1. commit: �۾��� ���������� ������ �� ������ ���� �κ� ����.
2. rollback: �۾��� ������������ ������ �� ���� �������� �ٽ� �ǵ�����.(������ ���󺹱�)
3. savepoint �̸�: �ش��������� �ٽ� �ǵ�����.

DDL������ ����Ǹ� commit�� �ڵ� ����, rollback �� �� ����.
client tool�� �����ص� commit�� �ڵ� ����.
*/