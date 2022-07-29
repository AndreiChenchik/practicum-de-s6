select 
	count(id) as total, 
	count(distinct id) as unique,
	'users' as dataset 
from ANDREI_CHENCHIK_ME__STAGING.users
union all 
select
	count(id),
	count(distinct id),
	'groups' 
from ANDREI_CHENCHIK_ME__STAGING.groups
union all
select 
	count(message_id), 
	count(distinct message_id), 
	'dialogs' 
from ANDREI_CHENCHIK_ME__STAGING.dialogs;

-- Двигайтесь дальше! Ваш код: zGxJRhNxuG