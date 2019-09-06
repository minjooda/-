/* ***************************************************************************************************************
����ó��
 - ���๮���� �߻��� ����(����)�� ó���Ͽ� ���ν����� ���������� �����ϵ��� �ϴ� ����.
 - ���� ����
	- ����Ŭ ����
		- �ڵ尡 Ʋ���� �߻��ϴ� ����
	- ����� ���� 
		- ����� �ڵ忡�� �߻���Ų ����.
		- ���� ��Ģ�� ��� ��� �߻���Ų��.
- EXCEPTION ���� ó�� ������ �ۼ�
	- ���� �� ������ �ۼ��Ѵ�.
 - ����
  EXCEPTION
    WHEN �����̸�1 THEN
        ó������
    WHEN �����̸�2 THEN
        ó������
	[WHEN OTHERS THEN
		ó������ ]
 
*************************************************************************************************************** */

--����Ŭ �����ڵ� ��ȸ: https://docs.oracle.com/pls/db92/db92.error_search?remark=homepage&prefill=ORA
set serveroutput on;

declare
    v_emp_name   emp.emp_name%type;
    v_cnt binary_integer;
begin
    v_cnt := 10/0;
    
    select emp_name     into   v_emp_name     from   emp;
    
    dbms_output.put_line(v_emp_name);
--exception
----    when too_many_rows then
----        dbms_output.put_line('�ʹ� ���� ���� ��ȸ�Ǿ���');
----    when zero_divide then
----        dbms_output.put_line('0���� ������');
--    when others then
--        dbms_output.put_line('������ ���� ���� ó��');
end;
/



insert into dept values (100, 'a','b');


/* ***************************************************************************************************************
- ����Ŭ ������ ���ܸ� ����

- ���ܸ��� ���ǵ��� ���� ����Ŭ ����
    - �����ڵ�� ������ �����̸��� ���� ����Ŭ ���� ����

 - ����
 1. �����̸� ����
    �����̸� EXCEPTION;
 2. �����̸��� ����Ŭ�����ڵ� ����
    PRAGMA EXCEPTION_INIT (�����̸�, �����ڵ�) 
    - �����ڵ�� ������ ���δ�. (-01400)
*************************************************************************************************************** */
-- �̸� ���ǵ��� ���� ���� �̸� ���̱� (null �� INSERT �߻� ������ �̸� ���̱�)
insert into dept values(850, null, null);
--ORA-01400: cannot insert NULL into ("SCOTT_JOIN"."DEPT"."DEPT_NAME")
desc dept;
declare
    --1. ����(exception) �̸� ����
    ex_null exception;
    --2. 1���� ������ �����̸��� ����Ŭ �����ڵ带 ����.
    pragma exception_init(ex_null, -01400);
    -- ORA-01400 ������ �߻��ϸ� ex_null�̶� �̸����� ���� ó���Ѵ�.
begin
    insert into dept values(850, null, null);
exception
    when  ex_null then
        dbms_output.put_line('NULL�� ���� �� �����ϴ�.');
end;
/

--TODO: �μ����̺���(DEPT) �μ�_ID�� 100�� �μ��� �����ϴ� �ڵ� �ۼ�.
--      100�� �μ��� EMP���� �����ϹǷ� 'ORA-02292: integrity constraint (SCOTT.FK_EMP_DEPT) violated - child record found' ����Ŭ ���� �߻��Ѵ�.
--      �߻��ϴ� ������ �����̸��� ����� EXCEPTION ��Ͽ��� ó���ϴ� �ڵ带 �ۼ��Ͻÿ�.

--declare 
create or replace procedure del_dept_sp(p_dept_id   dept.dept_id%type)
is
    ex_fk_violate exception;
    pragma exception_init(ex_fk_violate, -02292);
begin
    delete from dept where dept_id = p_dept_id;
    dbms_output.put_line('���� �Ǿ����ϴ�. ���� �۾� ����');
    commit;
exception
    when ex_fk_violate then
        dbms_output.put_line('���� �����Ͱ� �־ ���� �� �� �����ϴ�.');
end;
/
exec del_dept_sp(9900);
exec del_dept_sp(100);

select * from dept order by 1 desc;

/* ***************************************************************************************************************
���� �߻���Ű��
 - �����̸� ����
 
 - RAISE �����̸�
*************************************************************************************************************** */
--������ �μ� ID�� ������ ���� �߻���Ű��
declare
    v_id binary_integer:=3000`;
    v_cnt binary_integer;
    
    ex_not_found exception;
begin
    select count(*) into v_cnt from dept where dept_id = v_id;
    if  v_cnt = 0 then --������ �μ��� ����. -> ���ܹ߻�
        raise ex_not_found;
    end if;
    delete from dept where dept_id = v_id;
    dbms_output.put_line('���� �Ϸ�');
exception
    when ex_not_found then
        dbms_output.put_line('������ �μ��� �����ϴ�. �α� ���̺� insert');
end;
/
select count(*)  from dept where dept_id = ;
select * from dept order by 1 desc;


--TODO: EMP_ID�� 832���� ������ �̸��� UPDATE�ϴµ� 
--832���� ������ ���� ��� ����� ���� ���ܸ� ����� �߻� ��Ű�ÿ�.
declare
    ex_not_found exception;
    v_cnt binary_integer;
    v_emp_id emp.emp_id%type := &e_id;--������ emp_id
begin
    select count(*) into v_cnt
    from   emp where emp_id = v_emp_id;
    
    if v_cnt = 0 then
        raise ex_not_found;
    end if;
    
    update  emp
    set     emp_name = emp_name
    where   emp_id = v_emp_id;
    commit;
exception
    when  ex_not_found then
        dbms_output.put_line('���� id�� �����̹Ƿ� ������ �ȵǾ����ϴ�.');
end;
/

declare
    ex_not_found exception;
--    v_cnt binary_integer;
    v_emp_id emp.emp_id%type := &e_id;--������ emp_id
begin
--    select count(*) into v_cnt
--    from   emp where emp_id = v_emp_id;
--    
--    if v_cnt = 0 then
--        raise ex_not_found;
--    end if;
    
    --insert/delete/update ������ ���� ����� ���.
    
    update  emp
    set     emp_name = emp_name
    where   emp_id = v_emp_id;
        
    if sql%notfound then
        raise ex_not_found;
    end if;
    dbms_output.put_line('����');
    commit;
exception
    when  ex_not_found then
        dbms_output.put_line('���� id�� �����̹Ƿ� ������ �ȵǾ����ϴ�.');
        rollback; --����ο��� ���� �߻������� ó���� ������ ������Ű��.
end;
/

--TODO: �μ� ID�� �޾� �μ��� �����ϴ� ���ν��� �ۼ�
-- EMP ���̺��� �����Ϸ��� �μ��� �����ϴ� ���� �ִ��� Ȯ�� �ѵ� ������ 
--�����ϰ� ������ ��������� ���ܸ� �߻���Ų �� EXCEPTION ��Ͽ��� ó��
declare
    ex_fk_violate exception;
    v_cnt binary_integer;
    v_dept_id  dept.dept_id%type:=&d_id;
begin
    select count(*) 
    into v_cnt
    from  emp
    where dept_id = v_dept_id;
    
    if v_cnt <> 0 then
        raise ex_fk_violate;
    end if;
    
    delete from dept where dept_id = v_dept_id;
    commit;
    dbms_output.put_line('�����Ϸ�');
exception 
    when  ex_fk_violate then
        dbms_output.put_line('�����ǰ� �ִ� �μ�');
end;
/

/* ****************************************************************************************************************************************************
RAISE_APPLICATION_ERROR
���� ���� ���� ���� �ڵ�� ���ܸ޼����� �޾� ���ܸ� �߻���Ű�� ���ν���
 - RAISE_APPLICATION_ERROR(�����ڵ�, ���� �޼���)
    - �����ڵ�� -20000 ~ -20999 ������ ���ڸ� ����Ѵ�. 
**************************************************************************************************************************************************** */
declare
    ex_fk_violate exception;
    v_cnt binary_integer;
    v_dept_id  dept.dept_id%type:=&d_id;
begin
    select count(*) 
    into v_cnt
    from  emp
    where dept_id = v_dept_id;
    
    if v_cnt <> 0 then
        --raise ex_fk_violate;
        raise_application_error(-20001, v_dept_id||'�� �����ǰ� �ִ� �μ��̹Ƿ� ���� �ȵ�');
    end if;
    
    delete from dept where dept_id = v_dept_id;
    commit;
    dbms_output.put_line('�����Ϸ�');
exception 
    when  others then
        dbms_output.put_line(sqlcode); --����Ŭ �����ڵ带 ��ȸ: sqlcode
        dbms_output.put_line(sqlerrm); --���� �޼����� ��ȸ : sqlerrm
end;
/


--TODO: �μ� ID�� �޾� �μ��� �����ϴ� ���ν��� �ۼ�
--      EMP ���̺��� �����Ϸ��� �μ��� �����ϴ� ���� �ִ��� Ȯ�� �� �� ������ �����ϰ� ������ �����ڵ� -20100 ���� ������ �޼����� �־� ����� ���� ���ܸ� �߻���Ų�� EXCEPTION ������ ó��.



