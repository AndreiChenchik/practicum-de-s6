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
    registration_dt timestamp(0),
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
    registration_dt timestamp(0),
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
    message_ts timestamp(0),
    message_from int,
    message_to int ,
    message varchar(1000),
    message_type varchar(100),   
    CONSTRAINT C_PRIMARY PRIMARY KEY (message_id) DISABLED

)
ORDER BY message_id
SEGMENTED BY hash(message_id) all nodes
PARTITION BY message_ts::date
GROUP BY calendar_hierarchy_day(message_ts::date, 3, 2)
;

-- 3.3.1 Двигайтесь дальше! Ваш код: QgBA3wrA1C