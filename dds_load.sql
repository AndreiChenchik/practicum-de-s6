INSERT INTO ANDREI_CHENCHIK_ME__DWH.h_users(hk_user_id, user_id,registration_dt,load_dt,load_src)
select
       hash(id) as  hk_user_id,
       id as user_id,
       registration_dt,
       now() as load_dt,
       's3' as load_src
       from ANDREI_CHENCHIK_ME__STAGING.users
where hash(id) not in (select hk_user_id from ANDREI_CHENCHIK_ME__DWH.h_users); 


INSERT INTO ANDREI_CHENCHIK_ME__DWH.h_dialogs(hk_message_id, message_id,datetime,load_dt,load_src)
select
       hash(message_id) as hk_message_id,
       message_id,
       message_ts as datetime,
       now() as load_dt,
       's3' as load_src
       from ANDREI_CHENCHIK_ME__STAGING.dialogs
where hash(message_id) not in (select hk_message_id from ANDREI_CHENCHIK_ME__DWH.h_dialogs); 


INSERT INTO ANDREI_CHENCHIK_ME__DWH.h_groups(hk_group_id, group_id,registration_dt,load_dt,load_src)
select
       hash(id) as  hk_group_id,
       id as group_id,
       registration_dt,
       now() as load_dt,
       's3' as load_src
       from ANDREI_CHENCHIK_ME__STAGING.groups
where hash(id) not in (select hk_group_id from ANDREI_CHENCHIK_ME__DWH.h_groups); 


INSERT INTO ANDREI_CHENCHIK_ME__DWH.l_admins(
    hk_l_admin_id, hk_group_id, hk_user_id, load_dt, load_src
)
select
    hash(hg.hk_group_id, hu.hk_user_id)
    ,hg.hk_group_id
    ,hu.hk_user_id
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__STAGING.groups as g
left join ANDREI_CHENCHIK_ME__DWH.h_users as hu on g.admin_id = hu.user_id
left join ANDREI_CHENCHIK_ME__DWH.h_groups as hg on g.id = hg.group_id
where hash(hg.hk_group_id, hu.hk_user_id) 
    not in (select hk_l_admin_id from ANDREI_CHENCHIK_ME__DWH.l_admins);


INSERT INTO ANDREI_CHENCHIK_ME__DWH.l_groups_dialogs(
    hk_l_groups_dialogs, hk_group_id, hk_message_id, load_dt, load_src
)
select
    hash(hg.hk_group_id, hd.hk_message_id)
    ,hg.hk_group_id
    ,hd.hk_message_id
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__STAGING.dialogs as d
left join ANDREI_CHENCHIK_ME__DWH.h_dialogs as hd on d.message_id = hd.message_id
left join ANDREI_CHENCHIK_ME__DWH.h_groups as hg on d.message_group = hg.group_id
where hg.group_id is not null and hash(hg.hk_group_id, hd.hk_message_id) 
    not in (select hk_l_groups_dialogs from ANDREI_CHENCHIK_ME__DWH.l_groups_dialogs);


INSERT INTO ANDREI_CHENCHIK_ME__DWH.l_user_message(
    hk_l_user_message, hk_user_id, hk_message_id, load_dt, load_src
)
select
    hash(hu.hk_user_id, hd.hk_message_id)
    ,hu.hk_user_id
    ,hd.hk_message_id
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__STAGING.dialogs as d
left join ANDREI_CHENCHIK_ME__DWH.h_users as hu on d.message_from = hu.user_id
left join ANDREI_CHENCHIK_ME__DWH.h_dialogs as hd on d.message_id = hd.message_id
where hu.user_id is not null and hash(hu.hk_user_id, hd.hk_message_id)
    not in (select hk_l_user_message from ANDREI_CHENCHIK_ME__DWH.l_user_message);


INSERT INTO ANDREI_CHENCHIK_ME__DWH.s_admins(
    hk_admin_id, is_admin,admin_from,load_dt,load_src
)
select 
    la.hk_l_admin_id
    ,True as is_admin
    ,hg.registration_dt
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__DWH.l_admins as la
left join ANDREI_CHENCHIK_ME__DWH.h_groups as hg 
    on la.hk_group_id = hg.hk_group_id; 


INSERT INTO ANDREI_CHENCHIK_ME__DWH.s_user_chatinfo(
    hk_user_id, chat_name, load_dt,load_src
)
select 
    hu.hk_user_id
    ,u.chat_name
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__DWH.h_users as hu
left join ANDREI_CHENCHIK_ME__STAGING.users as u 
    on hu.user_id = u.id; 


INSERT INTO ANDREI_CHENCHIK_ME__DWH.s_group_name(
    hk_group_id, group_name, load_dt,load_src
)
select 
    hg.hk_group_id
    ,g.group_name
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__DWH.h_groups as hg
left join ANDREI_CHENCHIK_ME__STAGING.groups as g
    on hg.group_id = g.id;


INSERT INTO ANDREI_CHENCHIK_ME__DWH.s_group_private_status(
    hk_group_id, is_private, load_dt,load_src
)
select 
    hg.hk_group_id
    ,g.is_private
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__DWH.h_groups as hg
left join ANDREI_CHENCHIK_ME__STAGING.groups as g
    on hg.group_id = g.id; 


INSERT INTO ANDREI_CHENCHIK_ME__DWH.s_dialog_info(
    hk_message_id, message, message_from, message_to, load_dt,load_src
)
select 
    hd.hk_message_id
    ,d.message
    ,d.message_from
    ,d.message_to
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__DWH.h_dialogs as hd
left join ANDREI_CHENCHIK_ME__STAGING.dialogs as d
    on hd.message_id = d.message_id; 


INSERT INTO ANDREI_CHENCHIK_ME__DWH.s_user_socdem(
    hk_user_id, country, age, load_dt,load_src
)
select 
    hu.hk_user_id
    ,u.country
    ,u.age
    ,now() as load_dt
    ,'s3' as load_src
from ANDREI_CHENCHIK_ME__DWH.h_users as hu
left join ANDREI_CHENCHIK_ME__STAGING.users as u 
    on hu.user_id = u.id; 



-- 3.6.2 Двигайтесь дальше! Ваш код: bRhESIKcrH
-- 3.6.4 Двигайтесь дальше! Ваш код: tSUlVB5rgw
-- 3.6.5 Двигайтесь дальше! Ваш код: VOsZ1JXImP
