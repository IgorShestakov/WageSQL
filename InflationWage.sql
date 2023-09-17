SET NAMES 'cp1251'; /* Задаем формат для нормального отображения кириллических названий */
ALTER TABLE `town`.`data`  /*Добавляем поле Инфлянция */
ADD COLUMN `inflation` INT NULL AFTER `workers`; 

INSERT INTO town.inflation(
   year, town.inflation)
VALUES
      (2002,  0),
      (2003,  11.99),
      (2004,  11.74),
      (2005,  10.91),
      (2006,  9.00),
      (2007,  11.87),
      (2008,  13.28),
      (2009,  8.80),
      (2010,  8.78),
      (2011,  6.10),
      (2012,  6.58),
      (2013,  6.45),
      (2014,  11.36),
      (2015,  12.90),
      (2016,  5.40),
      (2017,  2.50); 
      
SELECT 
      region, 
      municipality, 
      year, 
      wage, 
      salary_increase, 
      inflation, 
      Round(EXP(SUM(LOG(inflation_1)) over (ORDER BY year)) * 
      (SELECT wage FROM data WHERE municipality = 'Нижний Новгород' LIMIT 1),2) AS wage_inflation /*Получаем зарплату 2002 года с учетом ежегодной инфляции*/
FROM (   
    SELECT           /* расчитываем темп роста зарплаты в Нижнем Новгороде */
          region,
	  municipality,
          year,
          wage,
	  round(100 - lag(wage) over w /  wage *  100.0, 2) AS salary_increase,
          CASE WHEN year = 2002 THEN wage ELSE 0 END AS x,
          inflation,
          inflation  / 100 + 1 AS inflation_1
     FROM data
          LEFT JOIN inflation USING(year)
	WHERE municipality = 'Нижний Новгород'
    Window w AS (ORDER BY wage ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) 
    ORDER BY municipality, wage, region, year) AS qr;



