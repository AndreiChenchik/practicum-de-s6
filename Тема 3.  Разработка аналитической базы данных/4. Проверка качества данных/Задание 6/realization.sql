SELECT count(*)
FROM ANDREI_CHENCHIK_ME__STAGING.groups AS g 
LEFT JOIN ANDREI_CHENCHIK_ME__STAGING.users AS u 
ON g.admin_id = u.id
WHERE u.id is null 

-- Двигайтесь дальше! Ваш код: Nzx3eJZ1d5