/* **************************************************************************
����(Aggregation) �Լ��� GROUP BY, HAVING
************************************************************************** */

/* ************************************************************
�����Լ�, �׷��Լ�, ������ �Լ�
- �μ�(argument)�� �÷�.
  - sum(): ��ü�հ�
  - avg(): ���
  - min(): �ּҰ�
  - max(): �ִ밪
  - stddev(): ǥ������
  - variance(): �л�
  - count(): ����
        - �μ�: 
            - �÷���: null�� ������ ����
            -  *: �� ���(null�� ����)
            
count(*)�� ������ ��� �����Լ����� null�� �����ϰ� �����Ѵ�. (avg, stddev, variance�� ����!!)
������/date: max(), min(), count()���� ��밡��.
************************************************************* */

--�޿�(salary)�� ���հ�, ���, �ּҰ�, �ִ밪, ǥ������, �л�, ���������� ��ȸ 
select sum(salary) ���հ�,
       avg(salary) ���,
       min(salary) �ּҰ�,
       max(salary) �ִ밪,
       stddev(salary) ǥ������,
       variance(salary) �л�,
       count(salary) ��������
from emp;

select to_char(sum(salary), '$999,999') ���հ�,
       round(avg(salary), 1) ���,
       min(salary) �ּҰ�,
       max(salary) �ִ밪,
       stddev(salary) ǥ������,
       variance(salary) �л�,
       count(salary) ��������
from emp;

-- ���� �ֱ� �Ի��ϰ� ���� ������ �Ի����� ��ȸ
select min(hire_date), max(hire_date) from emp;

-- emp ���̺��� job ������ ���� ��ȸ
select count(distinct job) from emp ;



--TODO:  Ŀ�̼� ����(comm_pct)�� �ִ� ������ ���� ��ȸ
select count(comm_pct) from emp;

--TODO: Ŀ�̼� ����(comm_pct)�� ���� ������ ���� ��ȸ
select count(*) - count(comm_pct) from emp;
select count(nvl(comm_pct, 1)) from emp where comm_pct is null;

--TODO: ���� ū Ŀ�̼Ǻ���(comm_pct)�� �� ���� ���� Ŀ�̼Ǻ����� ��ȸ
select max(comm_pct), min(comm_pct) from emp;

--TODO:  Ŀ�̼� ����(comm_pct)�� ����� ��ȸ. 
--�Ҽ��� ���� 2�ڸ����� ���
select round(avg(comm_pct), 2), round(avg(nvl(comm_pct, 0)), 2) from emp;
        --comm_pct�� �ִ� �������� ���  --��ü �������� ���
        
--TODO: ���� �̸�(emp_name) �� ���������� �����Ҷ� ���� ���߿� ��ġ�� �̸��� ��ȸ.
select max(emp_name) from emp;


--TODO: �޿�(salary)���� �ְ� �޿��װ� ���� �޿����� ������ ���
select max(salary) - min(salary) from emp;


--TODO: ���� �� �̸�(emp_name)�� ����� ���� ��ȸ.
select max(length(emp_name)) from emp;


--TODO: EMP ���̺��� ����(job) ������ � �ִ� ��ȸ. 
--���������� ����
select count(distinct job) from emp;


--TODO: EMP ���̺��� �μ�(dept_name)�� �������� �ִ��� ��ȸ. 
--���������� ����
select count(distinct dept_name) from emp; --null ������.
select count(distinct nvl(dept_name, 0))from emp; --null ����.


/* **************
group by ��
 -select�� where�� ������ ����Ѵ�.
 -Ư�� �÷�(��)�� ������ ���� ������ �� ������ �����÷��� �����ϴ� ����.
 -����: group by �÷��� [,�÷���]
 -�÷�: �з���(������, �����) (ex)�μ��� �޿� ���, ���� �޿� �հ�
 -select ������ group by���� ������ �÷��鸸 �����Լ��� ���� �� �� �ִ�.
****************/


-- ����(job)�� �޿��� ���հ�, ���, �ּҰ�, �ִ밪, ǥ������, �л�, �������� ��ȸ
select job,
       sum(salary) ���հ�,
       avg(salary) ���,
       min(salary) �ּҰ�,
       max(salary) �ִ밪,
       round(stddev(salary),2) ǥ������,
       round(variance(salary),2) �л�,
       count(*) ��������
from emp
group by job;

-- �Ի翬�� �� �������� �޿� ���.
select extract(year from hire_date) �Ի�⵵, round(avg(salary), 2) �޿����
from emp
group by extract(year from hire_date)
order by 1;


-- �޿�(salary) ������ �������� ���. �޿� ������ 10000 �̸�,  10000�̻� �� ����.
select case when salary >= 10000 then '1���'
            when salary < 10000 then '2���' 
            end ���,
       count(*) ������
from emp
group by case when salary >= 10000 then '1���'
              when salary < 10000 then '2���' 
              end;

select salary, case when salary >= 10000 then '1���'
            when salary < 10000 then '2���' 
            end ���
from emp;

select  dept_name, job, sum(salary)
from emp
group by dept_name, job -- ����&�μ��� �޿� �з�
order by 1;

--TODO: �μ���(dept_name) �������� ��ȸ
select dept_name, count(*)
from emp
group by dept_name;


--TODO: ������(job) �������� ��ȸ. �������� ���� �ͺ��� ����.
select job, count(*)
from emp
group by job
order by 2 desc;


--TODO: �μ���(dept_name), ����(job)�� ������, �ְ�޿�(salary)�� ��ȸ. �μ��̸����� �������� ����.
select dept_name, job, count(*), max(salary)
from emp
group by dept_name, job
order by 1;


--TODO: EMP ���̺��� �Ի翬����(hire_date) �� �޿�(salary)�� �հ��� ��ȸ. 
--(�޿� �հ�� �ڸ������� , �� �����ÿ�. ex: 2,000,000)
select to_char(hire_date ,'yyyy') �Ի�⵵, to_char(sum(salary), '999,999') �޿��հ�
from emp
group by to_char(hire_date ,'yyyy')
order by 1;


--TODO: ����(job)�� �Ի�⵵(hire_date)�� ��� �޿�(salary)�� ��ȸ
select job, to_char(hire_date ,'yyyy') �Ի�⵵, round(avg(salary), 2) ��ձ޿�
from emp
group by job, to_char(hire_date ,'yyyy');


--TODO: �μ���(dept_name) ������ ��ȸ�ϴµ� �μ���(dept_name)�� null�� ���� �����ϰ� ��ȸ.
select dept_name, count(*)
from emp
where dept_name is not null
group by dept_name;


--TODO �޿� ������ �������� ���. �޿� ������ 5000 �̸�, 5000�̻� 10000 �̸�, 10000�̻� 20000�̸�, 20000�̻�. 
select case when salary < 5000 then '5000�̸�' 
              when salary between 5000 and 9999 then '5000�̻� 10000�̸�'
              when salary between 10000 and 19999 then '10000�̻� 20000�̸�'
              when salary >= 20000 then '20000�̻�' end �޿�����, count(*)
from emp
group by case when salary < 5000 then '5000�̸�' 
              when salary between 5000 and 9999 then '5000�̻� 10000�̸�'
              when salary between 10000 and 19999 then '10000�̻� 20000�̸�'
              when salary >= 20000 then '20000�̻�' end
order by decode(�޿�����, '5000�̸�', 1, '5000�̻� 10000�̸�', 2, '10000�̻� 20000�̸�', 3, '20000�̻�', 4) ;

/* **************************************************************
having ��
 -�������� ���� �� ��������
 -group by ���� order by ���� �´�.
 -����
    -having ��������: �����ڴ� where���� �����ڸ� ����Ѵ�.
                   : �ǿ����ڴ� ���� �Լ��� ���.
************************************************************** */
-- �������� 10 �̻��� �μ��� �μ���(dept_name)�� �������� ��ȸ
select dept_name, count(*) ������
from emp
group by dept_name
having count(*) >= 10;




--TODO: 15�� �̻��� �Ի��� �⵵�� (�� �ؿ�) �Ի��� �������� ��ȸ.
select extract(year from hire_date) �Ի�⵵, count(*)
from emp
group by extract(year from hire_date)
having count(*) >= 15;



--TODO: �� ����(job)�� ����ϴ� ������ ���� 10�� �̻��� ����(job)��� ��� �������� ��ȸ
select job, count(*)
from emp
group by job
having count(*) >= 10;



--TODO: ��� �޿���(salary) $5000�̻��� �μ��� �̸�(dept_name)�� ��� �޿�(salary), �������� ��ȸ
select dept_name, floor(avg(salary)) ��ձ޿�, count(*) ������
from emp
group by dept_name
having avg(salary) >= 5000;



--TODO: ��ձ޿��� $5,000 �̻��̰� �ѱ޿��� $50,000 �̻��� �μ��� �μ���(dept_name), ��ձ޿��� �ѱ޿��� ��ȸ
select dept_name, ceil(avg(salary)) ��ձ޿�, sum(salary) �ѱ޿�
from emp
group by dept_name
having avg(salary) >= 5000 and sum(salary) >= 50000;



-- TODO ������ 2�� �̻��� �μ����� �̸��� �޿��� ǥ�������� ��ȸ
select dept_name, round(stddev(salary), 2) "�޿��� ǥ������"
from emp
group by dept_name
having count(*) >= 2;




/* **************************************************************
1. group by �� Ȯ�� : rollup �� cube
-rollup(): group by�� Ȯ��
    -�߰����質 �����踦 group�� �κ����迡 �߰��ؼ� ������ �� �� ���.
    -����: group by(�÷��� [,�÷���])
-cube(): rollup�� Ȯ��
    - group by ���� �÷��� ��� ������ ��� ����.
    - �׷����� ���� �÷��� �ΰ� �̻��� �� ���.
    
2. grouping(), grouping_id() �Լ�
-grouping_id(): grouping_id(group by���� ����� �÷��� [,�÷���])...
                ��� �� ������ ���.
-grouping()
    -group by���� rollup�̳� cube�� ���� �÷��� ���輭 ���������� 0, ���輭 �������� �ʾ����� 1�� ��ȯ�Ѵ�.
    -����: grouping(group by���� ����� �÷���)
    
************************************************************** */

/*
group by rollup(job)
����: job�� -> job�� �����ϰ� ����

group by rollup(dept_name, job)
1. (dept_name, job)
2. job�� �����ϰ� (dept_name)���� ������ ����
3. (), ��ü����
*/
-- EMP ���̺��� ����(job)�� �޿�(salary)�� ��հ� ����� �Ѱ赵 ���̳������� ��ȸ.
select job, ceil(avg(salary)) ��ձ޿�
from emp
group by rollup(job);

select job, ceil(avg(salary)) ��ձ޿�
from emp
group by cube(job);

select dept_name,
       grouping(dept_name),
       decode(grouping(dept_name), 0, dept_name, '�����')
       ,ceil(avg(salary)) ��ձ޿�
from emp
group by rollup(dept_name);

-- EMP ���̺��� ����(JOB) �� �޿�(salary)�� ��հ� ����� �Ѱ赵 ���̳������� ��ȸ.
-- ���� �÷���  �Ұ質 �Ѱ��̸� '�����'��  �Ϲ� �����̸� ����(job)�� ���

select decode(grouping(dept_name), 0, dept_name, '�����')
       ,ceil(avg(salary)) ��ձ޿�
from emp
group by rollup(dept_name);




-- EMP ���̺��� �μ�(dept_name), ����(job) �� salary�� �հ�� �������� �Ұ�� �Ѱ谡 �������� ��ȸ
select dept_name, job, sum(salary) �ѱ޿�, count(*) ������, grouping(dept_name)
from emp
group by rollup(dept_name, job)
order by dept_name;

select dept_name, job, sum(salary) �ѱ޿�, count(*) ������
from emp
group by cube(dept_name, job) --��� ��츦 ������ ����: (), (dept_name),(job), (dept_name, job)
order by dept_name;

select decode(grouping(dept_name), 0, dept_name, '������') dept_name, 
       decode(grouping(job), 0, job, '�߰�����') job,
       sum(salary) �ѱ޿�, count(*) ������
from emp
group by rollup(dept_name, job);



--# �Ѱ�/�Ұ� ���� ��� :  �Ѱ�� '�Ѱ�', �߰������ '��' �� ���
--TODO: �μ���(dept_name) �� �ִ� salary�� �ּ� salary�� ��ȸ
select decode(grouping(dept_name), 0, dept_name, '�Ѱ�') dept_name, max(salary), min(salary)
from emp
group by rollup(dept_name);



--TODO: ���_id(mgr_id) �� ������ ���� �Ѱ踦 ��ȸ�Ͻÿ�.
select decode(grouping(mgr_id), 0, to_char(mgr_id), '�Ѱ�') ���ID, count(*) ������
from emp
group by rollup(mgr_id);

select decode(grouping(mgr_id), 1, '�Ѱ�', to_char(mgr_id)) ���ID, count(*) ������ --���� ���� ���Ŀ� ����.
from emp
group by rollup(mgr_id);

--TODO: �Ի翬��(hire_date�� year)�� �������� ���� ���� �հ� �׸��� �Ѱ谡 ���� ��µǵ��� ��ȸ.
select  decode(grouping(to_char(hire_date, 'yyyy')), 0, to_char(hire_date, 'yyyy'), '�Ѱ�') year,
        count(*) ������,
        sum(salary)
from emp
group by rollup(to_char(hire_date, 'yyyy'));


--TODO: �μ���(dept_name), �Ի�⵵�� ��� �޿�(salary) ��ȸ. �μ��� ����� �����谡 ���� �������� ��ȸ
select decode(grouping(dept_name), 0, dept_name, '�Ѱ�') dept_name, 
       decode(grouping(to_char(hire_date, 'yyyy')), 0, to_char(hire_date, 'yyyy'), '��') �Ի�⵵,
       round(avg(salary)) ��տ���
from emp
group by rollup(dept_name, to_char(hire_date, 'yyyy'));


select --grouping_id(dept_name) dept_name, 
       --grouping_id(to_char(hire_date, 'yyyy')) year,
       decode(grouping_id(dept_name, to_char(hire_date, 'yyyy'))
                , 0, dept_name||'-'||to_char(hire_date, 'yyyy')
                , 1, '��', '�Ѱ�') "�μ�-�Ի�⵵", 
       round(avg(salary)) ��տ���
from emp
group by rollup(dept_name, to_char(hire_date, 'yyyy'));
