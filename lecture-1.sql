create table qualification(
    qualId number(3),
    qualDesc varchar2(20),

    constraint qualification_qualId_pk primary key(qualId)
);

create table position(
    positionId number(3),
    positionDesc varchar2(20),
    
    constraint position_positionId_pk primary key(positionId)
);

create table emplevel(
    levelNo number(3),
    lowSalary number(6),
    highSalary number(6),

    constraint emplevel_levelNo_pk primary key(levelNo)
);

create table dept(
    deptId number(3),
    deptName varchar2(20),
    location varchar2(20),
    employeeId number(5),

    constraint dept_deptId_pk primary key(deptId)
);

create table employee(
    employeeId number(5),
    lname varchar2(20) constraint employee_lname_nn not null,
    fname varchar2(20) constraint employee_fname_nn not null,
    positionId number(3),
    supervisor number(5),
    hiredate date,
    salary number(6),
    commission number(6),
    deptId number(3),
    qualId number(3),

    constraint employee_employeeId_pk primary key(employeeId),

    constraint employee_positionId_fk foreign key(positionId)
    references position(positionId),

    constraint employee_supervisor_fk foreign key(supervisor)
    references employee(employeeId),

    constraint employee_deptId_fk foreign key(deptId)
    references dept(deptId),

    constraint employee_qualId_fk foreign key(qualId)
    references qualification(qualId)
);

alter table dept
add constraint dept_employeeId_fk foreign key(employeeId)
references employee(employeeId);

create table dependent(
    employeeId number(5),
    dependentId number(3),
    depDob date,
    relation varchar2(20),
    
    constraint dependent_employeeId_dependentId_pk primary key(employeeId, dependentId),

    constraint dependent_employeeId_fk foreign key(employeeId)
    references employee(employeeId)
);