--Задача 1. Выборка данных

/*
Написать скрипты на языке T-SQL, чтобы получить список кредитов, которые на момент расчета имеют непогашенную задолженность, и рассчитать для каждого такого кредита:
1. Общую (накопленную) сумму просроченного долга непогашенную (не выплаченную) к моменту расчета.
2. Дату начала текущей просрочки. Под датой начала просрочки, в данной задаче понимается первая дата непрерывного периода, в котором общая сумма просроченного непогашенного долга > 0.
3. Кол-во дней текущей просрочки.

Исходные данные
Таблица PDCL – содержит информацию о выносах на просрочку неоплаченных сумм по кредиту и о погашениях просроченного долга. 

Структура:
Date - Дата
Customer - Номер клиента
Deal - Номер кредита
Currency - Валюта кредита
Sum - сумма, вынесенная на просрочку ("+") или выплаченная ("-")

Один клиент может иметь несколько кредитов. Если клиент, имеющий кредит, пропускает очередную выплату по графику, у него возникает просрочка. В таблице PDCL при этом появляется соответствующая запись, где Sum – невыплаченная сумма (с положительным знаком). Если, затем, клиент совершает выплату (полную сумму или ее часть)  появляется новая запись, где Sum – выплаченная сумма (со знаком «-»). Следует учесть, что выплата клиента не обязательно полностью гасит накопленный долг, она может составлять лишь часть долга.
В приведенном примере по кредиту 111111 имеется невыплаченный просроченный долг на сумму 6900руб. (12000 + 5000 - 10100), дата начала текущей просрочки 12.12.2009.
*/

-- Решение

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


--Итоговый скрипт
SELECT DISTINCT p.Deal, p.Customer, p2.Overdue_amount, p2.Start_overdue, p2.Count_days_delay_in_payment
FROM PDCL p
    JOIN
    (SELECT
        Deal, --номер договора
        SUM(Sum) Overdue_amount, --общая сумма просрочки
        MIN(Date) Start_overdue, --дата начала просрочки
        DATEDIFF(day, MIN(Date), GETDATE()) Count_days_delay_in_payment
    --количество дней просрочки (начиная от даты выхода на просрочку до текущей даты)
    FROM PDCL
    GROUP BY Deal
    HAVING SUM(Sum)>0) p2
    ON p.Deal = p2.Deal


