-- Author : Basir Payenda

----------------------------------------------------------------------------------------------------|
------------------------------------- LESSON 3 -----------------------------------------------------|
----------------------------------------------------------------------------------------------------|
* SHOW DATABASES;
* CREATE DATABASE new_world;
* USE new_world;
* CREATE DATABASE IF NOT EXISTS new_world;
* CREATE DATABASE new_world CHARACTER SET utf8 COLLATE utf8_persian_ci;
* SHOW CHARACTER SET;
* ALTER DATABASE new_world CHARACTER SET utf8;
-- You can't add collate along with CHARACTER SET.
* DROP DATABASE new_world;


-- BACKUP A DATABASE (MELLIFLUOUS/ SWEET)
* mysqldump -uroot -p new_world > d:\backup.sql


-- CREATE A TABLE
* CREATE TABLE sales (
	sales_id			INT PRIMARY KEY AUTO_INCREMENT,
	customer_name		varchar(32) NOT NULL,
	item				varchar(32) NOT NULL,
	unit_price			INT NOT NULL, 
	qunatity			INT NOT NULL,
	total_price			INT NOT NULL
);

----------------------------------------------------------------------------------------------------|
------------------------------------- LESSON 4 -----------------------------------------------------|
----------------------------------------------------------------------------------------------------|

CREATE TABLE guesthouse(
	guest_id		INT				PRIMARY KEY AUTO_INCREMENT,
	firstName		VARCHAR(32)		NOT NULL,
	gender			ENUM("M","F")	DEFAULT 'M',
	date_in			DATETIME		NOT NULL, -- YYYY-MM-DD HH:MM:SS
	description		TEXT,
	phone			CHAR			UNIQUE, 
	room_no			INT				NOT NULL
	-- Phone numbers can be preceded by zero, hence, integer is wrong data type
	-- unique is known as alternate key as well.
);

INSERT INTO guesthouse (firstName, date_in, room_no)
VALUES ('Basir Payenda', '12/1/2019', 352);

CREATE TABLE score(
	student_id		INT						NOT NULL,
	subject_id		INT						NOT NULL,
	chance			ENUM('1', '2', '3')		NOT NULL,
	mark			TINYINT NOT NULL,
	CONSTRAINT score_pk	PRIMARY KEY (student_id, subject_id, chance)
);

--------------------------------- FOREIGN KEY AND PRIMARY KEY CONSTRAINTS -------------------------|

CREATE TABLE department (
    dep_id          INT             PRIMARY KEY AUTO_INCREMENT,
    dep_name        VARCHAR(32)     NOT NULL UNIQUE
);
CREATE TABLE employee(
    emp_id          INT             PRIMARY KEY AUTO_INCREMENT,
    emp_name        VARCHAR(32)     NOT NULL,
    dep_id          INT             NOT NULL,
    CONSTRAINT emp_fk FOREIGN KEY (dep_id) REFERENCES department(dep_id)  
);

-- Or 

ALTER TABLE department ADD PRIMARY KEY (dep_id);  -- Notice: PK column in parenthesis
ALTER TABLE score ADD CONSTRAINT score_pk PRIMARY KEY (student_id, subject_id, chance);

ALTER TABLE employee ADD FOREIGN KEY (dep_id) REFERENCES department(dep_id);  -- or
ALTER TABLE employee ADD CONSTRAINT emp_fk FOREIGN KEY (dep_id) REFERENCES department(dep_id);

------------------------------- Dropping Primary Key and Foreign Key --------------------------------|
ALTER TABLE employee DROP FOREIGN KEY dep_id;
ALTER TABLE department DROP PRIMARY KEY;

-----------------------------------| Adding Referential Integrity |----------------------------------|
ALTER TABLE employee 
ADD CONSTRAINT emp_fk FOREIGN KEY (dep_id) REFERENCES department (dep_id)
ON DELETE NO ACTION ON UPDATE CASCADE;

-----------------------------------| Creating Temporary Tables |---------------------------------------
CREATE TEMPORARY TABLE tmp_student(
	student_id	INT	PRIMARY KEY AUTO_INCREMENT,
	student_name VARCHAR(32) NOT NULL
);

--| Others
SELECT * FROM teacher WHERE teacher_id BETWEEN 1002 AND 1005;
SELECT * FROM employee WHERE name IN ('BASIR','BASHIR');

------------------------------------------------------------------------------------------------------|
---------------------------------------------| Lesson 5 |---------------------------------------------|
------------------------------------------------------------------------------------------------------|

-----------------------------------| CTAS(Create Table As Select) |-------------------------------------|
CREATE TABLE doctor AS SELECT * FROM doctor;
--| To copy only structure of a table and not data, give it a wrong condition.
CREATE TABLE student2 AS SELECT * FROM student WHERE student_id = -50; -- wrong condition

--| If you are a database other than umis and want to make a similar student table from umis database,
--| use this code below!
CREATE TABLE student AS SELECT * FROM umis.student;

-----------------------------------| Defining Storage Engine |------------------------------------------|
CREATE TABLE doctor(
	doctor_id INT PRIMARY KEY AUTO_INCREMENT,
	doctor_name VARCHAR(32) NOT NULL,
	doctor_address VARCHAR(56) NOT NULL
) engine = InnoDB;

CREATE TABLE doctor(
	doctor_id INT PRIMARY KEY AUTO_INCREMENT,
	doctor_name VARCHAR(32) NOT NULL,
	doctor_address VARCHAR(56) NOT NULL
) engine = InnoDB;

----------------------------------------| Altering Tables |---------------------------------------------|
--| ALTER TABLE tbl_name ADD tbl_name DataType CONSTRAINT;
ALTER TABLE employee ADD emp_firstName VARCHAR(32) NOT NULL AFTER emp_id; --| AFTER VS FIRST KEYWORDS
ALTER TABLE employee ADD emp_firstName VARCHAR(32) NOT NULL FIRST;		  --| AFTER VS FIRST KEYWORDS

--| ALTER TABLE tbl_name CHANGE oldName newName DATATYPE CONSTRAINT;
ALTER TABLE course CHANGE course_id course_id INT AUTO_INCREMENT;	  	  --| Adding auto_increment to column
ALTER TABLE employee CHANGE emp_firstName firstName VARCHAR(32) NULL; 	  --| Rename a column and set null

--| Dropping Columns
ALTER TABLE employee DROP firstName;									  --| Drop Column in MySQL
ALTER TABLE employee DROP COLUMN firstName; -- SQL SERVER				  --| Drop Column in SQL Server

--| Rename Table
RENAME TABLE employee TO staff; 										  --| Rename a table

--| Dropping Tables
DROP TABLE tbl_name;
DROP TABLE IF EXISTS tbl_name;
TRUNCATE TABLE tbl_name;

--| Start auto_increment from 100
ALTER TABLE course AUTO_INCREMENT = 100;

------------------------------------------- Table Index ------------------------------------------------|
CREATE INDEX index_name ON tbl_name (tbl_column);			-- Structure
CREATE INDEX emp_firstName ON employee (firstName);			-- Example

ALTER TABLE tbl_name ADD INDEX (tbl_col);					-- Notice, you can't rename the index

DROP INDEX emp_firstName ON employee;						-- Dropping index
ALTER TABLE tbl_name DROP INDEX index_name;					-- Dropping named Index [Structure]
ALTER TABLE employee DROP INDEX emp_firstName;				-- Example

SHOW KEYS FROM employee;
SHOW INDEXES FROM employee;

-- PARTIAL INDEX
CREATE INDEX index_name ON tbl_name (column_name(n));		-- Structure, Search in 10 first chars of this column	
CREATE INDEX employee_index ON employee (address(10));		-- Example

ALTER TABLE tbl_name ADD INDEX (column_name(10));			-- Search in 10 first alphabets of this column
ALTER TABLE employee ADD INDEX (address(10));				-- Example

-- COMPOUND INDEX
CREATE INDEX index_name ON tbl_name (column1_name, column2_name);
ALTER TABLE tbl_name ADD INDEX (col1_name, col2_name);

--====================================================================================|
--=================================| Lesson 6 |=======================================|
--====================================================================================|
--| SELECT
# SELECT * FROM employee;
# SELECT employee_id, name, department FROM employee;
# SELECT employee_id, name, department FROM employee ORDER BY department DESC;  --| ORDER 
# SELECT employee_id AS id, name, department FROM employee;					            --| ALIAS
# SELECT * FROM employee LIMIT 1;											                        	--| LIMIT
# SELECT DISTINCT * FROM employee;										                         	--| DISTINCT

--| WHERE
# SELECT * FROM employee WHERE employee_dep = "Finance";
# SELECT * FROM employee WHERE employee_dep = "Finance" & employee_experience > 2;

--====================================================================================|
--=================================| Lesson 7 |=======================================|
--====================================================================================|
--| % [Zero or more chars]
--| _ [Only one char]
# SELECT * FROM employee WHERE emp_name LIKE "maryam%";
# SELECT * FROM employee WHERE emp_name LIKE "___maryam%";
# SELECT * FROM employee ORDER BY payroll_year ASC, payroll_month ASC;  -- Multi Level Sort

--| IN			  a precise form of OR
--| BETWEEN		a precise form of AND
# SELECT * FROM employee WHERE province IN ("Kabul", "Balkh");

# SELECT * FROM sale WHERE g_date > "2014-6-1" AND g_date < "2015-6-1"; --| Too Long
# SELECT * FROM sale WHERE g_date BETWEEN "2014-6-1" AND "2015-6-1";    --| Short Form

# SELECT * FROM teacher WHERE teacher_id > 1002 AND teacher_id < 1005;
# SELECT * FROM teacher WHERE teacher_id BETWEEN 1002 AND 1005;

--| Limit offset, n; => ignore first two rows and show next 5 rows!
# SELECT * FROM teacher LIMIT 2,5;

--| e.g. How to show last row of a table?
# SELECT * FROM teacher ORDER BY teacher_id DESC LIMIT 1;

--====================================================================================|
--=================================| Lesson 8 |=======================================|
--====================================================================================|
--| INSERT
# INSERT INTO tbl_name (col1,col2, col3) VALUES (1stValue, 2ndValue, 3rdValue);  
# INSERT INTO teacher VALUES(NULL, 'John Doe', '+145698233', 'johndoe@gmail.com', 'male');

--| Inserting Multiple ROWS
# INSERT INTO teacher VALUES
(NULL, 'John Doe', '+145698233', 'johndoe@gmail.com', 'male'),
(NULL, 'Asifa', '+158005600', 'Asifa@asify.com', 'female'),
(NULL, 'Suliman', '+1530000255', 'Sulaiman@yahoo.com', 'male');

--| Alternative Insert Syntax
# INSERT INTO teacher SET firstName = "John", lastName = "Doe", address="Kabul";

--| Delete
# DELETE FROM teacher WHERE teacher_firstName = 'Mujtaba';

--| Update
# UPDATE tbl_name SET col_name = 'value'; --| Structure
# UPDATE tbl_name SET col1_name = 'value', col2_name = 'value', col3_name = 'value'; --| Structure

# UPDATE teacher SET lastName = "Ahmadi" WHERE lastName IS NULL;     --| lastName = 'Null' (Wrong)    
# UPDATE teacher SET lastName = "Ahmadi" WHERE lastName IS NOT NULL; --| lastName <> 'Null'(Wrong)

--| REPLACE: Replaces old data with new data.
# REPLACE INTO tbl_name (col1, col2, col3) VALUES (val1, val2, val3); --| Similar to Insert Query
# REPLACE INTO tbl_name col1 = 'val1', col2 = 'val2', col3 = 'val3';	--| Similar to alternative insert query
# REPLACE INTO teacher VALUES (2, 'Aziz', 90);

--| TRANSACTION = Undo
START TRANSACTION;		  --| To Start Transaction
ROLLBACK;	              --| To Rollback

--====================================================================================|
--=================================| Lesson 9 |=======================================|
--====================================================================================|
# LOAD DATA INFILE 'd:/record.txt' INTO TABLE doctors;
# LOAD DATA INFILE 'd:/record.txt' INTO TABLE doctors IGNORE 1 LINES;

--| How to upload an excel file into MySQL. First, save excel file as '.csv' extension.
# LOAD DATA INFILE 'c:/record.csv' INTO TABLE doctors FIELDS TERMINATED BY ',' IGNORE 1 LINES;
# LOAD DATA INFILE 'c:/record.csv' INTO TABLE doctors FIELDS TERMINATED BY ',' FIELDS ENCLOSED BY '"';


--| Sub Queries
# SELECT student_id FROM score WHERE mark = (SELECT MAX(mark) FROM SCORE);
# SELECT * FROM student 
  WHERE student_id = ( SELECT student_id FROM score WHERE mark = (SELECT MAX(mark) FROM SCORE));
# SELECT c.contact_id, c.last_name
  FROM contacts c WHERE c.site_name IN
  (SELECT a.site_name FROM address_book a WHERE a.address_book_id < 50);

--====================================================================================|
--=================================| Lesson 10 |======================================|
--====================================================================================|
--| INNER JOIN
# SELECT std.student_id, std.std_firstName, subject.subject_name, score.chance, score.mark 
  FROM student std INNER JOIN score on std.student_id = score.student_id 
  INNER JOIN subject on subject.subject_id = score.subject_id

--| Same as example above
--| Using Alias: Subject AS sub, student AS std, score AS s
# SELECT std.student_id, std.std_firstName, sub.subject_name, s.chance, s.mark 
  FROM student std INNER JOIN score s on std.student_id = s.student_id 
  INNER JOIN subject sub on sub.subject_id = s.subject_id

--| CROSS JOIN : it is theory-based and never used in real-world.
# SELECT student.student_id, firstName, lastName, subject_id, chance, mark 
  FROM student, score;
  SELECT student.student_id, firstName, lastName, subject_id, chance, mark 
  FROM student CROSS JOIN score;

--| Basic Join
# SELECT student.student_id, firstName, lastName, subject_id, chance, mark 
  FROM student, score WHERE student.student_id = score.student_id; 

--| Copying data of one file to another file
# INSERT INTO score2  SELECT * FROM score; 				-- SWEET

--====================================================================================|
--=================================| Lesson 11 |======================================|
--====================================================================================|
--| UNION
--| 1. Each SELECT statement must have the SAME NUMBER OF COLUMN.   
--| 2. The columns must also have SAME DATA TYPE.
--| 3. The columns in each SELECT statement must be in the SAME ORDER.
# SELECT employee.emp_id, firstName, lastName, net_salary FROM employee 
  INNER JOIN salary on employee.emp_id = salary.emp_id
  UNION SELECT NULL, NULL, 'Total: ', SUM(net_salary) FROM salary;

# SELECT * FROM donate_cash UNION SELECT * FROM donate_goods; -- All conditions are met.


# SELECT * FROM student WHERE std_id = "101" OR std_firstName = "Asif" OR std_lastName = "Ahmadi";
--| For better performance of DB replace above query with below query, notice both are identical:
# SELECT * FROM student WHERE std_id = "101"
  UNION
  SELECT * FROM student WHERE std_firstName = "Asif"
  UNION 
  SELECT * FROM student WHERE std_lastName = "Ahmadi";
  
--====================================================================================|
--=================================| Lesson 12 |======================================|
--====================================================================================|	
--| DIV (Integer Division)
# SELECT 5/2;               --| outputs 2.5
# SELECT 5 DIV 2;           --| outputs 2

--| NULL
# SELECT 5 + NULL;          --| outputs NULL
# SELECT * FROM teacher WHERE salary IS NULL;
# DELETE FROM teacher WHERE salary IS NOT NULL;

--| FUNCTIONS
--| 1. Scalar Function: One result for every single row, like CONCAT() function.
--| 2. Aggregate Function: One result for all rows, like SUM() returns one row representing sum
--| of all rows. They are: SUM(), MAX(), MIN(), COUNT(), AVERAGE()
# SELECT CURDATE();							--| Shows Current DATE
# SELECT RAND();								--| Creates a random number

--| ROUND(), CEILING(), FLOOR(), TRUNCATE()
# SELECT ROUND(RAND()*100, 0);

--| e.g. Create a random number that is less than 50 & notice MOD => %
# SELECT ROUND(RAND()*100,0) MOD 50;

# SELECT * FROM student ORDER BY RAND();
# SELECT CEILING(2.1);						    --| ROUND UP
# SELECT FLOOR(2.3);							    --| ROUND DOWN
# SELECT TRUNCATE(2.386466, 2);				--| TRUNCATE: simply removes two decimals; outputs 2.38
# SELECT ROUND(2.383466, 2);					--| ROUND: returns 2.39; compare with TRUNCATE()

--| POW(), SQRT(), LOG(), EXP()
# SELECT POW(2, 3); 				    			--| Power, outputs 8
# SELECT SQRT(16);  						    	--| Square Root; outputs 4
# SELECT LOG(10000, 10);		    			--| Logarithm
# SELECT EXP(2);	    			          --| ln in Logarithm, Euler
# SELECT PI();								        --| PI
# SELECT SIN(90);				    				  --| SIN()
# SELECT COS(90);					    			  --| COS()
# SELECT TAN(90);					    			  --| TANG()
# SELECT DEGREES(PI()/2);		    			--| Converts Degree to Radian; returns 90deg
# SELECT RADIANS(180);				    		--| Converts Radian to Degree; returns 3.141592653589793

--====================================================================================|
--=================================| Lesson 13 |======================================|
--====================================================================================|		  
--| IF Condition
# SELECT *, IF(mark >= 50, 'Passed', 'Failed') AS test_result FROM score;
# SELECT *, IF(salary > 25000, "Hight", "Low") as salaryRange FROM salary;

--| CASE WHEN THEN
SELECT *, CASE WHEN salary >= 32000 THEN 'High' 
			         WHEN salary >= 25000 THEN 'Medium'
			         WHEN salary >= 20000 THEN 'Low'
			         ELSE 'No Range' END AS salaryRange 
		  FROM employee;

--====================================================================================|
--=================================| Lesson 14 |======================================|
--====================================================================================|		  
--| IFNULL
# SELECT emp_id, firstName, IFNULL(lastName, '') AS lastName, salary FROM employee;
--| e.g. Cut 5% tax of employees' salary. If any salary cell is NULL, replace it with 0 
--| and round it to zero precision
# SELECT EmployeeID, FirstName, LastName, IFNULL(ROUND(Salary-(Salary*5/100),0), 0) AS netSalary FROM employees;


--| NULLIF
# SELECT teacher_id, firstName, NULLIF(lastName, firstName) AS lastName, salary FROM teacher;	--| Right
# SELECT teacher_id, firstName, NULLIF(firstName, lastName) AS lastName, salary FROM teacher;	--| Wrong 

# SELECT emp_id, emp_family_phone1, NULLIF(emp_family_phone2, emp_family_phone1)
  AS emp_family_phone2 FROM employee;

--| String Operators: IN, LIKE, BETWEEN
# SELECT * FROM teacher WHERE firstName IN ('Ali', 'Ahmad', 'Layla');

--| e.g. FirstName starts with 'A' containing at least 3 characters
# SELECT * FROM teacher WHERE firstName LIKE "A__%";

--| Select all fields between 'a' and 's'
# SELECT * FROM teacher WHERE firstName BETWEEN 'a' and 's';

--| Uppercase letters have lower ASCI code than lower case letters. So, in order to order
--| columns by observing ASCI code use BINARY ORDERING.
# SELECT * FROM teacher ORDER BY BINARY firstName ASC;

# SELECT '100' + '200';			--| outputs 300

--| CONCAT(), CONCAT_WS() WS -> With Symbol
# SELECT CONCAT(date_year, '/', date_month, '/', date_day) FROM employee;
# SELECT CONCAT_WS('/', date_year, date_month, date_day) FROM employee;

--| LTRIM(), RTRIM(), TRIM()
# SELECT LTRIM(firstName) FROM teacher;
# SELECT RTRIM("Ahmad   ") FROM teacher;

--| TRIM(DIRECTION 'symbol' FROM string_col)
--| DIRECTION = LEADING, TRAILING, BOTH
# SELECT TRIM(LEADING 'https://' FROM ads_url)) AS ads_url FROM advertisement;

--====================================================================================|
--================================== Lesson 15 =======================================|
--====================================================================================|		
--| LPAD(), RPAD()
--| LPAD(colName, length, symbol)
# SELECT LPAD(firstName, 5, '*') FROM teacher;

--| LOCATE(searchWord, colName)
# SELECT LOCATE('@', emp_email) FROM employee;
# SELECT student_id, CONCAT(std_firstName, ' ', std_lastName) AS name, student_phone, 
  IF(locate("+", student_phone) >0 , 'Valid Phone Number', 'Invalid Phone Number') 
  AS validPhone FROM student;

--| LENGTH(), REPLACE(colName, oldChar, newChar) 
# SELECT LENGTH(firstName) as FN_length FROM employee;
# SELECT REPLACE(emp_email, '@', 'AT') AS email FROM employee;
# UPDATE employee SET emp_email = REPLACE(emp_email, '@', 'AT');

--| SUBSTRING(colName, start, length) 
# SELECT SUBSTRING(emp_email, 1, 10) FROM employee;
# SELECT new_en_id, news_title, CONCAT(SUBSTRING(news_text, 1, 20), '...') 
  AS news_text FROM news_en;

--| SUBTRING_INDEX(string, delimiter, part)
--| moi.basir@gmail.com => moi.basir [part 1], gmail.com [part -1], 
--| see below 3rd parameter:
# SELECT SUBSTRING_INDEX(emp_email, '@', 1) FROM employee;
# SELECT SUBSTRING_INDEX(emp_email, '@', -1) FROM employee;

--| UPPER(), LOWER()
# SELECT UPPER(emp_firstName) AS name FROM employee;
# SELECT LOWER(emp_firstName) AS namae FROM employee;

--==========================| Date functions and operators
--| INTERVAL unit keyword
	* MICROSECOND
	* SECOND
	* MINUTE
	* HOUR
	* DAY
	* WEEK
	* MONTH
	* QUARTER 	--| Season
	* YEAR

--| e.g. Add 40 days to 2015-8-5
# SELECT '2015-8-5' + INTERVAL 40 DAY;
# SELECT '2015-8-5' + INTERVAL 1 MONTH;

--| CURDATE(), CURTIME(), DATE_FORMAT(), TIME_FORMAT(), DATEDIFF(), TIMEDIFF(), EXTRACT()
--| CURDATE(), CURTIME()
# SELECT CURDATE();			--| Shows  current date
# SELECT CURTIME();			--| Shows current time
# SELECT NOW();				--| Shows current date and time

--| DATE_FORMAT(date, format);
--| TIME_FORMAT(time, format);
# SELECT DATE_FORMAT(CURDATE(), '%W %b %Y');   		--| Tuesday Jan 2019
# SELECT DATE_FORMAT(curdate(), '%a /%c/ %Y'); 		--| Tue /1/ 2019

--| DATEDIFF(big_date, small_date) -> returns difference of 2 dates in days
# SELECT DATEDIFF(CURDATE(), emp_dob) DIV 365 AS age FROM employee;
# SELECT ROUND(DATEDIFF(CURDATE(), emp_dob) / 365,0) AS age FROM employee;

--| TIMEDIFF('time', 'time'), notice, use quotes!
# SELECT TIMEDIFF('13:17:01', '11:04:01');	--| 02:03:00

--| EXTRACT(what FROM date)
# SELECT EXTRACT(YEAR FROM CURDATE()) AS currentYear;	--| 2019
# SELECT EXTRACT(DAY FROM emp_dob) FROM employee;

--====================================================================================|
--========================= Lesson 15, 2nd Part (Illusoire) ==========================|
--====================================================================================|	
--| GROUP BY, is often used with aggregate functions to group the result-set by one or 
--| more columns.
# SELECT column_name FROM tbl_name WHERE condition 
  GROUP BY column_name(s) GROUP BY column_name(s);				--| Structure
# SELECT COUNT(CustomerID), Country FROM Customers GROUP BY Country;
# SELECT COUNT(std_firstName), dep_name FROM student 
  INNER JOIN department ON department.dep_id = student.department
  GROUP BY department;

--| HAVING, is added to SQL because WHERE keyword could not be used with aggregate functions.
--| e.g. this query include countries with more than 5 customers.
# SELECT COUNT(CustomerID), Country FROM Customers GROUP BY Country
  HAVING COUNT(CustomerID) > 5;
  
# SELECT Employees.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
  FROM (Orders INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID)
  GROUP BY LastName HAVING COUNT(Orders.OrderID) > 10;
  
# SELECT Employees.LastName, COUNT(Orders.OrderID) FROM Orders 
  INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
  WHERE LastName = 'Davolio' OR LastName = 'Fuller'
  GROUP BY LastName
  HAVING COUNT(Orders.OrderID) > 25;

--====================================================================================|
--================================== Lesson 16 =======================================|
--====================================================================================|	
--| Create User
# CREATE USER basir@localhost IDENTIFIED BY 'pAss123';
# SHOW GRANTS;

--| Grant & Revoke Keyword
# GRANT SELECT, UPDATE ON university.teacher TO basir@localhost;
# REVOKE SELECT, UPDATE ON university.teacher FROM basir@localhost;

--| All Privileges
# GRANT ALL PRIVILEGES ON dbs_name.tbl.name TO user_name@itsHost_name

--| All Privileges on all tables
# GRANT ALL PRIVILEGES ON university.* TO walid@localhost;

--| All privileges on all databases and all tables
# GRANT ALL PRIVILEGES ON *.* TO walid@localhost;

--| Grant assigning privileges to others by a user
# GRANT INSERT, UPDATE ON university.* TO walid@localhost WITH GRANT OPTION;

# FLUSH PRIVILEGES; --| Identical to refresh
# SHOW GRANTS;
# SHOW GRANTS FOR basir@localhost;

--| Change Password
# SET PASSWORD FOR noor@localhost = PASSWORD("1234");
# SET PASSWORD = PASSWORD("password");

--| Grant all privileges to basir except drop
# GRANT ALL PRIVILEGES ON *.* TO basir@localhost;
  REVOKE DROP ON *.* FROM basir@localhost;

--| Using Wild cards, 36:00
# GRANT DELETE ON univeristy.teacher TO '%@192.168.1.__'; --|Wild cards within Quotes

--| Dropping Users
# DROP USER noor@localhost;

--====================================================================================|
--================================== Lesson 17 =======================================|
--====================================================================================|	
--| VIEW, FUNCTION, PROCEDURE, TRIGGER =  stored queries
--=====================| VIEW: virtual table; is a stored select query
# CREATE VIEW view_name AS 
  SELECT fields FROM tbl_name WHERE condition; --| SELECT statement  <- 
# CREATE VIEW view_student_result AS 
  SELECT std.std_id AS ID, CONCAT(std.std_firstName, ' ', std.std_lastName) AS fullName,  
  std.std_email as Email, dept.dep_name AS Department, 
  IFNULL(sub.subject_name, '') AS Subject, 
  CASE WHEN score.chance = '1' THEN 'First' WHEN score.chance = '2' THEN 'Second' 
  WHEN score.chance = '3' THEN 'Third' END AS Chance, 
  IFNULL(score.mark, '') AS Score, IF(mark > 55, 'Passed', 'Failed') AS Result 
  FROM student std 
  LEFT JOIN score ON std.std_id = score.student_id 
  LEFT JOIN subject sub ON sub.subject_id = score.subject_id 
  LEFT JOIN department dept ON dept.dep_id = std.department;

# CREATE VIEW std_age AS 
  SELECT std_id, CONCAT(std_firstName, ' ', std_lastName) AS Name, 
  ROUND(DATEDIFF(CURDATE(), std_dob)/ 365, 0) AS Age FROM student;

--| To alter a view you have to go through all stages of query modification!
# ALTER VIEW std_age AS 
  SELECT std_id, CONCAT(std_firstName, ' ', std_lastName) AS Name, 
  ROUND(DATEDIFF(CURDATE(), std_dob)/ 365, 0) AS std_age 
  FROM student; --| changed age
  
--| Drop a view
# DROP VIEW view_student_result;

--=======================| PROCEDURE: doesn't return any value!
--| We cannot use PROCEDURE within queries because it doesn't returns any value.
# CREATE PROCEDURE procedure_name(param data_type)
  BEGIN
	Query1
	Query2
	Query n...
  END;

--| A PROCEDURE to search students by their 'id'
# CREATE PROCEDURE student_search(id int) 
  SELECT * FROM teacher WHERE std_id = id;
  
--| A PROCEDURE to search students by their 'name'
# CREATE PROCEDURE student_search(name varchar(32))
  SELECT * FROM student WHERE std_firstName = name;
  
--| A PROCEDURE that first SELECT thenceforth delete it
# \d//;
  CREATE PROCEDURE last_teacher(id INT)
  BEGIN
	SELECT * FROM teachers WHERE teacher_id = id;
	DELETE FROM teachers WHERE teacher_id = id;
  END// --| Look at this delimiter
  
--| PROCEDURE without parameter
# CREATE PROCEDURE myDate() SELECT DATE_FORMAT(CURDATE(), '%a %m %Y') AS 'Current Date';  

--| To invoke a PROCEDURE use the keyword CALL 
# CALL student_search('Habib');
# DROP PROCEDURE myDate();

--====================|FUNCTIONS, returns a value. So, they can be used within queries.
# CREATE FUNCTION perc(x int, y int) 
  RETURNS FLOAT
  RETURN x * y / 100;
  
--| e.g.
# UPDATE employee SET salary = salary - perc(salary, 5);  
# SELECT perc(1000, 10); --| return 10

--====================|Users Access to Procedures and Function 
# GRANT EXECUTE ON FUNCTION perc() TO basir@localhost;
# GRANT EXECUTE ON PROCEDURE student_search TO basir@localhost;

--====================================================================================|
--================================== Lesson 18 =======================================|
--====================================================================================|	
--| Trigger, for automatic maintenance
--| First make a backup_tbl similar to the table, then make TRIGGER
# CREATE TRIGGER tbl_name BEFORE||AFTER ACTION ON tbl_name FOR EACH ROW 
  BEGIN							    --| ACTION = INSERT, UPDATE, DELETE
	Query 1
	Query 2
	Query n ...
  END;
  
--| OLD -> Delete 
--| NEW -> INSERT 
--| OLD, NEW -> UPDATE

# CREATE TRIGGER bf_teacher_dlt 
  BEFORE DELETE ON teacher FOR EACH ROW --| Attention below, it is INSERT SELECT query
  INSERT INTO teacher_bkup SELECT OLD.teacher_id, OLD.teacher_firstName, 
  OLD.teacher_lastName, OLD.salary FROM teacher WHERE teacher_id = OLD.teacher_id;

--| Undo last deletion by another trigger on teacher_bkup, see code above^ 
  CREATE TRIGGER teacher_bkup_dlt BEFORE DELETE ON teacher_bkup
  INSERT INTO teacher SELECT OLD.teacher_id, OLD.teacher_firstName,
  OLD.teacher_lastName, OLD.salary 
  FROM teacher_bkup WHERE teacher_id = OLD.teacher_id;

--| Audit System Example, Track Changes Example
--| First create the trigger table.
# CREATE TABLE audit_system{
		audit_id INT PRIMARY KEY AUTO_INCREMENT,
		user_name VARCHAR(32) NOT NULL, 
		action_date DATETIME NOT NULL,
		teacher_id INT NOT NULL
  }
--| Next, create the trigger! Notice below, it isn't INSERT SELECT query
CREATE TRIGGER teacher_audit AFTER INSERT ON teachers FOR EACH ROW
INSERT INTO audit_system VALUES (NULL, USER(), NOW(), NEW.teacher_id);
  
# SHOW TRIGGERS;
# SHOW TRIGGERS LIKE 'tbl_name'; --| Showing TRIGGERS of a specific column











































