/* *************************************
sql: ��ҹ��ڴ� ���� ����. (���� ����)

Select �⺻ ���� - ������, �÷� ��Ī

*select (distinct) �÷��� ((as) ��Ī) ->��ȸ�� �÷� ����. *�� ��� �÷���ȸ.
*from ���̺��                      ->��ȸ�� ���̺� ����.
 where ������
 group by �����Լ�(����), Ư�� �÷��� ���,�հ�...... 
 having �����Լ�(��������)
 order by ����
*************************************** */
desc emp;
--EMP ���̺��� ��� �÷��� ��� �׸��� ��ȸ.
select emp_id, emp_name, job, mgr_id, hire_date, salary, comm_pct, dept_name from emp;
select * from emp;

--EMP ���̺��� ���� ID(emp_id), ���� �̸�(emp_name), ����(job) �÷��� ���� ��ȸ.
select emp_id, emp_name, job from emp;

--EMP ���̺��� ����(job) � ����� �����Ǿ����� ��ȸ. - ������ ���� �ϳ����� ��ȸ�ǵ��� ó��.
select distinct job from emp;

--EMP ���̺��� �μ���(dept_name)�� � ����� �����Ǿ����� ��ȸ - ������ ���� �ϳ����� ��ȸ�ǵ��� ó��.
select distinct dept_name from emp;

select distinct job, dept_name from emp order by 2; 

--EMP ���̺��� emp_id�� ����ID, emp_name�� �����̸�, hire_date�� �Ի���, salary�� �޿�, dept_name�� �ҼӺμ� ��Ī���� ��ȸ�Ѵ�.
select emp_id as ����ID,
       emp_name as �����̸�, 
       hire_date as �Ի���, 
       salary �޿�, 
       dept_name �ҼӺμ� 
from emp;

select emp_id as "���� ID", --��Ī�� ������ ���� " "�� �����ش�.
       emp_name as "���� �̸�", 
       hire_date as �Ի���, 
       salary �޿�, 
       dept_name �ҼӺμ� 
from emp;


/* ������ 
��� ������: +, -, *, /
- date: +, - => day(��)�� + or -
- �ǿ����ڰ� null�� ���� ����� null

���� ������: ������ ��ĥ(����) �� ���. -> ��||��
*/

select 1+1, 2-1, 3*5, 10/4, round(10/3, 2) from dual; --round(����, �Ҽ������� �ڸ�): �ݿø�

select sysdate from dual; --sysdate: sql�� ������ ������ ��¥�� date������ ��ȯ
select sysdate, sysdate + 10, sysdate - 10 from dual;

select 10 + null from dual;

select 10||'��' from dual; --10||'��' => 10��

--EMP ���̺��� ������ �̸�(emp_name), �޿�(salary) �׸���  �޿� + 1000 �� ���� ��ȸ.
--�ǿ����ڰ� �÷��� ��� ������� ����.
select emp_name, salary, salary + 1000 from emp;


--EMP ���̺��� �Ի���(hire_date)�� �Ի��Ͽ� 10���� ���� ��¥�� ��ȸ.
select hire_date, hire_date + 10 from emp;


--TODO: EMP ���̺��� ������ ID(emp_id), �̸�(emp_name), �޿�(salary), Ŀ�̼�_PCT(comm_pct), �޿��� Ŀ�̼�_PCT�� ���� ���� ��ȸ.
select emp_id, emp_name, salary, comm_pct, salary * comm_pct from emp;


--TODO:  EMP ���̺��� �޿�(salary)�� �������� ��ȸ. (���ϱ� 12)
select salary ����, salary * 12 ���� from emp;


--TODO: EMP ���̺��� �����̸�(emp_name)�� �޿�(salary)�� ��ȸ. �޿� �տ� $�� �ٿ� ��ȸ.
select emp_name �����̸�, '$'||salary �޿� from emp;



--TODO: EMP ���̺��� �Ի���(hire_date) 30����, �Ի���, �Ի��� 30�� �ĸ� ��ȸ
select hire_date - 30 "30����", hire_date �Ի���, hire_date + 30 "30����" from emp;




/* *************************************
Where ���� �̿��� �� ���� -> �÷� ���� ������ ������ Ư�� ���� ���.
where �� �������ǽ�

************************************* */

--EMP ���̺��� ����_ID(emp_id)�� 110�� ������ �̸�(emp_name)�� �μ���(dept_name)�� ��ȸ
select emp_name, dept_name
from emp
where emp_id = 110;

 
--EMP ���̺��� 'Sales' �μ��� ������ ���� �������� ID(emp_id), �̸�(emp_name), �μ���(dept_name)�� ��ȸ.
select emp_id, emp_name, dept_name
from emp
where dept_name != 'Sales'; -- <>, !=, ^= ��� ���� ������ ��Ÿ��.



--EMP ���̺��� �޿�(salary)�� $10,000�� �ʰ��� ������ ID(emp_id), �̸�(emp_name)�� �޿�(salary)�� ��ȸ
select emp_id, emp_name, salary
from emp
where salary > 10000;


 
--EMP ���̺��� Ŀ�̼Ǻ���(comm_pct)�� 0.2~0.3 ������ ������ ID(emp_id), �̸�(emp_name), Ŀ�̼Ǻ���(comm_pct)�� ��ȸ.
select emp_id, emp_name, comm_pct
from emp
where comm_pct between 0.2 and 0.3;



--EMP ���̺��� Ŀ�̼��� �޴� ������ �� Ŀ�̼Ǻ���(comm_pct)�� 0.2~0.3 ���̰� �ƴ� ������ ID(emp_id), �̸�(emp_name), Ŀ�̼Ǻ���(comm_pct)�� ��ȸ.
select emp_id, emp_name, comm_pct
from emp
where comm_pct not between 0.2 and 0.3; -- between A and B �� not between A and B


--EMP ���̺��� ����(job)�� 'IT_PROG' �ų� 'ST_MAN' �� ������  ID(emp_id), �̸�(emp_name), ����(job)�� ��ȸ.
select emp_id, emp_name, job
from emp
where job in ('IT_PROG', 'ST_MAN'); 
    --job = 'IT_PROG' or job = 'ST_MAN';



--EMP ���̺��� ����(job)�� 'IT_PROG' �� 'ST_MAN' �� �ƴ� ������  ID(emp_id), �̸�(emp_name), ����(job)�� ��ȸ.
select emp_id, emp_name, job
from emp
where job not in ('IT_PROG', 'ST_MAN'); -- in () �� not in ()




--EMP ���̺��� ���� �̸�(emp_name)�� S�� �����ϴ� ������  ID(emp_id), �̸�(emp_name)
-- %: 0~n����, _: 1����
select emp_id, emp_name
from emp
where emp_name like 'S%';



--EMP ���̺��� ���� �̸�(emp_name)�� S�� �������� �ʴ� ������  ID(emp_id), �̸�(emp_name)
select emp_id, emp_name
from emp
where emp_name not like 'S%'; -- like �� not like



--EMP ���̺��� ���� �̸�(emp_name)�� en���� ������ ������  ID(emp_id), �̸�(emp_name)�� ��ȸ
select emp_id, emp_name
from emp
where emp_name like '%en';



--EMP ���̺��� ���� �̸�(emp_name)�� �� ��° ���ڰ� ��e���� ��� ����� �̸��� ��ȸ
select emp_name
from emp
where emp_name like '__e%';




-- EMP ���̺��� ������ �̸��� '%' �� ���� ������ ID(emp_id), �����̸�(emp_name) ��ȸ
select emp_id, emp_name
from emp
where emp_name like '%#%%' escape '#';

/*
like���� %, _ (���Ϲ���)
���Ϲ��� �տ� Ư�� ���ڸ� ���̸� %, _ ��ü ���ڸ� ��Ÿ����.
Ư�� ���ڸ� escape ������ �����Ѵ�.
*/

--EMP ���̺��� �μ���(dept_name)�� null�� ������ ID(emp_id), �̸�(emp_name), �μ���(dept_name)�� ��ȸ.
select emp_id, emp_name, dept_name
from emp
where dept_name is null; --null�� ���� ���� =�� �ϸ� �ȵȴ�. �÷� is null ���.



--�μ���(dept_name) �� NULL�� �ƴ� ������ ID(emp_id), �̸�(emp_name), �μ���(dept_name) ��ȸ
select emp_id, emp_name, dept_name
from emp
where dept_name is not null; -- is null �� is not null




--TODO: EMP ���̺��� ����(job)�� 'IT_PROG'�� �������� ��� �÷��� �����͸� ��ȸ. 
select *
from emp
where job = 'IT_PROG';


--TODO: EMP ���̺��� ����(job)�� 'IT_PROG'�� �ƴ� �������� ��� �÷��� �����͸� ��ȸ. 
select *
from emp
where job != 'IT_PROG';



--TODO: EMP ���̺��� �̸�(emp_name)�� 'Peter'�� �������� ��� �÷��� �����͸� ��ȸ
select *
from emp
where emp_name = 'Peter';


--TODO: EMP ���̺��� �޿�(salary)�� $10,000 �̻��� ������ ID(emp_id), �̸�(emp_name)�� �޿�(salary)�� ��ȸ
select emp_id, emp_name, salary
from emp
where salary >= 10000;


--TODO: EMP ���̺��� �޿�(salary)�� $3,000 �̸��� ������ ID(emp_id), �̸�(emp_name)�� �޿�(salary)�� ��ȸ
select emp_id, emp_name, salary
from emp
where salary < 3000;


--TODO: EMP ���̺��� �޿�(salary)�� $3,000 ������ ������ ID(emp_id), �̸�(emp_name)�� �޿�(salary)�� ��ȸ
select emp_id, emp_name, salary
from emp
where salary <= 3000;


--TODO: �޿�(salary)�� $4,000���� $8,000 ���̿� ���Ե� �������� ID(emp_id), �̸�(emp_name)�� �޿�(salary)�� ��ȸ
select emp_id, emp_name, salary
from emp
where salary between 4000 and 8000;



--TODO: �޿�(salary)�� $4,000���� $8,000 ���̿� ���Ե��� �ʴ� ��� ��������  ID(emp_id), �̸�(emp_name), �޿�(salary)�� ǥ��
select emp_id, emp_name, salary
from emp
where salary not between 4000 and 8000;



--TODO: EMP ���̺��� 2007�� ���� �Ի��� ��������  ID(emp_id), �̸�(emp_name), �Ի���(hire_date)�� ��ȸ.
select emp_id, emp_name, hire_date
from emp
--where hire_date >= '2007-01-01';
where to_char(hire_date, 'yyyy') >= '2007';

--TODO: EMP ���̺��� 2004�⿡ �Ի��� �������� ID(emp_id), �̸�(emp_name), �Ի���(hire_date)�� ��ȸ.
select emp_id, emp_name, hire_date
from emp
--where hire_date like '2004%';
where to_char(hire_date, 'yyyy') = '2004';



--TODO: EMP ���̺��� 2005�� ~ 2007�� ���̿� �Ի�(hire_date)�� �������� ID(emp_id), �̸�(emp_name), ����(job), �Ի���(hire_date)�� ��ȸ.
select emp_id, emp_name, job, hire_date
from emp
--where hire_date between '2005-01-01' and '2007-12-31';
where to_char(hire_date, 'yyyy') between '2005' and '2007'; 


--TODO: EMP ���̺��� ������ ID(emp_id)�� 110, 120, 130 �� ������  ID(emp_id), �̸�(emp_name), ����(job)�� ��ȸ
select emp_id, emp_name, job
from emp
where emp_id in (110, 120, 130);


--TODO: EMP ���̺��� �μ�(dept_name)�� 'IT', 'Finance', 'Marketing' �� �������� ID(emp_id), �̸�(emp_name), �μ���(dept_name)�� ��ȸ.
select emp_id, emp_name, dept_name
from emp
where dept_name in ('IT', 'Finance', 'Marketing');


--TODO: EMP ���̺��� 'Sales' �� 'IT', 'Shipping' �μ�(dept_name)�� �ƴ� �������� ID(emp_id), �̸�(emp_name), �μ���(dept_name)�� ��ȸ.
select emp_id, emp_name, dept_name
from emp
where dept_name not in ('Sales', 'IT', 'Shipping');


--TODO: EMP ���̺��� �޿�(salary)�� 17,000, 9,000,  3,100 �� ������ ID(emp_id), �̸�(emp_name), ����(job), �޿�(salary)�� ��ȸ.
select emp_id, emp_name, job, salary
from emp
where salary in (17000, 9000, 3100);


--TODO EMP ���̺��� ����(job)�� 'SA'�� �� ������ ID(emp_id), �̸�(emp_name), ����(job)�� ��ȸ
select emp_id, emp_name, job
from emp
where job like '%SA%';


--TODO: EMP ���̺��� ����(job)�� 'MAN'�� ������ ������ ID(emp_id), �̸�(emp_name), ����(job)�� ��ȸ
select emp_id, emp_name, job
from emp
where job like '%MAN';



--TODO. EMP ���̺��� Ŀ�̼��� ����(comm_pct�� null��) ��� ������ ID(emp_id), �̸�(emp_name), �޿�(salary) �� Ŀ�̼Ǻ���(comm_pct)�� ��ȸ
select  emp_id, emp_name, salary, comm_pct
from emp
where comm_pct is null;
    

--TODO: EMP ���̺��� Ŀ�̼��� �޴� ��� ������ ID(emp_id), �̸�(emp_name), �޿�(salary) �� Ŀ�̼Ǻ���(comm_pct)�� ��ȸ
select  emp_id, emp_name, salary, comm_pct
from emp
where comm_pct is not null;



--TODO: EMP ���̺��� ������ ID(mgr_id) ���� ������ ID(emp_id), �̸�(emp_name), ����(job), �ҼӺμ�(dept_name)�� ��ȸ
select emp_id, emp_name, job, dept_name
from emp
where mgr_id is null;



--TODO : EMP ���̺��� ����(salary * 12) �� 200,000 �̻��� �������� ��� ������ ��ȸ.
select *
from emp
where (salary * 12) >= 200000;



/* *************************************
 WHERE ������ �������� ���
 AND(��� ���� ����), OR(�� �� �ϳ��� ���Ǹ� ����)
 
 1. AND - �� and �� => ��(������ ����)
 2. OR - ���� or ���� => ����(������ ��)
 **************************************/
-- EMP ���̺��� ����(job)�� 'SA_REP' �̰� �޿�(salary)�� $9,000 �� ������ ������ ID(emp_id), �̸�(emp_name), ����(job), �޿�(salary)�� ��ȸ.
select emp_id, emp_name, job, salary
from emp
where job = 'SA_REP' and salary = 9000;



-- EMP ���̺��� ����(job)�� 'FI_ACCOUNT' �ų� �޿�(salary)�� $8,000 �̻����� ������ ID(emp_id), �̸�(emp_name), ����(job), �޿�(salary)�� ��ȸ.
select emp_id, emp_name, job, salary
from emp
where job = 'FI_ACCOUNT' or salary >= 8000;

select emp_id, emp_name, job, salary
from emp
where not(job = 'FI_ACCOUNT' or salary >= 8000);
        --job != 'FI_ACCOUNT' and salary <= 8000
        
--TODO: EMP ���̺��� �μ�(dept_name)�� 'Sales��'�� ����(job)�� 'SA_MAN' �̰� �޿��� $13,000 ������ 
--      ������ ID(emp_id), �̸�(emp_name), ����(job), �޿�(salary), �μ�(dept_name)�� ��ȸ
select emp_id, emp_name, job, salary, dept_name
from emp
where dept_name = 'Sales' and job = 'SA_MAN' and salary <= 13000;


--TODO: EMP ���̺��� ����(job)�� 'MAN'�� ���� ������ �߿��� �μ�(dept_name)�� 'Shipping' �̰� 2005������ �Ի��� 
--      ��������  ID(emp_id), �̸�(emp_name), ����(job), �Ի���(hire_date), �μ�(dept_name)�� ��ȸ
select emp_id, emp_name, job, hire_date, dept_name
from emp
where job like '%MAN%' and dept_name = 'Shipping' and to_char(hire_date, 'yyyy') >= '2005';


--TODO: EMP ���̺��� �Ի�⵵�� 2004���� ������� �޿��� $20,000 �̻��� 
--      �������� ID(emp_id), �̸�(emp_name), �Ի���(hire_date), �޿�(salary)�� ��ȸ.
select emp_id, emp_name, hire_date, salary
from emp
where to_char(hire_date, 'yyyy') = '2004' or salary >= 20000;


--TODO : EMP ���̺���, �μ��̸�(dept_name)��  'Executive'�� 'Shipping' �̸鼭 �޿�(salary)�� 6000 �̻��� ����� ��� ���� ��ȸ. 
select *
from emp
--where (dept_name = 'Executive' or dept_name = 'Shipping') and salary >= 6000;
where dept_name in ('Executive', 'Shipping') and salary >= 6000;


--TODO: EMP ���̺��� ����(job)�� 'MAN'�� ���� ������ �߿��� �μ��̸�(dept_name)�� 'Marketing' �̰ų� 'Sales'�� 
--      ������ ID(emp_id), �̸�(emp_name), ����(job), �μ�(dept_name)�� ��ȸ
select emp_id, emp_name, job, dept_name
from emp
--where (dept_name = 'Marketing' or dept_name = 'Sales') and job like '%MAN%';
where job like '%MAN%' and dept_name in ('Marketing', 'Sales');



--TODO: EMP ���̺��� ����(job)�� 'MAN'�� ���� ������ �� �޿�(salary)�� $10,000 ������ �ų� 2008�� ���� �Ի��� 
--      ������ ID(emp_id), �̸�(emp_name), ����(job), �Ի���(hire_date), �޿�(salary)�� ��ȸ
select emp_id, emp_name, job, hire_date, salary
from emp
where job like '%MAN%' and (salary <= 10000 or to_char(hire_date, 'yyyy') >= '2008');
--������ �켱����: AND > OR(AND�� �켱������ �� ����.)


/* *************************************
<order by�� �̿��� ����>
order by���� select���� ���������� �´�.
order by ���ı����÷� ���Ĺ�� [, .....]
    -���ı����÷�: �÷��̸�, �÷��Ǽ���(select���� �������), ��Ī(alias)

1. ��������: ASC (���� ������ ���ʴ��), default��.
    ���ڿ� ��������: ���� -> �빮�� -> �ҹ��� -> �ѱ�
    date ��������: ���� -> �̷�
    null ��������: �� �������� ���´�.

2. ��������: DESC (���� ������ ���ʴ��)
************************************* */

-- �������� ��ü ������ ���� ID(emp_id)�� ū ������� ������ ��ȸ
select *
from emp
order by emp_id desc;


-- �������� id(emp_id), �̸�(emp_name), ����(job), �޿�(salary)�� 
-- ����(job) ������� (A -> Z) ��ȸ�ϰ� ����(job)�� ���� ��������  �޿�(salary)�� ���� ������� 2�� �����ؼ� ��ȸ.
select emp_id, emp_name, job, salary
from emp
order by job asc, salary desc;


--�μ����� �μ���(dept_name)�� ������������ ������ ��ȸ�Ͻÿ�.
select *
from emp
order by dept_name;

select dept_name
from emp
--order by 1 nulls first; 
--���������� �� null���� ó������: nulls first
order by 1 desc nulls last; 
--���������� �� null���� ����������: nulls last

--TODO: �޿�(salary)�� $5,000�� �Ѵ� ������ ID(emp_id), �̸�(emp_name), �޿�(salary)�� �޿��� ���� �������� ��ȸ
select emp_id, emp_name, salary
from emp
where salary > 5000
order by salary desc;


--TODO: �޿�(salary)�� $5,000���� $10,000 ���̿� ���Ե��� �ʴ� ��� ������  ID(emp_id), �̸�(emp_name), �޿�(salary)�� �̸�(emp_name)�� ������������ ����
select emp_id, emp_name, salary
from emp
where salary not between 5000 and 10000
order by 2;


--TODO: EMP ���̺��� ������ ID(emp_id), �̸�(emp_name), ����(job), �Ի���(hire_date)�� �Ի���(hire_date) ��(��������)���� ��ȸ.
select emp_id, emp_name, job, hire_date
from emp
order by hire_date;


--TODO: EMP ���̺��� ID(emp_id), �̸�(emp_name), �޿�(salary), �Ի���(hire_date)�� �޿�(salary) ������������ �����ϰ� 
--�޿�(salary)�� ���� ���� �Ի���(hire_date)�� ������ ������ ����.
select emp_id, emp_name, salary, hire_date
from emp
order by 3, 4;

--ġȯ����
--ġȯ������ ������� �ʰڴ�.
set define off;

select * from emp
where dept_name = '&dept_name';

--ġȯ������ ����ϰڴ�.(default)
set define on;