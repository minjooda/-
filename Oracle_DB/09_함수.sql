/* ***************************************************************************************
�Լ� (FUNCTION)
- �̸� �����ϵǾ� ���� ������ ��ü�� SQL�� �Ǵ� PL/SQL�� ������ ȣ��Ǿ� ���Ǵ� �������α׷�.
- ȣ���ڷ� ���� �Ķ���� ���� �Է� �޾� ó���ѵ� �� ����� ȣ���ڿ��� ��ȯ�Ѵ�. 
	- �Ķ���ʹ� �� ���� �� �� �ִ�.
- ��Ʈ�� �Լ�
	- ����Ŭ���� �����ϴ� �����Լ�
- ����� ���� �Լ��̸�	
	- ����� �����Լ�
	
- ����� ���� �Լ� ����
	CREATE [OR REPLACE] FUNCTION �Լ��̸� [(�Ķ����1, �Ķ����2, ..)]
		RETURN datatype
	IS
		-- �����: ����, ����� ����
	BEGIN
		-- ���� �� : ó������
		RETURN value;
	[EXCETPION]
		-- ����ó�� ��
	END;
	
	
	- RETURN ��ȯ������Ÿ��
		- ȣ���ڿ��� ������ ��ȯ���� Ÿ�� ����
		- char/varchar2 �� number�� ��� size�� �������� �ʴ´�.
		- ���� �ο��� `return ��` ������ �̿��� ó������� ��ȯ�Ѵ�.
	- �Ķ���� 
		- ���� : 0 ~ N��
		- IN ��常 ����. 
		- ����
			������ ������Ÿ�� [:=�⺻��]
		- �⺻���� ���� �Ű��������� ȣ���ڿ��� �ݵ�� ���� �����ؾ� �Ѵ�.
		
	
�Լ� ����
DROP FUNCTION �Լ���;
*************************************************************************************** */

-- �Ű����� ���� �Լ� ���� �� ȣ��



--�Ű������� 1�� �ִ� �Լ�




--�⺻���� �ִ� �Ű������� ���� �Լ�




--�Ű������� �������� �Լ�



  

--  emp_id�� �޾Ƽ� �� ������ Ŀ�̼�(salary * comm_pct)�� ���� ��ȯ�ϴ� �Լ� 





-- TODO: �Ű������� ���� �ΰ��� �޾� ���� ����� �Ҽ��� ���� �κи� ��ȯ�ϴ� �Լ� ���� (ex: 10/4 -> 0.5 ��ȯ)
create or replace function ex01_fn(v_num1 binary_integer, v_num2 binary_integer) return binary_float
is
    v_result binary_float;
    v_temp binary_float;
begin
    v_result := v_num1 / v_num2;
    v_temp := v_result - floor(v_result);
    
    return v_temp;
end;
/

select ex01_fn(10, 4) from dual;





-- TODO: �Ű������� ���� �ΰ��� �޾Ƽ� ������ ������ ó���ϴ� �Լ� ����.  (10/4 -> 2�� ��ȯ)
-- ���������: --������ - (��� ������ * ����)
-- ex) 10/4�� ������ : 10 - (10/4������� * 4)
create or replace function ex02_fn(v_num1 binary_integer, v_num2 binary_integer) return binary_integer
is
    v_result BINARY_INTEGER;
begin
    v_result := mod(v_num1, v_num2);
    return v_result;
end;
/

select ex02_fn(10, 4) from dual;




-- TODO: 1. �Ű������� ��� ID�� �޾Ƽ� �ڽ��� �޿��� �ڽ��� ���� �μ��� ��ձ޿� �̻��̸� TRUE�� �̸��̸� FALSE�� ��ȯ�ϴ� �Լ� �ۼ�. ��ȸ�� ����� ���� ��� NULL�� ��ȯ
--       2. ���� �Լ��� ȣ���ϴ� �͸� ���ν������� �ۼ�.
--			�Լ��� ȣ���Ͽ� ��ȯ�Ǵ� boolean ����
--				TRUE�̸� '������ �޿��� �μ���� �̻�' �� FALSE�̸� '������ �޿��� �μ���� �̸�' �� NULL�̸� '���� ����' �� ����Ѵ�.


CREATE OR REPLACE FUNCTION todo_03_fn(p_emp_id emp.emp_id%TYPE)
    RETURN boolean
IS  
    v_cnt binary_integer;
    
    v_salary emp.salary%type;
    v_dept_id emp.dept_id%type;
	
	v_avg_salary emp.salary%type;
    emp_null_exp EXCEPTION;
BEGIN

	-- salary �� �μ� id�� ��ȸ
	select salary, dept_id
    into v_salary, v_dept_id
    from emp
    where emp_id = p_emp_id;
    
    select count(*)
    into v_cnt
    from emp
    where emp_id = p_emp_id;
    
    if v_cnt = 0 then
        raise emp_null_exp;
    end if;
    
	-- �μ��� ��� �޿��� ��ȸ
    select avg(salary)
    into v_avg_salary
    from emp
    where v_dept_id = dept_id;
	-- ������ salary�� �μ� ��ձ޿��� ���ؼ� boolean ���� ��ȯ
    if v_salary >= v_avg_salary then
        return TRUE;
    else return FALSE;
    end if;
	
EXCEPTION
    -- ��ȸ ������ ������ null�� ��ȯ
    when emp_null_exp then
        return null;
END;
/

select todo_03_fn(emp_id) from emp;

-- 170(�̻�) 180(����) 
-- ------���� �Լ� ����ϴ� ���ν���. ---------
DECLARE
    v_result boolean;
BEGIN
   v_result := todo_03_fn(180);
   if v_result = TRUE then
        dbms_output.put_line('������ �޿��� �μ���� �̻�');
    elsif v_result = FALSE then
        dbms_output.put_line('������ �޿��� �μ���� �̸�');
    else 
        dbms_output.put_line('���� ����');
    end if;
   
   
   
END;
/
--Ȯ�� sql��
select salary from emp where emp_id = 170;
select avg(salary) from emp where dept_id = (select dept_id from emp where emp_id = 170);






--TODO �Ű������� 5���� 'y' �Ǵ� 'n'�� �޾Ƽ� ���° �Ű������� y������ �ϳ��� ���ڿ��� ��� ��ȯ�ϴ� �Լ� ����.
-- select todo_03_fn('y','n', 'n', 'y', 'y') from dual;  => 1, 4, 5

create or replace function todo_04_fn (  �Ű����� ���� ) 
    return varchar2
is  
    v_return varchar2(100); -- ������� ���ڿ��� ������ ����.

begin  
    
    --p_yn1 ó��: y �̸� v_return ���ڿ��� ����.
    
	
    
    --p_yn2 ó��
    
	
	
    
     --p_yn3 ó��
    
	
	
     --p_yn4 ó��
	 
	 
	 
	 
     --p_yn5 ó��
	 
	 
	 
    
    -- ����� ��ȯ

end;
/
select todo_04_fn('y','y', 'n', 'y', 'n') from dual;
select todo_04_fn('n','n', 'n', 'y', 'y') from dual;