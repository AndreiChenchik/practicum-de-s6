CREATE TABLE if not exists members_v2
(
    id varchar(2000) NOT NULL,
        age varchar(2000),
    gender varchar(2000),
    email varchar(2000),
    CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
); 


insert into members_v2
select id,age,gender,email from members

SELECT anchor_table_schema,
anchor_table_name,
SUM(used_bytes) * (1/1024/1024) AS TABLE_SIZE_MB
FROM   v_monitor.projection_storage
WHERE anchor_table_name in('members', 'members_v2')
GROUP  BY anchor_table_schema,
anchor_table_name
order  by sum(used_bytes) desc;

-- Двигайтесь дальше! Ваш код: RZu4HrYxzj