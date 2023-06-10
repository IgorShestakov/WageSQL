SET NAMES 'cp1251'; /* Задаем формат для нормального отображения кириллических названий */
ALTER TABLE `town`.`data`  /*Добавляем поле Инфлянция */
ADD COLUMN `inflation` INT NULL AFTER `workers`; 

insert into town.inflation(
   year, town.inflation)
Values
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
      
Select 
      region, 
	  municipality, 
      year, 
      wage, 
      salary_increase, 
      inflation, 
      Round(EXP(SUM(LOG(inflation_1)) over (Order by year)) * 
      (select wage from data where municipality = 'Нижний Новгород' limit 1),2) as wage_inflation /*Получаем зарплату 2002 года с учетом 15 летней инфляции */
from (   
    Select           /* расчитываем темп роста зарплаты в Нижнем Новгороде */
          region,
		  municipality,
          year,
          wage,
	      round(100 - lag(wage) over w /  wage *  100.0, 2) as salary_increase,
          case when year = 2002 then wage else 0 end as x,
          inflation,
          inflation  / 100 + 1 as inflation_1
     FROM data
          left join inflation using(year)
	Where municipality = 'Нижний Новгород'
    window w as (order by wage ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) 
    Order by municipality, wage, region, year) as qr;



