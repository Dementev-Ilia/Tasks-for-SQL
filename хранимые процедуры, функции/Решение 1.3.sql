----Задание 1.3----
--Условие задачи:
/*
Необходимо разработать код хранимой процедуры\функции, которая при передаче в нее текущей отчетной даты будет возвращать в табличном режиме значения текущей даты и дат предыдущих 3 недель.
call test ('2013-03-06')--вызов отчетной даты
*/

/*
USE master;
GO

--создаю БД
CREATE DATABASE Tasks;
*/

--выбираю БД для работы
use Tasks;
GO

--создаем таблицу
CREATE TABLE Date_DB
(
    [Дата] date
);
GO


------Решение-------------------------------

--Добавляем процедурную функцию которая дабавляет в таблицу текущую дату
--и высчитывает и добавляем даты 3х предыдущих недель
GO
CREATE PROCEDURE test1(@CurrentDate date)
AS
BEGIN
    INSERT INTO Date_DB
        (Дата)
    VALUES
        (DATEADD(day, -21, @CurrentDate));
    INSERT INTO Date_DB
        (Дата)
    VALUES
        (DATEADD(day, -14, @CurrentDate));
    INSERT INTO Date_DB
        (Дата)
    VALUES
        (DATEADD(day, -7, @CurrentDate));
    INSERT INTO Date_DB
        (Дата)
    VALUES
        (@CurrentDate);
END;


--вызываем процедуру
EXECUTE test1 '2013-03-06'

--call test1 '2013-03-06'

--Просмотр результата
SELECT *
FROM Date_DB;

