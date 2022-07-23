drop table if exists members;
drop table if exists members_rej;

create table if not exists members
(
    id int NOT NULL,
    age int,
    gender char,
    email varchar(50),
    CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
);

COPY members ( id,age,gender,email  ENFORCELENGTH )
FROM LOCAL '/Volumes/MacData/Developer/learning/DataEngineering/praktikum/sprint6/Тема 2. Аналитические СУБД. Vertica/5. Запись данных в Vertica/Задание 2/members.csv'
DELIMITER ';'
REJECTED DATA AS TABLE members_rej
; 

-- Двигайтесь дальше! Ваш код: BypNVb4HdI