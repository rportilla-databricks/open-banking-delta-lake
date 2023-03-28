--how many events on average for our target customer
select date_trunc('MINUTE', from_unixtime(requestContext.requestTimeEpoch/1000)) requestTs, count(1) request_count from api_logs
group by date_trunc('MINUTE', from_unixtime(requestContext.requestTimeEpoch/1000)) 
