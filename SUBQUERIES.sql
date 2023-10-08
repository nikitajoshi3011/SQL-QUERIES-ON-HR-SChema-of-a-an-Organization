use hr;

-- 1. Name of dept where lex works

-- First solution using joins
SELECT 
    d.department_name, e.first_name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    first_name = 'Lex';


-- Second solution using subqueries
SELECT 
    department_name
FROM
    departments
WHERE
    department_id = (SELECT 
            department_id
        FROM
            employees
        WHERE
            first_name = 'Lex');
            
            
            
-- 2.Give the name of the employees working in sales dept
-- First solution using joins
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Name of the employee',
    e.department_id,
    department_name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    department_name = 'Sales';
    
    
-- Second solution using subquery
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Name of the employee',
    department_id
FROM
    employees
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            departments
        WHERE
            department_name = 'Sales');
            
            
            
-- 3.Display the employees with salary greater than avg salary of the organization
-- Using subqueries
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Name of the employees whose salary is more than avg of salary'
FROM
    employees
WHERE
    salary > ALL (SELECT 
            AVG(salary)
        FROM
            employees);
            
            
            
-- Display the names of dept where employees with salary greater than 10000 works
SELECT 
    department_name
FROM
    departments
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            employees
        WHERE
            salary > 10000);   
            
            
            
-- Display employees with salary greater than salary of any employees from sales dept
SELECT 
    first_name
FROM
    employees
WHERE
    salary > ANY (SELECT 
            salary
        FROM
            employees
        WHERE
            department_id = (SELECT 
                    department_id
                FROM
                    departments
                WHERE
                    department_name = 'Sales'));
                    
                    
                    
-- Display employees with salary greater than salary of all employees from sales dept
SELECT 
    first_name
FROM
    employees
WHERE
    salary > ALL (SELECT 
            salary
        FROM
            employees
        WHERE
            department_id = (SELECT 
                    department_id
                FROM
                    departments
                WHERE
                    department_name = 'Sales'));
                    
                    
                    
-- Find the department name of the employees whose name starts with a
SELECT 
    department_name
FROM
    departments
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            employees
        WHERE
            first_name LIKE 'a%');
            
            
            
-- Find people who joined before either David or Jennifer
SELECT 
    CONCAT(first_name, ' ', last_name) 'Name of the employee whose hire_date is less than either David or Jeniffer',
    hire_date
FROM
    employees
WHERE
    hire_date < ANY (SELECT 
            hire_date
        FROM
            employees
        WHERE
            first_name IN ('Jennifer' , 'David'));
            
            
            
-- Find out the employees who are working from London office
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'Name of the employee operating from London office'
FROM
    employees
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            departments
        WHERE
            location_id IN (SELECT 
                    location_id
                FROM
                    locations
                WHERE
                    city = 'London'));
                    
                    
                    
-- Display employees with salary greater than avg salary of their own dept

SELECT 
    *
FROM
    employees e1
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees e2
        WHERE
            e1.department_id = e2.department_id);
            
            
            
-- Find out employees with the same designation and joinin year as David
SELECT 
    *
FROM
    employees
WHERE
    ROW( YEAR(hire_date) , job_id) IN (SELECT 
            YEAR(hire_date), job_id
        FROM
            employees
        WHERE
            first_name = 'David'); 
            
            
            
-- Give the summary of organization as on today in terms of
-- number of employees
-- number of locations from which organization is operating
-- total payroll
select current_date() as 'Date Today',
(select count(*) from employees) as 'Number of Employees',
(select count(*) from locations) as 'Location Count',
(select sum(salary) from employees) as 'Total Payroll';



-- For each employee calculate the deviation of his/her salary from avg salary of organization
SELECT 
    salary - (SELECT 
            AVG(salary)
        FROM
            employees) AS 'Deviation from avg Salary',
    CONCAT(first_name, ' ', last_name) AS 'Name of the employee'
FROM
    employees;
    
    
    
-- Calculate total earning for the employees who get some commission
SELECT 
    salary + commission_pct
FROM
    (SELECT 
        salary, commission_pct
    FROM
        employees
    WHERE
        commission_pct IS NOT NULL) AS Commission;
        
        
        
-- Display the names of departments where the avg salary of the dept is more than Jenniffer's salary
SELECT 
    department_name
FROM
    departments
WHERE
    department_id IN (SELECT 
            department_id
        FROM
            employees
        GROUP BY department_id
        HAVING AVG(salary) > ANY (SELECT 
                salary
            FROM
                employees
            WHERE
                first_name = 'Jennifer'));