drop table if exists 
    ANDREI_CHENCHIK_ME__STAGING.users,
    ANDREI_CHENCHIK_ME__STAGING.groups,
    ANDREI_CHENCHIK_ME__STAGING.dialogs
;

create table ANDREI_CHENCHIK_ME__STAGING.users(
    id int not null,
    chat_name varchar(200) not null,
    registration_dt timestamp(0) not null,
    country varchar(200) not null,
    age int not null,
    CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
)
ORDER BY id
SEGMENTED BY HASH(id) ALL NODES;
;


create table ANDREI_CHENCHIK_ME__STAGING.groups(
    id int not null,
    admin_id int not null,
    group_name varchar(100) not null,
    registration_dt timestamp(0) not null,
    is_private bool not null,
    CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
)
ORDER BY id, admin_id
SEGMENTED BY hash(id) all nodes
PARTITION BY registration_dt::date
GROUP BY calendar_hierarchy_day(registration_dt::date, 3, 2)
;


create table ANDREI_CHENCHIK_ME__STAGING.dialogs(
    message_id int not null,
    message_ts timestamp(0) not null,
    message_from int not null,
    message_to int not null,
    message varchar(1000) not null,
    message_type varchar(100) not null,   
    CONSTRAINT C_PRIMARY PRIMARY KEY (message_id) DISABLED

)
ORDER BY message_id
SEGMENTED BY hash(message_id) all nodes
PARTITION BY message_ts::date
GROUP BY calendar_hierarchy_day(message_ts::date, 3, 2)
;

-- 3.3.1 Двигайтесь дальше! Ваш код: QgBA3wrA1C