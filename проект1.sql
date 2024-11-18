CREATE DATABASE project_1;

USE project_1;

UPDATE customer_info SET Gender = NULL WHERE Gender = '';
UPDATE customer_info SET Age = NULL WHERE Age = '';
ALTER TABLE customer_info MODIFY Age INT NULL;


CREATE TABLE transactions_info (
    date_new DATE,                               
    Id_check INT,                               
    ID_client INT,                             
    Count_products DECIMAL(10, 3),            
    Sum_payment DECIMAL(10, 2)                
);

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TRANSACTIONS.csv"
INTO TABLE transactions_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW variables like 'secure_file_priv';

drop table transactions_info;

 drop table customer_info;

select * from customer_info;

select * from transactions_info;


#1 задание 
SELECT t.ID_client AS client_id,
    AVG(t.Sum_payment) AS avg_check,                       # Средний чек за период
    SUM(t.Sum_payment) / 12 AS avg_monthly_sum,            # Средняя сумма покупок за месяц
    COUNT(t.Id_check) AS total_operations                  # Общее количество операций за период
FROM 
    transactions_info t
WHERE 
    t.date_new BETWEEN '2015-06-01' AND '2016-06-01'       
GROUP BY 
    t.ID_client
HAVING 
    COUNT(DISTINCT DATE_FORMAT(t.date_new, '%Y-%m')) = 12;
    
#2

SELECT 
    DATE_FORMAT(t.date_new, '%Y-%m') AS month,                   
    AVG(t.Sum_payment) AS avg_check,                            # Средняя сумма чека в месяц
    COUNT(t.Id_check) AS total_operations,                      # Количество операций в месяц
    COUNT(DISTINCT t.ID_client) AS total_clients,               # Количество клиентов в месяц
    COUNT(t.Id_check) / (SELECT COUNT(*) FROM transactions_info) AS operations_share,  # Доля операций от общего количества
    SUM(t.Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions_info) AS amount_share # Доля суммы операций от общей
FROM 
    transactions_info t
WHERE 
    t.date_new BETWEEN '2015-06-01' AND '2016-06-01'            
GROUP BY 
    DATE_FORMAT(t.date_new, '%Y-%m');
    
    
SELECT 
    DATE_FORMAT(t.date_new, '%Y-%m') AS month,
    c.Gender,                                                   # Пол клиента
    COUNT(t.Id_check) AS total_operations,                      # Количество операций
    SUM(t.Sum_payment) AS total_amount,                         # Общая сумма затрат
    SUM(t.Sum_payment) / (SELECT SUM(Sum_payment) FROM transactions_info) * 100 AS amount_share # Доля затрат
FROM 
    transactions_info t
JOIN 
    customer_info c ON t.ID_client = c.Id_client
WHERE 
    t.date_new BETWEEN '2015-06-01' AND '2016-06-01'           
GROUP BY 
    DATE_FORMAT(t.date_new, '%Y-%m'), c.Gender;
    
    
#3 

SELECT 
    CASE 
        WHEN c.Age IS NULL THEN 'Unknown'
        WHEN c.Age < 20 THEN '0-19'
        WHEN c.Age < 30 THEN '20-29'
        WHEN c.Age < 40 THEN '30-39'
        WHEN c.Age < 50 THEN '40-49'
        WHEN c.Age < 60 THEN '50-59'
        WHEN c.Age < 70 THEN '60-69'
        WHEN c.Age < 80 THEN '70-79'
        ELSE '80-88'
    END AS age_group,                                 -- Возрастная группа
    SUM(t.Sum_payment) AS total_amount,               -- Общая сумма операций
    COUNT(t.Id_check) AS total_operations             -- Общее количество операций
FROM 
    transactions_info t
LEFT JOIN 
    customer_info c ON t.ID_client = c.Id_client
WHERE 
    t.date_new BETWEEN '2015-06-01' AND '2016-06-01'  -- Период анализа
GROUP BY 
    age_group;