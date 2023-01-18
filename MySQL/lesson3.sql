create table usersss(
                        id int primary key auto_increment,
                        username varchar(20) not null ,
                        passport varchar(20) not null
);
-- зв'язок один до одного
create table profile(
                        id int primary key auto_increment,
                        name varchar(20) not null ,
                        age int not null ,
                        photo varchar(100) null ,
                        user_id int not null unique ,
                        foreign key (user_id) references usersss(id)
    -- unique -унікальне не можна записати в одней те саме в одну колонку
);
-- зв'язок багато до багатьох
create table users_cars(
                           car_id bigint,
                           user_id int,
                           primary key (user_id,car_id),
                           foreign key (user_id) references usersss(id),
                           foreign key (car_id) references cars(id)
);
select usersss.* from usersss
                          join users_cars  on usersss.id = users_cars.user_id
                          join cars on cars.id = users_cars.car_id;

select usersss.*,p.*, model from usersss
                                     join users_cars uc on usersss.id = uc.user_id
                                     join cars c on c.id = uc.car_id
                                     join profile p on usersss.id = p.user_id
where model='bmw';
---------------------------------------------------------------------------------------------
-- є два окремих запити
select count(*) from client join department d on d.idDepartment = client.Department_idDepartment
where DepartmentCity = 'Lviv';
select count(*) from client join department d on d.idDepartment = client.Department_idDepartment;
-- ми хочемо об'єднати їх в один запит union-обєднує два запити в один
select count(*) as Lviv_all from client join department d on d.idDepartment = client.Department_idDepartment
where DepartmentCity = 'Lviv' union
select count(*) from client join department d on d.idDepartment = client.Department_idDepartment;
-- покращуємо цей запит
select (select count(*) as Lviv_all from client join department d on d.idDepartment = client.Department_idDepartment
        where DepartmentCity = 'Lviv') as Lviv_count, (select count(*) from client join department d
        on d.idDepartment = client.Department_idDepartment) as all_count;
-- шукаємо місто з клієнта,-отримаємо всі application по кожному з клієнтів та порахуємо їх потім згрупуємо по порахованому,
-- від більшого до меншого
select City from client join application a on client.idClient = a.Client_idClient group by idClient order by count(*) desc ;
select count(*) as count,City from client join application a on client.idClient = a.Client_idClient group by idClient
order by count desc ;
-- виводимо тільки одного
select City from client join application a on client.idClient = a.Client_idClient group by idClient
order by count(*) desc limit 1;
-- знайти клієнта яка взяла найбільше кредитів та інформацію про неї
select * from client where City = (select City from client join application a on client.idClient = a.Client_idClient
group by idClient order by count(*) desc limit 1);