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

drop table if exists ANDREI_CHENCHIK_ME__DWH.h_users;

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


drop table if exists ANDREI_CHENCHIK_ME__DWH.h_dialogs;

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



drop table if exists ANDREI_CHENCHIK_ME__DWH.h_groups;

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

drop table if exists ANDREI_CHENCHIK_ME__DWH.l_user_message;
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

drop table if exists ANDREI_CHENCHIK_ME__DWH.l_admins;
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


drop table if exists ANDREI_CHENCHIK_ME__DWH.l_groups_dialogs;
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



-- 3.3.1 Двигайтесь дальше! Ваш код: QgBA3wrA1C
-- 3.6.1 Двигайтесь дальше! Ваш код: ZPSFu4gGWm
-- 3.6.3 Двигайтесь дальше! Ваш код: BqqAznPPKg