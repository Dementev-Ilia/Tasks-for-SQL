----По заданию 1.1----

USE master;
GO

--создаю БД
CREATE DATABASE Tasks;

--выбираю БД для работы
use Tasks;
GO


--Создаю таблицу
CREATE TABLE PDCL
(
    [Date] date,
    Customer INT,
    Deal INT,
    Currency NVARCHAR(3),
    [Sum] INT
);
GO

--Заполняю данными для анализа
INSERT INTO PDCL
VALUES
    ('2009-12-12', 111110, 111111, 'RUR', 12000);
INSERT INTO PDCL
VALUES
    ('2009-12-25', 111110, 111111, 'RUR', 5000);
INSERT INTO PDCL
VALUES
    ('2009-12-12', 111110, 122222, 'RUR', 10000);
INSERT INTO PDCL
VALUES
    ('2009-12-01', 111110, 111111, 'RUR', -10000);
INSERT INTO PDCL
VALUES
    ('2009-11-20', 220000, 222221, 'RUR', 25000);
INSERT INTO PDCL
VALUES
    ('2009-12-20', 220000, 222221, 'RUR', -25000);
INSERT INTO PDCL
VALUES
    ('2009-12-21', 220000, 222221, 'RUR', 20000);
INSERT INTO PDCL
VALUES
    ('2009-12-29', 111110, 122222, 'RUR', -10000);
GO


--Просмотр содержания таблицы
SELECT *
FROM PDCL

--Решение:
SELECT DISTINCT p.Deal, p.Customer, p2.Overdue_amount, p2.Start_overdue, p2.Count_days_delay_in_payment
FROM PDCL p
    JOIN
    (SELECT
        Deal, --номер договора
        SUM(Sum) Overdue_amount, --общая сумма просрочки
        MIN(Date) Start_overdue, --дата начала просрочки
        DATEDIFF(day, GETDATE(), MIN(Date)) Count_days_delay_in_payment --количество дней просрочки (начиная от даты выхода на просрочку до текущей даты)
    FROM PDCL
    GROUP BY Deal
    HAVING SUM(Sum)>0) p2
    ON p.Deal = p2.Deal

