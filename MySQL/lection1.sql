--підключення до бд
use iva520567;
--створити табличку
create table userss (
    id int primary key auto_increment,
    name varchar(255) not null ,
    age int not null ,
    gender varchar(6) not null
);
--вставити в табличку дані
insert into userss values (null,'Max',18,'male');
-- вибрати з таблички якісь дані(витягнути)
select * from userss; //показати все
select id, age from userss; //показати щось конкретне(id,age)
--пошук по конкретним запитам
select *from users where name = 'Oleg';
select *from users where age = 20;
select *from users where age = 16 and gender = 'male';
select *from users where age = 16 or age = 20 ;
--пошук по літерам
--%-йому все рівно що буде йти далі
select *from users where name like 'o%'; //все що починається на о
select *from users where name like '%i'; //все що кінчається на i
select *from users where name like '%o%'; //все що містить о
select *from users where name like '__e%'; //третя буква повинна бути е
select *from users where name like '%na'; //декілька символів в кінці (na)
--пошук по цифрам
select *from users where age = 18;
select *from users where age > 18;
select *from users where age >= 18;
select *from users where age <= 18;
select *from users where age < 18;
--пошук в проміжках
select *from users where age between 20 and 30;//входять в проміжок
select *from users where age not between 20 and 30;//невходять в проміжок
--вибір з входжень(масивів)
select *from users where age in(18,16,4,25); //конкретно з цими параметрами
select *from users where age not in(18,16,4,25);//все крім цих параметрів
--пошук по довжині
select *from users where length(name)= 4;
--сортування-order by
select *from users order by age asc; //від меншого до більшого
select *from users order by age desc; //від більшого до меншого
select *from users where length(name)= 4 order by age desc;
--вказування лімітів при пошуку - взяти певну кількість - limit
select *from users where length(name)= 4 order by age desc limit 2;
-- пропустити певну кількість-offset
select *from users where length(name)= 4 order by age desc limit 2 offset 2;
select *from users limit 5 offset 5;
-- агрегатні функції -min,max,avg(середнє),count(підрахунок),sum
-- знаходимо мінімальний вік усіх користувачів
select min(age) from users; //{'min(age)':4} - відповідь від бекенду(js)
select min(age) as min from users; //as min- вказуємо назву стовпчика, яку ми б хотіли мати при відповіді
select sum(age) as sum from users;
select avg(age) as avg from users;
select max(age) as max from users;
select count(age) as count from users;
-- групування
select count(*) from cars group by model; //групуємо машини по їхнім моделям
select count(*), model from cars group by model;//групуємо машини по їхнім моделям і виводимо назву цієї моделі
-- групуємо машини по максимальній ціні конкретної моделі і виводимо назву цієї моделі
select max(price), model from cars group by model;
-- групуємо машини по максимальній ціні конкретної моделі і виводимо назву цієї моделі та ціни по спаданню
select max(price) as max_cost, model from cars group by model order by max_cost desc;
-- групуємо машини по максимальній ціні конкретної моделі і виводимо назву цієї моделі та ціни по спаданню(тільки одну машину)
select max(price) as max_cost, model from cars group by model order by max_cost desc limit 1;
-- групуємо машини по їхній кількості та моделям, де рік випуску менший за 2005
select count(*) as count, model from cars where year < 2005 group by model ;
-- having те саме що і where тільки ставиться в кінці після group by
select count(*) as count, model from cars where year < 2005 group by model having count>2;
-- абдейти
select count(*) as count, model from cars where year < 2005 group by model having count =3;
-- видалення
delete from users where id=3;
-- страхування при видаленні
delete from users where name= 'kokos' limit 500;
-- оновлення
update users set age=100 where name='kokos';