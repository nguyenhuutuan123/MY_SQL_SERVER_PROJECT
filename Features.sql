

--  =========================================  VIEW  ======================================== 

-- TẠO VIEW SELECT NHỮNG NHÂN VIÊN CÓ LEVEL ENGLISH CAO NHẤT --

drop view if exists `xem_tieng_anh`;
create view xem_tieng_anh as
select employees.id_employee, employees.name,languagues.name_language,detail_languages.level 
from employees, languagues, detail_languages
where employees.id_employee=detail_languages.id_employee
and languagues.id_language=detail_languages.id_language
and languagues.id_language= 1
and detail_languages.level='A';


--      TẠO VIEW SELECT THÔNG TIN CỦA CÁC TRƯỞNG PHÒNG       --
drop view if exists `thong_tin_truong_phong`;
create view thong_tin_truong_phong as
select employees.id_employee,positions.id_position,positions.name_position,employees.name,departments.name_department,departments.phone_number_dep
from employees, positions,departments
where employees.id_department=departments.id_department
and employees.id_position=positions.id_position
and positions.id_position=3;


-- =========================================PROCEDURE========================================

/*  PROCEDURE DÙNG ĐỂ UPDATE LẠI TÀI KHOẢN ATM CỦA NHÂN VIÊN */

drop procedure if exists update_ATM ;
Delimiter $$
Create Procedure update_ATM(id_emp int(10), ATM varchar (50))
	Begin
update employees set ATM_code = ATM where  id_employee = id_emp; 
END $$
Delimiter ;
Call update_ATM(1,'8660 00967791433 099');



-- PROCEDURE THAY ĐỔI, TĂNG LƯƠNG TRONG CÔNG TY LÀM VIỆC HƠN 1 NĂM HAY NHIEU NAM  
drop procedure if exists `change_salary`;
delimiter $$
create procedure `change_salary`(in id int)
begin
        declare days date ;
        declare endday date ;
        select end_day into endday from contracts where id_employee=id;
        if (endday > now()) then
			select start_day into days from contracts where id_employee=id;
			begin
				if (DATEDIFF(now(),days) > 365) then
					update contracts set salary=salary + 500000 where id_employee=id;
				elseif (DATEDIFF(now(),days) > 730) then
					update contracts set salary=salary + 1000000 where id_employee=id;
				end if;
			end;
		end if;
end $$
delimiter ;

call change_salary(5);


--  =========================================FUNCTION========================================


/*FUNCTION DÙNG ĐỂ TÍNH LƯƠNG CỦA NHÂN VIÊN DỰA VÀO MÃ NHÂN VIÊN,THÁNG VÀ NĂM MUỐN TÍNH ĐƯỢC NHẬP
                             VÀO VÀ TRẢ RA LƯƠNG CỦA NHÂN VIÊN ĐÓ            */

drop function if exists `tinh_luong`;
delimiter $$
create function `tinh_luong`(id int ) returns int deterministic
begin
	declare result int;
	declare luong_co_ban int;
	declare so_ngay_lam int;
	declare tong_ngay_cong int;
	declare nghi_phep int;
    
	select salary into luong_co_ban 
    from  contracts where id_employee=id;
    
    select working_day into so_ngay_lam 
    from timekeepings 
    where id_employee= id and month = month(now()) and year = year(now());
 
	select date_working  into tong_ngay_cong
	from total_working_days
	where total_working_days.month = month(now()) and year = year(now());

	select day_off_allow into nghi_phep 
    from timekeepings 
    where  id_employee = 2 and month = month(now()) and year = year(now());
    
	set result = ((so_ngay_lam + nghi_phep)* luong_co_ban ) / tong_ngay_cong ; 
    /*Ngay nghỉ phép được tính là ngày đi làm nên được cộng vào số ngày đi làm
      Công thức tính lương như sau: Lương = (Số ngày đi làm * Lương cơ bản) / tổng số ngày công của tháng đó.
    */ 
	return result; 
end $$
delimiter ;

select tinh_luong(6 ) as Tien_luong;

 
 


--  =========================================TRIGGER========================================

--  =======================TRIGGER KIỂM SOÁT SỰ THAY ĐỔI ===============================

/*-----------------TRIGGER THEO DÕI NHÂN VIÊN VỪA MỚI KÝ HỢP ĐỒNG ------------*/
DROP TRIGGER IF EXISTS `INSERT_CONTRACT`;
DELIMITER //
	CREATE TRIGGER `INSERT_CONTRACT` BEFORE INSERT ON CONTRACTS
	FOR EACH ROW
	BEGIN
		INSERT INTO employees_auditS
		(id_employee, action, changed_on, message) 
		VALUES 
		(new.id_employee,'INSERT', NOW(), 'Đã có nhân viên vừa được kí hợp đồng ');
	END//
DELIMITER ;

INSERT INTO CONTRACTS (id_type, id_employee, start_day,end_day,salary)
 VALUES (3,3,'2017-04-12','2020-04-12',20000000);



/*---- TRIGGER SỰ THAY ĐỔI PHÒNG BAN CỦA NHÂN VIÊN TỪ PHÒNG BAN NÀY SANG PHÒNG BAN KHÁC------------------*/

DROP TRIGGER IF EXISTS `EMPLOYEES_UPDATE_departments`;
DELIMITER //
	CREATE TRIGGER `EMPLOYEES_UPDATE_departments` BEFORE UPDATE ON `employees`
	FOR EACH ROW
	BEGIN
		declare old_name varchar (25) default ''; 
        declare new_name varchar (25) default '';
        declare emp_name varchar (25) default '';
        select  name_department into old_name from departments where id_department= OLD.id_department;
        select  name_department into new_name from departments where id_department= new.id_department;
        select  name  into emp_name from employees where id_employee= old.id_employee;
        
		IF OLD.id_department != NEW.id_department THEN
		INSERT INTO employees_audits 
		(id_employee, action, changed_on, message) 
		VALUES 
		(OLD.id_employee,'update', NOW(),CONCAT('Nhân viên  ',emp_name,' đã chuyển từ  ', old_name, ' sang   ',new_name));
		END IF;
	END//
DELIMITER ;

Update employees set id_department = 4 where id_employee = 1;


--  =======================TRIGGER KIỂM SOÁT SỰ TÍNH HỢP LỆ  ===============================

/*-------- TRIGGER KIỂM TRA INSERT LƯƠNG VÀO BẢNG CONTRACTS CÓ HỢP LỆ HAY KHÔNG  --------*/
DROP TRIGGER IF EXISTS  contract_insert_validation ;
DELIMITER //
CREATE TRIGGER contract_insert_validation after INSERT ON contracts
FOR EACH ROW
	BEGIN
		IF(new.salary <0 or new.salary <=1000000 ) then 
			signal sqlstate'45000' set MESSAGE_TEXT = 'the salary inserted is invalid ';
		end if;
	END//
DELIMITER ;

INSERT INTO CONTRACTS (id_type, id_employee, start_day,end_day,salary)
VALUES (4,3,'2017-04-12','2020-04-12',-11111111);




/*-------- TRIGGER KIỂM TRA NGÀY KÝ HỢP ĐỒNG MỚI CÓ TRÙNG VỚI NGÀY HẾT HẠN CỦA HỢP ĐỒNG CŨ HAY KHÔNG  --------*/

DROP TRIGGER IF EXISTS  validation_new_constracts;
DELIMITER //
CREATE TRIGGER validation_new_constracts after INSERT ON contracts
FOR EACH ROW
	BEGIN
    declare  old_endday date ;
    declare  old_startday date ;
    select max(end_day) into old_endday from contracts where id_employee =new.id_employee;
	select min(start_day) into old_startday from contracts where id_employee =new.id_employee;
		IF(old_startday < new.start_day < old_endday  or new.start_day < old_startday  ) then 
			signal sqlstate'45000' set MESSAGE_TEXT = 'Tháng không hợp lệ !';
		end if;
    END//
DELIMITER ;

INSERT INTO CONTRACTS (id_type, id_employee, start_day,end_day,salary)
 VALUE (3,2, '2018-12-19 ','2020-06-12',20000000);
 

 --  =========================================EVENT========================================

/*--------------- EVENT BÁO CHO CÁC TRƯỞNG PHÒNG ĐẦU TUẦN ĐI HỌP  ---------------*/

DROP EVENT IF EXISTS event_inform ;
delimiter $$ 
	create event event_inform
	on schedule every 1 week
	starts timestamp ('2018-12-17 07:30:00')
	ends timestamp('2019-12-17 07:30:00')
	on completion preserve
	-- not preserve: xong việc thì tự động biến mất, bởi vì có chữ not trước preserve
	enable
	-- tự động bật lại
	do
	begin
	insert into messages(content,created_date)
	values ('Invite you for the meeting right now' , now());
	end$$
delimiter ;
show events;
select * from messages;


 /*---------------  EVENT NHẮC NHỞ THÁNG ĐÓ CÓ BAO NHIÊU NHÂN VIÊN CÓ SINH NHẬT   ---------------*/

Drop event if exists check_dayofbirth ;
Delimiter $$
Create Event check_dayofbirth 
on schedule every 1 month 
starts timestamp('2018-12-20 15:46:00')
Ends  timestamp('2020-12-19 7:30:00')
on completion preserve 
ENABLE 
	DO
    Begin
		declare thang_hien_tai int;
        declare so_luong int;
		select month(now()) into thang_hien_tai;
        SELECT  count(id_employee) into so_luong FROM employees  WHERE Month(employees.date_of_birth) = thang_hien_tai;
		Insert INTO MESSAGES (content, created_date)
		values(concat('Có', so_luong,'nhan viên có sinh nhật trong tháng',month(now()) ,' này') ,NOW());
	END$$
DELIMITER ;
SHOW events;





--  =========================================INDEX========================================

--  ........................................INDEX SỐ.......................................

/*	Tạo index cho cột địa chỉ phòng ban của bảng departments */
create index departments_address on departments(address);
show index from departments;

/*	Tạo index cho cột working_day  của bảng timekeepings */
create index employee_workingday on timekeepings(working_day);
show index from timekeepings;



--  .......................................INDEX TEXT......................................

ALTER TABLE employees ADD FULLTEXT (name);
SELECT * FROM employees WHERE MATCH (name) AGAINST ('tuấn' IN NATURAL LANGUAGE MODE);

ALTER TABLE departments ADD FULLTEXT (name_department);
SELECT * FROM departments WHERE MATCH (name_department) AGAINST ('Phòng' IN NATURAL LANGUAGE MODE);





--  =========================================  PROCEDURE TRANSACTION  ========================================

/*	Kiểm tra xem tháng có hợp lệ với cả 2 bảng cham_cong, so ngay lam viec hay khong */

DELIMITER $$
DROP procedure if exists check_thang1 $$
create procedure check_thang1()
begin
	DECLARE roll_back BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET roll_back = 1;
    START TRANSACTION;
    INSERT INTO timekeepings(month) values (now());
    INSERT INTO total_working_days(month) values (now());  
    IF roll_back  THEN
		ROLLBACK;
	ELSE 
		COMMIT;
	END IF;
end$$
DELIMITER ;
 

--  =========================================  USER ROLES  ========================================

--  =============    Phân quyền select, insert, update, delete cho người quản lý nhân sự   ========

CREATE USER 'databaseManager'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT,CREATE, DROP, DELETE, INSERT, UPDATE ON database_project.*  TO 'databaseManager'@'localhost';

--  === Phân quyền cho nhân viên chỉ được xem ngày công và số ngày làm việc trong tháng đó   ====

CREATE USER 'employee'@'localhost' IDENTIFIED BY 'password';
GRANT  SELECT  ON  database_project.timekeepings  TO 'employee'@'localhost';
GRANT  SELECT  ON  database_project.total_working_days TO 'employee'@'localhost';
 




 