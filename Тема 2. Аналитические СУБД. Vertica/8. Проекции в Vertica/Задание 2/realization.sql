CREATE TABLE MY_TABLE (
    i int,
    ts timestamp(6),
    v varchar(1024),
    PRIMARY KEY (i, ts)
)
ORDER BY i, v, ts
SEGMENTED BY HASH(i, ts) ALL NODES; 

/* При создании проекции мы можем указать любое имя,
но всё-таки рекомендуется использовать формат
[TABLE_NAME]_[postfix], где постфикс — удобный для вас идентификатор.*/
CREATE PROJECTION MY_TABLE_proj2 as
SELECT
    i,
    ts,
    v
FROM
    MY_TABLE
ORDER BY
    v, ts /* поменяем сортировку ... */
SEGMENTED BY HASH(i, trunc(ts, 'DD')) ALL NODES ; /* И сделаем другую сегментацию */     

-- Двигайтесь дальше! Ваш код: X74a7fpwqI