CREATE DATABASE school_roll
;

CREATE Table school_roll(
student_id INT PRIMARY KEY,
student_name VARCHAR(20),
student_major VARCHAR(20)
);

Insert into school_roll(student_id,student_name,student_major)
Values
(1,'jude','chemistry'),
(2,'Ada','Biology'),
(3,'Esy','Arts');

--SELECT

select * from school_roll;

select student_name  from school_roll;

select student_major from [school_roll];

--WHERE CLAUSE

SELECT student_name from 
[school_roll] where student_name like 'jude';

--LIMIT FUNCTION
SELECT * FROM school_roll
ORDER BY student_major ASC
OFFSET 0 ROW FETCH NEXT 2 ROW ONLY;

--RENAME
SELECT STUDENT_NAME FROM school_roll AS [STUDENT NAME];

--RENAME + ORDER CLAUSE TOGETHER.
select student_major as [top class]
from school_roll
order by student_id Desc;

use database [dbo].[MOVIE_REVIEW]

select * from [dbo].[MOVIE_REVIEW]
