--what is the most popular partner fintech app used by this customer
select case when (body like '%Amazon%' or body like '%Walmart%') then 'retail' when body like '%Media%' then 'media' when body like '%Groceries%' then 'groceries' when body like '%Comedy%' then 'entertainment' when body like '%Food%' then 'dining' when body like '%account%modified%ROTH%' then 'investment' else 'Other' end category from api_logs

