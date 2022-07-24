SET SESSION AUTOCOMMIT TO off;

TRUNCATE TABLE members;

SELECT node_name, projection_name, deleted_row_count FROM DELETE_VECTORS
    where projection_name like 'members%';

ROLLBACK;

SELECT * FROM members; 

-- Двигайтесь дальше! Ваш код: wk9A3MLJHm