COPY members ( id,age,gender,email  ENFORCELENGTH )
FROM LOCAL '/Volumes/MacData/Developer/learning/DataEngineering/praktikum/sprint6/Тема 2. Аналитические СУБД. Vertica/5. Запись данных в Vertica/Задание 2/members.csv'
DELIMITER ';'
REJECTED DATA AS TABLE members_rej
; 


create table members_inc
(
        id int NOT NULL,
        age int,
        gender char,
        email varchar(50),
        CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
)
ORDER BY id
SEGMENTED BY HASH(id) ALL NODES
;

COPY members_inc(id, age, gender, email ENFORCELENGTH )
FROM LOCAL '/Volumes/MacData/Developer/learning/DataEngineering/praktikum/sprint6/Тема 2. Аналитические СУБД. Vertica/11. Удаление и обновление данных в Vertica/Задание 3/members_inc.csv'
DELIMITER ';'
REJECTED DATA AS TABLE members_rej;

MERGE INTO members tgt /* имя таблицы в которой будут обновляться данные и в которую будут вставлены новые записи*/
USING /* Запрос, формирующий входящие данные */
    (SELECT id, age, gender, email /*список колонок*/ 
    FROM members_inc) AS src /*таблица из которой нужно взять данные*/
ON  /* ключи MERGE */
    tgt.id = src.id 
WHEN MATCHED and (tgt.email <> src.email /*сравнение записей*/
                                    or tgt.gender <> src.gender 
                                    or tgt.age <> src.age )
    THEN UPDATE SET email = src.email, gender = src.gender, age= src.age 
WHEN NOT MATCHED
    THEN INSERT VALUES (src.id, src.age, src.gender, src.email);

-- Двигайтесь дальше! Ваш код: FVlyeGncOQ

