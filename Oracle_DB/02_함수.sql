/* *************************************
�Լ� - ���ڿ����� �Լ�
 UPPER()/ LOWER() : �빮��/�ҹ��� �� ��ȯ
 INITCAP(): �ܾ� ù���ڸ� �빮�� ������ �ҹ��ڷ� ��ȯ
 LENGTH() : ���ڼ� ��ȸ
 LPAD(��, ũ��, ä�ﰪ) : "��"�� ������ "ũ��"�� �������� ���ڿ��� ����� ���ڶ�� ���� ���ʺ��� "ä�ﰪ"���� ä���.
 RPAD(��, ũ��, ä�ﰪ) : "��"�� ������ "ũ��"�� �������� ���ڿ��� ����� ���ڶ�� ���� �����ʺ��� "ä�ﰪ"���� ä���.
 SUBSTR(��, ����index, ���ڼ�) - "��"���� "����index"��° ���ں��� ������ "���ڼ�" ��ŭ�� ���ڿ��� ����. ���ڼ� ������ ������. 
 REPLACE(��, ã�����ڿ�, �����ҹ��ڿ�) - "��"���� "ã�����ڿ�"�� "�����ҹ��ڿ�"�� �ٲ۴�.
 LTRIM(��): �ް��� ����
 RTRIM(��): �������� ����
 TRIM(��): ���� ���� ����
 ************************************* */
select upper('abc'), lower('ABC') from dual;
select initcap('hello world') from dual;
select length('abcdefg') from dual;
select * from emp where length(emp_name)>7;
select lpad('test', 10, '*'), rpad('test', 2, '*'), substr('test', 2, 1) from dual;
select replace('i got it', 'i ', 'you ') from dual;
select ltrim('     hhh     ') a, rtrim('     hhh     ') b, trim('     hhh     ') c from dual;

--�Լ� �ȿ��� �Լ��� ȣ���ϴ� ���: ���� �Լ��� ���� �����ϰ� �� ����� �־� �ٱ��� �Լ� ����.
select length(trim('   hhh   ')) from dual;

--EMP ���̺��� ������ �̸�(emp_name)�� ��� �빮��, �ҹ���, ù���� �빮��, �̸� ���ڼ��� ��ȸ
select upper(emp_name), lower(emp_name), initcap(emp_name), length(emp_name) from emp;


--TODO: EMP ���̺��� ������ ID(emp_id), �̸�(emp_name), �޿�(salary), �μ�(dept_name)�� ��ȸ.
--�� �����̸�(emp_name)�� ��� �빮��, �μ�(dept_name)�� ��� �ҹ��ڷ� ���. UPPER/LOWER
select emp_id, upper(emp_name) emp_name, salary, lower(dept_name) dept_name from emp;

--(�Ʒ� 2���� �񱳰��� ��ҹ��ڸ� Ȯ���� �𸣴� ����)
--TODO: EMP ���̺��� ������ �̸�(emp_name)�� PETER�� ������ ��� ������ ��ȸ�Ͻÿ�.
select *
from emp
where upper(emp_name) = 'PETER';


--TODO: EMP ���̺��� ����(job)�� 'Sh_Clerk' �� ��������  ID(emp_id), �̸�(emp_name), ����(job), �޿�(salary)�� ��ȸ
select emp_id, emp_name, job, salary
from emp
where initcap(job) = 'Sh_Clerk';


--TODO: ���� �̸�(emp_name) �� �ڸ����� 15�ڸ��� ���߰� ���ڼ��� ���ڶ� ��� ������ �տ� �ٿ� ��ȸ. ���� �µ��� ��ȸ
select lpad(emp_name, 15) name
from emp;

    
--TODO: EMP ���̺��� ��� ������ �̸�(emp_name)�� �޿�(salary)�� ��ȸ.
--(��, "�޿�(salary)" ���� ���̰� 7�� ���ڿ��� �����, ���̰� 7�� �ȵ� ��� ���ʺ��� �� ĭ�� '_'�� ä��ÿ�. EX) ______5000) -LPAD() �̿�
select emp_name, lpad(salary, 7, '_') salary from emp;


--TODO: EMP ���̺��� �̸�(emp_name)�� 10���� �̻��� �������� �̸�(emp_name)�� �̸��� ���ڼ� ��ȸ
select emp_name, length(emp_name)
from emp
where length(emp_name) >= 10;




/* *************************************
�Լ� - ���ڰ��� �Լ�
 round(��, �ڸ���) : �ڸ������� �ݿø� (��� - �Ǽ���, ���� - ������)
 trunc(��, �ڸ���) : �ڸ������� ����(��� - �Ǽ���, ���� - ������)
 ceil(��) : �ø�
 floor(��) : ����
 mod(�����¼�, �����¼�) : �������� ������ ����
 
************************************* */
select round(5.43456567, 3), round(123.45, -1) from dual;
select trunc(6.34562343, 3), trunc(545.326, -1) from dual;
select ceil(3.254), floor(3.254) from dual; --ceil, floor�� ����� ����.
select mod(37, 3) from dual;

--TODO: EMP ���̺��� �� ������ ���� ����ID(emp_id), �̸�(emp_name), �޿�(salary) �׸��� 15% �λ�� �޿�(salary)�� ��ȸ�ϴ� ���Ǹ� �ۼ��Ͻÿ�.
--(��, 15% �λ�� �޿��� �ø��ؼ� ������ ǥ���ϰ�, ��Ī�� "SAL_RAISE"�� ����.)
select emp_id, emp_name, salary, ceil(salary * 1.5) SAL_RAISE from emp;


--TODO: ���� SQL������ �λ� �޿�(sal_raise)�� �޿�(salary) ���� ������ �߰��� ��ȸ 
--(����ID(emp_id), �̸�(emp_name), 15% �λ�޿�, �λ�� �޿��� ���� �޿�(salary)�� ����)
select emp_id, emp_name, 
       salary * 1.5 "�λ�� �޿�",
       ceil(salary * 1.5) - salary  "���� �޿����� ����" from emp;


-- TODO: EMP ���̺��� Ŀ�̼��� �ִ� �������� ����_ID(emp_id), �̸�(emp_name), Ŀ�̼Ǻ���(comm_pct), Ŀ�̼Ǻ���(comm_pct)�� 8% �λ��� ����� ��ȸ.
--(�� Ŀ�̼��� 8% �λ��� ����� �Ҽ��� ���� 2�ڸ����� �ݿø��ϰ� ��Ī�� comm_raise�� ����)
select emp_id, emp_name, comm_pct, round(comm_pct * 1.08, 2) comm_raise
from emp
where comm_pct is not null;



/* *************************************
�Լ� - ��¥���� ��� �� �Լ�
Date +- ���� : ��¥ ���.
sysdate: ��������� �Ͻ�, date type
systimestamp: ��������� �Ͻ�, timestamp type
months_between(d1, d2) -����� ������(d1�� �ֱ�, d2�� ����)
add_months(d1, ����) - �������� ���� ��¥. ������ ��¥�� 1���� �Ĵ� ���� ������ ���� �ȴ�. 
next_day(d1, '����') - d1���� ù��° ������ ������ ��¥. ������ �ѱ�(locale)�� �����Ѵ�.
last_day(d) - d ���� ��������.
extract(year|month|day from date) - date���� year/month/day�� ����
************************************* */
select to_char(sysdate, 'yyyy/mm/dd hh24:mm:ss') from dual;
select sysdate - 10 from dual;
select add_months(sysdate, 10), add_months(sysdate, -10) from dual;
select next_day(sysdate, '') from dual;
select months_between(sysdate, '2015-07-01'), months_between(sysdate, '2015-07-05') from dual;
select next_day(sysdate, '��'),last_day(sysdate)from dual;
select extract(year from sysdate) from dual;

select * from emp where extract(year from hire_date) = 2004;
--TODO: EMP ���̺��� �μ��̸�(dept_name)�� 'IT'�� �������� '�Ի���(hire_date)�� ���� 10����', �Ի��ϰ� '�Ի��Ϸ� ���� 10����',  �� ��¥�� ��ȸ. 
select hire_date + 10 "10�� ��", hire_date �Ի���, hire_date - 10 "10�� ��"
from emp
where dept_name = 'IT';

    
--TODO: �μ��� 'Purchasing' �� ������ �̸�(emp_name), �Ի� 6�������� �Ի���(hire_date), 6������ ��¥�� ��ȸ.
select emp_name,
       add_months(hire_date, -6) "�Ի� 6���� ��",
       hire_date �Ի���,
       add_months(hire_date, 6) "�Ի� 6���� ��"
from emp
where dept_name = 'Purchasing';

--TODO: EMP ���̺��� �Ի��ϰ� �Ի��� 2�� ��, �Ի��� 2�� �� ��¥�� ��ȸ.
select hire_date �Ի���,
       add_months(hire_date, 2) "2�� ��",
       add_months(hire_date, -2) "2�� ��"
from emp;
            
--TODO: �� ������ �̸�(emp_name), �ٹ� ������ (�Ի��Ͽ��� ��������� �� ��)�� ����Ͽ� ��ȸ.
--(�� �ٹ� �������� �Ǽ� �� ��� ������ �ݿø�. �ٹ������� ������������ ����.)
select emp_name, 
       round(months_between(sysdate, hire_date))||'����' �ٹ�������
from emp
order by �ٹ������� desc;


--TODO: ���� ID(emp_id)�� 100 �� ������ �Ի��� ���� ù��° �ݿ����� ��¥�� ���Ͻÿ�.
select emp_id, next_day(hire_date, '��') friday
from emp
where emp_id = 100;

/* *************************************
�Լ� - ��ȯ �Լ�
to_char(��, ����) : ������, ��¥���� ���������� ��ȯ
to_number(��, ����) : �������� ���������� ��ȯ 
to_date(��, ����) : �������� ��¥������ ��ȯ

- to_char()�� ����: ��ȯ ó�� ����� ����(�������)
- to_number()/to_date() : ��ȯ�� ����� ����.

���Ĺ��� 
-���� : 
 0, 9 : ���ڰ� �� �ڸ��� ����. (0�� ���� �ڸ��� 0���� ä���, 9�� �������� ä���.)
        fm���� �����ϸ� 9�� ��� ������ ����.
 .: ����/�Ǽ��� ������
 ,: ������ ���� ������
 L, $ : ��ȭǥ��. L�� ������ȭ��ȣ 
-�Ͻ� : yyyy(���� 4�ڸ�), yy(2000���, ���� 2�ڸ�), RR(���� 2�ڸ�, 50�̻� 90��� 50�̸� 2000���),
        mm(�� 2�ڸ�), dd(�� 2�ڸ�),
        hh24(00~23��), hh(01~12��), mi(�� 2�ڸ�), ss(�� 2�ڸ�), day(����), am �Ǵ� pm 
**************************************/
select '20'+10 from dual;
select to_date('10', 'yy')-10 from dual;

select to_char(1234567, '9,999,999') A,
       to_char(12345, '9,999,999') B, 
       to_char(12345, 'fm9,999,999') C,
       to_char(12345, '0,000,000') D,
       to_char(12345, '9,999') E, --���Ĺ��ڿ��� �ڸ����� ������ ũ�ų� ���ƾ� �Ѵ�. ������ #���� ���´�.
       to_char(12345.6789, '99999.99') F,
       to_char(5000, '$9,999') G,
       to_char(5000, 'L9,999') H, 
       to_char(5000, '9,999')||'��' I from dual; 
       --���ڴ� ���Ĺ��ڿ����� ���Ĺ��ڸ� ������ ���� ��� ����.

select to_number('4,000', '9,999')+10,
       to_number('$4,000', '$9,999')+10 from dual;
       
select to_char(sysdate, 'hh24:mi:ss') from dual;
select to_char(sysdate, 'yyyy"��" mm"��" dd"��"') from dual; --date���� ���� ���ڸ� ������ ���ڿ��� ""�� ���μ� �־��� �� �ִ�.

select to_char(sysdate, 'w') from dual; --�������� �˷��ش�.
select to_char(sysdate, 'ww') from dual; --�ϳ��� ��������...
select to_char(sysdate, 'q') from dual; --4�б� �� ����� �б�(1�б�:1-3, 2: 4-6, 3: 7-9, 4: 10-12)
select to_char(sysdate, 'd') from dual; --������ ���ڷ� ��ȯ.

select to_date('20191010', 'yyyymmdd')-10, 
       to_date('201005', 'yyyymm') from dual;

-- EMP ���̺��� ����(job)�� "CLERK"�� ���� �������� ID(emp_id), �̸�(name), ����(job), �޿�(salary)�� ��ȸ
--(�޿��� ���� ������ , �� ����ϰ� �տ� $�� �ٿ��� ���.)
select emp_id, emp_name, job, to_char(salary, 'fm$99,999.99') salary from emp
where job like '%CLERK%';


-- ���ڿ� '20030503' �� 2003�� 05�� 03�� �� ���.
-- char -> char : char -> date -> char
select to_char(to_date('20030503', 'yyyymmdd'), 'yyyy"��" mm"��" dd"��"') from dual;

-- TODO: �μ���(dept_name)�� 'Finance'�� �������� ID(emp_id), �̸�(emp_name)�� �Ի�⵵(hire_date) 4�ڸ��� ����Ͻÿ�. (ex: 2004);
--to_char()
select emp_id, emp_name, to_char(hire_date, 'yyyy"��"') hire_date
from emp
where dept_name = 'Finance'
order by 3 desc;

--TODO: �������� 11���� �Ի��� �������� ����ID(emp_id), �̸�(emp_name), �Ի���(hire_date)�� ��ȸ
--to_char()
select emp_id, emp_name, hire_date
from emp
--where to_char(hire_date, 'mm') = '11';
where extract(month from hire_date) = '11';

--TODO: 2006�⿡ �Ի��� ��� ������ �̸�(emp_name)�� �Ի���(yyyy-mm-dd ����)�� �Ի���(hire_date)�� ������������ ��ȸ
--to_char()
select emp_name, to_char(hire_date, 'yyyy-mm-dd') hire_date
from emp
where to_char(hire_date, 'yyyy') = '2006'
order by hire_date;

--TODO: 2004�� 01�� ���� �Ի��� ���� ��ȸ�� �̸�(emp_name)�� �Ի���(hire_date) ��ȸ
select emp_name, hire_date
from emp
where to_char(hire_date, 'yyyy/mm') >= '2004/01';


--TODO: ���ڿ� '20100107232215' �� 2010�� 01�� 07�� 23�� 22�� 15�� �� ���. (dual ���Ժ� ���)
select to_char(to_date('20100107232215','yyyymmddhh24miss'), 'yyyy"��" mm"��" dd"��" hh24"��" mi"��" ss"��"') from dual;

/* *************************************
�Լ� - null ���� �Լ� 
NVL(ex1, ex2) - ex1�� ���̸� ex2, �ƴϸ� ex1.
NVL2(expr, nn, null) - expr�� null�� �ƴϸ� nn, ���̸� ����°
nullif(ex1, ex2) ���� ������ null, �ٸ��� ex1
coalesce(ex1, ex2, ex3....) ex1 ~ exn �� null�� �ƴ� ù��° �� ��ȯ.
************************************* */

select nvl2(10, 1, 0), nvl2(null, 1, 0) from dual;
select nullif(10, 10), nullif(20, 10) from dual;
select coalesce(null, 10, 20, null) from dual;
            --�� �÷��� Ÿ���� ��� ���ƾ� �Ѵ�.
            
-- EMP ���̺��� ���� ID(emp_id), �̸�(emp_name), �޿�(salary), Ŀ�̼Ǻ���(comm_pct)�� ��ȸ. �� Ŀ�̼Ǻ����� NULL�� ������ 0�� ��µǵ��� �Ѵ�..
select emp_id, emp_name, salary, nvl(comm_pct, 0) comm_pct from emp;

--TODO: EMP ���̺��� ������ ID(emp_id), �̸�(emp_name), ����(job), �μ�(dept_name)�� ��ȸ. �μ��� ���� ��� '�μ��̹�ġ'�� ���.
select emp_id, emp_name, job, nvl(dept_name, '�μ��̹�ġ') dept_name from emp;

--TODO: EMP ���̺��� ������ ID(emp_id), �̸�(emp_name), �޿�(salary), Ŀ�̼� (salary * comm_pct)�� ��ȸ. Ŀ�̼��� ���� ������ 0�� ��ȸ�ǵ��� �Ѵ�.
select emp_id, emp_name, salary, nvl(salary * comm_pct, 0) from emp;


/* *************************************
DECODE�Լ��� CASE ��
decode(�÷�, [�񱳰�, ��°�, ...] , [else���]) 

case�� �����
case �÷� when �񱳰� then ��°�
              [when �񱳰� then ��°�]
              [else ��°�]
              end
              
case�� ���ǹ�
case when ���� then ��°�
       [when ���� then ��°�]
       [else ��°�]
       end
************************************* */
select decode(dept_name, null, '�μ�����') from emp where dept_name is null;
select case when dept_name is null then '�μ�����' end 
from emp where dept_name is null;

--EMP���̺��� �޿��� �޿��� ����� ��ȸ�ϴµ� �޿� ����� 10000�̻��̸� '1���', 10000�̸��̸� '2���' ���� �������� ��ȸ
select salary, case when salary >= 10000 then '1���'
                    else '2���'
                    end �޿����
from emp;


--TODO: EMP ���̺��� ����(job)�� 'AD_PRES'�ų� 'FI_ACCOUNT'�ų� 'PU_CLERK'�� �������� ID(emp_id), �̸�(emp_name), ����(job)�� ��ȸ. 
-- ����(job)�� 'AD_PRES'�� '��ǥ', 'FI_ACCOUNT'�� 'ȸ��', 'PU_CLERK'�� ��� '����'�� ��µǵ��� ��ȸ
select emp_id, emp_name, decode(job, 'AD_PRES', '��ǥ', 
                                      'FI_ACCOUNT', 'ȸ��', 
                                      'PU_CLERK', '����') job2
from emp
where job in ('AD_PRES', 'FI_ACCOUNT', 'PU_CLERK');

select emp_id, emp_name, case job when 'AD_PRES' then '��ǥ'
                                  when 'FI_ACCOUNT' then 'ȸ��'
                                  when 'PU_CLERK' then '����'
                                  end job2
from emp
where job in ('AD_PRES', 'FI_ACCOUNT', 'PU_CLERK');

--TODO: EMP ���̺��� �μ��̸�(dept_name)�� �޿� �λ���� ��ȸ. �޿� �λ���� �μ��̸��� 'IT' �̸� �޿�(salary)�� 10%��
--      'Shipping' �̸� �޿�(salary)�� 20%�� 'Finance'�̸� 30%�� �������� 0�� ���
-- decode �� case���� �̿��� ��ȸ
select dept_name,
       salary * decode(dept_name, 'IT', 0.1, 'Shipping', 0.2, 'Finance', 0.3, 0) �޿��λ��
from emp;

select dept_name,
       salary * case dept_name when 'IT' then 0.1
                      when 'Shipping' then 0.2
                      when 'Finance' then 0.3 
                      else 0 end �޿��λ��
from emp;     

--TODO: EMP ���̺��� ������ ID(emp_id), �̸�(emp_name), �޿�(salary), �λ�� �޿��� ��ȸ�Ѵ�. 
--�� �޿� �λ����� �޿��� 5000 �̸��� 30%, 5000�̻� 10000 �̸��� 20% 10000 �̻��� 10% �� �Ѵ�.
select emp_id, emp_name, salary, 
       salary * case when salary < 5000 then 1.3 
                     when salary >= 5000 and salary < 10000 then 1.2
                     else 1.1
                     end �λ�޿�
from emp;

--decode()/case �� �̿��� ����
-- �������� ��� ������ ��ȸ�Ѵ�. �� ������ ����(job)�� 'ST_CLERK', 'IT_PROG', 'PU_CLERK', 'SA_MAN' ������� ������������ �Ѵ�. (������ JOB�� �������)
select *
from emp
order by decode(job, 'ST_CLERK', 1, 
                     'IT_PROG', 2, 
                     'PU_CLERK', 3, 
                     'SA_MAN', 4, 9999), salary desc;