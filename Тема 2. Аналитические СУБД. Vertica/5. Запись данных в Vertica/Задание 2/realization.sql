CREATE TABLE if not exists users
(
    id int NOT NULL,
    chat_name varchar(200),
    registration_ts timestamp(6),
    country varchar(200),
    age float,
    gender varchar(1),
    email varchar(50),
    CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
);


COPY users ( id,chat_name,registration_ts,country,age,gender,email  ENFORCELENGTH )
FROM LOCAL '/Volumes/MacData/Developer/learning/DataEngineering/praktikum/sprint6/Тема 2. Аналитические СУБД. Vertica/5. Запись данных в Vertica/Задание 2/users.csv'
DELIMITER ';'
REJECTED DATA AS TABLE users_rej
; 

-- Двигайтесь дальше! Ваш код: BypNVb4HdI