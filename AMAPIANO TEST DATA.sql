Create database AMAPIANO;

create table AMAPIANO (
MPNO Int primary key,
Enname VARCHAR (20),
Job VARCHAR (15),
MRG VARCHAR (10),
Hire_date Date
);
select * from AMAPIANO

--INSERT CLAUSE

INSERT INTO AMAPIANO (MPNO, Enname, Job, MRG, Hire_date)
VALUES
(7369, 'smith', 'clerk', 7902, '1990-02-01'),
(7499, 'allen', 'salesman', 7698, '2000-11-03'),
(7521, 'ward', 'salesman', 7698, '1997-01-01'),
(7566, 'jones', 'manager', 7839, '1994-07-04'),
(7654, 'martin', 'salesman', 7698, '1980-07-21');

select * from AMAPIANO;

select Job as [JOBS] from AMAPIANO
order by Hire_date desc
offset 0 row fetch next 3 row only;

select Enname from [AMAPIANO];

select Job from  [AMAPIANO];

--WHERE CLAUSE

SELECT Job FROM AMAPIANO 
WHERE job like 'SALESMAN';

select * from [dbo].[AMAPIANO]
order by MRG asc

--LIMIT CLAUSE

SELECT *
FROM AMAPIANO
ORDER BY MRG ASC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;


--JOINS CLAUSE-INNER JOIN,RIGHT JOIN AND LEFT JOIN.
