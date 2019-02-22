drop database if exists database_project;
create database database_project character set = utf8mb4;
use database_project;


create table if not exists positions  (
	id_position int(11) not null auto_increment,
	name_position varchar (255) not null,
    primary key (id_position)
);
 
create table if not exists departments  (
	id_department int(11) not null auto_increment,
	name_department varchar (255) not null,
    address int (5) not null,
    phone_number_dep varchar(25),
    primary key (id_department)
);


create table if not exists academic_levels  (
	id_academic_level int(11) not null auto_increment,
	name_level text  (255) not null,
    major text  (255) not null,
    primary key (id_academic_level)
);

create table if not exists employees (
	id_employee int(11) not null auto_increment ,
	name varchar(255) not null,
	date_of_birth date not null,
	cmnd int(11) not null,
	address varchar(255) not null ,
    nationality varchar(25) not null ,
	gender varchar(10) not null,
	phone_number varchar (25) not null,
    email varchar (255) not null,
	id_department int (15) not null,
	id_position int (15) not null,
	id_academic_level int (15) not null,
    ATM_code varchar(50) not null,
    primary key(id_employee),
    foreign key(id_department) references departments (id_department),
	foreign key(id_position) references positions (id_position),
    foreign key(id_academic_level) references academic_levels (id_academic_level)
);


create table if not exists employees_audits (
	id int(11) not null auto_increment,
    action  varchar(45) DEFAULT NULL,
    changed_on datetime DEFAULT NULL,
    message varchar(500) DEFAULT NULL,
    id_employee int(11) not null,
    primary key(id,id_employee),
	foreign key(id_employee) references employees(id_employee)
);



create table if not exists languagues (
	id_language int not null ,
	name_language varchar(50) not null,
	primary key (id_language)
);

create table if not exists detail_languages (
	id_language int(11),
	id_employee int(11),
	level varchar(20) not null,
	primary key(id_language, id_employee),
	foreign key(id_language) references languagues(id_language),
	foreign key(id_employee) references employees(id_employee)
);

create table if not exists types_contracts (
	id_type int not null auto_increment,
	name varchar(50) not null,
	primary key (id_type)
);

create table if not exists contracts (
	id_contract int not null auto_increment,
    id_type int not null ,
    id_employee int(11) not null,
    start_day  datetime not null,
    end_day datetime not null,
    salary decimal,
    note text,
    primary key (id_contract),
    foreign key(id_type) references types_contracts(id_type),
	foreign key(id_employee) references employees(id_employee)
);



create table if not exists total_working_days (
	year year not null ,
    month int(2) not null,
	date_working  int(2) not null,
	primary key (year,month)
);

create table if not exists Timekeepings (
	id_employee int(11),
    working_day int(2),
	day_off_allow int(2),
    day_not_allowed int(2),
    month int(2) not null, 
    year year not null,
	primary key(id_employee, month,year),
	foreign key(id_employee) references employees(id_employee)
);

create table if not exists messages (
	id int not null auto_increment,
	content text not null,
	created_date datetime,
	primary key (id)
);

insert into departments (name_department, address, phone_number_dep) values
	('Phòng hành chính', 205, ' (+84) 052 225 225'),
	('Phòng kinh doanh', 206 ,'(+84) 052 225 226'),
	('Phòng kế toán', 207, '(+84) 052 225 227'),
	('Phòng nhân sự' ,305, '(+84) 052 225 335'),
	('Phòng công tác tổ chức ' ,306, '(+84) 052 335 336'),
	('Phòng kĩ thuật ' ,307, '(+84) 052 335 337'),
    ('Phòng lao động ' ,307, '(+84) 052 335 337'),
	('Phòng quản lí ', 405 ,'(+84) 052 335 445');

insert into positions (name_position) values
	('Tổng giám đốc'),
	('Giám đốc'),
	('Trưởng phòng'),
	('Phó phòng'),
	('Nhân viên');
    
    
    
insert into academic_levels (name_level,major) values
	('Cao đẳng','Công Nghệ Thông Tin'),
	('Đại học','Kê Toán'),
	('Thạc sĩ','Công Nghệ Thông Tin'),
    ('Đại học','Ngôn Ngữ Anh'),
	('Tiến sĩ','Quản Lý Phần Mềm');
    
insert into employees (name, date_of_birth, cmnd,address,nationality,gender,
phone_number,email,id_department,id_position,id_academic_level,ATM_code) values
	('Nguyễn Hữu Tuấn',date('1995-03-19'),201732623,'Đà Nẵng','Việt Nam','Nam','(+84)165982764','tuan.nguyen@gmail.com', 1 , 1 , 5 ,'9704 3668 01234567 022'),
	('Lê Công Vinh',date('1997-03-01'),20193743,'Đà Nẵng','Việt Nam','Nam','(+84)121787321','vinh.le@gmail.com', 4 , 4 , 4 ,'1904 3668 01204567 082'),
	('Hồ Tuấn Tài',date('1990-05-11'),42123452,'Đà Nẵng','Việt Nam','Nam','(+84)983627412','tai.ho@gmail.com', 3 , 3 , 4 ,'9714 3768 01714567 012'),
	('Alizabet Soncrasin',date('1992-03-21'),525215661,'Đà Nẵng','Australia ','Nữ','(+84)987122556','alizabet.soncrasin@gmail.com', 6 , 3 , 2 ,'9764 3268 01289367 122'),
	('Nguyễn Văn Toàn',date('1993-03-01'),21421563,'Đà Nẵng','Việt Nam','Nam','(+84)908897124','toan.nguyen@gmail.com', 8 , 4 , 1 ,'9706 3664 01014567 922'),
	('Võ Thị Phương Ly',date('1992-03-03'),642412525,'Đà Nẵng','Việt Nam','Nữ','(+84)1236642671','ly.vo@gmail.com', 1 , 4 , 2 ,'9704 3668 00127567 928'),
	('Phan Văn Đức',date('1994-10-01'),726513351,'Đà Nẵng','Việt Nam','Nam','(+84)943212321','duc.phan@gmail.com', 7 , 3 , 2 ,'9754 3008 12344567 109'),
	('Nguyễn Công Phượng',date('1993-12-22'),62562412,'Đà Nẵng','Việt Nam','Nam','(+84)126582764','phuong.nguyen@gmail.com', 7 , 4 , 2 ,'9954 3673 01932108 875'),
	('Nguyễn Quang Hải',date('1994-08-12'),54761212,'Đà Nẵng','Việt Nam','Nam','(+84)125962794','hai.nguyen@gmail.com', 4 , 5 , 1 ,'7653 7445 87012340 988'),
	('Leonel Messi ',date('1993-12-25'),7467246,'Đà Nẵng','Arghentina','Nam','(+84)129592268','messi.leonel@gmail.com', 1 , 5 , 2 ,'8660 009 67791433 088');


insert into languagues (id_language,name_language) values
	(1,'English'),
	(2,'Japanese'),
	(3,'Chinese'),
	(4,'Thailand'),
	(5,'French');

insert into detail_languages (id_language, id_employee, level) values
	(1,1,'A'),
    (2,1, 'B'),
	(1,2, 'A'),
	(2,2, 'B'),
	(3,2, 'C'),
    (1,3, 'A'),
    (5,3, 'C'),
	(3, 4, 'C'),
	(5,4, 'A'),
    (3,5, 'C'),
    (4,6, 'A'),
    (5,7, 'C'),
	(3, 7, 'C'),
	(5,8, 'A'),
    (3,9, 'C'),
	(1,10, 'B');

insert into types_contracts (name) values
	('Thực tập'),
	('1 năm'),
	('2 năm'),
	('5 năm');

 
insert into contracts (id_type, id_employee, start_day, end_day, salary) values
	(4,1,date('2018-03-01 17:01:57'),date('2023-05-01'),30000000), 
	(1,2,date('2018-12-12 15:30:00'),date('2019-02-12'),7000000),
	(2,3,date('2016-04-12 08:00:00'),date('2017-04-12'),10000000),
	(2,4,date('2015-01-22 10:00:00'),date('2016-01-22'),12000000),
	(3,5,date('2015-08-22 08:00:00'),date('2017-08-22'),7000000),
	(3,6,date('2018-04-12 16:00:00'),date('2020-04-12'),6500000),
	(3,7,date('2017-01-22 16:00:00'),date('2019-01-22'),8500000),
	(3,8,date('2018-08-02 08:00:00'),date('2020-08-02'),8000000),
    (4,9,date('2018-01-12 16:00:00'),date('2023-01-12'),7000000),
	(4,10,date('2017-12-02 08:00:00'),date('2022-12-02'),9500000);
    



insert into total_working_days (year, month, date_working) values
	(2018,1,24),
	(2018,2,17),
	(2018,3,23),
	(2018,4,24),
	(2018,5,23),
	(2018,6,22),
	(2018,7,21),
    (2018,8,24),
	(2018,9,24),
	(2018,10,23),
	(2018,11,21),
	(2018,12,24),
	(2019,1,24),
	(2019,2,16),
    (2019,3,23),
	(2019,4,21),
	(2019,5,23),
	(2019,6,24),
	(2019,7,24),
	(2019,8,21),
	(2019,9,20),
    (2019,10,22),
	(2019,11,21),
	(2019,12,24);
    


insert into timekeepings (id_employee, working_day, day_off_allow, day_not_allowed, month, year) values
	(1,21,0,0,11,2018),
	(2,20,01,0,11,2018),
	(3,19,0,2,11,2018),
	(4,21,0,0,11,2018),
	(5,21,0,0,11,2018),
	(6,18,0,3,11,2018),
	(7,20,0,01,11,2018),
	(8,21,0,0,11,2018),
	(9,20,01,0,11,2018),
	(10,20,01,0,11,2018),
    (1,24,0,0,12,2018),
	(2,23,01,0,12,2018),
	(3,24,0,0,12,2018),
	(4,21,03,0,12,2018),
	(5,20,02,02,12,2018),
	(6,23,01,0,12,2018),
	(7,23,0,01,12,2018),
	(8,24,0,0,12,2015),
	(9,24,0,0,12,2018),
	(10,19,05,0,12,2018);







 
