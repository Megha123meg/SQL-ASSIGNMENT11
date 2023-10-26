CREATE DATABASE practice_sql;

USE practice_sql;

/*Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
The CountryCode for America is USA.*/
SELECT * FROM CITY WHERE POPULATION>100000 AND COUNTRYCODE='USA'; 

/*Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
The CountryCode for America is USA.*/
SELECT NAME FROM CITY WHERE POPULATION>120000 AND COUNTRYCODE='USA';

/*Q3. Query all columns (attributes) for every row in the CITY table.*/
SELECT * FROM CITY;

/*Q4. Query all columns for a city in CITY with the ID 1661.*/
SELECT * FROM CITY WHERE ID=1661;

/*Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is
JPN.*/
SELECT * FROM CITY WHERE COUNTRYCODE='JPN';

/*Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is
JPN.*/
SELECT NAME FROM CITY WHERE COUNTRYCODE='JPN';

CREATE TABLE STATIONARY(
Id INT PRIMARY KEY,
City VARCHAR(20),
State VARCHAR(20),
Lat_N INT,
Long_W INT);

/*Q7. Query a list of CITY and STATE from the STATION table.*/
SELECT City,State FROM STATIONARY;

/*Q8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results
in any order, but exclude duplicates from the answer.*/
SELECT CITY FROM STATIONARY WHERE ID%2=0;

/*Find the difference between the total number of CITY entries in the table and the number of
distinct CITY entries in the table.*/
SELECT COUNT(CITY)-COUNT(DISTINCT(CITY)) FROM STATIONARY;

/*Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
largest city, choose the one that comes first when ordered alphabetically.*/
WITH RankedCities AS (
    SELECT CITY, LEN(CITY) AS NameLength,
           ROW_NUMBER() OVER (ORDER BY LEN(CITY), CITY) AS AscRank,
           ROW_NUMBER() OVER (ORDER BY LEN(CITY) DESC, CITY) AS DescRank
    FROM STATIONARY
)
SELECT CITY, NameLength
FROM RankedCities
WHERE AscRank = 1 OR DescRank = 1;


/*Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result
cannot contain duplicates.*/
SELECT DISTINCT(CITY) FROM STATIONARY WHERE CITY LIKE '[aeiou]%';

/*Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot
contain duplicates.*/
SELECT DISTINCT(CITY) FROM STATIONARY WHERE CITY LIKE '%[aeiou]';

/*Q13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot
contain duplicates.*/
SELECT DISTINCT(CITY) FROM STATIONARY WHERE CITY LIKE '[^aeiou]%';

/*Q14. Query the list of CITY names from STATION that do not end with vowels. Your result cannot
contain duplicates.*/
SELECT DISTINCT(CITY) FROM STATIONARY WHERE CITY LIKE '%[^aeiou]';

/*Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end
with vowels. Your result cannot contain duplicates.*/
SELECT DISTINCT(CITY) FROM STATIONARY WHERE CITY NOT LIKE '[aeiou]%' OR CITY NOT LIKE '%[aeiou]';

/*Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with
vowels. Your result cannot contain duplicates.*/
SELECT DISTINCT(CITY) FROM STATIONARY WHERE CITY NOT LIKE '[aeiou]%' AND CITY NOT LIKE '%[aeiou]';

/*Q17.
Table: Product
Column Name Type
product_id int
product_name varchar
unit_price int
product_id is the primary key of this table.
Each row of this table indicates the name and the price of each product.
Table: Sales
Column Name Type
seller_id int
product_id int
buyer_id int
sale_date date
quantity int
price int
This table has no primary key, it can have repeated rows.

product_id is a foreign key to the Product table.
Each row of this table contains some information about one sale.

Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
between 2019-01-01 and 2019-03-31 inclusive.
Return the result table in any order.
The query result format is in the following example.
Input:
Product table:
product_id product_name unit_price
1 S8 1000
2 G4 800
3 iPhone 1400

Sales table:
seller_id product_id buyer_id sale_date quantity price
1 1 1 2019-01-21 2 2000
1 2 2 2019-02-17 1 800
2 2 3 2019-06-02 1 800
3 3 4 2019-05-13 2 2800
Output:
product_id product_name
1 S8
Explanation:
The product with id 1 was only sold in the spring of 2019.
The product with id 2 was sold in the spring of 2019 but was also sold after the spring of 2019.
The product with id 3 was sold after spring 2019.
We return only product 1 as it is the product that was only sold in the spring of 2019.*/
CREATE TABLE PRODUCT(
PRODUCT_ID INT PRIMARY KEY,
PRODUCT_NAME VARCHAR(20),
UNIT_PRICE INT);

CREATE TABLE SALES(
SELLER_ID INT,
PRODUCT_ID INT,
BUYER_ID INT,
SALE_DATE DATE,
QUANTITY INT,
PRICE INT);

INSERT INTO PRODUCT
VALUES
(1,'S8',1000),
(2,'G4',800),
(3,'IPHONE',1400);

INSERT INTO SALES
VALUES
    (1, 1, 1, '2019-01-21', 2, 2000),
    (1, 2, 2, '2019-02-17', 1, 800),
    (2, 2, 3, '2019-06-02', 1, 800),
    (3, 3, 4, '2019-05-13', 2, 2800);

SELECT product_id, product_name
FROM Product
WHERE product_id NOT IN (
    SELECT DISTINCT S.product_id
    FROM Sales AS S
    WHERE sale_date < '2019-01-01' OR sale_date > '2019-03-31'
);

/*Q18.
Table: Views
Column Name Type
article_id int
author_id int
viewer_id int
view_date date
There is no primary key for this table, it may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some
date.
Note that equal author_id and viewer_id indicate the same person.

Write an SQL query to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.
The query result format is in the following example.
Input:
Views table:
article_id author_id viewer_id view_date
1 3 5 2019-08-01
1 3 6 2019-08-02
2 7 7 2019-08-01
2 7 6 2019-08-02
4 7 1 2019-07-22
3 4 4 2019-07-21
3 4 4 2019-07-21
Output:
id
4
7*/

CREATE TABLE Views (
    article_id int,
    author_id int,
    viewer_id int,
    view_date date
);


INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES
    (1, 3, 5, '2019-08-01'),
    (1, 3, 6, '2019-08-02'),
    (2, 7, 7, '2019-08-01'),
    (2, 7, 6, '2019-08-02'),
    (4, 7, 1, '2019-07-22'),
    (3, 4, 4, '2019-07-21'),
    (3, 4, 4, '2019-07-21');

SELECT DISTINCT author_id
FROM Views
WHERE author_id = viewer_id;

/*Q19.
Table: Delivery
Column Name Type
delivery_id int
customer_id int
order_date date
customer_pref_delivery_date date

delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and
specify a preferred delivery date (on the same order date or after it).

If the customer's preferred delivery date is the same as the order date, then the order is called
immediately; otherwise, it is called scheduled.
Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal
places.
The query result format is in the following example.
Input:
Delivery table:
delivery_id customer_id order_date

customer_pref_
delivery_date
1 1 2019-08-01 2019-08-02
2 5 2019-08-02 2019-08-02
3 1 2019-08-11 2019-08-11
4 3 2019-08-24 2019-08-26
5 4 2019-08-21 2019-08-22
6 2 2019-08-11 2019-08-13*/

-- Create Delivery table
CREATE TABLE Delivery (
    delivery_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    customer_pref_delivery_date DATE
);

-- Insert data into Delivery table
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date) VALUES
    (1, 1, '2019-08-01', '2019-08-02'),
    (2, 5, '2019-08-02', '2019-08-02'),
    (3, 1, '2019-08-11', '2019-08-11'),
    (4, 3, '2019-08-24', '2019-08-26'),
    (5, 4, '2019-08-21', '2019-08-22'),
    (6, 2, '2019-08-11', '2019-08-13');
SELECT 
    ROUND(
        (SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1.0 ELSE 0 END) 
        / COUNT(*)) * 100, 
        2
    ) as immediate_percentage
FROM Delivery;


/*Q20.
Table: Ads
Column Name Type
ad_id int
user_id int
action enum
(ad_id, user_id) is the primary key for this table.
Each row of this table contains the ID of an Ad, the ID of a user, and the action taken by this user
regarding this Ad.
The action column is an ENUM type of ('Clicked', 'Viewed', 'Ignored').

A company is running Ads and wants to calculate the performance of each Ad.
Performance of the Ad is measured using Click-Through Rate (CTR) where:

Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a
tie.
The query result format is in the following example.
Input:
Ads table:
ad_id user_id action
1 1 Clicked
2 2 Clicked
3 3 Viewed
5 5 Ignored
1 7 Ignored
2 7 Viewed
3 5 Clicked
1 4 Viewed
2 11 Viewed
1 2 Clicked*/

-- Create Ads table
CREATE TABLE Ads (
    ad_id INT,
    user_id INT,
    action VARCHAR(10),
    PRIMARY KEY (ad_id, user_id)
);

-- Insert data into Ads table
INSERT INTO Ads (ad_id, user_id, action) VALUES
    (1, 1, 'Clicked'),
    (2, 2, 'Clicked'),
    (3, 3, 'Viewed'),
    (5, 5, 'Ignored'),
    (1, 7, 'Ignored'),
    (2, 7, 'Viewed'),
    (3, 5, 'Clicked'),
    (1, 4, 'Viewed'),
    (2, 11, 'Viewed'),
    (1, 2, 'Clicked');

SELECT ad_id,
    CASE 
        WHEN COUNT(CASE WHEN action IN ('Clicked') THEN 1 ELSE NULL END) = 0 THEN 0
        ELSE ROUND(SUM(CASE WHEN action = 'Clicked' THEN 1
                       
                       ELSE 0 END) * 100.0 / 
                       NULLIF(COUNT(CASE WHEN action IN ('Clicked', 'Viewed') THEN 1 ELSE NULL END), 0), 2)
    END AS ctr
FROM Ads
GROUP BY ad_id
ORDER BY ctr DESC, ad_id;

/*Table: Employee
Column Name Type
employee_id int
team_id int
employee_id is the primary key for this table.
Each row of this table contains the ID of each employee and their respective team.

Write an SQL query to find the team size of each of the employees.
Return result table in any order.
The query result format is in the following example.
Input:
Employee Table:
employee_id team_id
1 8
2 8
3 8
4 7
5 9
6 9*/
-- Create Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    team_id INT
);

-- Insert data into Employee table
INSERT INTO Employee (employee_id, team_id) VALUES
    (1, 8),
    (2, 8),
    (3, 8),
    (4, 7),
    (5, 9),
    (6, 9);

SELECT 
    e.employee_id, 
    t.team_size
FROM 
    Employee e
JOIN 
    (SELECT team_id, COUNT(employee_id) as team_size FROM Employee GROUP BY team_id) t
ON 
    e.team_id = t.team_id;

/*Q22.
Table: Countries
Column Name Type
country_id int
country_name varchar
country_id is the primary key for this table.
Each row of this table contains the ID and the name of one country.

Table: Weather
Column Name Type
country_id int
weather_state int
day date
(country_id, day) is the primary key for this table.
Each row of this table indicates the weather state in a country for one day.

Write an SQL query to find the type of weather in each country for November 2019.
The type of weather is:
● Cold if the average weather_state is less than or equal 15,
● Hot if the average weather_state is greater than or equal to 25, and
● Warm otherwise.
Return result table in any order.
The query result format is in the following example.
Input:
Countries table:
country_id country_name
2 USA
3 Australia
7 Peru
5 China
8 Morocco
9 Spain

Weather table:
country_id weather_state day
2 15 2019-11-01
2 12 2019-10-28

2 12 2019-10-27
3 -2 2019-11-10
3 0 2019-11-11
3 3 2019-11-12
5 16 2019-11-07
5 18 2019-11-09
5 21 2019-11-23
7 25 2019-11-28
7 22 2019-12-01
7 20 2019-12-02
8 25 2019-11-05
8 27 2019-11-15
8 31 2019-11-25
9 7 2019-10-23
9 3 2019-12-23*/

-- Create Countries table
CREATE TABLE Countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(255)
);

-- Create Weather table
CREATE TABLE Weather (
    country_id INT,
    weather_state INT,
    day DATE,
    PRIMARY KEY (country_id, day)
);

-- Insert data into Countries table
INSERT INTO Countries (country_id, country_name) VALUES
    (2, 'USA'),
    (3, 'Australia'),
    (7, 'Peru'),
    (5, 'China'),
    (8, 'Morocco'),
    (9, 'Spain');

-- Insert data into Weather table
INSERT INTO Weather (country_id, weather_state, day) VALUES
    (2, 15, '2019-11-01'),
    (2, 12, '2019-10-28'),
    (2, 12, '2019-10-27'),
    (3, -2, '2019-11-10'),
    (3, 0, '2019-11-11'),
    (3, 3, '2019-11-12'),
    (5, 16, '2019-11-07'),
    (5, 18, '2019-11-09'),
    (5, 21, '2019-11-23'),
    (7, 25, '2019-11-28'),
    (7, 22, '2019-12-01'),
    (7, 20, '2019-12-02'),
    (8, 25, '2019-11-05'),
    (8, 27, '2019-11-15'),
    (8, 31, '2019-11-25'),
    (9, 7, '2019-10-23'),
    (9, 3, '2019-12-23');

SELECT c.country_name, 
       CASE 
           WHEN AVG(w.weather_state) <= 15 THEN 'Cold'
           WHEN AVG(w.weather_state) >= 25 THEN 'Hot'
           ELSE 'Warm'
       END as weather_type
FROM Countries c
JOIN Weather w
ON c.country_id = w.country_id
WHERE w.day >= '2019-11-01' AND w.day <= '2019-11-30'
GROUP BY c.country_name;


/*Q23.
Table: Prices
Column Name Type
product_id int
start_date date
end_date date
price int
(product_id, start_date, end_date) is the primary key for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two
intersecting periods for the same product_id.

Table: UnitsSold
Column Name Type
product_id int
purchase_date date
units int
There is no primary key for this table, it may contain duplicates.
Each row of this table indicates the date, units, and product_id of each product sold.

Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places.
Return the result table in any order.
The query result format is in the following example.

Input:
Prices table:
product_id start_date end_date price
1 2019-02-17 2019-02-28 5
1 2019-03-01 2019-03-22 20
2 2019-02-01 2019-02-20 15
2 2019-02-21 2019-03-31 30

UnitsSold table:
product_id purchase_date units
1 2019-02-25 100
1 2019-03-01 15
2 2019-02-10 200
2 2019-03-22 30*/

-- Create Prices table
CREATE TABLE Prices (
    product_id INT,
    start_date DATE,
    end_date DATE,
    price INT,
    PRIMARY KEY (product_id, start_date, end_date)
);

-- Create UnitsSold table
CREATE TABLE UnitsSold (
    product_id INT,
    purchase_date DATE,
    units INT
);

-- Insert data into Prices table
INSERT INTO Prices (product_id, start_date, end_date, price) VALUES
    (1, '2019-02-17', '2019-02-28', 5),
    (1, '2019-03-01', '2019-03-22', 20),
    (2, '2019-02-01', '2019-02-20', 15),
    (2, '2019-02-21', '2019-03-31', 30);

-- Insert data into UnitsSold table
INSERT INTO UnitsSold (product_id, purchase_date, units) VALUES
    (1, '2019-02-25', 100),
    (1, '2019-03-01', 15),
    (2, '2019-02-10', 200),
    (2, '2019-03-22', 30);

SELECT us.product_id,
       ROUND(SUM(p.price * us.units) * 1.0 / SUM(us.units), 2) AS average_price
FROM UnitsSold us
JOIN Prices p
ON us.product_id = p.product_id
   AND us.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY us.product_id;

/*Q24.
Table: Activity
Column Name Type
player_id int
device_id int
event_date date
games_played int
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before
logging out on someday using some device.

Write an SQL query to report the first login date for each player.
Return the result table in any order.
The query result format is in the following example.
Input:
Activity table:
player_id device_id event_date games_played
1 2 2016-03-01 5
1 2 2016-05-02 6
2 3 2017-06-25 1
3 1 2016-03-02 0
3 4 2018-07-03 5*/

-- Create Activity table
CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT,
    PRIMARY KEY (player_id, event_date)
);

-- Insert data into Activity table
INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES
    (1, 2, '2016-03-01', 5),
    (1, 2, '2016-05-02', 6),
    (2, 3, '2017-06-25', 1),
    (3, 1, '2016-03-02', 0),
    (3, 4, '2018-07-03', 5);

SELECT player_id, MIN(event_date) as first_login
FROM Activity
GROUP BY player_id;

/*Q25.
Table: Activity
Column Name Type
player_id int
device_id int
event_date date
games_played int
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before
logging out on someday using some device.

Write an SQL query to report the device that is first logged in for each player.
Return the result table in any order.
The query result format is in the following example.
Input:
Activity table:
player_id device_id event_date games_played
1 2 2016-03-01 5
1 2 2016-05-02 6
2 3 2017-06-25 1
3 1 2016-03-02 0
3 4 2018-07-03 5*/

-- Create Activity table
CREATE TABLE Activity1 (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT,
    PRIMARY KEY (player_id, event_date)
);

-- Insert data into Activity table
INSERT INTO Activity1 (player_id, device_id, event_date, games_played) VALUES
    (1, 2, '2016-03-01', 5),
    (1, 2, '2016-05-02', 6),
    (2, 3, '2017-06-25', 1),
    (3, 1, '2016-03-02', 0),
    (3, 4, '2018-07-03', 5);

SELECT a.player_id, a.device_id
FROM Activity1 a
JOIN (
    SELECT player_id, MIN(event_date) as first_login
    FROM Activity1
    GROUP BY player_id
) b ON a.player_id = b.player_id AND a.event_date = b.first_login;

/*Q26.
Table: Products
Column Name Type
product_id int
product_name varchar
product_category varchar
product_id is the primary key for this table.
This table contains data about the company's products.

Table: Orders
Column Name Type
product_id int
order_date date
unit int
There is no primary key for this table. It may have duplicate rows.
product_id is a foreign key to the Products table.
unit is the number of products ordered in order_date.

Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
and their amount.
Return result table in any order.
The query result format is in the following example.
Input:
Products table:
product_id product_name

product_catego
ry

1

Leetcode
Solutions Book

2

Jewels of
Stringology Book
3 HP Laptop
4 Lenovo Laptop
5 Leetcode Kit T-shirt

Orders table:
product_id order_date unit
1 2020-02-05 60
1 2020-02-10 70
2 2020-01-18 30
2 2020-02-11 80
3 2020-02-17 2
3 2020-02-24 3
4 2020-03-01 20
4 2020-03-04 30
4 2020-03-04 60
5 2020-02-25 50
5 2020-02-27 50
5 2020-03-01 50*/

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_category VARCHAR(255)
);

-- Create Orders table
CREATE TABLE Orders (
    product_id INT,
    order_date DATE,
    unit INT
);

-- Insert data into Products table
INSERT INTO Products (product_id, product_name, product_category) VALUES
    (1, 'Leetcode Solutions Book', 'Book'),
    (2, 'Jewels of Stringology Book', 'Book'),
    (3, 'HP Laptop', 'Laptop'),
    (4, 'Lenovo Laptop', 'Laptop'),
    (5, 'Leetcode Kit T-shirt', 'T-shirt');

-- Insert data into Orders table
INSERT INTO Orders (product_id, order_date, unit) VALUES
    (1, '2020-02-05', 60),
    (1, '2020-02-10', 70),
    (2, '2020-01-18', 30),
    (2, '2020-02-11', 80),
    (3, '2020-02-17', 2),
    (3, '2020-02-24', 3),
    (4, '2020-03-01', 20),
    (4, '2020-03-04', 30),
    (4, '2020-03-04', 60),
    (5, '2020-02-25', 50),
    (5, '2020-02-27', 50),
    (5, '2020-03-01', 50);

SELECT p.product_name, 
       SUM(o.unit) AS amount
FROM Products p
JOIN Orders o
ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY p.product_id, p.product_name
HAVING SUM(o.unit) >= 100;

/*Q27.
Table: Users
Column Name Type
user_id int
name varchar
mail varchar
user_id is the primary key for this table.
This table contains information of the users signed up in a website. Some emails are invalid.
Write an SQL query to find the users who have valid emails.
A valid e-mail has a prefix name and a domain where:
● The prefix name is a string that may contain letters (upper or lower case), digits, underscore
'_', period '.', and/or dash '-'. The prefix name must start with a letter.
● The domain is '@leetcode.com'.
Return the result table in any order.
The query result format is in the following example.

Input:
Users table:
user_id name mail
1 Winston

winston@leetc
ode.com
2 Jonathan jonathanisgreat
3 Annabelle

bella-@leetcod
e.com

4 Sally

sally.come@lee
tcode.com

5 Marwan

quarz#2020@le
etcode.com

6 David

david69@gmail
.com

7 Shapiro

.shapo@leetco
de.com*/
-- Create Users table
CREATE TABLE Users1 (
    user_id INT PRIMARY KEY,
    name VARCHAR(255),
    mail VARCHAR(255)
);

-- Insert data into Users table
INSERT INTO Users1 (user_id, name, mail) VALUES
    (1, 'Winston', 'winston@leetcode.com'),
    (2, 'Jonathan', 'jonathanisgreat'),
    (3, 'Annabelle', 'bella-@leetcode.com'),
    (4, 'Sally', 'sally.come@leetcode.com'),
    (5, 'Marwan', 'quarz#2020@leetcode.com'),
    (6, 'David', 'david69@gmail.com'),
    (7, 'Shapiro', '.shapo@leetcode.com');

SELECT * 
FROM Users1
WHERE mail LIKE '[A-Za-z][A-Za-z0-9_.-]%@leetcode.com';


/*Q28.
Table: Customers
Column Name Type
customer_id int
name varchar
country varchar
customer_id is the primary key for this table.
This table contains information about the customers in the company.

Table: Product

Column Name Type
customer_id int
name varchar
country varchar
product_id is the primary key for this table.
This table contains information on the products in the company.
price is the product cost.

Table: Orders
Column Name Type
order_id int
customer_id int
product_id int
order_date date
quantity int
order_id is the primary key for this table.
This table contains information on customer orders.
customer_id is the id of the customer who bought "quantity" products with id "product_id".
Order_date is the date in format ('YYYY-MM-DD') when the order was shipped.

Write an SQL query to report the customer_id and customer_name of customers who have spent at
least $100 in each month of June and July 2020.
Return the result table in any order.
The query result format is in the following example.

Input:
Customers table:
customer_id name country
1 Winston USA
2 Jonathan Peru
3 Moustafa Egypt
Product table:
product_id description price
10 LC Phone 300
20 LC T-Shirt 10
30 LC Book 45
40 LC Keychain 2

Orders table:
order_id customer_id product_id order_date quantity
1 1 10 2020-06-10 1
2 1 20 2020-07-01 1
3 1 30 2020-07-08 2
4 2 10 2020-06-15 2
5 2 40 2020-07-01 10
6 3 20 2020-06-24 2
7 3 30 2020-06-25 2
9 3 30 2020-05-08 3*/

-- Create Customers table
CREATE TABLE Customers1 (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    country VARCHAR(255)
);

-- Create Product table
CREATE TABLE Product1 (
    product_id INT PRIMARY KEY,
    description VARCHAR(255),
    price INT
);

-- Create Orders table
CREATE TABLE Orders1 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT
);

-- Insert data into Customers table
INSERT INTO Customers1 (customer_id, name, country) VALUES
    (1, 'Winston', 'USA'),
    (2, 'Jonathan', 'Peru'),
    (3, 'Moustafa', 'Egypt');

-- Insert data into Product table
INSERT INTO Product1 (product_id, description, price) VALUES
    (10, 'LC Phone', 300),
    (20, 'LC T-Shirt', 10),
    (30, 'LC Book', 45),
    (40, 'LC Keychain', 2);

-- Insert data into Orders table
INSERT INTO Orders1 (order_id, customer_id, product_id, order_date, quantity) VALUES
    (1, 1, 10, '2020-06-10', 1),
    (2, 1, 20, '2020-07-01', 1),
    (3, 1, 30, '2020-07-08', 2),
    (4, 2, 10, '2020-06-15', 2),
    (5, 2, 40, '2020-07-01', 10),
    (6, 3, 20, '2020-06-24', 2),
    (7, 3, 30, '2020-06-25', 2),
    (9, 3, 30, '2020-05-08', 3);


SELECT c.customer_id, c.name as customer_name
FROM Customers1 c
JOIN (
    SELECT o.customer_id, MONTH(o.order_date) as order_month, SUM(p.price * o.quantity) as total_spent
    FROM Orders1 o
    JOIN Product1 p ON o.product_id = p.product_id
    WHERE o.order_date >= '2020-06-01' AND o.order_date < '2020-08-01'
    GROUP BY o.customer_id, MONTH(o.order_date)
    HAVING SUM(p.price * o.quantity) >= 100
) t
ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT t.order_month) = 2;

/*Q29.
Table: TVProgram
Column Name Type
program_date date
content_id int
channel varchar
(program_date, content_id) is the primary key for this table.
This table contains information about the programs on the TV.
content_id is the id of the program in some channel on the TV.
Table: Content
Column Name Type
content_id varchar
title varchar
Kids_content enum
content_type varchar
content_id is the primary key for this table.
Kids_content is an enum that takes one of the values ('Y', 'N') where:

'Y' means content for kids, otherwise 'N' is not content for kids.
content_type is the category of the content as movies, series, etc.

Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.
Return the result table in any order.
The query result format is in the following example.
Input:
TVProgram table:
program_date content_id channel
2020-06-10 08:00 1 LC-Channel
2020-05-11 12:00 2 LC-Channel
2020-05-12 12:00 3 LC-Channel
2020-05-13 14:00 4 Disney Ch
2020-06-18 14:00 4 Disney Ch
2020-07-15 16:00 5 Disney Ch

Content table:
content_id title Kids_content content_type
1 Leetcode Movie N Movies
2 Alg. for Kids Y Series
3 Database Sols N Series
4 Aladdin Y Movies
5 Cinderella Y Movies*/

-- Create TVProgram table
CREATE TABLE TVProgram (
    program_date DATE,
    content_id INT,
    channel VARCHAR(255),
    PRIMARY KEY (program_date, content_id)
);

-- Create Content table
CREATE TABLE Content (
    content_id VARCHAR(255) PRIMARY KEY,
    title VARCHAR(255),
    Kids_content VARCHAR(1),
    content_type VARCHAR(255)
);


-- Insert data into TVProgram table
INSERT INTO TVProgram (program_date, content_id, channel) VALUES
    ('2020-06-10', 1, 'LC-Channel'),
    ('2020-05-11', 2, 'LC-Channel'),
    ('2020-05-12', 3, 'LC-Channel'),
    ('2020-05-13', 4, 'Disney Ch'),
    ('2020-06-18', 4, 'Disney Ch'),
    ('2020-07-15', 5, 'Disney Ch');

-- Insert data into Content table
INSERT INTO Content (content_id, title, Kids_content, content_type) VALUES
    ('1', 'Leetcode Movie', 'N', 'Movies'),
    ('2', 'Alg. for Kids', 'Y', 'Series'),
    ('3', 'Database Sols', 'N', 'Series'),
    ('4', 'Aladdin', 'Y', 'Movies'),
    ('5', 'Cinderella', 'Y', 'Movies');

SELECT DISTINCT c.title
FROM TVProgram t
JOIN Content c ON t.content_id = c.content_id
WHERE c.Kids_content = 'Y' 
AND c.content_type = 'Movies'
AND t.program_date >= '2020-06-01' 
AND t.program_date < '2020-07-01';

/*Q30.

Table: NPV
Column Name Type
id int
year int
npv int
(id, year) is the primary key of this table.
The table has information about the id and the year of each inventory and the corresponding net
present value.

Table: Queries
Column Name Type
id int
year int
(id, year) is the primary key of this table.
The table has information about the id and the year of each inventory query.

Write an SQL query to find the npv of each query of the Queries table.
Return the result table in any order.
The query result format is in the following example.
Input:
NPV table:
id year npv
1 2018 100
7 2020 30
13 2019 40
1 2019 113
2 2008 121
3 2009 12
11 2020 99
7 2019 0

Queries table:

id year
1 2019
2 2008
3 2009
7 2018
7 2019
7 2020
13 2019*/
-- Create NPV table
CREATE TABLE NPV (
    id INT,
    year INT,
    npv INT,
    PRIMARY KEY (id, year)
);

-- Create Queries table
CREATE TABLE Queries (
    id INT,
    year INT,
    PRIMARY KEY (id, year)
);

-- Insert data into NPV table
INSERT INTO NPV (id, year, npv) VALUES
    (1, 2018, 100),
    (7, 2020, 30),
    (13, 2019, 40),
    (1, 2019, 113),
    (2, 2008, 121),
    (3, 2009, 12),
    (11, 2020, 99),
    (7, 2019, 0);

-- Insert data into Queries table
INSERT INTO Queries (id, year) VALUES
    (1, 2019),
    (2, 2008),
    (3, 2009),
    (7, 2018),
    (7, 2019),
    (7, 2020),
    (13, 2019);

SELECT q.id, q.year, COALESCE(n.npv, 0) as npv
FROM Queries q
LEFT JOIN NPV n
ON q.id = n.id AND q.year = n.year;

/*Q31.
Table: NPV
Column Name Type
id int
year int
npv int
(id, year) is the primary key of this table.
The table has information about the id and the year of each inventory and the corresponding net
present value.

Table: Queries
Column Name Type
id int
year int
(id, year) is the primary key of this table.
The table has information about the id and the year of each inventory query.

Write an SQL query to find the npv of each query of the Queries table.
Return the result table in any order.
The query result format is in the following example.
Input:
NPV table:
id year npv
1 2018 100
7 2020 30
13 2019 40
1 2019 113
2 2008 121
3 2009 12
11 2020 99
7 2019 0

Queries table:
id year
1 2019
2 2008
3 2009
7 2018
7 2019
7 2020
13 2019*/

-- Create NPV table
CREATE TABLE NPV1 (
    id INT,
    year INT,
    npv INT,
    PRIMARY KEY (id, year)
);

-- Create Queries table
CREATE TABLE Queries1 (
    id INT,
    year INT,
    PRIMARY KEY (id, year)
);

-- Insert data into NPV table
INSERT INTO NPV1 (id, year, npv) VALUES
    (1, 2018, 100),
    (7, 2020, 30),
    (13, 2019, 40),
    (1, 2019, 113),
    (2, 2008, 121),
    (3, 2009, 12),
    (11, 2020, 99),
    (7, 2019, 0);

-- Insert data into Queries table
INSERT INTO Queries1 (id, year) VALUES
    (1, 2019),
    (2, 2008),
    (3, 2009),
    (7, 2018),
    (7, 2019),
    (7, 2020),
    (13, 2019);

SELECT q.id, q.year, COALESCE(n.npv, 0) as npv
FROM Queries q
LEFT JOIN NPV n
ON q.id = n.id AND q.year = n.year;

/*Q32.
Table: Employees
Column Name Type
id int
name varchar
id is the primary key for this table.
Each row of this table contains the id and the name of an employee in a company.

Table: EmployeeUNI
Column Name Type
id int
unique_id int
(id, unique_id) is the primary key for this table.
Each row of this table contains the id and the corresponding unique id of an employee in the
company.

Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
show null.
Return the result table in any order.
The query result format is in the following example.
Input:
Employees table:
id name
1 Alice
7 Bob
11 Meir
90 Winston
3 Jonathan
EmployeeUNI table:
id unique_id
3 1
11 2
90 3*/

-- Create Employees table
CREATE TABLE Employees (
    id INT,
    name VARCHAR(255),
    PRIMARY KEY (id)
);

-- Create EmployeeUNI table
CREATE TABLE EmployeeUNI (
    id INT,
    unique_id INT,
    PRIMARY KEY (id, unique_id)
);

-- Insert data into Employees table
INSERT INTO Employees (id, name) VALUES
    (1, 'Alice'),
    (7, 'Bob'),
    (11, 'Meir'),
    (90, 'Winston'),
    (3, 'Jonathan');

-- Insert data into EmployeeUNI table
INSERT INTO EmployeeUNI (id, unique_id) VALUES
    (3, 1),
    (11, 2),
    (90, 3);

SELECT eu.unique_id, 
       e.name
FROM Employees e
LEFT JOIN EmployeeUNI eu
ON e.id = eu.id;

/*Q33.
Table: Users
Column Name Type
id int
name varchar
id is the primary key for this table.
name is the name of the user.
Table: Rides
Column Name Type
id int
user_id int
distance int
id is the primary key for this table.
user_id is the id of the user who travelled the distance "distance".
Write an SQL query to report the distance travelled by each user.
Return the result table ordered by travelled_distance in descending order, if two or more users
travelled the same distance, order them by their name in ascending order.
The query result format is in the following example.
Input:
Users table:
id name
1 Alice
2 Bob
3 Alex
4 Donald
7 Lee

13 Jonathan
19 Elvis
Rides table:
id user_id distance
1 1 120
2 2 317
3 3 222
4 7 100
5 13 312
6 19 50
7 7 120
8 19 400
9 7 230*/

-- Create Users table
CREATE TABLE Users2 (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO Users2 (id, name) VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Alex'),
    (4, 'Donald'),
    (7, 'Lee'),
    (13, 'Jonathan'),
    (19, 'Elvis');

CREATE TABLE Rides (
    id INT PRIMARY KEY,
    user_id INT,
    distance INT,
    FOREIGN KEY (user_id) REFERENCES Users2(id)
);

INSERT INTO Rides (id, user_id, distance) VALUES
    (1, 1, 120),
    (2, 2, 317),
    (3, 3, 222),
    (4, 7, 100),
    (5, 13, 312),
    (6, 19, 50),
    (7, 7, 120),
    (8, 19, 400),
    (9, 7, 230);

SELECT u.id, u.name, COALESCE(SUM(r.distance), 0) as travelled_distance
FROM Users2 u
LEFT JOIN Rides r
ON u.id = r.user_id
GROUP BY u.id, u.name
ORDER BY travelled_distance DESC, u.name ASC;

/*Table: Products
Column Name Type
product_id int
product_name varchar
product_category varchar
product_id is the primary key for this table.
This table contains data about the company's products.

Table: Orders
Column Name Type
product_id int
order_date date
unit int
There is no primary key for this table. It may have duplicate rows.
product_id is a foreign key to the Products table.
unit is the number of products ordered in order_date.

Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
and their amount.
Return result table in any order.
The query result format is in the following example.
Input:
Products table:
product_id product_name

product_catego
ry

1

Leetcode
Solutions Book

2

Jewels of
Stringology Book
3 HP Laptop
4 Lenovo Laptop
5 Leetcode Kit T-shirt*/

-- Create Products table
CREATE TABLE Products2 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    product_category VARCHAR(255)
);

-- Create Orders table
CREATE TABLE Orders2 (
    product_id INT,
    order_date DATE,
    unit INT
);

-- Insert data into Products table
INSERT INTO Products2 (product_id, product_name, product_category) VALUES
    (1, 'Leetcode Solutions Book', 'Book'),
    (2, 'Jewels of Stringology Book', 'Book'),
    (3, 'HP Laptop', 'Laptop'),
    (4, 'Lenovo Laptop', 'Laptop'),
    (5, 'Leetcode Kit T-shirt', 'Clothing');

-- Insert data into Orders table
INSERT INTO Orders2 (product_id, order_date, unit) VALUES
    (1, '2020-02-05', 120),
    (2, '2020-02-15', 80),
    (3, '2020-02-10', 150),
    (4, '2020-02-20', 90),
    (5, '2020-01-30', 50),
    (1, '2020-02-28', 100),
    (3, '2020-02-15', 70),
    (2, '2020-03-01', 120),
    (4, '2020-02-25', 110);

SELECT p.product_name, SUM(o.unit) AS amount
FROM Products2 p
JOIN Orders2 o
ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01' 
    AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

/*Q35.

Table: Movies
Column Name Type
movie_id int
title varchar
movie_id is the primary key for this table.
The title is the name of the movie.

Table: Users
Column Name Type
user_id int
name varchar
user_id is the primary key for this table.

Table: MovieRating
Column Name Type
movie_id int
user_id int
rating int
created_at date
(movie_id, user_id) is the primary key for this table.
This table contains the rating of a movie by a user in their review.
created_at is the user's review date.

Write an SQL query to:
● Find the name of the user who has rated the greatest number of movies. In case of a tie,
return the lexicographically smaller user name.
● Find the movie name with the highest average rating in February 2020. In case of a tie, return
the lexicographically smaller movie name.
The query result format is in the following example.

Input:

Movies table:
movie_id title
1 Avengers
2 Frozen 2
3 Joker
Users table:
user_id name
1 Daniel
2 Monica
3 Maria
4 James
MovieRating table:
movie_id user_id rating created_at
1 1 3 2020-01-12
1 2 4 2020-02-11
1 3 2 2020-02-12
1 4 1 2020-01-01
2 1 5 2020-02-17
2 2 2 2020-02-01
2 3 2 2020-03-01
3 1 3 2020-02-22
3 2 4 2020-02-25*/

-- Create Movies table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255)
);

-- Create Users table
CREATE TABLE Users3 (
    user_id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Create MovieRating table
CREATE TABLE MovieRating (
    movie_id INT,
    user_id INT,
    rating INT,
    created_at DATE
);

-- Insert data into Movies table
INSERT INTO Movies (movie_id, title) VALUES
    (1, 'Avengers'),
    (2, 'Frozen 2'),
    (3, 'Joker');

-- Insert data into Users table
INSERT INTO Users3 (user_id, name) VALUES
    (1, 'Daniel'),
    (2, 'Monica'),
    (3, 'Maria'),
    (4, 'James');

-- Insert data into MovieRating table
INSERT INTO MovieRating (movie_id, user_id, rating, created_at) VALUES
    (1, 1, 3, '2020-01-12'),
    (1, 2, 4, '2020-02-11'),
    (1, 3, 2, '2020-02-12'),
    (1, 4, 1, '2020-01-01'),
    (2, 1, 5, '2020-02-17'),
    (2, 2, 2, '2020-02-01'),
    (2, 3, 2, '2020-03-01'),
    (3, 1, 3, '2020-02-22'),
    (3, 2, 4, '2020-02-25');

WITH UserRatingCount AS (
    SELECT user_id, COUNT(*) AS rating_count
    FROM MovieRating 
    GROUP BY user_id
),
MovieAvgRating AS (
    SELECT movie_id, AVG(rating) AS avg_rating
    FROM MovieRating 
    WHERE created_at >= '2020-02-01' AND created_at < '2020-03-01' 
    GROUP BY movie_id
),
UserRank AS (
    SELECT user_id, DENSE_RANK() OVER (ORDER BY rating_count DESC, user_id) AS rnk
    FROM UserRatingCount
),
MovieRank AS (
    SELECT movie_id, DENSE_RANK() OVER (ORDER BY avg_rating DESC, movie_id) AS rnk
    FROM MovieAvgRating
)
SELECT u.name AS user_with_most_ratings, m.title AS movie_with_highest_avg_rating
FROM UserRank ur
JOIN Users3 u ON ur.user_id = u.user_id
JOIN MovieRank mr ON 1=1
JOIN Movies m ON mr.movie_id = m.movie_id
WHERE ur.rnk = 1 AND mr.rnk = 1;


/*Q36.

Table: Users
Column Name Type
id int
name varchar
id is the primary key for this table.
name is the name of the user.

Table: Rides
Column Name Type
id int
user_id int
distance int
id is the primary key for this table.
user_id is the id of the user who travelled the distance "distance".

Write an SQL query to report the distance travelled by each user.
Return the result table ordered by travelled_distance in descending order, if two or more users
travelled the same distance, order them by their name in ascending order.
The query result format is in the following example.
Input:
Users table:
id name
1 Alice
2 Bob
3 Alex
4 Donald
7 Lee
13 Jonathan
19 Elvis
Rides table:
id user_id distance
1 1 120
2 2 317
3 3 222
4 7 100
5 13 312
6 19 50

7 7 120
8 19 400
9 7 230*/

-- Create Users table
CREATE TABLE Users4 (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Insert data into Users table
INSERT INTO Users4 (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Alex'),
(4, 'Donald'),
(7, 'Lee'),
(13, 'Jonathan'),
(19, 'Elvis');

-- Create Rides table
CREATE TABLE Rides4 (
    id INT PRIMARY KEY,
    user_id INT,
    distance INT
);

-- Insert data into Rides table
INSERT INTO Rides4 (id, user_id, distance) VALUES
(1, 1, 120),
(2, 2, 317),
(3, 3, 222),
(4, 7, 100),
(5, 13, 312),
(6, 19, 50),
(7, 7, 120),
(8, 19, 400),
(9, 7, 230);


SELECT u.name, COALESCE(SUM(r.distance), 0) AS travelled_distance
FROM Users4 u
LEFT JOIN Rides r ON u.id = r.user_id
GROUP BY u.id, u.name
ORDER BY travelled_distance DESC, u.name;


/*Q37.
Table: Employees
Column Name Type
id int
name varchar
id is the primary key for this table.
Each row of this table contains the id and the name of an employee in a company.

Table: EmployeeUNI
Column Name Type
id int
unique_id int
(id, unique_id) is the primary key for this table.
Each row of this table contains the id and the corresponding unique id of an employee in the
company.

Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
show null.
Return the result table in any order.

The query result format is in the following example.
Input:
Employees table:
id name
1 Alice
7 Bob
11 Meir
90 Winston
3 Jonathan
EmployeeUNI table:
id unique_id
3 1
11 2
90 3*/

CREATE TABLE Employees4 (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO Employees4 (id, name) VALUES
(1, 'Alice'),
(7, 'Bob'),
(11, 'Meir'),
(90, 'Winston'),
(3, 'Jonathan');

CREATE TABLE EmployeeUNI4 (
    id INT PRIMARY KEY,
    unique_id INT
);

INSERT INTO EmployeeUNI4 (id, unique_id) VALUES
(3, 1),
(11, 2),
(90, 3);

SELECT eu.unique_id, e.name
FROM Employees4 e
LEFT JOIN EmployeeUNI4 eu ON e.id = eu.id;

/*Q38.

Table: Departments
Column Name Type
id int
name varchar
id is the primary key of this table.
The table has information about the id of each department of a university.

Table: Students
Column Name Type
id int
name varchar
department_id int
id is the primary key of this table.
The table has information about the id of each student at a university and the id of the department
he/she studies at.
Write an SQL query to find the id and the name of all students who are enrolled in departments that no
longer exist.
Return the result table in any order.
The query result format is in the following example.
Input:
Departments table:
id name
1 Electrical Engineering
7 Computer Engineering
13 Business Administration
Students table:
id name department_id
23 Alice 1
1 Bob 7
5 Jennifer 13
2 John 14
4 Jasmine 77
3 Steve 74
6 Luis 1
8 Jonathan 7
7 Daiana 33
11 Madelynn 1*/

CREATE TABLE Departments (
    id int PRIMARY KEY,
    name varchar(255)
);

INSERT INTO Departments (id, name) VALUES
(1, 'Electrical Engineering'),
(7, 'Computer Engineering'),
(13, 'Business Administration');

CREATE TABLE Students (
    id int PRIMARY KEY,
    name varchar(255),
    department_id int
);

INSERT INTO Students (id, name, department_id) VALUES
(23, 'Alice', 1),
(1, 'Bob', 7),
(5, 'Jennifer', 13),
(2, 'John', 14),
(4, 'Jasmine', 77),
(3, 'Steve', 74),
(6, 'Luis', 1),
(8, 'Jonathan', 7),
(7, 'Daiana', 33),
(11, 'Madelynn', 1);

SELECT s.id, s.name
FROM Students s
LEFT JOIN Departments d ON s.department_id = d.id
WHERE d.id IS NULL;

/*Q39.
Table: Calls
Column Name Type
from_id int
to_id int
duration int
This table does not have a primary key, it may contain duplicates.
This table contains the duration of a phone call between from_id and to_id.
from_id != to_id
Write an SQL query to report the number of calls and the total call duration between each pair of
distinct persons (person1, person2) where person1 < person2.
Return the result table in any order.
The query result format is in the following example.
Input:
Calls table:
from_id to_id duration
1 2 59
2 1 11
1 3 20
3 4 100
3 4 200
3 4 200
4 3 499*/

CREATE TABLE Calls (
    from_id int,
    to_id int,
    duration int
);

INSERT INTO Calls (from_id, to_id, duration) VALUES (1, 2, 59);
INSERT INTO Calls (from_id, to_id, duration) VALUES (2, 1, 11);
INSERT INTO Calls (from_id, to_id, duration) VALUES (1, 3, 20);
INSERT INTO Calls (from_id, to_id, duration) VALUES (3, 4, 100);
INSERT INTO Calls (from_id, to_id, duration) VALUES (3, 4, 200);
INSERT INTO Calls (from_id, to_id, duration) VALUES (3, 4, 200);
INSERT INTO Calls (from_id, to_id, duration) VALUES (4, 3, 499);

SELECT 
    CASE WHEN from_id < to_id THEN from_id ELSE to_id END AS person1,
    CASE WHEN from_id < to_id THEN to_id ELSE from_id END AS person2,
    COUNT(*) AS call_count,
    SUM(duration) AS total_duration
FROM Calls
GROUP BY 
    CASE WHEN from_id < to_id THEN from_id ELSE to_id END,
    CASE WHEN from_id < to_id THEN to_id ELSE from_id END;


/*Q40.
Table: Prices
Column Name Type
product_id int
start_date date
end_date date
price int
(product_id, start_date, end_date) is the primary key for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two
intersecting periods for the same product_id.
Table: UnitsSold
Column Name Type
product_id int
purchase_date date
units int
There is no primary key for this table, it may contain duplicates.
Each row of this table indicates the date, units, and product_id of each product sold.
Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places.
Return the result table in any order.
The query result format is in the following example.

Input:
Prices table:
product_id start_date end_date price
1 2019-02-17 2019-02-28 5
1 2019-03-01 2019-03-22 20
2 2019-02-01 2019-02-20 15
2 2019-02-21 2019-03-31 30

UnitsSold table:

product_id purchase_date units
1 2019-02-25 100
1 2019-03-01 15
2 2019-02-10 200
2 2019-03-22 30*/

CREATE TABLE Prices1 (
    product_id int,
    start_date date,
    end_date date,
    price int,
    PRIMARY KEY (product_id, start_date, end_date)
);

INSERT INTO Prices1 (product_id, start_date, end_date, price) VALUES
(1, '2019-02-17', '2019-02-28', 5),
(1, '2019-03-01', '2019-03-22', 20),
(2, '2019-02-01', '2019-02-20', 15),
(2, '2019-02-21', '2019-03-31', 30);

CREATE TABLE UnitsSold1 (
    product_id int,
    purchase_date date,
    units int
);

INSERT INTO UnitsSold1 (product_id, purchase_date, units) VALUES
(1, '2019-02-25', 100),
(1, '2019-03-01', 15),
(2, '2019-02-10', 200),
(2, '2019-03-22', 30);

SELECT 
    us.product_id,
    ROUND(SUM(p.price * us.units) / SUM(us.units), 2) AS average_price
FROM UnitsSold1 us
JOIN Prices1 p ON us.product_id = p.product_id AND us.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY us.product_id;

/*Q41.
Table: Warehouse
Column Name Type
name varchar
product_id int
units int
(name, product_id) is the primary key for this table.
Each row of this table contains the information of the products in each warehouse.
Table: Products
Column Name Type
product_id int
product_name varchar
Width int
Length int
Height int
product_id is the primary key for this table.
Each row of this table contains information about the product dimensions (Width, Length, and Height)
in feets of each product.
Write an SQL query to report the number of cubic feet of volume the inventory occupies in each
warehouse.
Return the result table in any order.
The query result format is in the following example.

Input:
Warehouse table:
name product_id units
LCHouse1 1 1
LCHouse1 2 10
LCHouse1 3 5
LCHouse2 1 2
LCHouse2 2 2
LCHouse3 4 1

Products table:
product_id product_name Width Length Height
1 LC-TV 5 50 40
2 LC-KeyChain 5 5 5
3 LC-Phone 2 10 10
4 LC-T-Shirt 4 10 20*/

CREATE TABLE Warehouse (
    name varchar(255),
    product_id int,
    units int,
    PRIMARY KEY (name, product_id)
);

INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 1, 1);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 2, 10);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 3, 5);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse2', 1, 2);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse2', 2, 2);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse3', 4, 1);

CREATE TABLE Warehouse (
    name VARCHAR(255),
    product_id INT,
    units INT,
    PRIMARY KEY (name, product_id)
);

INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 1, 1);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 2, 10);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 3, 5);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse2', 1, 2);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse2', 2, 2);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse3', 4, 1);

CREATE TABLE Warehouse (
    name VARCHAR(255),
    product_id INT,
    units INT,
    PRIMARY KEY (name, product_id)
);

INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 1, 1);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 2, 10);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse1', 3, 5);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse2', 1, 2);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse2', 2, 2);
INSERT INTO Warehouse (name, product_id, units) VALUES ('LCHouse3', 4, 1);

CREATE TABLE Warehouse1 (
    name VARCHAR(255),
    product_id INT,
    units INT,
    PRIMARY KEY (name, product_id)
);

INSERT INTO Warehouse1 (name, product_id, units) VALUES ('LCHouse1', 1, 1);
INSERT INTO Warehouse1 (name, product_id, units) VALUES ('LCHouse1', 2, 10);
INSERT INTO Warehouse1 (name, product_id, units) VALUES ('LCHouse1', 3, 5);
INSERT INTO Warehouse1 (name, product_id, units) VALUES ('LCHouse2', 1, 2);
INSERT INTO Warehouse1 (name, product_id, units) VALUES ('LCHouse2', 2, 2);
INSERT INTO Warehouse1 (name, product_id, units) VALUES ('LCHouse3', 4, 1);

CREATE TABLE Products5 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    Width INT,
    Length INT,
    Height INT
);

INSERT INTO Products5 (product_id, product_name, Width, Length, Height) VALUES (1, 'LC-TV', 5, 50, 40);
INSERT INTO Products5 (product_id, product_name, Width, Length, Height) VALUES (2, 'LC-KeyChain', 5, 5, 5);
INSERT INTO Products5 (product_id, product_name, Width, Length, Height) VALUES (3, 'LC-Phone', 2, 10, 10);
INSERT INTO Products5 (product_id, product_name, Width, Length, Height) VALUES (4, 'LC-T-Shirt', 4, 10, 20);

SELECT
    w.name,
    SUM(p.Width * p.Length * p.Height * w.units) AS volume
FROM Warehouse1 w
JOIN Products5 p ON w.product_id = p.product_id
GROUP BY w.name;

/*Q42.

Table: Sales
Column Name Type
sale_date date
fruit enum
sold_num int
(sale_date, fruit) is the primary key for this table.
This table contains the sales of "apples" and "oranges" sold each day.
Write an SQL query to report the difference between the number of apples and oranges sold each day.
Return the result table ordered by sale_date.
The query result format is in the following example.

Input:
Sales table:
sale_date fruit sold_num
2020-05-01 apples 10
2020-05-01 oranges 8
2020-05-02 apples 15
2020-05-02 oranges 15
2020-05-03 apples 20
2020-05-03 oranges 0
2020-05-04 apples 15
2020-05-04 oranges 16*/

CREATE TABLE Sales5 (
    sale_date DATE,
    fruit VARCHAR(255),
    sold_num INT,
    PRIMARY KEY (sale_date, fruit)
);

INSERT INTO Sales5 (sale_date, fruit, sold_num) VALUES ('2020-05-01', 'apples', 10);
INSERT INTO Sales5 (sale_date, fruit, sold_num) VALUES ('2020-05-01', 'oranges', 8);
INSERT INTO Sales5 (sale_date, fruit, sold_num) VALUES ('2020-05-02', 'apples', 15);
INSERT INTO Sales5 (sale_date, fruit, sold_num) VALUES ('2020-05-02', 'oranges', 15);
INSERT INTO Sales5 (sale_date, fruit, sold_num) VALUES ('2020-05-03', 'apples', 20);
INSERT INTO Sales5 (sale_date, fruit, sold_num) VALUES ('2020-05-03', 'oranges', 0);
INSERT INTO Sales5 (sale_date, fruit, sold_num) VALUES ('2020-05-04', 'apples', 15);
INSERT INTO Sales5 (sale_date, fruit, sold_num) VALUES ('2020-05-04', 'oranges', 16);

SELECT 
    sale_date,
    SUM(CASE WHEN fruit = 'apples' THEN sold_num ELSE -sold_num END) AS diff
FROM Sales5
GROUP BY sale_date
ORDER BY sale_date;

/*Q43.

Table: Activity
Column Name Type
player_id int
device_id int
event_date date
games_played int
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before
logging out on someday using some device.

Write an SQL query to report the fraction of players that logged in again on the day after the day they
first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
that logged in for at least two consecutive days starting from their first login date, then divide that
number by the total number of players.
The query result format is in the following example.
Input:
Activity table:
player_id device_id event_date games_played
1 2 2016-03-01 5
1 2 2016-03-02 6
2 3 2017-06-25 1
3 1 2016-03-02 0
3 4 2018-07-03 5*/

CREATE TABLE Activity2 (
    player_id int,
    device_id int,
    event_date date,
    games_played int,
    PRIMARY KEY (player_id, event_date)
);

INSERT INTO Activity2 (player_id, device_id, event_date, games_played) VALUES
    (1, 2, '2016-03-01', 5),
    (1, 2, '2016-03-02', 6),
    (2, 3, '2017-06-25', 1),
    (3, 1, '2016-03-02', 0),
    (3, 4, '2018-07-03', 5);

WITH ConsecutiveLogins AS (
    SELECT 
        player_id, 
        CASE 
            WHEN LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) = DATEADD(day, 1, event_date) 
            THEN 1.0 
            ELSE 0.0
        END AS LoggedInNextDay
    FROM Activity2
),
Fraction AS (
    SELECT 
        CAST(SUM(LoggedInNextDay) AS DECIMAL(10, 2)) / COUNT(DISTINCT player_id) AS fraction
    FROM ConsecutiveLogins
)
SELECT CAST(round(fraction,2)AS FLOAT) FROM Fraction;

/*Q44.

Table: Employee
Column Name Type
id int
name varchar
department varchar
managerId int
id is the primary key column for this table.
Each row of this table indicates the name of an employee, their department, and the id of their
manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.

Write an SQL query to report the managers with at least five direct reports.
Return the result table in any order.
The query result format is in the following example.
Input:
Employee table:
id name department managerId
101 John A None
102 Dan A 101
103 James A 101
104 Amy A 101
105 Anne A 101
106 Ron B 101*/

CREATE TABLE Employee6 (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    department VARCHAR(255),
    managerId INT
);

INSERT INTO Employee6 (id, name, department, managerId) VALUES (101, 'John', 'A', NULL);
INSERT INTO Employee6 (id, name, department, managerId) VALUES (102, 'Dan', 'A', 101);
INSERT INTO Employee6 (id, name, department, managerId) VALUES (103, 'James', 'A', 101);
INSERT INTO Employee6 (id, name, department, managerId) VALUES (104, 'Amy', 'A', 101);
INSERT INTO Employee6 (id, name, department, managerId) VALUES (105, 'Anne', 'A', 101);
INSERT INTO Employee6 (id, name, department, managerId) VALUES (106, 'Ron', 'B', 101);

SELECT e1.name AS name
FROM Employee6 e1
JOIN Employee6 e2 ON e1.id = e2.managerId
GROUP BY e1.name
HAVING COUNT(e2.id) >= 5;

/*Q45.

Table: Student
Column Name Type
student_id int
student_name varchar
gender varchar
dept_id int
student_id is the primary key column for this table.
dept_id is a foreign key to dept_id in the Department tables.
Each row of this table indicates the name of a student, their gender, and the id of their department.

Table: Department
Column Name Type
dept_id int
dept_name varchar
dept_id is the primary key column for this table.
Each row of this table contains the id and the name of a department.

Write an SQL query to report the respective department name and number of students majoring in
each department for all departments in the Department table (even ones with no current students).
Return the result table ordered by student_number in descending order. In case of a tie, order them by
dept_name alphabetically.
The query result format is in the following example.
Input:
Student table:
student_id student_name gender dept_id
1 Jack M 1
2 Jane F 1
3 Mark M 2

Department table:
dept_id dept_name
1 Engineering
2 Science
3 Law*/

CREATE TABLE Department (
    dept_id int PRIMARY KEY,
    dept_name varchar(255)
);

INSERT INTO Department (dept_id, dept_name)
VALUES 
    (1, 'Engineering'),
    (2, 'Science'),
    (3, 'Law');

CREATE TABLE Student (
    student_id int PRIMARY KEY,
    student_name varchar(255),
    gender varchar(255),
    dept_id int,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

INSERT INTO Student (student_id, student_name, gender, dept_id)
VALUES 
    (1, 'Jack', 'M', 1),
    (2, 'Jane', 'F', 1),
    (3, 'Mark', 'M', 2);

SELECT d.dept_name, COUNT(s.student_id) AS student_number
FROM Department d
LEFT JOIN Student s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY student_number DESC, d.dept_name;

/*Q46.
Table: Customer
Column Name Type
customer_id int
product_key int
There is no primary key for this table. It may contain duplicates.
product_key is a foreign key to the Product table.
Table: Product
Column Name Type
product_key int
product_key is the primary key column for this table.
Write an SQL query to report the customer ids from the Customer table that bought all the products in
the Product table.
Return the result table in any order.
The query result format is in the following example.
Input:
Customer table:
customer_id product_key
1 5
2 6
3 5
3 6
1 6
Product table:
product_key
5
6*/

CREATE TABLE Customer (
    customer_id INT,
    product_key INT
);

INSERT INTO Customer (customer_id, product_key) VALUES
(1, 5),
(2, 6),
(3, 5),
(3, 6),
(1, 6);

CREATE TABLE Product8 (
    product_key INT PRIMARY KEY
);

INSERT INTO Product8 (product_key) VALUES
(5),
(6);

SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(DISTINCT product_key) FROM Product8);


/*Q47.
Table: Project
Column Name Type
project_id int
employee_id int
(project_id, employee_id) is the primary key of this table.
employee_id is a foreign key to the Employee table.
Each row of this table indicates that the employee with employee_id is working on the project with
project_id.

Table: Employee
Column Name Type
employee_id int
name varchar
experience_yea
rs int
employee_id is the primary key of this table.
Each row of this table contains information about one employee.
Write an SQL query that reports the most experienced employees in each project. In case of a tie,
report all employees with the maximum number of experience years.
Return the result table in any order.
The query result format is in the following example.
Input:
Project table:
project_id employee_id
1 1
1 2
1 3
2 1
2 4

Employee table:

employee_id name

experience_yea
rs
1 Khaled 3
2 Ali 2
3 John 3
4 Doe 2*/

CREATE TABLE Project (
    project_id int,
    employee_id int,
    PRIMARY KEY (project_id, employee_id)
);

CREATE TABLE Employee1 (
    employee_id int,
    name varchar(255),
    experience_years int,
    PRIMARY KEY (employee_id)
);

INSERT INTO Project (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4);

INSERT INTO Employee1 (employee_id, name, experience_years) VALUES
(1, 'Khaled', 3),
(2, 'Ali', 2),
(3, 'John', 3),
(4, 'Doe', 2);

WITH RankedExperience AS (
    SELECT
        p.project_id,
        e.employee_id,
        e.name,
        e.experience_years,
        DENSE_RANK() OVER (PARTITION BY p.project_id ORDER BY e.experience_years DESC) as experience_rank
    FROM Project p
    JOIN Employee1 e ON p.employee_id = e.employee_id
)
SELECT project_id, employee_id, name, experience_years
FROM RankedExperience
WHERE experience_rank = 1;

/*Q48.
Table: Books
Column Name Type
book_id int
name varchar
available_from date
book_id is the primary key of this table.
Table: Orders
Column Name Type
order_id int
book_id int
quantity int
dispatch_date date
order_id is the primary key of this table.
book_id is a foreign key to the Books table.

Write an SQL query that reports the books that have sold less than 10 copies in the last year,
excluding books that have been available for less than one month from today. Assume today is
2019-06-23.
Return the result table in any order.
The query result format is in the following example.

Input:

Books table:
book_id name available_from
1

"Kalila And
Demna" 2010-01-01
2 "28 Letters" 2012-05-12
3 "The Hobbit" 2019-06-10
4

"13 Reasons
Why" 2019-06-01

5

"The Hunger
Games" 2008-09-21*/

CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    name VARCHAR(255),
    available_from DATE
);

INSERT INTO Books (book_id, name, available_from) VALUES
(1, 'Kalila And Demna', '2010-01-01'),
(2, '28 Letters', '2012-05-12'),
(3, 'The Hobbit', '2019-06-10'),
(4, '13 Reasons Why', '2019-06-01'),
(5, 'The Hunger Games', '2008-09-21');

CREATE TABLE Orders3 (
    order_id INT PRIMARY KEY,
    book_id INT,
    quantity INT,
    dispatch_date DATE
);

INSERT INTO Orders3 (order_id, book_id, quantity, dispatch_date) VALUES
(1, 1, 8, '2018-06-24'),
(2, 2, 12, '2018-12-15'),
(3, 1, 7, '2019-03-03'),
(4, 2, 5, '2019-06-02'),
(5, 4, 6, '2019-05-12'),
(6, 5, 9, '2019-06-20');

SELECT b.book_id, b.name
FROM Books b
WHERE b.available_from <= DATEADD(month, -1, '2019-06-23')
AND b.book_id NOT IN (
    SELECT o.book_id
    FROM Orders3 o
    WHERE o.dispatch_date BETWEEN DATEADD(year, -1, '2019-06-23') AND '2019-06-23'
    GROUP BY o.book_id
    HAVING SUM(o.quantity) >= 10
);

/*Q49.
Table: Enrollments
Column Name Type
student_id int
course_id int
grade int
(student_id, course_id) is the primary key of this table.

Write a SQL query to find the highest grade with its corresponding course for each student. In case of
a tie, you should find the course with the smallest course_id.
Return the result table ordered by student_id in ascending order.
The query result format is in the following example.
Input:
Enrollments table:
student_id course_id grade
2 2 95
2 3 95
1 1 90
1 2 99
3 1 80
3 2 75
3 3 82
Output:
student_id course_id grade
1 2 99
2 2 95
3 3 82*/

-- Create the Enrollments table
CREATE TABLE Enrollments (
    student_id int,
    course_id int,
    grade int,
    PRIMARY KEY (student_id, course_id)
);

-- Insert data into the Enrollments table
INSERT INTO Enrollments (student_id, course_id, grade) VALUES (2, 2, 95);
INSERT INTO Enrollments (student_id, course_id, grade) VALUES (2, 3, 95);
INSERT INTO Enrollments (student_id, course_id, grade) VALUES (1, 1, 90);
INSERT INTO Enrollments (student_id, course_id, grade) VALUES (1, 2, 99);
INSERT INTO Enrollments (student_id, course_id, grade) VALUES (3, 1, 80);
INSERT INTO Enrollments (student_id, course_id, grade) VALUES (3, 2, 75);
INSERT INTO Enrollments (student_id, course_id, grade) VALUES (3, 3, 82);

SELECT 
    student_id, 
    course_id, 
    grade 
FROM 
    (SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY grade DESC, course_id) as rnk
     FROM Enrollments) as T
WHERE 
    rnk = 1
ORDER BY 
    student_id;

/*Q50.

Table: Teams
Column Name Type
team_id int
team_name varchar
team_id is the primary key of this table.
Each row of this table represents a single football team.

Table: Matches
Column Name Type
match_id int
host_team int
guest_team int
host_goals int
guest_goals int
match_id is the primary key of this table.
Each row is a record of a finished match between two different teams.
Teams host_team and guest_team are represented by their IDs in the Teams table (team_id), and they
scored host_goals and guest_goals goals, respectively.

The winner in each group is the player who scored the maximum total points within the group. In the
case of a tie, the lowest player_id wins.
Write an SQL query to find the winner in each group.
Return the result table in any order.
The query result format is in the following example.
Input:
Players table:
player_id group_id
15 1
25 1
30 1
45 1
10 2
35 2
50 2
20 3
40 3
Matches table:
match_id first_player second_player first_score second_score

1

1
5

4
5

3

0

2

3
0

2
5

1

2

3

3
0

1
5

2

0

4

4
0

2
0

5

2

5

3
5

5
0

1

1

O
u
t
p
u
t: group_id

pla
y
e
r
_id

1

1
5

2

3
5

3

4
0*/
CREATE TABLE Teams2 (
    team_id int,
    team_name varchar(50),
    PRIMARY KEY (team_id)
);

INSERT INTO Teams2 (team_id, team_name) VALUES
(1, 'Team A'),
(2, 'Team B'),
(3, 'Team C');

CREATE TABLE Matches2 (
    match_id int,
    host_team int,
    guest_team int,
    host_goals int,
    guest_goals int,
    PRIMARY KEY (match_id)
);

INSERT INTO Matches2 (match_id, host_team, guest_team, host_goals, guest_goals) VALUES
(1, 15, 45, 3, 0),
(2, 30, 25, 1, 2),
(3, 30, 15, 2, 0),
(4, 40, 20, 5, 2),
(5, 35, 50, 1, 1);

CREATE TABLE Players2 (
    player_id int,
    group_id int,
    PRIMARY KEY (player_id)
);

-- Insert sample data into the Players table
INSERT INTO Players2 (player_id, group_id) VALUES
(15, 1),
(25, 1),
(30, 1),
(45, 1),
(10,2),
(35,2),
(50,2),
(20,3),
(40,3);

WITH AllScores AS (
    SELECT 
        player_id, 
        group_id, 
        SUM(CASE
            WHEN team_id = host_team AND host_goals > guest_goals THEN 3
            WHEN team_id = guest_team AND guest_goals > host_goals THEN 3
            WHEN host_goals = guest_goals THEN 1
            ELSE 0
        END) AS total_points
    FROM Players2
    LEFT JOIN Teams2 ON Players2.player_id = Teams2.team_id
    LEFT JOIN Matches2 ON Players2.player_id IN (host_team, guest_team)
    GROUP BY player_id, group_id
),
GroupRanks AS (
    SELECT 
        group_id, 
        player_id, 
        total_points, 
        RANK() OVER (PARTITION BY group_id ORDER BY total_points DESC, player_id) AS rnk
    FROM AllScores
)
SELECT group_id, player_id
FROM GroupRanks
WHERE rnk = 1;