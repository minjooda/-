/* *********************************************************************************************
PL/SQL ����
- PL/SQL �̶�
	- Oracle's Procedual Lanague extension to SQL
	- SQL�� Ȯ���Ͽ� SQL�۾��� ������ ���α׷����� �ۼ��� �� �ִ� ���α׷��� ���.
	- �ټ��� SQL���� �ѹ��� ó���� �� �־� �ϳ��� Ʈ���輱 �۾��� �ϳ��� ������� �ۼ��� ���ִ�.
	- ������ �����ϴ�.
	- ����ó���� �����Ѵ�.

********************************************************************************************* */
--�μ��� ���� �հ踦 �����ϴ� ���̺�
create table emp_sum
as
select dept_id, sum(salary) salary_num
from emp
group by dept_id;

select * from emp_sum;

--emp_id�� XXX�� ������ ����.
--emp_sum���� �޿� �հ踦 ����.
--salary_num�� ��ȸ.(10, 5000)

select * from emp_sum;
select * from emp where emp_id = 200;
--dept_id = 10, salary = 5000;
delete from emp where emp_id = 200;
--�հ� ���̺� ����.
update emp_sum 
set salary_num = salary_num - 5000 
where dept_id = 10;

rollback;

set serveroutput on; --client�� server���� ��µ� ����� �޾ƿ��ڴ�.
DECLARE
  emp_rec emp%rowtype;
  sum_rec emp_sum%rowtype;
BEGIN
  --1. 200�� ������ ���� ��ȸ 
  select * 
  into emp_rec --��ȸ�� ����� emp_rec���� �ȿ� ����.
  from emp where emp_id = 200;
  --2. 200�� ������ ����
  delete from emp where emp_id = 200;
  --3. �޿��հ� ���̺��� ����(update)
  update emp_sum
  set salary_num = salary_num - emp_rec.salary
  where dept_id = emp_rec.dept_id;
  --4. �޿��հ� ���̺��� ���� ���� ��ȸ�ؼ� ���
  select *
  into sum_rec
  from emp_sum
  where dept_id = emp_rec.dept_id;
  
  --��� : �μ�ID : 10, �޿��հ� : 0
  dbms_output.put_line('�μ�ID: '||sum_rec.dept_id);
  dbms_output.put_line('�޿��հ�: '||sum_rec.salary_num);
  rollback; --commit;
END;
/ --��������� ��������.

rollback;
select * from emp where emp_id = 200;
/* ***********************************************************************************************
PL/SQL �⺻ ���
- ����(DECLARE)
    -  ����, Ŀ��, ��������� ���� �� ����
    -  ���û���
- ���౸�����(BEGIN)
    - ȣ��Ǹ� ������ ���� �ۼ�
    - SQL��, PL/SQL ���� ���� ������ �°� ����
    - ���ǹ��̳� �ݺ��� ��밡��
    - �ʼ�
- ����ó��(EXCEPTION)
    - ���๮���� �߻��� ������ ó���ϴ� ���� �ۼ�
    - ���๮�� ���൵�� ������ �߻��ϸ� EXCEPTION ���� �̵�
    - ���û���
- ����(END;)
    -  PL/SQL ������ ���Ḧ ǥ��
    
- PL/SQL ����
    - �͸� ���ν���
		- �̸� ���� �ۼ��ϴ� PL/SQL ���
		- DATABASE�� ����Ǿ� ���� ���� �ʰ� �ʿ��� ������ �ݺ� �ۼ�, �����Ѵ�.
    - ���� ���ν���(Stored Procedure)
		- �̸��� ������ DATABASE�� ����Ǿ� �����ȴ�.
		- �̸����� ȣ���Ͽ� ������ �����ϴ�. 
		- ȣ��� ���� �޾� �� ���� ���ο��� ����� �� �ִ�.
    - �Լ�(Function)
		- ����� ���� �Լ��� ó���� ���� �ݵ�� ��ȯ�ؾ� �Ѵ�.
		- SQL������ ���� ó���ϱ� ���� ȣ���ؼ� ����Ѵ�.
		
*********************************************************************************************** */

/
-- Helloworld ����ϴ� PL/SQL
begin
    dbms_output.put_line('Hello World!');
end;
/


-- TODO: ������ ����ϴ� ���� �ۼ��Ͻÿ�.
/*
�̸� : ȫ�浿
���� : 20��
�ּ� : ����� ������ ���ﵿ
*/

begin
    dbms_output.put_line('�̸�: ȫ�浿');
    dbms_output.put_line('����: 20��');
    dbms_output.put_line('�ּ�: ����� ������ ���ﵿ');
end;
/

--conteol + space : �����ڵ��ϼ�








