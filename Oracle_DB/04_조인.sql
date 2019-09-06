create user scott_join identified by tiger; --��������
grant all privileges to scott_join; --��� ���� �ο�.

select * from dept;
desc dept;

/* ****************************************
����(JOIN) �̶�
- 2�� �̻��� ���̺� �ִ� �÷����� ���ļ� ������ ���̺��� ����� ��ȸ�ϴ� ����� ���Ѵ�.
 	- �ҽ����̺� : ���� ���� �о�� �Ѵٰ� �����ϴ� ���̺�
	- Ÿ�����̺� : �ҽ��� ���� �� �ҽ��� ������ ����� �Ǵ� ���̺�
 
- �� ���̺��� ��� ��ĥ���� ǥ���ϴ� ���� ���� �����̶�� �Ѵ�.
    - ���� ���꿡 ���� ��������
        - Equi join (=)������ ���, non-equi join (=)������ �� ���.
- ������ ����
    - Inner Join 
        - ���� ���̺��� ���� ������ �����ϴ� ��鸸 ��ģ��. 
    - Outer Join
        - ���� ���̺��� ����� ��� ����ϰ� �ٸ� �� ���̺��� ���� ������ �����ϴ� �ุ ��ģ��. ���������� �����ϴ� ���� ���� ��� NULL�� ��ģ��.
        - ���� : Left Outer Join,  Right Outer Join, Full Outer Join
    - Cross Join = īƼ�� ��
        - �� ���̺��� �������� ��ȯ�Ѵ�.(A*B)
- ���� ����
    - ANSI ���� ����
        - ǥ�� SQL ����
        - ����Ŭ�� 9i ���� ����.
    - ����Ŭ ���� ����
        - ����Ŭ ���� �����̸� �ٸ� DBMS�� �������� �ʴ´�.
**************************************** */        
        

/* ****************************************
-- inner join : ANSI ���� ����
FROM  �ҽ����̺�a (INNER) JOIN Ÿ�����̺�b ON �������� 

- inner�� ���� �� �� �ִ�.
**************************************** */
-- ������ ID(emp.emp_id), �̸�(emp.emp_name), �Ի�⵵(emp.hire_date), �ҼӺμ��̸�(dept.dept_name)�� ��ȸ
select emp.emp_id, emp.emp_name, emp.hire_date, dept.dept_name
from emp inner join dept on emp.dept_id = dept.dept_id;

select E.emp_id, E.emp_name, E.hire_date, D.dept_name
from emp E inner join dept D on E.dept_id = D.dept_id; --���̺���� ��Ī�� ������ ��� ����.


-- ������ ID(emp.emp_id)�� 100�� ������ ����_ID(emp.emp_id), �̸�(emp.emp_name), �Ի�⵵(emp.hire_date), �ҼӺμ��̸�(dept.dept_name)�� ��ȸ.
select emp.emp_id, emp.emp_name, emp.hire_date, dept.dept_name
from emp join dept on emp.dept_id = dept.dept_id
where emp_id = 100;


-- ����_ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), ��������(job.job_title), �ҼӺμ��̸�(dept.dept_name)�� ��ȸ
select emp_id, emp_name, salary, job_title, D.dept_name
from emp E join job J on E.job_id = J.job_id 
           join dept D on E.dept_id = D.dept_id;
      
      
-- �μ�_ID(dept.dept_id)�� 30�� �μ��� �̸�(dept.dept_name), ��ġ(dept.loc), �� �μ��� �Ҽӵ� ������ �̸�(emp.emp_name)�� ��ȸ.
select dept_name, loc, emp_name
from dept inner join emp on dept.dept_id = emp.dept_id
where dept.dept_id = 30;


-- ������ ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), �޿����(salary_grade.grade) �� ��ȸ. �޿� ��� ������������ ����
select emp_id, emp_name, salary, grade||'���' �޿����
from emp join salary_grade on salary between low_sal and high_sal
order by 4;


--TODO 200����(200 ~ 299) ���� ID(emp.emp_id)�� ���� �������� ����_ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), 
--     �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ. ����_ID�� ������������ ����.
select emp_id, emp_name, salary, dept_name, loc
from emp join dept on emp.dept_id = dept.dept_id
where emp_id between 200 and 299
order by 1;


--TODO ����(emp.job_id)�� 'FI_ACCOUNT'�� ������ ID(emp.emp_id), �̸�(emp.emp_name), ����(emp.job_id), 
--     �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ.  ����_ID�� ������������ ����.
select emp_id, emp_name, job_id, dept_name, loc
from emp join dept on emp.dept_id = dept.dept_id
where job_id = 'FI_ACCOUNT'
order by 1;


--TODO Ŀ�̼Ǻ���(emp.comm_pct)�� �ִ� �������� ����_ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), Ŀ�̼Ǻ���(emp.comm_pct), 
--     �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ. ����_ID�� ������������ ����.
select emp_id, emp_name, salary, comm_pct, dept_name, loc
from emp join dept on emp.dept_id = dept.dept_id
where comm_pct is not null
order by 1;



--TODO 'New York'�� ��ġ��(dept.loc) �μ��� �μ�_ID(dept.dept_id), �μ��̸�(dept.dept_name), ��ġ(dept.loc), 
--     �� �μ��� �Ҽӵ� ����_ID(emp.emp_id), ���� �̸�(emp.emp_name), ����(emp.job_id)�� ��ȸ. �μ�_ID �� ������������ ����.
select D.dept_id, dept_name, loc, emp_id, emp_name, job_id
from dept D join emp E on D.dept_id = E.dept_id
where loc = 'New York'
order by 1;

--TODO ����_ID(emp.emp_id), �̸�(emp.emp_name), ����_ID(emp.job_id), ������(job.job_title) �� ��ȸ.
select emp_id, emp_name, E.job_id, job_title
from emp E join job J on E.job_id = J.job_id; 

              
-- TODO: ���� ID �� 200 �� ������ ����_ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), 
--       ��������(job.job_title), �ҼӺμ��̸�(dept.dept_name)�� ��ȸ              
select emp_id, emp_name, salary, job_title, dept_name
from emp join job on emp.job_id = job.job_id
         join dept on emp.dept_id = dept.dept_id
where emp_id = 200;


-- TODO: 'Shipping' �μ��� �μ���(dept.dept_name), ��ġ(dept.loc), �Ҽ� ������ �̸�(emp.emp_name), ������(job.job_title)�� ��ȸ. 
--       �����̸� ������������ ����
select dept_name, loc, emp_name, job_title
from dept join emp on emp.dept_id = dept.dept_id
          join job on emp.job_id = job.job_id
where dept_name = 'Shipping'
order by 3 desc;



-- TODO:  'San Francisco' �� �ٹ�(dept.loc)�ϴ� ������ id(emp.emp_id), �̸�(emp.emp_name), �Ի���(emp.hire_date)�� ��ȸ
--         �Ի����� 'yyyy-mm-dd' �������� ���
select emp_id, emp_name, to_char(hire_date, 'yyyy-mm-dd') �Ի���
from emp join dept on emp.dept_id = dept.dept_id
where loc = 'San Francisco';

-- TODO �μ��� �޿�(salary)�� ����� ��ȸ. �μ��̸�(dept.dept_name)�� �޿������ ���. �޿� ����� ���� ������ ����.
-- �޿��� , ���������ڿ� $ �� �ٿ� ���.
select to_char(avg(salary), 'fm$9,999,999') �޿����, dept_name
from emp join dept on emp.dept_id = dept.dept_id
group by dept_name
order by avg(salary) desc;

--TODO ������ ID(emp.emp_id), �̸�(emp.emp_name), ������(job.job_title), �޿�(emp.salary), 
--     �޿����(salary_grade.grade), �ҼӺμ���(dept.dept_name)�� ��ȸ. ��� ������������ ����
select emp_id, emp_name, job_title, salary, grade, dept_name
from emp join job on emp.job_id = job.job_id
         join dept on emp.dept_id = dept.dept_id
         join salary_grade on salary between low_sal and high_sal
order by 4 desc;


--TODO �޿������(salary_grade.grade) 1�� ������ �Ҽӵ� �μ���(dept.dept_name)�� ���1�� ������ ���� ��ȸ. �������� ���� �μ� ������� ����.
select dept_name, count(*) ������
from emp join salary_grade on salary between low_sal and high_sal
         join dept on emp.dept_id = dept.dept_id
where grade = 1
group by dept_name
order by 2 desc ;

/* ###################################################################################### 
����Ŭ ���� 
- Join�� ���̺���� from���� �����Ѵ�.
- Join ������ where���� ����Ѵ�. 

###################################################################################### */
-- ������ ID(emp.emp_id), �̸�(emp.emp_name), �Ի�⵵(emp.hire_date), �ҼӺμ��̸�(dept.dept_name)�� ��ȸ
-- �Ի�⵵�� �⵵�� ���
select emp_id, emp_name, to_char(hire_date, 'yyyy'), dept_name
from emp, dept
where emp.dept_id = dept.dept_id;

-- ������ ID(emp.emp_id)�� 100�� ������ ����_ID(emp.emp_id), �̸�(emp.emp_name), �Ի�⵵(emp.hire_date), �ҼӺμ��̸�(dept.dept_name)�� ��ȸ
-- �Ի�⵵�� �⵵�� ���
select emp_id, emp_name, to_char(hire_date, 'yyyy'), dept_name
from emp, dept
where emp.dept_id = dept.dept_id and emp_id = 100;


-- ����_ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), ��������(job.job_title), �ҼӺμ��̸�(dept.dept_name)�� ��ȸ
select emp_id, emp_name, salary, job_title, dept_name
from emp, dept, job
where emp.dept_id = dept.dept_id and emp.job_id = job.job_id;


--TODO 200����(200 ~ 299) ���� ID(emp.emp_id)�� ���� �������� ����_ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), 
--     �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ. ����_ID�� ������������ ����.
select emp_id, emp_name, salary, dept_name, loc
from emp, dept
where emp.dept_id = dept.dept_id and emp_id between 200 and 299
order by 1;

--TODO ����(emp.job_id)�� 'FI_ACCOUNT'�� ������ ID(emp.emp_id), �̸�(emp.emp_name), ����(emp.job_id), 
--     �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ.  ����_ID�� ������������ ����.
select emp_id, emp_name, job_id, dept_name, loc
from emp, dept
where emp.dept_id = dept.dept_id and job_id = 'FI_ACCOUNT'
order by 1;


--TODO Ŀ�̼Ǻ���(emp.comm_pct)�� �ִ� �������� ����_ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), Ŀ�̼Ǻ���(emp.comm_pct), 
--     �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ. ����_ID�� ������������ ����.
select emp_id, emp_name, salary, comm_pct, dept_name, loc
from emp, dept
where emp.dept_id = dept.dept_id and comm_pct is not null
order by 1;



--TODO 'New York'�� ��ġ��(dept.loc) �μ��� �μ�_ID(dept.dept_id), �μ��̸�(dept.dept_name), ��ġ(dept.loc), 
--     �� �μ��� �Ҽӵ� ����_ID(emp.emp_id), ���� �̸�(emp.emp_name), ����(emp.job_id)�� ��ȸ. �μ�_ID �� ������������ ����.
select dept.dept_id, dept_name, loc, emp_id, emp_name, job_id
from emp, dept
where emp.dept_id = dept.dept_id and loc = 'New York'
order by emp_id;


--TODO ����_ID(emp.emp_id), �̸�(emp.emp_name), ����_ID(emp.job_id), ������(job.job_title) �� ��ȸ.
select emp_id, emp_name, emp.job_id, job_title
from emp, job
where emp.job_id = job.job_id;


             
-- TODO: ���� ID �� 200 �� ������ ����_ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), 
--       ��������(job.job_title), �ҼӺμ��̸�(dept.dept_name)�� ��ȸ              
select emp_id, emp_name, salary, job_title, dept_name
from emp, job, dept
where emp.job_id = job.job_id and emp.dept_id = dept.dept_id and emp_id = 200;


-- TODO: 'Shipping' �μ��� �μ���(dept.dept_name), ��ġ(dept.loc), �Ҽ� ������ �̸�(emp.emp_name), ������(job.job_title)�� ��ȸ. 
--       �����̸� ������������ ����
select dept_name, loc, emp_name, job_title
from emp, job, dept
where emp.job_id = job.job_id and emp.dept_id = dept.dept_id and dept_name = 'Shipping';

-- TODO:  'San Francisco' �� �ٹ�(dept.loc)�ϴ� ������ id(emp.emp_id), �̸�(emp.emp_name), �Ի���(emp.hire_date)�� ��ȸ
--         �Ի����� 'yyyy-mm-dd' �������� ���
select emp_id, emp_name, to_char(hire_date, 'yyyy-mm-dd')
from emp, dept
where emp.dept_id = dept.dept_id and loc = 'San Francisco';



--TODO �μ��� �޿�(salary)�� ����� ��ȸ. �μ��̸�(dept.dept_name)�� �޿������ ���. �޿� ����� ���� ������ ����.
-- �޿��� , ���������ڿ� $ �� �ٿ� ���.
select to_char(avg(salary), 'fm$99,999') �޿����, dept_name
from emp, dept
where emp.dept_id = dept.dept_id
group by dept_name
order by avg(salary) desc;


--TODO ������ ID(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), �޿����(salary_grade.grade) �� ��ȸ. ���� id ������������ ����
select emp_id, emp_name, salary, grade
from emp, salary_grade
where salary between low_sal and high_sal
order by 1;



--TODO ������ ID(emp.emp_id), �̸�(emp.emp_name), ������(job.job_title), �޿�(emp.salary), 
--     �޿����(salary_grade.grade), �ҼӺμ���(dept.dept_name)�� ��ȸ. ��� ������������ ����
select emp_id, emp_name, job_title, salary, grade, dept_name
from emp, job, dept, salary_grade
where emp.job_id = job.job_id and emp.dept_id = dept.dept_id
      and salary between low_sal and high_sal
order by grade desc;

--TODO �޿������(salary_grade.grade) 1�� ������ �Ҽӵ� �μ���(dept.dept_name)�� ���1�� ������ ���� ��ȸ. �������� ���� �μ� ������� ����.
select dept_name, count(*)
from dept, salary_grade, emp
where emp.dept_id = dept.dept_id
      and salary between low_sal and high_sal
      and grade = 1
group by dept_name
order by 2 desc;

/* ****************************************************
Self ����
- ���������� �ϳ��� ���̺��� �ΰ��� ���̺�ó�� �����ϴ� ��.
- �ַ� �������� ǥ���� �� ����.
**************************************************** */
--������ ID(emp.emp_id), �̸�(emp.emp_name), ����̸�(emp.emp_name)�� ��ȸ
select e.emp_id, e.emp_name �����̸�, m.emp_name ����̸�
from emp e join emp m on e.mgr_id = m.emp_id;

select e.emp_id, e.emp_name �����̸�, m.emp_name ����̸�
from emp e , emp m 
where e.mgr_id = m.emp_id;

-- TODO : EMP ���̺��� ���� ID(emp.emp_id)�� 110�� ������ �޿�(salary)���� ���� �޴� 
-- �������� id(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary)�� ���� ID(emp.emp_id) ������������ ��ȸ.
select e2.emp_id, e2.emp_name, e2.salary
from emp e1 join emp e2 on e1.salary < e2. salary
where e1.emp_id = 110
order by 1;

select e2.emp_id, e2.emp_name, e2.salary
from emp e1, emp e2
where e1.emp_id = 110 and e1.salary < e2.salary
order by 1;

/* ****************************************************
�ƿ��� ���� (Outer Join)
-����� ����
    -���� ����� �ҽ����̺��� ���� �� join�ϰ� Ÿ�����̺��� ���� ���� ������ �����ϸ� ���̰� ������ nulló��.

1. left outer join: ������ �ҽ� ���̺��� ����
2. right outer join: ������ �ҽ� ���̺��� ������
3. full outer join: �� �� �ҽ� ���̺�(����Ŭ ���ι����� ��������.)

-ANSI ����
from ���̺�a [LEFT | RIGHT | FULL] (OUTER) JOIN ���̺�b ON ��������
- OUTER�� ���� ����.

-����Ŭ JOIN ����
- FROM ���� ������ ���̺��� ����
- WHERE ���� ���� ������ �ۼ�
    - Ÿ�� ���̺� (+) �� ���δ�.
    - FULL OUTER JOIN�� �������� �ʴ´�.

**************************************************** */
-- ������ id(emp.emp_id), �̸�(emp.emp_name), �޿�(emp.salary), �μ���(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ. 
-- �μ��� ���� ������ ������ �������� ��ȸ. (�μ������� null). dept_name�� ������������ �����Ѵ�.
select emp_id, emp_name, salary, dept_name, loc
from emp e left outer join dept d on e.dept_id = d.dept_id;
--����Ŭ ����
select emp_id, emp_name, salary, dept_name, loc
from emp e, dept d 
where e.dept_id = d.dept_id(+);


select d.dept_id, d.dept_name, d.loc, e.emp_name, e.hire_date
from emp e right join dept d on e.dept_id =  d.dept_id
where d.dept_id in (260, 270, 10, 60);
--����Ŭ ����
select d.dept_id, d.dept_name, d.loc, e.emp_name, e.hire_date
from emp e, dept d
where e.dept_id(+) =  d.dept_id and d.dept_id in (260, 270, 10, 60);

select d.dept_id, loc, emp_id, emp_name, salary
from dept d full outer join emp e on d.dept_id = e.dept_id
where emp_id in (100,175, 178) or d.dept_id in (260, 270, 10, 60);


-- ��� ������ id(emp.emp_id), �̸�(emp.emp_name), �μ�_id(emp.dept_id)�� ��ȸ�ϴµ�
-- �μ�_id�� 80 �� �������� �μ���(dept.dept_name)�� �μ���ġ(dept.loc) �� ���� ����Ѵ�. (�μ� ID�� 80�� �ƴϸ� null�� ��������)
select emp_id, emp_name, e.dept_id, 
       d.dept_id, dept_name, loc
from emp e left join dept d on e.dept_id = d.dept_id and e.dept_id = 80;
--����Ŭ ����
select emp_id, emp_name, e.dept_id, 
       d.dept_id, dept_name, loc
from emp e, dept d 
where e.dept_id = d.dept_id(+) and d.dept_id(+) = 80;




--TODO: ����_id(emp.emp_id)�� 100, 110, 120, 130, 140�� ������ ID(emp.emp_id), �̸�(emp.emp_name), ������(job.job_title) �� ��ȸ. 
--      �������� ���� ��� '�̹���' ���� ��ȸ
select emp_id, emp_name, decode(job_title, null, '�̹���', job_title) job_title
from emp e left join job j on e.job_id = j.job_id
where emp_id in (100, 110, 120, 130, 140);

select emp_id, emp_name, decode(job_title, null, '�̹���', job_title) job_title
from emp e, job j
where e.job_id = j.job_id(+) and emp_id in (100, 110, 120, 130, 140);

select emp_id, emp_name, nvl(job_title, '�̹���') job_title
from emp e, job j
where e.job_id = j.job_id(+) and emp_id in (100, 110, 120, 130, 140);


--TODO: �μ��� ID(dept.dept_id), �μ��̸�(dept.dept_name)�� �� �μ��� ���� �������� ���� ��ȸ. 
--      ������ ���� �μ��� 0�� �������� ��ȸ�ϰ� �������� ���� �μ� ������ ��ȸ.

--����!! count(*)�� ���� ���� ���Ƿ� ������ ��� 1�� ���´�.
select d.dept_id, dept_name, count(emp_id)
from emp e right join dept d on e.dept_id = d.dept_id
group by d.dept_id, dept_name
order by 3 desc;

select d.dept_id, dept_name, count(emp_id)
from emp e, dept d 
where e.dept_id(+) = d.dept_id
group by d.dept_id, dept_name
order by 3 desc;

-- TODO: EMP ���̺��� �μ�_ID(emp.dept_id)�� 90 �� �������� id(emp.emp_id), �̸�(emp.emp_name), ����̸�(emp.emp_name), �Ի���(emp.hire_date)�� ��ȸ. 
-- �Ի����� yyyy-mm-dd �������� ���
-- ��簡�� ���� ������ '��� ����' ���
select e1.emp_id, e1.emp_name �����̸�, 
--       decode(e2.emp_name, null, '��� ����', e2.emp_name) ����̸�,
       nvl(e2.emp_name, '������') ����̸�,
       to_char(e1.hire_date, 'yyyy-mm-dd')
from emp e1 left join emp e2 on e1.mgr_id = e2.emp_id
where e1.dept_id = 90;



--TODO 2003��~2005�� ���̿� �Ի��� ������ id(emp.emp_id), �̸�(emp.emp_name), ������(job.job_title), �޿�(emp.salary), �Ի���(emp.hire_date),
--     ����̸�(emp.emp_name), ������Ի���(emp.hire_date), �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)�� ��ȸ.
-- �� ��簡 ���� ������ ��� ����̸�, ������Ի����� null�� ���.
-- �μ��� ���� ������ ��� null�� ��ȸ
select e1.emp_id ����id, e1.emp_name �����̸�, j.job_title ������, e1.salary �޿�, e1.hire_date �Ի���,
       e2.emp_name ����̸�, e2.hire_date ����Ի���, d.dept_name �ҼӺμ�, d.loc �μ���ġ
from emp e1 left join job j on e1.job_id = j.job_id
            left join emp e2 on e1.mgr_id = e2.emp_id
            left join dept d on e1.dept_id = d.dept_id
where to_char(e1.hire_date, 'yyyy') between 2003 and 2005
order by 1;




