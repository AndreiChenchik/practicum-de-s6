(SELECT 
    min(u.registration_dt) as 'datestamp',
    'earliest user registration' as info
FROM ANDREI_CHENCHIK_ME__STAGING.users u)
UNION ALL
(SELECT
    max(u.registration_dt),
    'latest user registration'
FROM ANDREI_CHENCHIK_ME__STAGING.users u)
union all 
select
    min(registration_dt),
    'earliest group creation'
from ANDREI_CHENCHIK_ME__STAGING.groups
union all 
select
    max(registration_dt),
    'latest group creation'
from ANDREI_CHENCHIK_ME__STAGING.groups
union all 
select
    min(message_ts),
    'earliest dialog message'
from ANDREI_CHENCHIK_ME__STAGING.dialogs
union all 
select
    max(message_ts),
    'latest dialog message'
from ANDREI_CHENCHIK_ME__STAGING.dialogs
; 

-- Двигайтесь дальше! Ваш код: FDrOk7Bozl
