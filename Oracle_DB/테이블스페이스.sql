
/* ******************************************************************
���̺� �����̽� ��ȸ

- ��� ���̺����̽� Ȯ��
�ý��� ��������  dba_data_files �Ǵ� dba_tablespaces �並 �̿��� ��ȸ
- ���� ������ ������ default tablespace Ȯ��
	- user_users ���� default_tablespace �÷��� �̿��� ��ȸ
******************************************************************* */
--���� ������� default ���̺����̽� ��ȸ.
select * from user_users;
select * from tabs; --���� ����� ������ ���̺� ���� ��ȸ.

select * from dba_data_files; --system �������� ����.
select * from dba_tablespaces;




/* ***********************************************
���̺� �����̽� ����

create tablespace ���̺����̽��̸�
datafile '���̺����̽��� ����� data������ ���'
size ����ũ��  --k|m  Ű�ι���Ʈ, �ް�����Ʈ
[autoextend on next Ȯ��� ũ��] --G: ������ ���� ����
[maxsize �ִ�����ũ��] --������ �ִ������ ��������
[
default storage(
  initial 10K --���̺����̽��� ù��° extends ũ��
  next  10K -- ���� extends�� ũ��
  minextents 2 --������ extent �� �ּҰ�
  maxextents 50 -- ������ extent�� �ִ밳��
  pctincrease 50 -- extents ������
)
]
*********************************************** */
--system
create tablespace my_tbs
datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf' size 10m;

--scott_join
create table test_tbs(
    txt varchar2(1000)
)tablespace my_tbs;

select * from tabs where table_name = 'TEST_TBS';

begin 
    for i in 1..50000
    loop
        insert into test_tbs values (i||'��° ����');
    end loop;
    commit;
end;
/
select * from test_tbs;

--system
--���̺����̽��� ������ ����
--1. data file�� �߰�.
alter tablespace my_tbs add datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs2.dbf' size 20m;
select * from dba_data_files;
--2. datafile�� ũ��(size)�� �ڵ����� �þ���� ����.
alter database datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf' autoextend on next 10m; --10m�� �ڵ� ����.
--3. data file�� ũ��(size)�� �ø���.
alter database datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf'
resize 20m;


/* *********************************
���̺� �����̽� ����
drop tablesapce ���̺����̽��̸� [�ɼ�]
- �ɼ�
	- including contents [and datafiles] : �����Ͱ� �̹� ��� �ִ� ��� ������ ������ ��� ����. �����Ͱ� �ִ� ��� �� �ɼ��� �ݵ�� ��� �Ѵ�. 
										   and datafiles�� �߰��ϸ� ���̺����̽��� ����ϴ� ���������ϵ� ���� ��ũ���� �����Ѵ�.
	- cascade constraints: ���̺����̽����� ���̺��� primary key�� �����ϴ� foreign key ������ ��� �����ϰ� ���̺����̽��� �����Ѵ�.
********************************* */
drop tablespace my_tbs including contents and datafiles cascade constraints;
select * from dba_data_files;

