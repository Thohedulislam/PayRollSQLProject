
Drop Database PaymentMangSytm
GO
Create database PaymentMangSytm
on
(
	Name='PaymentMangSytm_Data_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\PaymentMangSytm_Data_1.mdf',
	SIZE=25mb,
	Maxsize=100mb,
	FileGrowth=5%
)
log on
(
	Name='PaymentMangSytm_log_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\PaymentMangSytm_log_1.ldf',
	Size=2mb,
	Maxsize=50mb,
	FileGrowth=1%
)
go

----Table create -----

Use PaymentMangSytm

----Create designation Table----
Create table designation 
(
	designation_id int primary key Identity(1,1),
	designation_name varchar(50)
)
go

----Create Bonus Table----
Create table Bonus 
(
	bonus_id int primary key Identity(1,1),
	bonus varchar(50),
	skim varchar(50),
	skim_on varchar(50),
)
go

----Create Employee Table----
Create table Employee 
(
	employee_id int primary key Identity(1,1),
	firstname varchar(50),
	lastname varchar(50),
	email varchar(50),
	phone varchar(50),
	register_Date date,
	designation_id int references designation(designation_id),
	basic_salary decimal(18,2),
	medical decimal(18,2),
	home_rent decimal(18,2),
	provident_fund decimal(18,2),
	net_salary decimal(18,2)
 

)

go

----Create salary_distribution Table----
Create table salary_distribution
(
	salary_id int primary key Identity(1,1),
	emp_id int ,
	Perday_salary_grosh  decimal(18,2),
	net_salary decimal(18,2),
	deduction int ,
	bonus decimal(18,2),
	net_payable_salary decimal(18,2),
	payment_status varchar(50),
	bank_acc_no varchar(50),
	bank_name varchar(50),
	payment_type varchar(50),
	deduction_reason int,
	bonus_reason int references Bonus (bonus_id)

)


----Create salarys Table Store Procedure----
create table salarys
(
	Employee_ID int,
	Salary decimal(18,2)
)





----All Table show----
select* from designation
select * from Bonus
select * from Employee
select * from salarys
select * from salary_distribution