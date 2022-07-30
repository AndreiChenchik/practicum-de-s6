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

-- Двигайтесь дальше! Ваш код: bRhESIKcrH