/* *****************************************
�� (View)
- �ϳ� �Ǵ� ���� ���̺�� ���� �������� �κ� ������ �������� ǥ���ϴ� ��.
- ���� �����͸� ������ �ִ� ���� �ƴ϶� �ش� �������� ��ȸ SELECT ������ ������ �ִ� ��.
- �並 �̿��� ��ȸ�Ӹ� �ƴ϶� ������ ����(insert/update/delete)�� �����ϴ�.

- ����
  - ������ select���� �����ϰ� ó�� ����
  - ������� ������ ������ ���� 

- ���� ����
  - �ܼ��� 
	- �ϳ��� ���̺��� �����͸� ��ȸ�ϸ� �Լ��� ������� �ʴ´�.  

  - ���պ�
	- ���� ���̺��� �����͸� ��ȸ�Ѵ�. (�������� ������ ����ڿ� ���� �� �� ���� �ִ�.)
	- �Լ��� group by�� �̿��� ��ȸ�Ѵ�.
	
- �並 �̿��� DML(INSERT/DELETE/UPDATE) �۾��� �ȵǴ� ���
	- ���� �׸��� ���Ե� �ִ� ��� insert/delete/update �� �� ����.
		- �׷��Լ�
		- group by ��
		- distinct 
		- rownum 
		- SELECT ���� ǥ������ �ִ� ���
		- View�� ����� �࿡ NOT NULL ���� �ִ� ���
		

- ����
CREATE [OR REPLACE] VIEW ���̸�
AS
SELECT ��
[WITH CHECK OPTION]
[WITH READ ONLY]


- OR REPLACE
	- ���� �̸��� �䰡 ���� ��� �����ϰ� ���� �����Ѵ�.
	
- WITH CHECK OPTION
	- View���� ��ȸ�� �� �ִ� ���� insert�Ǵ� update�� �� �ִ�.

- WITH READ ONLY
	- �б� ���� View�� ����. INSERT/DELETE/UPDATE�� �� �� ����.
	
View ����
DROP VIEW VIEW�̸�;	

��� ������ �� ����.
**************************************** */

create view emp_view
as 
select * from emp where dept_id = 60;

select * from emp_view;

select e.emp_name, d.dept_name
from emp_view e, dept d
where e.dept_id = d.dept_id;

update emp_view 
set comm_pct = 0.5 
where emp_id = 104;

select * from emp where emp_id = 104; --view�� update�ϸ� ���� �����Ͱ� �����ȴ�.

create or replace view emp_view
as
select emp_id, emp_name, dept_id
from emp;

insert into emp_view values (5000, 'Sara', 60); --emp table�� ������ �Ǳ� ������ hire_date �� not null�÷� ������ ����.

create view dept_view
as
select * from dept where loc = 'New York';

select * from dept_view;
insert into dept_view values (300, '������', 'seoul');

select * from dept;

create view dept_view2
as
select * from dept where loc = 'New York'
with check option;

select * from dept_view2;

insert into dept_view2 values (301, 'seoul part', 'seoul'); --�ش� view���� �����ϴ� ���� ����(����)
                                                            --��, view�� where���� ���ǵ��� �����ϴ� ���鸸 ������ �� �ִ�.
update dept_view2
set dept_name = 'security'
where dept_id = 10; --view�� ���� �������̹Ƿ� update�� �ȵ�(0�� ����)

create view dept_view3
as
select * from dept where loc = 'New York'
with read only;

select * from dept_view3;
insert into dept_view3 values (302, 'security', 'seoul');


create view emp_name_view
as
select emp_name, length(emp_name) name_length --�Լ� ���� �� alias�� �� ��.
from emp;

select * from emp_name_view;

create view emp_view2
as
select dept_id, max(salary) �ִ�޿�, min(salary) �ּұ޿�
from emp
group by dept_id;

update emp
set salary = 20000
where emp_id = 108;

select * from emp_view2;
select * from emp where emp_id = 108;

create view emp_dept_view
as
select e.emp_id, e.emp_name, e.salary, e.job_id, e.hire_date, e.comm_pct,
       d.dept_id, d.dept_name, d.loc
from emp e left join dept d on e.dept_id = d.dept_id;

select * from emp_dept_view where loc = 'Seattle';



--TODO: �޿�(salary)�� 10000 �̻��� �������� ��� �÷����� ��ȸ�ϴ� View ����
create view emp_sal_view
as
select * from emp where salary >= 10000;

select * from emp_sal_view;

--TODO: �μ���ġ(dept.loc) �� 'Seattle'�� �μ��� ��� �÷����� ��ȸ�ϴ� View ����
create view dept_loc_view
as
select * from dept where loc = 'Seattle';

select * from dept_loc_view;



--TODO: JOB_ID�� 'FI_ACCOUNT', 'FI_MGR' �� �������� ����_ID(emp.emp_id), �����̸�(emp.emp_name), ����_ID(emp.job_id), 
-- ������(job.job_title), �����ִ�޿�(job.max_salary), �ּұ޿�(job.min_salary)�� ��ȸ�ϴ� View�� ����
create or replace view emp_job_view
as
select emp_id, emp_name, e.job_id, job_title, max_salary, min_salary
from emp e left join job j on e.job_id = j.job_id
where e.job_id in ('FI_ACCOUNT', 'FI_MGR');

select * from emp_job_view;


--TODO: �������� ������ ������ �޿� ���(salary_grade.grade)�� ��ȸ�ϴ� View�� ����
create view emp_grade_view
as
--select emp_id, emp_name, job_id, mgr_id, hire_date, salary, comm_pct, dept_id, grade
select emp.*, grade
from emp, salary_grade
where emp.salary between low_sal and high_sal;

select * from emp_grade_view;

--TODO: ������ id(emp.emp_id), �̸�(emp.emp_name), ������(job.job_title), �޿�(emp.salary), �Ի���(emp.hire_date),
--   ����̸�(emp.emp_name), ������Ի���(emp.hire_date), �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ�ϴ� View�� ����
-- ��簡 ���� ������ ��� ����̸�, ������Ի����� null�� ���.
-- �μ��� ���� ������ ��� '�̹�ġ'�� ���
-- ������ ���� ������ ��� '��������' ���� ���
create view emp_join_view
as
select e.emp_id ����id, e.emp_name �����̸�, nvl(j.job_title, '��������') ������, e.salary �޿�, e.hire_date �Ի���,
       m.emp_name ����̸�, m.hire_date ����Ի���,
       nvl(dept_name, '�̹�ġ') �ҼӺμ�, nvl(loc, '�̹�ġ') ��ġ 
from emp e left join job j on e.job_id = j.job_id
           left join emp m on e.mgr_id = m.emp_id
           left join dept d on e.dept_id = d.dept_id;

select * from emp_join_view;

--TODO: ������ �޿��� ��谪�� ��ȸ�ϴ� View ����. ��� �÷� ������, �޿��� �հ�, ���, �ִ�, �ּҰ��� ��ȸ�ϴ� View�� ���� 
create or replace view sal_avg_view
as
select job_title, sum(salary) �޿��հ�, round(avg(salary), 2) �޿����, max(salary) �ִ�޿�, min(salary) �ּұ޿�
from emp e, job j
where e.job_id = j.job_id
group by job_title;

select * from sal_avg_view;


--TODO: ������, �μ�����, ������ ������  ��ȸ�ϴ� View�� ����
create or replace view count_view
as
select '������' label, count(*) cnt from emp
union all
select '�μ���', count(*) from dept
union all
select '������', count(*) from job;

select * from count_view;


/* **************************************************************************************************************
������ : SEQUENCE
- �ڵ������ϴ� ���ڸ� �����ϴ� ����Ŭ ��ü
- ���̺� �÷��� �ڵ������ϴ� ������ȣ�� ������ ����Ѵ�.
	- �ϳ��� �������� ���� ���̺��� �����ϸ� �߰��� �� ������ �� �� �ִ�.

���� ����
CREATE SEQUENCE sequence�̸�
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(�⺻)]		
	[CACHE n | NOCACHE]		  

- INCREMENT BY n: ����ġ ����. ������ 1
- START WITH n: ���� �� ����. ������ 0
	- ���۰� ������
	 - ����: MINVALUE ���� ũĿ�� ���� ���̾�� �Ѵ�.
	 - ����: MAXVALUE ���� �۰ų� ���� ���̾�� �Ѵ�.
- MAXVALUE n: �������� ������ �� �ִ� �ִ밪�� ����
- NOMAXVALUE : �������� ������ �� �ִ� �ִ밪�� ���������� ��� 10^27 �� ��. ���������� ��� -1�� �ڵ����� ����. 
- MINVALUE n :�ּ� ������ ���� ����
- NOMINVALUE :�������� �����ϴ� �ּҰ��� ���������� ��� 1, ���������� ��� -(10^26)���� ����
- CYCLE �Ǵ� NOCYCLE : �ִ�/�ּҰ����� ������ ��ȯ�� �� ����. NOCYCLE�� �⺻��(��ȯ�ݺ����� �ʴ´�.)
- CACHE|NOCACHE : ĳ�� ��뿩�� ����.(����Ŭ ������ �������� ������ ���� �̸� ��ȸ�� �޸𸮿� ����) NOCACHE�� �⺻��(CACHE�� ������� �ʴ´�. )
                  ĳ�� �⺻ �� = 20

������ �ڵ������� ��ȸ
 - sequence�̸�.nextval  : ���� ����ġ ��ȸ
 - sequence�̸�.currval  : ���� �������� ��ȸ


������ ����
ALTER SEQUENCE ������ �������̸�
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(�⺻)]		
	[CACHE n | NOCACHE]	

������ �����Ǵ� ������ ������ �޴´�. (�׷��� start with ���� ��������� �ƴϴ�.)	  


������ ����
DROP SEQUENCE sequence�̸�
	
************************************************************************************************************** */

-- 1���� 1�� �ڵ������ϴ� ������
create sequence ex01_seq;
select * from user_sequences;

select ex02_seq.nextval from dual;

-- 1���� 50���� 10�� �ڵ����� �ϴ� ������
create sequence ex02_seq
       increment by 10
       maxvalue 50;


 alter sequence ex02_seq 
       cycle 
       nocache;


-- 100 ���� 150���� 10�� �ڵ������ϴ� ������
create sequence ex03_seq
       increment by 10
       start with 100
       maxvalue 150;
 
 select ex03_seq.nextval from dual;
 select ex03_seq.currval from dual;
 

-- 100 ���� 150���� 2�� �ڵ������ϵ� �ִ밪�� �ٴٸ��� ��ȯ�ϴ� ������
create sequence ex04_seq
       increment by 2
       start with 100
       maxvalue 150
       cycle; --cycle�� �������� �����ϴ� ������ ������ cache size���� Ŀ���Ѵ�.
       
select ex04_seq.nextval from dual; -- cycle�� minvalue ������ �����Ѵ�.


create sequence ex05_seq
       increment by 10
       start with 100
       maxvalue 150
       minvalue 100
       cycle
       cache 3;
       
select ex05_seq.nextval from dual;


-- -1���� �ڵ� �����ϴ� ������
create sequence ex06_seq
       increment by -1;

select * from user_sequences;       
select ex06_seq.nextval from dual;


-- -1���� -50���� -10�� �ڵ� �����ϴ� ������
create sequence ex07_seq
       increment by -10
       minvalue -50;
       
select ex07_seq.nextval from dual;

-- -10���� -100���� -10�� �����ϴ� ������
drop sequence ex08_seq;
create sequence ex08_seq
       increment by -10
       start with -10
       minvalue -100
       cycle --����: ��ȯ�� maxvalue���� ����.
       nocache; 

alter sequence ex08_seq
      maxvalue -10; --���� ������ ū ���̾�� �Ѵ�.
      
-- 100 ���� -100���� -100�� �ڵ� �����ϴ� ������
-- ����: sequence�� ����� ���� �ִ� maxvalue���� Ŭ �� ����.
create sequence ex09_seq
       increment by -100
       start with 100
       minvalue -100
       maxvalue 100;
       
select ex09_seq.nextval from dual;



-- 15���� -15���� 1�� �����ϴ� ������ �ۼ�
create sequence ex10_seq
       increment by -1
       start with 15
       minvalue -15
       maxvalue 15;

select ex10_seq.nextval from dual;

-- -10 ���� 1�� �����ϴ� ������ �ۼ�
-- ����: �������� �����ϴ� ���� minvalue���� �۾Ƽ��� �ȵȴ�.
create sequence ex11_seq
       start with -10 --start with ���� ������ ����.
       minvalue -10;

--����
drop sequence ex10_seq;

-- Sequence�� �̿��� �� insert
create table items(
    no number primary key, --1�� �ڵ�����
    name varchar2(100) not null
);

drop sequence item_no_seq;
create sequence item_no_seq;

insert into items values (item_no_seq.nextval, '����'||ex01_seq.nextval);
select * from items;

rollback; --sequence�� rollback ����� �ƴϴ�.

create table dept_copy
as
select * from dept where 1=0;
-- TODO: �μ�ID(dept.dept_id)�� ���� �ڵ����� ��Ű�� sequence�� ����. 10 ���� 10�� �����ϴ� sequence
-- ������ ������ sequence�� ����ؼ�  dept_copy�� 5���� ���� insert.
drop sequence dept_id_seq;
create sequence dept_id_seq
       increment by 10
       start with 10;
       
insert into dept_copy (dept_id, dept_name, loc) values (dept_id_seq.nextval, '�μ�'||ex01_seq.nextval, 'korea');
select * from dept_copy;

-- TODO: ����ID(emp.emp_id)�� ���� �ڵ����� ��Ű�� sequence�� ����. 10 ���� 1�� �����ϴ� sequence
-- ������ ������ sequence�� ����� emp_copy�� ���� 5�� insert
create table emp_copy
as
select * from emp where 1=0;

create sequence emp_id_seq
       start with 10;
       
insert into emp_copy (emp_id, emp_name, hire_date, salary) values (emp_id_seq.nextval, '�ƹ���', sysdate, 5000);
select * from emp_copy;