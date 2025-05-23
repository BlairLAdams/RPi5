
    
    

select
    obs_id as unique_field,
    count(*) as n_records

from "analytics"."silver_gold"."silver2gold_sf_scada"
where obs_id is not null
group by obs_id
having count(*) > 1


