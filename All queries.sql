-- Create Database
CREATE DATABASE OnlineBookstore;

USE OnlineBookstore;

-- Create Tables
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Retrieve all books in the "Fiction" genre:
SELECT * FROM Books 
WHERE Genre='Fiction';

-- Find books published after the year 1960:
SELECT * FROM Books 
WHERE Published_year>1960;

-- List all customers from the India:
SELECT * FROM Customers 
WHERE country='India';

-- Show orders placed in November 2023:
SELECT * FROM Orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- Retrieve the total stock of books available:
SELECT SUM(stock) AS Total_Stock
From Books;

-- Find the details of the most expensive book:
SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;

-- Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE quantity>1;

-- Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE total_amount>20;

-- List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

-- Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM Orders;

-- Retrieve the total number of books sold for each genre:
SELECT * FROM ORDERS;

SELECT Books.Genre, SUM(Orders.Quantity) AS Total_Books_sold
FROM Orders 
JOIN Books ON Orders.book_id = Books.book_id
GROUP BY Books.Genre;

-- Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- List customers who have placed at least 2 orders:
SELECT orders.customer_id, customers.name, COUNT(orders.Order_id) AS ORDER_COUNT
FROM orders 
JOIN customers ON orders.customer_id=customers.customer_id
GROUP BY orders.customer_id, customers.name
HAVING COUNT(Order_id) >=2;

-- Find the most frequently ordered book:
SELECT orders.Book_id, books.title, COUNT(orders.order_id) AS ORDER_COUNT
FROM orders
JOIN books ON orders.book_id=books.book_id
GROUP BY orders.book_id, books.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

-- Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

-- Retrieve the total quantity of books sold by each author:
SELECT books.author, SUM(orders.quantity) AS Total_Books_Sold
FROM orders
JOIN books ON orders.book_id=books.book_id
GROUP BY books.Author;

-- List the cities where customers who spent over $30 are located:
SELECT DISTINCT customers.city, total_amount
FROM orders
JOIN customers ON orders.customer_id=customers.customer_id
WHERE orders.total_amount > 30;

-- Find the customer who spent the most on orders:
SELECT customers.customer_id, customers.name, SUM(orders.total_amount) AS Total_Spent
FROM orders
JOIN customers ON orders.customer_id=customers.customer_id
GROUP BY customers.customer_id, customers.name
ORDER BY Total_spent Desc LIMIT 1;

-- Calculate the stock remaining after fulfilling all orders:
SELECT 
    books.book_id, 
    MAX(books.title) AS title, 
    MAX(books.stock) AS stock, 
    COALESCE(SUM(orders.quantity),0) AS Order_quantity,
    MAX(books.stock) - COALESCE(SUM(orders.quantity),0) AS Remaining_Quantity
FROM books
LEFT JOIN orders ON books.book_id = orders.book_id
GROUP BY books.book_id
ORDER BY books.book_id
LIMIT 0, 1000;




