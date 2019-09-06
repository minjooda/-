/* **********************************************************
���ǹ�
 - ���ǿ� ���� �����ϴ� ������ �ٸ� ��� ���.
 - IF ���� CASE�� �� �ִ�.



- IF �� ����
    - [������ 1���� ���] 
    IF ���� THEN ó������ END IF;
    
    - [���ΰ�� ������ ����� �� ����]
    IF ���� THEN ó������_1
    ELSE ó������_2
    END IF
    
    - [������ �������� �ܿ�]
    IF ����_1 THEN ó������_1
    ELSIF ����_2 THEN ó������_2
    ELSIF ����_3 THEN ó������_3
    ...
    ELSE ó������_N
    END IF
********************************************************** */    

set serveroutput on;

declare
    v_num1 binary_integer := 20;
    v_num2 binary_integer := 20;
begin
    if v_num1 > v_num2 then dbms_output.put_line('num1�� ũ��');
    elsif v_num1 = v_num2 then dbms_output.put_line('num1�� num2�� ����');
    else dbms_output.put_line('num2�� ũ��');
    end if;
end;
/


-- TODO : ���� ID�� 110 �� ������ �޿�(salary)�� ��ȸ�� �� 5000 �̸��̸� 'LOW', 5000�̻� 10000���ϸ� 'MIDDLE', 1000 �ʰ��̸� 'HIGH'�� ����Ѵ�.
DECLARE
  v_salary emp.salary%TYPE;
  v_grade varchar2(10); --����� ���� ����
BEGIN
  select salary into v_salary from emp where emp_id = 110;
  
  if v_salary < 5000 then v_grade := 'LOW';
  elsif v_salary between 5000 and 10000 then v_grade := 'MIDDLE';
  else v_grade := 'HIGH';
  end if;
  
  dbms_output.put_line(v_grade);
  
  /*if v_salary < 5000 then dbms_output.put_line('LOW');
  elsif v_salary between 5000 and 10000 then dbms_output.put_line('MIDDLE');
  else dbms_output.put_line('HIGH');
  end if;*/
END;
/

-- TODO: ���� ID�� 100 �� ������ SALARY�� COMM_PCT�� ��ȸ�Ѵ�. COMM_PCT�� NULL�� �ƴϸ� SALARY + SALARY * COMM_PCT�� ���� ����ϰ� NULL �̸� COMM_PCT�� ������ SALARY�� ����Ѵ�.
--����ID 100�� 145 �θ��� �غ���.
DECLARE
  v_salary emp.salary%TYPE;
  v_comm_pct emp.comm_pct%TYPE;
BEGIN
  SELECT salary, comm_pct
  INTO v_salary, v_comm_pct
  FROM emp
  WHERE emp_id = 145;
  
  if v_comm_pct is not null then dbms_output.put_line(v_salary + v_salary * v_comm_pct);
  else dbms_output.put_line('comm_pct����, '||v_salary);
  end if;
  
END;
/



-- TODO: emp_id�� bind������ �޾Ƽ� �� ������ Ŀ�̼��� �ִ��� ��ȸ��(emp.comm_pct) Ŀ�̼��� �ִ� �����̸�
-- commission ���̺� emp_id�� ������� �Ͻÿ� Ŀ�̼�(salary * comm_pct)�� �����Ѵ�.

--Ŀ�̼� ���� ���̺�
create table commission(
    emp_id number(6),
    curr_date date,
    commission number
);

DECLARE
  v_emp_id emp.emp_id%TYPE := :emp_id;
  v_comm_pct emp.comm_pct%TYPE;
  v_salary emp.salary%TYPE;
BEGIN
  SELECT salary, comm_pct 
  INTO v_salary, v_comm_pct 
  FROM emp
  WHERE emp_id = v_emp_id;
  
  --comm_pct�� �ְ� salary < 10000�̸��� ��
  if v_comm_pct is not null and v_salary < 10000
  then insert into commission values (v_emp_id, sysdate, v_salary * v_comm_pct);
  end if;
  
  commit;
END;
/

select * from commission;

/* ************************************************************** 
CASE �� : SQL�� CASE ���� (����)����

 [���� 1]
    CASE ǥ����
        WHEN ���1 THEN ó������_1;
        WHEN ���2 THEN ó������_2;
        ...
        ELSE ��Ÿ ó������;
    END CASE;
     
    [���� 2]
    CASE WHEN ǥ����1 THEN ó������_1;
         WHEN ǥ����2 THEN ó������_2;
         ...
         ELSE ��Ÿ ó������;
    END CASE;
************************************************************** */    

DECLARE
  v_num binary_integer := &num;
  v_result varchar2(20);
BEGIN
  case v_num when 10 then v_result := '��';
             when 20 then v_result := '�̽�';
  else v_result := '��Ÿ';
  end case;
  
  DBMS_OUTPUT.PUT_LINE(v_result);
  
END;
/


-- TODO : ���� ID�� 110 �� ������ �޿�(salary)�� ��ȸ�� �� 5000 �̸��̸� 'LOW', 5000�̻� 10000���ϸ� 'MIDDLE', 1000 �ʰ��̸� 'HIGH'�� ����Ѵ�.
-- CASE ���� �̿��� �ۼ�
DECLARE
  v_salary emp.salary%TYPE;
  v_grade varchar2(10); --����� ���� ����
BEGIN
  select salary into v_salary from emp where emp_id = 110;
  
  case when v_salary < 5000 then v_grade := 'LOW';
       when v_salary between 5000 and 10000 then v_grade := 'MIDDLE';
  else v_grade := 'HIGH';
  end case;
  
  dbms_output.put_line(v_salary||' - '||v_grade);
END;
/



/* *********************************************************************************
�ݺ���
 - Ư�� ������ �ݺ��ؼ� �����ϴ� ����
 - LOOP, WHILE, FOR ������ ������ �ִ�.
 - EXIT WHEN ����
	- �ݺ����� ���߰� �������´�.
 - CONTINUE WHEN ����
	- �ݺ����� ���Ϻκ��� �������� �ʰ� ó������ ó������ ���� �����Ѵ�.
 ********************************************************************************* */



 
 /* ************************************************************
    LOOP �� : �ܼ� �ݺ�ó��
    ����
        LOOP
            �ݺ�ó���� ����
            EXIT WHEN ��������
        END LOOP
 ************************************************************ */
-- LOOP ���� �̿��� 0 ~ 10���� �����հ� ���ϱ�
DECLARE
  v_result binary_integer := 0;
  v_num binary_integer := 0;
BEGIN
  LOOP
    v_result := v_result + v_num;
    v_num := v_num + 1;
    exit when v_num > 10;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE(v_result);
END;
/


 /* ************************************************************
 WHILE ��: ������ ��(TRUE)�� ���� �ݺ�
 ����
    WHILE �ݺ�����
    LOOP
        ó������
    END LOOP;

************************************************************  */
-- WHILE ���� �̿��� 0 ~ 10���� �����հ�
DECLARE
  v_result binary_integer := 0;
  v_num binary_integer := 0;
BEGIN
  while v_num <= 10
  loop
    v_result := v_result + v_num;
    v_num := v_num + 1;
  end loop;
  
  DBMS_OUTPUT.PUT_LINE(v_result);
END;
/


-- TODO: hello1, hello2, hello3 ... hello10�� ����ϴ� �ڵ带 �ۼ� (LOOP�� WHILE������ �ۼ�)
DECLARE
  v_num BINARY_INTEGER := 1;
BEGIN
  while v_num <= 10
  loop
    DBMS_OUTPUT.PUT_LINE('hello'||v_num);
    v_num := v_num + 1;
  end loop;
END;
/

DECLARE
  v_num BINARY_INTEGER := 1;
BEGIN
  loop
    DBMS_OUTPUT.PUT_LINE('hello'||v_num);
    v_num := v_num + 1;
    exit when v_num > 10;
  end loop;
END;
/

-- TODO: sequence t_seq2 �� ���� 20�� �ɶ� ���� ��ȸ�� ����ϴ� �ڵ带 �ۼ�. (LOOP �� WHILE������ �ۼ�)
drop sequence t_seq;
create sequence t_seq;

DECLARE
  v_num BINARY_INTEGER := t_seq.nextval;
BEGIN
  while v_num <= 20
  loop
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := t_seq.nextval;
  end loop;
END;
/

DECLARE
  v_num BINARY_INTEGER := t_seq.nextval;
BEGIN
  loop
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := t_seq.nextval;
    exit when v_num > 20;
  end loop;
END;
/
 /* ************************************************************
 FOR ��: ���� Ƚ���� �ݺ��� �� ���
 
 FOR �ε��� IN [REVERSE] �ʱ갪..������
 LOOP
    �ݺ� ó�� ����
 END LOOP;

-- �ε���: �ݺ� �ø��� 1�� �����ϴ� ��. ������ �����ϳ� ������ �ȵȴ�.
-- REVERSE : ������->�ʱ갪

************************************************************ */

-- FOR ����  �̿��� 0 ~ 10���� �����հ�
DECLARE
  v_result binary_integer := 0;
BEGIN
  for v_num in reverse 0..10
  loop
    v_result := v_result + v_num;
  end loop;
  
  DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

BEGIN
    for e_row in (select * from emp where dept_id = 10)
    loop
        dbms_output.put_line(e_row.emp_id||e_row.emp_name);  
    end loop;
END;
/

-- TODO: hello1, hello2, hello3 ... hello10�� ����ϴ� �ڵ带 �ۼ� (FOR������ �ۼ�)
BEGIN
  for v_num in 1..10
  loop
    DBMS_OUTPUT.PUT_LINE('hello'||v_num);
  end loop;
END;
/



-- TODO: sequence t_seq �� ���� 20�� �ɶ� ���� ��ȸ�� ����ϴ� �ڵ带 �ۼ�. (FOR������ �ۼ�)
BEGIN
    for i in 1..20
    loop
        dbms_output.put_line(t_seq.nextval);
    end loop;
END;
/


--TODO ������ 5���� ����ϴ� �ڵ带 �ۼ� (loop, for, while���� �ۼ�)
DECLARE
    result BINARY_INTEGER := 0;
BEGIN
    for i in 1..9
    loop
        result := 5*i;
        dbms_output.put_line('5 * '||i||' = '||result);
    end loop;
END;
/

DECLARE
    result BINARY_INTEGER := 0;
    i PLS_INTEGER := 1;
BEGIN
    loop
        result := 5*i;
        dbms_output.put_line('5 * '||i||' = '||result);
        i := i+1;
        
        exit when i > 9;
    end loop;
END;
/

DECLARE
    result BINARY_INTEGER := 0;
    i PLS_INTEGER := 1;
BEGIN
    while i <= 9
    loop
        result := 5*i;
        dbms_output.put_line('5 * '||i||' = '||result);
        i := i+1;
    
    end loop;
END;
/

--TODO 1 ~ 100 ������ ���� �߿� 5�� ����� ����ϵ��� �ۼ�. (MOD(A, B): A�� B�� ���� ������ ��ȯ �Լ�)
BEGIN
    for i in 1..100
    loop
        if mod(i, 5) = 0 then dbms_output.put_line(i);
        end if;
    end loop;
END;
/
