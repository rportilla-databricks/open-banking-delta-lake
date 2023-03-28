--number of transactions 
select count(1) from (select * from api_logs where body like '%transaction%created%') foo


