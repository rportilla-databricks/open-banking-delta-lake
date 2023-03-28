--number of account modifications 
select count(1) from (select * from api_logs where body like '%account%modified%') foo
