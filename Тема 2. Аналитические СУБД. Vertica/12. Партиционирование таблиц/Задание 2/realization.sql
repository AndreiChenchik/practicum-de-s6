drop table if exists dialogs;
create table if not exists dialogs
(
    message_id   int PRIMARY KEY,
    message_ts   timestamp(6),
    message_from int,
    message_to int,
    message varchar(1000),
    message_type varchar(100)
)
order by message_id, message_ts 
SEGMENTED BY hash(message_id) all nodes
PARTITION BY message_ts::date
GROUP BY calendar_hierarchy_day(message_ts::date, 3, 2) /*добавьте ваш код в эту строку*/
; 

-- Двигайтесь дальше! Ваш код: 5ECEtJxoS4