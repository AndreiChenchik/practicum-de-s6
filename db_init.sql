drop table if exists 
	ANDREI_CHENCHIK_ME__DWH.s_admins,
	ANDREI_CHENCHIK_ME__DWH.s_user_chatinfo,
	ANDREI_CHENCHIK_ME__DWH.s_group_name,
    ANDREI_CHENCHIK_ME__DWH.s_group_private_status,
    ANDREI_CHENCHIK_ME__DWH.s_dialog_info,
    ANDREI_CHENCHIK_ME__DWH.s_user_socdem
;


drop table if exists 
	ANDREI_CHENCHIK_ME__DWH.l_groups_dialogs,
	ANDREI_CHENCHIK_ME__DWH.l_user_message,
	ANDREI_CHENCHIK_ME__DWH.l_admins
;


drop table if exists
	ANDREI_CHENCHIK_ME__DWH.h_users,
	ANDREI_CHENCHIK_ME__DWH.h_dialogs,
	ANDREI_CHENCHIK_ME__DWH.h_groups
;


drop table if exists
    ANDREI_CHENCHIK_ME__STAGING.users,
    ANDREI_CHENCHIK_ME__STAGING.groups,
    ANDREI_CHENCHIK_ME__STAGING.dialogs,
    ANDREI_CHENCHIK_ME__STAGING.users_rej,
    ANDREI_CHENCHIK_ME__STAGING.groups_rej,
    ANDREI_CHENCHIK_ME__STAGING.dialogs_rej
;


create table ANDREI_CHENCHIK_ME__STAGING.users(
    id int not null,
    chat_name varchar(200),
    registration_dt timestamp,
    country varchar(200),
    age numeric(4,1),
    CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
)
ORDER BY id
SEGMENTED BY HASH(id) ALL NODES;
;


create table ANDREI_CHENCHIK_ME__STAGING.groups(
    id int not null,
    admin_id int,
    group_name varchar(100),
    registration_dt timestamp,
    is_private bool,
    CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
)
ORDER BY id, admin_id
SEGMENTED BY hash(id) all nodes
PARTITION BY registration_dt::date
GROUP BY calendar_hierarchy_day(registration_dt::date, 3, 2)
;


create table ANDREI_CHENCHIK_ME__STAGING.dialogs(
    message_id int not null,
    message_ts timestamp,
    message_from int,
    message_to int ,
    message varchar(1000),
    message_group int,   
    CONSTRAINT C_PRIMARY PRIMARY KEY (message_id) DISABLED

)
ORDER BY message_id
SEGMENTED BY hash(message_id) all nodes
PARTITION BY message_ts::date
GROUP BY calendar_hierarchy_day(message_ts::date, 3, 2)
;


create table ANDREI_CHENCHIK_ME__DWH.h_users
(
    hk_user_id bigint primary key,
    user_id      int,
    registration_dt datetime,
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_user_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;


create table ANDREI_CHENCHIK_ME__DWH.h_dialogs
(
    hk_message_id bigint primary key,
    message_id      int,
    datetime datetime,
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_message_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;


create table ANDREI_CHENCHIK_ME__DWH.h_groups
(
    hk_group_id bigint primary key,
    group_id      int,
    registration_dt datetime,
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_group_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;


create table ANDREI_CHENCHIK_ME__DWH.l_user_message (
    hk_l_user_message bigint primary key,
    hk_user_id bigint not null CONSTRAINT fk_l_user_message_user REFERENCES ANDREI_CHENCHIK_ME__DWH.h_users (hk_user_id),
    hk_message_id bigint not null CONSTRAINT fk_l_user_message_message REFERENCES ANDREI_CHENCHIK_ME__DWH.h_dialogs (hk_message_id),
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_user_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


create table ANDREI_CHENCHIK_ME__DWH.l_admins (
    hk_l_admin_id bigint primary key,
    hk_user_id bigint not null CONSTRAINT fk_l_admins_user REFERENCES ANDREI_CHENCHIK_ME__DWH.h_users (hk_user_id),
    hk_group_id bigint not null CONSTRAINT fk_l_admins_group REFERENCES ANDREI_CHENCHIK_ME__DWH.h_groups (hk_group_id),
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_l_admin_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


create table ANDREI_CHENCHIK_ME__DWH.l_groups_dialogs (
    hk_l_groups_dialogs bigint primary key,
    hk_message_id bigint not null CONSTRAINT fk_l_groups_dialogs_message REFERENCES ANDREI_CHENCHIK_ME__DWH.h_dialogs (hk_message_id),
    hk_group_id bigint not null CONSTRAINT fk_l_groups_dialogs_group REFERENCES ANDREI_CHENCHIK_ME__DWH.h_groups (hk_group_id),
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_l_groups_dialogs all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


create table ANDREI_CHENCHIK_ME__DWH.s_admins (
    hk_admin_id bigint not null 
        CONSTRAINT fk_s_admins_l_admins 
        REFERENCES ANDREI_CHENCHIK_ME__DWH.l_admins (hk_l_admin_id),
    is_admin boolean,
    admin_from datetime,
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_admin_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;


create table ANDREI_CHENCHIK_ME__DWH.s_user_chatinfo (
    hk_user_id bigint not null 
        CONSTRAINT fk_s_user_chatinfo_h_users 
        REFERENCES ANDREI_CHENCHIK_ME__DWH.h_users (hk_user_id),
    chat_name varchar(200),
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_user_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;


create table ANDREI_CHENCHIK_ME__DWH.s_group_name (
    hk_group_id bigint not null 
        CONSTRAINT fk_s_group_name_h_groups
        REFERENCES ANDREI_CHENCHIK_ME__DWH.h_groups (hk_group_id),
    group_name varchar(100),
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_group_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;


create table ANDREI_CHENCHIK_ME__DWH.s_group_private_status (
    hk_group_id bigint not null 
        CONSTRAINT fk_s_group_name_h_groups
        REFERENCES ANDREI_CHENCHIK_ME__DWH.h_groups (hk_group_id),
    is_private bool,
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_group_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;


create table ANDREI_CHENCHIK_ME__DWH.s_dialog_info (
    hk_message_id bigint not null 
        CONSTRAINT fk_s_dialog_info_h_dialogs
        REFERENCES ANDREI_CHENCHIK_ME__DWH.h_dialogs (hk_message_id),
    message varchar(1000),
    message_from int,
    message_to int ,
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_message_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;


create table ANDREI_CHENCHIK_ME__DWH.s_user_socdem (
    hk_user_id bigint not null 
        CONSTRAINT fk_s_user_socdem_h_users 
        REFERENCES ANDREI_CHENCHIK_ME__DWH.h_users (hk_user_id),
    country varchar(200),
    age numeric(4,1),
    load_dt datetime,
    load_src varchar(20)
)
order by load_dt
SEGMENTED BY hk_user_id all nodes
PARTITION BY load_dt::date
GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);
;




-- 3.3.1 Двигайтесь дальше! Ваш код: QgBA3wrA1C
-- 3.6.1 Двигайтесь дальше! Ваш код: ZPSFu4gGWm
-- 3.6.3 Двигайтесь дальше! Ваш код: BqqAznPPKg
-- 3.6.5 Двигайтесь дальше! Ваш код: VOsZ1JXImP
