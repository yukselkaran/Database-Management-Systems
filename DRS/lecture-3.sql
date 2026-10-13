--------------------------
--CHAPTER 1 
--------------------------

drop table employee cascade constraints;
drop table qualification cascade constraints;
drop table emplevel cascade constraints;
drop table dependent cascade constraints;
drop table dept cascade constraints;
drop table position cascade constraints;

create table qualification (
    qualid number(3) primary key,
    qualdesc varchar2(20)
);

create table position (
    positionid number(3) primary key,
    positiondesc varchar2(20)
);

create table emplevel (
    levelno number(3) primary key,
    lowsalary number(6),
    highsalary number(6)
);

create table dept (
    deptid number(3) primary key,
    deptname varchar2(20),
    location varchar2(20),
    employeeid number(5)
);

create table employee (
    employeeid number(5) primary key,
    lname varchar2(20) not null,
    fname varchar2(20) not null,
    positionid number(3) references position(positionid),
    supervisor number(5) references employee(employeeid),
    hiredate date,
    salary number(6),
    commission number(6),
    deptid number(3) references dept(deptid),
    qualid number(3) references qualification(qualid)
);

create table dependent (
    employeeid number(5),
    dependentid number(3),
    depdob date,
    relation varchar2(20),
    constraint dependent_pk primary key(dependentid, employeeid),
    constraint dependent_empid_fk foreign key(employeeid) references employee(employeeid)
);

alter table dept add constraint dept_fk foreign key(employeeid) references employee(employeeid);

-----------------------------
--CHAPTER 2 
-----------------------------

insert into position values (1, 'president');
insert into position values (2, 'manager');
insert into position values (3, 'programmer');
insert into position values (4, 'accountant');
insert into position values (5, 'salesman');

insert into emplevel values (1, 1, 25000);
insert into emplevel values (2, 25001, 50000);
insert into emplevel values (3, 50001, 100000);
insert into emplevel values (4, 100001, 500000);

insert into qualification values (1, 'doctorate');
insert into qualification values (2, 'masters');
insert into qualification values (3, 'bachelors');
insert into qualification values (4, 'associates');
insert into qualification values (5, 'high school');

insert into dept values (10, 'finance', 'charlotte', null);
insert into dept values (20, 'infosys', 'new york', null);
insert into dept values (30, 'sales', 'woodbridge', null);
insert into dept values (40, 'marketing', 'los angeles', null);

insert into employee values (
    111, 'smith', 'john', 1, null,
    to_date('04/17/1995', 'mm/dd/yyyy'), 265000, 35000, 10, 1
);

insert into employee values (
    543, 'dev', 'derek', 2, 111,
    to_date('03/15/2010', 'mm/dd/yyyy'), 80000, 20000, 20, 1
);

insert into employee values (
    246, 'houston', 'larry', 2, 111,
    to_date('05/19/1997', 'mm/dd/yyyy'), 150000, 10000, 40, 2
);

insert into employee values (
    123, 'roberts', 'sandi', 2, 111,
    to_date('12/01/2006', 'mm/dd/yyyy'), 75000, null, 10, 2
);

insert into employee values (
    433, 'mccall', 'alex', 3, 543,
    to_date('05/10/2012', 'mm/dd/yyyy'), 66500, null, 20, 4
);

insert into employee values (
    135, 'garner', 'stanley', 2, 111,
    to_date('06/29/2011', 'mm/dd/yyyy'), 45000, 5000, 30, 5
);

insert into employee values (
    200, 'shaw', 'jinku', 5, 135,
    to_date('01/02/2015', 'mm/dd/yyyy'), 24500, 3000, 30, null
);

insert into employee values (
    222, 'chen', 'sunny', 4, 123,
    to_date('08/15/2014', 'mm/dd/yyyy'), 35000, null, 10, 3
);

insert into dependent values (
    543, 1, to_date('09/28/1958', 'mm/dd/yyyy'), 'spouse'
);

insert into dependent values (
    543, 2, to_date('10/14/1988', 'mm/dd/yyyy'), 'son'
);

insert into dependent values (
    200, 1, to_date('06/10/1976', 'mm/dd/yyyy'), 'spouse'
);

insert into dependent values (
    222, 1, to_date('02/04/1975', 'mm/dd/yyyy'), 'spouse'
);

update dept set employeeid = 123 where deptid = 10;
update dept set employeeid = 543 where deptid = 20;
update dept set employeeid = 135 where deptid = 30;
update dept set employeeid = 246 where deptid = 40;
--------------------------
--CHAPTER 3 
--------------------------

select lname as "last name", fname as "first name" from employee;

select lname, fname, salary from employee where salary < 50000;
