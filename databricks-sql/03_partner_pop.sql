--what is the most popular partner fintech app used by this customer
select user_agent from (
select user_agent, row_number() over (partition by 1 order by num_calls desc) rn  from (select headers.`User-Agent` user_agent, count(1) num_calls from api_logs group by headers.`User-Agent`) foo
) foo2 
where rn = 1
