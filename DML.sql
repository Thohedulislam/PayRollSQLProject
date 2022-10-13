Use PaymentMangSytm


--insert  info tables designation 

insert into designation (designation_name) 
values ('manager'),('officestuff'),('Marketing')
go

--insert  info tables designation 
insert into Bonus(bonus,skim,skim_on) 
values ('EID ul Fiter','50%','gross'),('EID ul Azha','50%','gross'),('Boishakh','10%','gross'),('Best performar','10%','gross')
go

insert into Employee(firstname,lastname,email,phone,register_Date,designation_id,basic_salary,medical,home_rent,provident_fund,net_salary) 
values ('Jahid','Khan','jahid@gmail.com','01456687755','05/02/2022',1,20000,200,5000,400,25000),
		('Korim','Islam','korim@gmail.com','0156687755','04/02/2022',3,20000,200,5000,400,25000),
		('Jamal','Mirda','jamal@gmail.com','0165668775','05/02/2022',2,20000,200,5000,400,25000),
		('thohed','Howlader','jamal@gmail.com','0165668775','05/02/2022',2,20000,200,5000,400,25000),
		('Emon','Hossain','emon@gmail.com','0165668775','05/02/2022',2,20000,200,5000,400,25000),
		('Johurul','Howlader','joh22@gmail.com','0165668775','05/02/2022',2,20000,200,5000,400,25000),
		('Obaydul','kha','Oby@gmail.com','0165668775','05/02/2022',2,20000,200,5000,400,25000),
		('Robiul','Islam','robi@gmail.com','0165668775','05/02/2022',2,20000,200,5000,400,25000),
		('Rohoman','Mirda','rhom@gmail.com','017566345654','04/02/2022',1,20000,200,5000,400,25000)
go
--insert  info tables salary_distribution 
insert into salary_distribution (emp_id,Perday_salary_grosh,net_salary,deduction,bonus,net_payable_salary,
payment_status,bank_acc_no,bank_name,payment_type,deduction_reason,bonus_reason) 

values (1,200,25000,1300,2500,29000,'Done','12568465','On hand','Cash',2,3),
		(2,200,22000,1100,2200,25500,'Done','12568465','City','Bank',1,1),
		(3,200,27000,1450,2700,30850,'Done','12568465','Bkash','Online',3,2),
		(4,200,28000,1500,2800,32500,'Done','12568465','On hand','Cash',1,1),
		(5,200,26000,1400,2600,30200,'Done','12568465','Bkash','Online',3,2),
		(6,200,25000,1300,2500,29000,'Done','12568465','City','Bank',1,1),
		(7,200,28000,1500,2800,32500,'Done','12568465','On hand','Cash',3,2),
		(8,200,20000,1000,2000,23200,'Done','12568465','Bkash','Online',3,2),
		(9,200,18500,500,1900,21100,'Done','12568465','City','Bank',3,1)


go

	
--Q:-Find out designation ID with Employee firstname and lastname inner join

	select Employee.designation_id, Employee.firstname,Employee.lastname
	from Employee inner join designation 
	on Employee.designation_id = designation.designation_id

--Q:-Find out Manegar under Employee in Self join

	SELECT e.firstname, e.email,e.designation_id,m.firstname as ManagerName
	FROM Employee e
left outer join Employee m on e.designation_id=m.designation_id

--Q:-Count which designation_id get Bonus in ROLLUP
	select COUNT(bonus_id) AS designation_id from Bonus GROUP BY ROLLUP(bonus)

--Q:-Write a select query to find out salary_distribution those have no or one deduction_reason.

	select * from salary_distribution where deduction_reason is null or deduction_reason < 2 

--Q:-Write a select query to find out last 5 percent salary whose net_payable_salary is more than 20000.
	select * from salary_distribution where net_salary > 20000 order by net_salary 
	offset(select count(emp_id) from salary_distribution 
	where net_salary > 20000)-5 rows fetch next 5 rows only

--Q:-Write a select query to count salary_distribution where net_payable_salary count is more than 1.
	select net_payable_salary, count(net_payable_salary) numOfid 
	from salary_distribution 
	group by net_payable_salary 
	having count(net_payable_salary)>1
--Q:-Write a join query to find bonus, those have more than 5 to 10 persons
	select e.firstname, s.emp_id
	from (select net_salary,sum(bonus) emp_id from salary_distribution group by net_salary having sum(bonus)>10) s
	join Employee e on s.net_salary = e.net_salary





--select * from Employee
SELECT net_salary, employee_id FROM Employee 
GROUP BY GROUPING SETS (medical, home_rent)

---- SubQuery:------
select c.employee_id ,c.firstname,p.bonus,p.skim_on 
from Employee c, Bonus p
where c.designation_id=p.bonus_id and  p.skim_on>
(select skim_on from Employee where bonus_id=1);


--Q:-Find the Employee Joining year in CTE
CTE:
	WITH CTE_Employee_JoinYear(firstname, register_Date, JoinYear, EmployeeJoinYear) AS (
		SELECT    
			e.firstname + ' ' + e.email, 
			e. register_Date,
			GETDATE(),
			YEAR(GETDATE()) - YEAR(e.register_Date)
		FROM Employee e)

	SELECT
		firstname as EmployeeName_email, 
		JoinYear,
		EmployeeJoinYear
	FROM 
		CTE_Employee_JoinYear
	WHERE
		EmployeeJoinYear <= 4;
	go


--Q:-COUNT total Number of  salary_distribution
	select COUNT(*) as [Number] from salary_distribution

--Q:-COUNT total net_salary of salary_distribution
	select COUNT(net_salary) as [Number] from salary_distribution

--Q:-AVG total net_salary of salary_distribution 
	select AVG(net_salary) as [Number] from salary_distribution

--Q:-Maximum total net_salary of salary_distribution 
	select MAX(net_salary) as [Number] from salary_distribution

--Q:-Minimum total net_salary of salary_distribution 
	select MIN(net_salary) as [Number] from salary_distribution

--Q:-Count which net_payable_salary get salary_distribution in ROLLUP
	select COUNT(emp_id) AS ID, net_payable_salary from salary_distribution GROUP BY ROLLUP(net_payable_salary)

--Q:-Count which payment_type get salary_distribution in ROLLUP
	SELECT payment_type, SUM(net_payable_salary) FROM salary_distribution GROUP BY ROLLUP (payment_type);

--Q:-CUBE which net_payable_salary get salary_distribution 
	SELECT payment_type, SUM(net_payable_salary) FROM salary_distribution GROUP BY CUBE(payment_type) ORDER BY payment_type;

--Q:-Find the net_payable_salary get salary_distribution in OVER
	SELECT firstname, email, net_salary, COUNT(*) OVER() AS [OverColumn] FROM Employee




--Q:-How to see a table view  Creating function
	Create function function_designation()
		returns table
		return 
			(
				select*
				from designation
			)
	select* from function_designation();

--Q:-How to see a table scalar count Column Creating function

	create function fn_Bonus()
		returns int
		begin
			declare @c int;
			select @c= count(*) from Bonus
			return @c
	End

--check the function
	select noOfColumn= dbo. fn_Bonus();


--Q:-How to see a table multi statement function find out the Extra Comition include net_salary

	create function fn_employee()
	returns @outTable table(firstname varchar(50), basic_salary decimal(18,2), net_salary decimal(18,2))
		begin
			insert into @outTable(firstname, basic_salary, net_salary)
			select firstname, basic_salary, Comition=net_salary+10
			from Employee;
			return;
		end;

--check the function out put--
	select* from dbo.fn_employee();


--Q:-How to Create insert procedure and insert data
	create proc sp_insertsalary
	
		@Employee_ID int,
		@Salary decimal(18,2)
		as
		insert into salarys(Employee_ID, Salary)
			values(@Employee_ID,@Salary)
	go

	exec sp_insertsalary 2,'150000';

--check the insert procedure
	select* from salarys


--Q:-when you need to find update procdure in yours  salarys list
	create proc sp_Updatesalary
		@Employee_ID int,
		@Salary decimal(18,2)
		as
		update salarys set Salary=@Salary
		where Employee_ID=@Employee_ID
	go

	exec sp_Updatesalary 2,'75000'

--check the update salarys list
	select* from salarys


--delete procedure--
	create proc sp_deletesalary
		@Employee_ID int
		as
		delete from salarys
		where Employee_ID=@Employee_ID
	go

	exec sp_deletesalary 2;
--check the update salarys list
	select* from salarys

--Q::The stored procedure must have at least one in parameter and one out parameter

	drop proc sp_output_peramitter

	create proc sp_output_peramitter
		@firstname varchar(50) output
		as 
		begin 
		select @firstname=count(employee_id) from Employee
	end
-- check execute output procedure

	declare @firstname varchar(50)
	execute sp_output_peramitter @firstname output
	print @firstname

--Q::The stored procedure must have at least return perametter

	drop proc sp_return_peramitter
	create proc sp_return_peramitter
		as 
		begin
		return (select count(basic_salary) from Employee)
	end
--check exicute return peramitter

	declare @salary int 
	execute @salary =sp_return_peramitter
	print  @salary 





	-------------------after trigger--------------------

Create Trigger tblTriggerEmployee
on Employee
after update, insert
as
begin
	insert into salary_distribution(emp_id,net_salary)
	select s.net_salary,e.net_salary
	from Employee e
	inner join inserted s on e.net_salary=s.net_salary
end
go 

insert into Employee values(null,7),
					(null,8),
					(null,9)


	select* from Employee
	select* from salary_distribution

	update tblOrders
	set OrderStatus='Approved', OrderApprovalDateTime=getdate()
	where OrderID=2

	update tblOrders
	set OrderStatus='Cancelled', OrderApprovalDateTime=getdate()
	where OrderID=1












select* from designation
select * from Bonus
select * from Employee
select * from salary_distribution
select * from salarys