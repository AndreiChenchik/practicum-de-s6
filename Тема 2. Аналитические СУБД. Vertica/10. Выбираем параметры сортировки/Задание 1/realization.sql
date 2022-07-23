drop table if exists dialogs;
create table if not exists dialogs
(
    message_id   int PRIMARY KEY,
    message_ts   timestamp(6),
    message_from int REFERENCES users(id),
    message_to int REFERENCES users(id),
    message varchar(1000),
    message_type varchar(100)
)
ORDER BY message_id, message_ts
SEGMENTED BY hash(message_id) all nodes;

-- Двигайтесь дальше! Ваш код: IIrTN0FHoF