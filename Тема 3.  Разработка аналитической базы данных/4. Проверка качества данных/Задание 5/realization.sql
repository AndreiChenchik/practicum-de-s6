(SELECT 
    max(u.registration_dt) < now() as 'no future dates',
    min(u.registration_dt) >= '2020-09-03' as 'no false-start dates',
    'users' as dataset
FROM ANDREI_CHENCHIK_ME__STAGING.users u)
UNION ALL
(SELECT
    max(g.registration_dt) < now(),
    min(g.registration_dt) >= '2020-09-03',
    'groups'
FROM ANDREI_CHENCHIK_ME__STAGING.groups g)
UNION ALL
(SELECT
    max(d.message_ts) < now(),
    min(d.message_ts) >= '2020-09-03',
    'dialogs'
FROM ANDREI_CHENCHIK_ME__STAGING.dialogs d); 

-- Двигайтесь дальше! Ваш код: iM3FK9w8O8