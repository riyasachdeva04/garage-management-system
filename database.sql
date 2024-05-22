-- TABLE CREATION

Declare
Begin
    Execute Immediate 'CREATE TABLE parts (
        part_id INT,
        part_name VARCHAR(100) NOT NULL,
        quantity INT DEFAULT 1,
        price DECIMAL(10, 2),
        manufacturer_name VARCHAR(100) NOT NULL,
        CONSTRAINT pk_parts PRIMARY KEY (part_id)
    )';
    Execute Immediate 'CREATE TABLE customer (
        cust_id INT,
        cust_name VARCHAR(100) NOT NULL,
        CONSTRAINT pk_cust PRIMARY KEY (cust_id)
    )';
    Execute Immediate '-- CREATE TABLE customer_contacts (
        cust_id INT,
        contact_info VARCHAR(100) UNIQUE NOT NULL,
        CONSTRAINT fk_customer_contacts FOREIGN KEY (cust_id) REFERENCES customer(cust_id) ON DELETE CASCADE
    )';
    Execute Immediate 'CREATE TABLE department (
        dept_id INT,
        dept_name VARCHAR(100),
        CONSTRAINT pk_department PRIMARY KEY (dept_id)
    )';
    Execute Immediate 'CREATE TABLE employee (
        emp_id INT,
        first_name VARCHAR(100),
        last_name VARCHAR(100),
        dept_id INT NOT NULL,
        date_of_join DATE,
        CONSTRAINT pk_emp PRIMARY KEY (emp_id),
        CONSTRAINT fk_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE CASCADE
    )';
    Execute Immediate 'CREATE TABLE salary (
        emp_id INT,
    	account_number INT,
    	base_salary DECIMAL(10, 2),
        CONSTRAINT pk_account PRIMARY KEY (account_number),
        CONSTRAINT fk_empid FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE)';
    Execute Immediate 'CREATE TABLE employee_contacts (
        emp_id INT,
        emp_info VARCHAR(30),
        CONSTRAINT fk_emp_contacts FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE
    )';
    Execute Immediate 'CREATE TABLE orders (
        order_id INT,
        cust_id INT,
        emp_id INT,
        order_date DATE,
        part_id INT,
        quantity INT DEFAULT 1,
        CONSTRAINT pk_order PRIMARY KEY (order_id),
        CONSTRAINT fk_cust FOREIGN KEY (cust_id) REFERENCES customer(cust_id) ON DELETE CASCADE,
        CONSTRAINT fk_emp FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
        CONSTRAINT fk_part FOREIGN KEY (part_id) REFERENCES parts(part_id) ON DELETE CASCADE)';  
End;

-- drop table parts;
-- drop table customer;
-- drop table employee;
-- drop table orders;
-- drop table customer_contacts;
-- drop table employee_contacts;
-- drop table salary;
-- drop table department;

-- PACKAGE
CREATE OR REPLACE PACKAGE OrderManagement AS
    PROCEDURE PlaceOrder(order_id In Int, cust_id In Int, emp_id In Int,order_date In DATE,part_id In Int, quantity In Int);
    PROCEDURE CancelOrder(order_id IN INT);
END OrderManagement;


CREATE OR REPLACE PACKAGE BODY OrderManagement AS
    PROCEDURE PlaceOrder(order_id In Int, cust_id In Int, emp_id In Int,order_date In DATE,part_id In Int, quantity In Int) IS
    BEGIN
        -- Implementation of order placement logic
        INSERT INTO orders VALUES (order_id, cust_id, emp_id, order_date, part_id, quantity);
        -- UPDATE customer SET total_orders = total_orders + 1 WHERE cust_id = cust_id;
    END PlaceOrder;
    
    PROCEDURE CancelOrder(order_id IN INT) IS
    BEGIN
        -- Implementation of order cancellation logic
        DELETE FROM orders WHERE order_id = order_id;
        -- Decrement total_orders of customer
        -- UPDATE customer SET total_orders = total_orders - 1 WHERE cust_id IN (SELECT cust_id FROM orders WHERE order_id = order_id);
    END CancelOrder;
END OrderManagement;

-- VIEW
CREATE OR REPLACE VIEW OrderDetails AS
    SELECT o.order_id, c.cust_name, e.first_name || ' ' || e.last_name AS emp_name, o.order_date, p.part_name, o.quantity
    FROM orders o
    JOIN customer c ON o.cust_id = c.cust_id
    JOIN employee e ON o.emp_id = e.emp_id
    JOIN parts p ON o.part_id = p.part_id;

--PROCEDURES
--PARTS
Create Or Replace Procedure Addparts(part_id In Int,part_name In Varchar,quantity In Int,price In NUMBER,manufacturer_name In Varchar)
Is
Begin
Insert Into Parts Values(part_id,part_name,quantity,price,manufacturer_name); 
End Addparts;

Declare
    part_id parts.part_id%Type;
    part_name Parts.part_name%Type;
    quantity Parts.quantity%Type;
    price Parts.price%Type;
    manufacturer_name Parts.manufacturer_name%Type;
BEGIN
    part_id := 101	/*&part_id*/;
    part_name := 'engine'	/*'&part_name'*/;
    quantity := 10	/*&quantity*/;
    price := 95000	/*&price*/;
    manufacturer_name := 'Honda'	/*'&manufacturer_name'*/;
        Addparts(part_id, part_name, quantity, price, manufacturer_name);
END;

Desc Parts;
Select * From Parts;

--CUSTOMER
Create Or Replace Procedure Addcust(Cust_Id In Int,Cust_Name In Varchar)
Is
Begin
    Insert Into Customer Values(Cust_Id,Cust_Name); 
End Addcust;

Declare
    Cust_Id Customer.Cust_Id%Type;
    Cust_Name Customer.Cust_Name%Type;
Begin
    Cust_id := 007	/*&Cust_id*/;
    Cust_name := 'Denis'	/*'&Cust_name'*/;
    Addcust(Cust_Id,Cust_Name);
End;

Desc Customer;
Select * From Customer;

--CUSTOMER CONTACTS
Create Or Replace Procedure Addcustcontact(Cust_Id In Int,Contact_Info In Varchar)
Is
Begin
    Insert Into Customer_Contacts Values(Cust_Id, Contact_Info); 
End Addcustcontact;

Declare
    Cust_Id Customer_Contacts.Cust_Id%Type;
    Contact_Info Customer_Contacts.Contact_Info%Type;
Begin
    Cust_id := 007	/*&Cust_id*/;
    Contact_info := 'Den@mail.com'	/*&Contact_info*/;
    Addcustcontact(Cust_Id,Contact_Info);
End;

Desc Customer_Contacts;
Select * From Customer_Contacts;

--DEPARTMENT
Create Or Replace Procedure Adddepartment(Dept_Id In Int,Dept_Name In Varchar)
Is
Begin
    Insert Into Department Values(Dept_Id,Dept_Name); 
End Adddepartment;

Declare
    Dept_Id Department.Dept_Id%Type;
    Dept_Name Department.Dept_Name%Type;
Begin
    Dept_id := 23	/*&Dept_id*/;
    Dept_Name := 'Sales'	/*'&Dept_Name'*/;
    Adddepartment(Dept_id, Dept_Name);
End;

Desc Department;
Select * From Department;



--EMPLOYEE
Create Or Replace Procedure Addemp(Emp_Id In Int,First_Name In Varchar, Last_Name In Varchar,Dept_ID In INT, Date_join In DATE)
Is
Begin
    Insert Into Employee Values(Emp_Id,First_Name,Last_Name,Dept_ID,Date_join); 
End Addemp;



Declare
    Emp_Id Employee.Emp_Id%Type;
    Emp_First Employee.First_Name%Type;
    Emp_Last Employee.Last_Name%Type;
    Dept_ID Employee.Dept_ID%Type;
    Date_join Employee.Date_of_join%Type;
Begin
    Emp_id := 12	/*&Emp_id*/;
    Emp_First := 'Yavisht'	/*'&Emp_First'*/;
    Emp_Last := 'Gupta'	/*'&Emp_Last'*/;
	Dept_id := 23	/*&Dept_id*/;
    Date_join := TO_DATE('2023-05-12', 'YYYY-MM-DD')	/*'&Date_join'*/;
    Addemp(Emp_Id,Emp_First, Emp_Last, Dept_id, Date_join);
End;


Desc Employee;
Select * From Employee;


--EMPLOYEE CONTACTS
Create Or Replace Procedure Addempcontact(Emp_Id In Int,Emp_Info In Varchar)
Is
Begin
    Insert Into Employee_Contacts Values(Emp_Id, Emp_Info); 
End Addempcontact;



Declare
    Emp_Id Employee_Contacts.Emp_Id%Type;
    Emp_Info Employee_Contacts.Emp_Info%Type;
Begin
    Emp_id := 12	/*&Emp_id*/;
    Emp_info := 'yav@mail.com'	/*&Emp_info*/;
    Addempcontact(Emp_Id,Emp_Info);
End;



Desc Employee_Contacts;
Select * From Employee_Contacts;



--SALARY
Create Or Replace Procedure Addsalary(Emp_Id In Int, Acc_no In Int, Base_salary In Float)
Is
Begin
    Insert Into Salary Values(Emp_Id, Acc_no, Base_salary); 
End Addsalary;



Declare
    Emp_Id Salary.Emp_Id%Type;
    Acc_no Salary.Account_number%Type;
	Base_salary Salary.Base_salary%Type;
Begin
    Emp_id := 12	/*&Emp_id*/;
    Acc_no := 1022836	/*&Acc_no*/;
    Base_salary := 100000.00 	/*&Base_Salary*/;
    Addsalary(Emp_id, Acc_no, Base_salary);
End;



Desc Salary;
Select * From Salary;



--orders
--using package OrderManagement

Declare
    order_id orders.order_id%Type;
    cust_id orders.cust_id%Type;
    emp_id orders.emp_id%Type;
    order_date orders.order_date%Type;
    part_id orders.part_id%Type;
	quantity orders.Quantity%Type;
BEGIN
    order_id := 1002	/*&order_id*/;
    cust_id := 007	/*'&order_name'*/;
    emp_id := 12	/*&emp_id*/;
    order_date := TO_DATE('2024-08-05', 'YYYY-MM-DD')	/*'&order_date'*/;
    part_id := 101	/*&part_id*/;
	quantity := 35	/*&quantity*/;
    
    OrderManagement.Placeorder(order_id, cust_id, emp_id, order_date, part_id, quantity);
END;

Desc orders;
Select * From orders;

-- FUNCTIONS

CREATE OR REPLACE FUNCTION TotalParts
RETURN INT AS
    Total_Part INT := 0;
BEGIN
    SELECT COUNT(*) INTO Total_Part
    FROM Parts;
    
    RETURN Total_Part;
END TotalParts;


Create Or Replace Function Totalcustomers
Return int as 
   Total_customers int := 0;
 Begin 
   Select Count(*) Into Total_customers
   From Customer; 
 Return Total_customers; 
End Totalcustomers;


Create Or Replace Function Totalemployees
Return int as 
   Total_employees int := 0;
 Begin 
   Select Count(*) Into Total_employees 
   From Employee; 
 Return Total_employees; 
End Totalemployees;


Create Or Replace Function Totalorders
Return int as 
   Total_orders int := 0;
 Begin 
   Select Count(*) Into Total_orders 
   From Orders; 
 Return Total_orders; 
End Totalorders;


CREATE OR REPLACE FUNCTION CalculateCommission(Emp_Id_in IN INT)
RETURN int
IS
    TotalCommission int := 0;
    Part_price parts.price%type;
BEGIN
    FOR OrderRow IN (SELECT * FROM Orders WHERE Emp_Id = Emp_Id_in) LOOP
         SELECT price FROM parts INTO part_price WHERE part_id=OrderRow.part_id;
         TotalCommission := TotalCommission + (part_price * OrderRow.quantity * 0.1);
    END LOOP;
    RETURN TotalCommission;
END CalculateCommission;

DECLARE
    Total_Parts int;
    Total_Customers int;
    Total_Employees int;
    Total_Orders int;
BEGIN
    -- Call the functions to get the totals
    Total_Parts := TotalParts();
    Total_Customers := Totalcustomers();
    Total_Employees := Totalemployees();
    Total_Orders := Totalorders();

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Total number of parts: ' || Total_Parts);
    DBMS_OUTPUT.PUT_LINE('Total number of customers: ' || Total_Customers);
    DBMS_OUTPUT.PUT_LINE('Total number of employees: ' || Total_Employees);
    DBMS_OUTPUT.PUT_LINE('Total number of orders: ' || Total_Orders);

    -- Output commission for each employee
    FOR EmpRow IN (SELECT DISTINCT Emp_Id FROM Orders) LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ' || EmpRow.Emp_Id || ' commission: ' || CalculateCommission(EmpRow.Emp_Id));
    END LOOP;
END;

--TRIGGERS
CREATE OR REPLACE TRIGGER PreventPartDeletion
BEFORE DELETE ON parts
FOR EACH ROW
DECLARE
    part_count NUMBER;
    part_name VARCHAR2(255);
BEGIN
    SELECT COUNT(*) INTO part_count FROM parts WHERE part_id = :OLD.part_id;
    IF part_count > 0 THEN
        SELECT part_name INTO part_name FROM parts WHERE part_id = :OLD.part_id;
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete part: ' || part_name);
    END IF;
END;

CREATE OR REPLACE TRIGGER order_placed_trigger
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE parts
    SET quantity = quantity - :NEW.quantity
    WHERE part_id = :NEW.part_id;
END;
