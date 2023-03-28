--how many events on average for our target customer
select avg(events) avg_events_per_date 
from ( select date(from_unixtime(requestContext.requestTimeEpoch/1000)) requestDate, count(1) events from api_logs group by date(from_unixtime(requestContext.requestTimeEpoch/1000)) ) foo 

