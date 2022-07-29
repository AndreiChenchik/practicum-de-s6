(SELECT count(1), 'missing group admin info' as info
FROM ANDREI_CHENCHIK_ME__STAGING.groups g 
LEFT JOIN ANDREI_CHENCHIK_ME__STAGING.users AS u 
ON g.admin_id = u.id
WHERE u.id is null )
UNION ALL
(SELECT COUNT(1), 'missing sender info'
FROM ANDREI_CHENCHIK_ME__STAGING.dialogs d 
LEFT JOIN ANDREI_CHENCHIK_ME__STAGING.users AS u 
ON d.message_from = u.id
WHERE u.id is null )
UNION ALL
(SELECT COUNT(1), 'missing receiver info'
FROM ANDREI_CHENCHIK_ME__STAGING.dialogs d
LEFT JOIN ANDREI_CHENCHIK_ME__STAGING.users AS u 
ON d.message_to = u.id
WHERE u.id is null) 
UNION ALL
(SELECT COUNT(1), 'norm receiver info'
FROM ANDREI_CHENCHIK_ME__STAGING.dialogs d
LEFT JOIN ANDREI_CHENCHIK_ME__STAGING.users AS u 
ON d.message_to = u.id
WHERE u.id is not null) 

-- Двигайтесь дальше! Ваш код: YIarVz86dJ