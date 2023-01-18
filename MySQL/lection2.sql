use iva52;
create table cities(
    id int primary key auto_increment,
    city varchar(25) not null
);

create table userss(
    id int primary key auto_increment,
    name varchar(20) not null,
    age int not null ,
    city_id int null,
    foreign key (city_id) references cities(id)
--звязок між таблицями foreign key (city_id) яке поле з якою таблицею та яким іншим полем звязати references cities(id)
);
-- вставлення значень в готову таблицю
insert into cities values (null,'Zaporizhia');
insert into userss values (null,'Mike',10,4);
--оновлення якогось значення
update userss set city_id=4 where id = 1;
--обєднання табличок за допомогою join - буде виводити всю інформацію де чітко співпвдвють стовбці
select * from userss join cities c on c.id = userss.city_id;
--left join-говорить що пріоритетно головна табличка та що з ліва
select * from userss left join cities c on c.id = userss.city_id;
--right join-говорить що пріоритетно головна табличка та що з права
select * from userss right join cities c on c.id = userss.city_id
where city_id = 4;
--якась конкретна інформація яку ми хочемо userss.id,name,city
select userss.id,name,city  from userss right join cities c on c.id = userss.city_id
where city_id = 4;
--повна інформація тільки про юзера, вибираючи місто по якому ми хочемо шукати
select userss.*  from userss right join cities c on c.id = userss.city_id
where city_id = 4;
select userss.*  from userss right join cities c on c.id = userss.city_id
where city = 'Kyiv';
--повна інформація тільки про юзера, вибираючи місто по якому ми хочемо шукати, та виводячи це місто
select userss.*,city  from userss right join cities c on c.id = userss.city_id
where city = 'Kyiv';
--отримаємо userss.ig,name,age,city.id,cities.id,city
select userss.*, cities.*  from userss right join cities  on cities .id = userss.city_id
where city = 'Kyiv';
select userss.*, cities.*  from userss left join cities  on cities .id = userss.city_id;
--додали Chornobyl
select userss.*, cities.*  from userss right join cities  on cities .id = userss.city_id;
--------------------------------------------------------------------------------------------
--обєднали дві табитці client та department
select * from client join department d on d.idDepartment=client.Department_idDepartment;
--обєднали три табитці client - department -application
select * from client
join department d on d.idDepartment=client.Department_idDepartment
join application a on client.idClient = a.Client_idClient;
-- у нас тільки таблиця client знає щось про таблиці department та application. Але самі по собі department
-- нічого не знає про application, тому всі join потрібно робити через таблицю client
select * from department join client c on department.idDepartment = c.Department_idDepartment;
select * from department
join client c on department.idDepartment = c.Department_idDepartment
join application a on c.idClient = a.Client_idClient;
--обєднали дві таблиці client та department але фільтруємо по таблиці application та її sum не виводячи цю таблицю
select c.*, department.* from department
join client c on department.idDepartment = c.Department_idDepartment
join application a on c.idClient = a.Client_idClient
where sum>10000;
-- distinct унікальні значення
select distinct name from users;
