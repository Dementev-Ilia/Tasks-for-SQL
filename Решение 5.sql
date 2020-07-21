---По заданию 5-----

--Условия задачи:
/*
Есть таблица table1 c 2 столбцами: дата Date1 и значение val1 числовое.
a. Вывести значения суммы нарастающим итогом с учетом, отсутсвующих дат в table1 начиная с 01.01.2018
*/

/*
USE master;
GO

--создаю БД
CREATE DATABASE sber;
*/

--выбираю БД для работы
use Tasks;
GO

--Создаем таблицу
CREATE TABLE Table_1
(
    Date1 date,
    val1 INT
);
GO

--Заполняем таблицу произвольными данными
INSERT
INTO Table_1
VALUES
    ('2018-02-26', 312.00),
    ('2018-03-05', NULL),
    ('2018-03-12', 225.00),
    ('2018-03-19', 453.00),
    ('2018-03-26', 774.00),
    ('2018-04-02', 719.00),
    ('2018-04-09', 136.00),
    ('2018-04-16', 133.00),
    ('2018-04-23', 157.00),
    ('2018-04-30', NULL),
    ('2018-05-07', 940.00),
    ('2018-05-14', 933.00),
    ('2018-05-21', NULL),
    ('2018-05-28', 952.00),
    ('2018-06-04', 136.00),
    ('2018-06-11', 701.00),
    ('2017-02-26', 312.00),
    ('2017-03-05', NULL),
    ('2017-03-12', 225.00),
    ('2017-03-19', 453.00),
    ('2017-03-26', 774.00),
    ('2017-04-02', 719.00);
    GO


--Просмотр содержания
SELECT *
FROM Table_1

--Находим знаяения с учетом нарастающего итога использую оконные функции
--для обработки NULL используем COALESCE
--сортируем данные по дате
--суммируем данные по столбцу val1, используя строки до текущей
--итоговое значение указываем в столбце total
SELECT s.*,
    COALESCE (SUM(s.val1) OVER (ORDER BY s.Date1
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
                0) AS total
FROM Table_1 s
WHERE Date1 > '2018-01-01'
ORDER BY s.Date1;