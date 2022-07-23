drop table if exists orders_v2;
create table if not exists orders_v2
(
id  int PRIMARY KEY,
registration_ts timestamp(0),
user_id uuid,
is_confirmed boolean
)
ORDER BY id
SEGMENTED BY HASH(id) ALL NODES
; 

-- Двигайтесь дальше! Ваш код: HhGPYXDHQh