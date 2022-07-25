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
PARTITION BY message_ts::date /*здесь нужно указать поле*/
; 

-- Двигайтесь дальше! Ваш код: weNNVUMBcY