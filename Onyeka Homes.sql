select * from [dbo].[Onyekas_Homes]

select top(2)Home_id,Home_name,Home_adress,Home_packing from Onyekas_Homes;

select distinct home_id from Onyekas_Homes;

select home_id as [Home ID] from Onyekas_Homes;

select * from Onyekas_Homes
order by Home_packing desc
OFFSET 0 ROWS FETCH NEXT 3 ROW ONLY




