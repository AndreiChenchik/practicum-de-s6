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

-- Двигайтесь дальше! Ваш код: tSUlVB5rgw