# DDL (Data Definition Language): Table Creation Order and Foreign Key Relationships

This document explains the order in which the tables in the schema must be created, how the `REFERENCES` clause is determined, and how to handle the case where two tables depend on each other.

DDL is the group of SQL commands that define the structure of database objects. `CREATE TABLE`, `ALTER TABLE` and `DROP TABLE` belong to this group.


## 1. Why Are Some Tables Created First?

If a table has a Foreign Key (FK), the table it points to must already exist in the database.

**Reason:** The database cannot validate the rule "this column depends on data in that table" if the target table has not been created yet. If the target table does not exist, Oracle returns this error:

```
ORA-00942: table or view does not exist
```

Therefore the order is:

1. First, the parent tables that do not depend on any other table are created: `QUALIFICATION`, `POSITION`, `EMPLEVEL`, `DEPT`
2. Then the table that references them is created: `EMPLOYEE`
3. Finally, the table that depends on `EMPLOYEE` is created: `DEPENDENT`

The `EMPLEVEL` table has no relationship with any other table, so it can be created at any point.


## 2. How Is "REFERENCES" Determined?

A Foreign Key always points to the Primary Key (PK) of another table, or of the same table. In the schema diagram, the arrow starts at the FK column and its head points to the PK column.

General pattern:

```sql
constraint constraint_name foreign key(fk_column)
    references parent_table(pk_column)
```

Relationships in the schema:

**EMPLOYEE.positionId → POSITION.positionId**
When a position is assigned to an employee, that position must already be defined in the `POSITION` table.

**EMPLOYEE.deptId → DEPT.deptId**
The department an employee belongs to must exist in the `DEPT` table.

**EMPLOYEE.qualId → QUALIFICATION.qualId**
The qualification assigned to an employee must be defined in the `QUALIFICATION` table.

**EMPLOYEE.supervisor → EMPLOYEE.employeeId (self reference)**
An employee's supervisor is also an employee of the company, so the FK points to the PK of the same table. Since the table references itself, there is no ordering problem; the constraint can be written inside the same `CREATE TABLE` statement.

**DEPENDENT.employeeId → EMPLOYEE.employeeId**
To record an employee's dependent (spouse, child), the employee must first be registered in the `EMPLOYEE` table.

**DEPT.employeeId → EMPLOYEE.employeeId**
Identifies the manager of the department. This relationship creates the special case described below.


## 3. Special Case: Circular Dependency

In this schema, two tables depend on each other:

1. `EMPLOYEE` depends on `DEPT` through `deptId`, so `DEPT` must be created first.
2. `DEPT` also depends on `EMPLOYEE` through `employeeId`, so `EMPLOYEE` must be created first.

Both conditions cannot be satisfied at the same time. The solution takes three steps:

1. Create the `DEPT` table including the `employeeId` column, but **without** the Foreign Key constraint.
2. Create the `EMPLOYEE` table with all of its Foreign Key constraints. Since `DEPT` now exists, no error occurs.
3. Add the missing Foreign Key to `DEPT` afterwards using `ALTER TABLE`. Since `EMPLOYEE` now exists, this also succeeds.


## 4. Creation Order Summary

1. `QUALIFICATION`
2. `POSITION`
3. `EMPLEVEL`
4. `DEPT` (without the Foreign Key)
5. `EMPLOYEE`
6. `ALTER TABLE DEPT` (Foreign Key added)
7. `DEPENDENT`

In short: the parent tables that the arrows point to are created first, and the tables the arrows start from, which hold the Foreign Keys, are created afterwards.


## 5. Notes on the Code

**Composite key in DEPENDENT:** `primary key(employeeId, dependentId)` consists of two columns. A dependent can only be identified together with the employee they belong to. That is why `employeeId` is both part of the Primary Key and a Foreign Key.

**Constraint naming:** Names follow the `table_column_type` pattern (`pk`, `fk`, `nn`). When an error occurs, the violated rule can be identified directly from its name.

**Dropping tables reverses the order:** When using `DROP TABLE`, dependent tables (`DEPENDENT`) are dropped first, then the parent tables. Because of the circular dependency, either the `dept_employeeId_fk` constraint must be removed first, or `cascade constraints` must be used when dropping `DEPT` and `EMPLOYEE`.
