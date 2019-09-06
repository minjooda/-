/* **********************
����� ���� ����
*********************** */
/* *****************************************
����� ���� ��ȸ
- ������ ����(SYSTEM, SYS)�� dba_users �� ��ȸ
- ������ ����� ���� ��ȸ: user_users �� ���
****************************************** */
-- ����� ���� ��ȸ
select * from dba_users;
select * from user_users;
select * from user_views;
select * from dba_views;


/* ************************************
- ����� ���� ����
 ����
 CREATE USER ������ IDENTIFIED BY �н����� 
 [DEFAULT TABLESPACE ���̺����̽��̸�]  		--������� �⺻ ���̺����̽� ����. ���̺� ������ ���� �������� ������ �� ���̺� �����̽��� ����Ѵ�.
 [TEMPORARY TABLESPACE ���̺����̽��̸�] 		-- ������� �ӽ����̺����̽� ����
 [QUOTA SIZE|UNLIMITED ON ���̺����̽��̸�]  --���̺����̽����� ����ڰ� ����� ������ ���Ѱ�. ���� K|M, unlimited ������
 [PASSWORD EXPIRE]                         		        --������ �н����带 �����Ų ���·� ����. ����� �α��ν� �н����带 ����ϰ� �Ѵ�.
 [ACCOUNT LOC/UNLOCK]                      		    --����� ������ ��װų� Ǭ���·� ����(�⺻��: UNLOCK)
 
************************************ */
-- ����� ���� ����- username: test_user, password: 1111, users ���̺����̽� 10M ���
create user test_user identified by 1111
quota 10m on users
quota 10m on system;

grant create session, create table to test_user;

drop user a_user;
create user a_user identified by 1111
default tablespace users
quota unlimited on users --users ���̺����̽��� ����� �� �ִ�.
quota 10m on system --system ���̺����̽��� ����� �� �ִ�.
password expire; --��ȣ����


grant create session, create table to a_user;

select * from dba_tablespaces;
--Guide: ������ sqlplus���� �غ���. 

/* ************************************
����� ���� ����
ALTER USER ������ ������ �׸�
************************************** */

-- �н����� ����
-- ALTER USER ������ INDENTIFIED BY ���н�����
alter user a_user indentified by oracle;


-- ����� �н����� ����(expire)/���� ��ױ�(lock) : ������ ������ ����
-- ����: ����ڰ� �α��ν� ���ο� �н����带 �Է¹޴´�.
-- ��ױ�: ����� �����Ѵ�. �����ڰ� Ǯ���� �� ���� �α����� �ȵȴ�.

-- �н����� ����
alter user a_user password expire;

 
-- ���� ��ױ�(lock)
alter user a_user account lock;
  
-- ��� Ǯ��(unlock)
alter user a_user account unlock;
  
  
/* ************************************
- ����� ����
 ����
 DROP USER ������ [CASCADE]
 - CASCADE : �����Ϸ��� ������ ��ü(TABLE��)�� �����ϴ� ��� ���� ��ü�� ���� ���� �Ѵ�. --GUIDE: ���̺���� ������ DROP �ȵȴ� CASCADE �ɼ������.
************************************ */

-- test_user ���� ����
drop user a_user cascade;


/* **********************
����� ���Ѱ� ��
- ���� : Ư���� �۾��� ������ �� �ִ� ����(�Ǹ�)
- ��(Role): �������� ������ ��� �� ��.

����� ���� ����
- ����ڰ� �����ͺ��̽��� ���õǾ� � ���� �� ���ִ����� �����ϴ� ��.
- ����
 GRANT �������� TO ��� [ WITH ADMIN OPTION]
    - �������� 
         - ���� ������ �ѹ��� �ٶ��� , �� �����ڷ� �ؼ� �����Ѵ�.
         -  ALL PRIVILEGES: ��� ������ �� �ش�.
    - ���
        - ����ڰ�����
        - ROLE
        - PUBLIC : ������ ��� ����ڿ��� ������ �ο��Ѵ�.
    - WITH ADMIN OPTION �� �����ϸ� �ο����� ������ �ٸ� ����ڿ��� �ο��� �� �ִ�. 

- ������ �ΰ���
  - �ý��� ����: �����ͺ��̽� �۾��� ���õ� ����
  - ��ü(object)����: ����ڰ� �ٸ�����ڰ� ������ Ư�� ��ü(ex: ���̺�)�� ����, ������ �� �ִ� ����
- �ֿ� �ý��۱��� - ������ �������� �ش�.
Guide: (create �ϸ� drop, alter ���ѵ� �����.)
    - CREATE SESSION : DB ����(CONNECT) ����
    - CREATE TABLE : ���̺� ��������
    - CREATE PROCEDURE : ���ν��� ��������
    - CREATE VIEW : VIEW ��������
    - CREATE TRIGGER: Ʈ���� ���� ����
    - CREATE TYPE : ���ڵ�, �÷��ǵ� Ÿ�� ��������
    - GREATE SEQUENCE : ������ ���� ����
- ��ü ����
    - ����ڰ� ������ Ư����ü(���̺�, ��, ������, ���ν���)�� �ٸ� ����ڰ� �����ϰų� ������ �� �ִ� ����.
    - ��ü�� ������(������)�� ��ü�� ���� ��� ������ ��������.
    - ��ü �����ڷ� �α����� �� �ٸ� ����ڿ��� ������ �ش�. 
    - ��ü�� ���� ��ɾ� ����
        - ALTER : ���̺�, ������
        - INSERT : ���̺�, ��
        - DELETE : ���̺�, ��
        - UPDATE: ���̺�, ��
        - SELECT : ���̺�, ��, ������
        - EXECUTE : ���ν���
     - ���� : GRANT ��ɾ� ON ���̺� TO �����_����;
 
-- ���� ȸ��(���� )
REVOKE �ο��� ���� FROM �����_����;
*********************** */
-- test_user ���� ����.
drop user test_user;
create user test_user identified by 1111
quota 10m on users;
-- test_user ����ڿ��� ����, ���̺� ����, ������ ������ ������ �ο�
grant create session, create table, create sequence to test_user;

alter user test_user default tablespace users;

-- SCOTT_JOIN �������� test_user �������� EMP ���̺��� SELECT ������ �ش�.
grant select, insert on emp to test_user;

--�ٸ� ������ ��ü(���̺�)�� ���� - ������.���̺��
select * from scott_join.emp;
insert into scott_join.emp values (220, 'Daven', 'AD_VP', null, sysdate, 5000, null, 90);


-- SCOTT_JOIN �������� test_user �������� DEPT ���̺��� DELETE, SELECT ������ �ش�.
grant select, delete on dept to test_user;



--SCOTT_JOIN�������� test_user �������� �� dept ���̺� select ������ ȸ���Ѵ�..
revoke select on emp from test_user;



-- test_user ������ �ý��� ���� �� ���̺����, ������ ���� ������ ȸ���Ѵ�.
revoke create table, create sequence from test_user;


/* **********************
����� ROLE ����
- ����Ŭ���� ������� ���ѵ��� Ư�� ������ ���� ���� ���� ROLE�� ����. 

-- ����Ŭ ���� ROLE
  - CONNECT: �����ͺ��̽� ���Ӱ� ���õ� ������ ���� ���� ROLE
  - RESOURCE: ����Ŭ �����ͺ��̽� �⺻ ��ü(���̺�, ��, �ε���, ���ν���, ������)�� ����, ����, ������ �� �ִ� ������ ������� ROLE
  - DBA : ����Ŭ �����ͺ��̽��� �����ϱ� ���� 124���� ������ ���� ���� ROLE
  - SYSDBA: �����ͺ��̽� ����/����/������ ���� ROLE
  - SYSOPER : SYSDBA���Ѱ� �����ͺ��̽��� ������ �� �ִ� ROLE
  
- ����ڿ��� ROLE �ο�
 GRANT ROLE TO ����ڰ���;
 - ������� ROLE öȸ
 REVOKE ROLE FROM ����ڰ���;
 
- ROLE ����
1. ROLE ����
	- CREATE ROLE ROLE�̸� 
2. ROLE�� ���� �ο�
	- GRANT ���� TO ROLE�̸�
3. ����ڿ��� ROLE ����
	- GRANT ROLE�̸� TO ������ [, ..]


*********************** */
create user test_user2 identified by 1111;
alter user test_user2 default tablespace users quota 10m on users;
--role
create role manager_role; --  role ����.
grant create session, create table, create view to manager_role; --role�� ������ ��´�.

grant manager_role to test_user2;



/*
TODO
1. ����� ���� ����
    - username/password�� �˾Ƽ� ����.
    - �⺻ ���̺����̽��� users ����
    - users ���̺� �����̽����� 10m�� ����ϵ��� ����
    
2. 1���� ������ ����ڿ��� DB ����, ���̺� ���� ���� �ο�

3. 1���� ������ �������� ���� Ȯ��.

4. 1���� ������ ������� �н����� ����

5. ����� �н������ ���� Ȯ��

6. ���̺� ���� Ȯ���Ѵ�.

7. ������ �������� �����ؼ� 1���� ������ ������ ���̺� ���� ���� ���� 

8. 1���� ������ ������ ������ �� ���̺� ������ �Ǵ��� Ȯ���Ѵ�.

9. ������ �������� 1���� ������ ���� ����
*/
create user test_user3 identified by 1111
default tablespace users
quota 10m on users;

grant create session, create table to test_user3;
alter user test_user3 identified by oracle;

revoke create table from test_user3;

drop user test_user3 cascade;
/*
TODO
1. ���̺����̽� ����
    - �̸� : hr_tbs
    - ���������� : ���/hr_tbs1.dbf  , size : 50m

2. 1���� ������ ���̺����̽��� ���������� �߰�
    - ����������:  ���/hr_tbs2.dbf,  size: 50m 
    
3.  ����� ���� ����
    - username/password�� �˾Ƽ� ����.
    - �⺻ ���̺����̽��� hr_tbs ����
    - hr_tbs ���̺����̽����� �뷮�� ���������� ����ϵ��� ����.
    - �н������ ����� ���·� �����ؼ� ó�����ӽ� �н����带 �Է��ϵ��� �Ѵ�.
    
4. ROLE ����
    - �̸� : director_role
    - ���� : ����, ���̺����, �����, ������ ����

5. 3���� ������ ����ڿ��� 4���� ������ ROLE�� �ο��Ѵ�.

6. 3���� ������ �������� ������ ���̺�, ��, �������� �����ؼ� ������ �ο��Ǿ����� üũ�Ѵ�.

7. SCOTT_JOIN ���� �����ؼ� 3���� ������ �������� EMP ���̺� ���� ��ȸ ������ �ο��Ѵ�.

8 3���� ������ �������� ������ SCOTT_JOIN�� EMP ���̺��� ��ȸ�Ѵ�.



*/
create tablespace hr_tbs
datafile 'C:\oraclexe\app\oracle\oradata\XE\hr_tbs2.dbf' size 50m;

alter tablespace hr_tbs add datafile 'C:\oraclexe\app\oracle\oradata\XE\hr_tbs1.dbf' size 50m;

select * from dba_data_files;

create user test_user4 identified by 1111
default tablespace hr_tbs
quota unlimited on hr_tbs
password expire;

create role director_role;
grant create session, create table, create view, create sequence to director_role;
grant director_role to test_user4;

grant select on emp to test_user4;
