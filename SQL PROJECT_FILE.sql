--create table books
DROP TABLE IF EXISTS Books;
create table Books(
       Book_id serial primary key,
	   Title varchar(100),
	   Author varchar(100),
	   Genre varchar(50),
	   Published_Year int,
	   Price numeric(10,2),
	   Stock int
);
DROP TABLE IF EXISTS Customers;


create table Customers(
        Customer_id serial primary key,
		Name varchar(100),
		Email varchar(100),
		Phone varchar(50),
		City varchar(50),
		Country varchar(150)
		
);

DROP TABLE IF EXISTS Orders;
create table Orders(
       Order_id serial primary key,
       Customer_id int references Customers(Customer_id),
	   Book_Id int references Books(Book_id),
	   Order_date DATE,
	   Quantity int,
	   Total_Amount numeric(10,2)
);

select * from Books;
select * from Customers;
select * from Orders;

copy Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock )
from 'D:\Books.csv'
CSV HEADER;

copy Customers(Customer_ID,Name,Email,phone,City,Country)
from 'D:\Customers.csv'
CSV HEADER;

copy Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
from 'D:\Orders.csv'
CSV HEADER;

--1)Retrive all books in the "Fiction" genre:
select * from Books Where Genre='Fiction';

--2)find books published after the year 1950;
select * from Books where Published_year>1950;

--3)List all the customers from canada;
select * from Customers where country='Canada';

--4) show order placed in november 2023;
select * from Orders where order_date between '2023-11-1' and '2023-11-30';

--5) retrieve the total stock of book available;
select sum(Stock) as Total_books from Books;

--6) find the details of the most expensive book;
 select * from Books ORDER BY price DESC Limit 1;

 --7) show all customers who ordered more than 1 quantity of a book;
 select * from Orders where quantity>1;

 --8) retrive all orders where the total amount exceeds $20;
 select * from Orders where total_amount>20;
 
 --9) list all genre available in the Books table;
  select distinct genre from Books;

-- 10) FInd the book with the lowest stock;
  select * from Books order by Stock LIMIT 1;

  --11) Calculate the total revenue generate from all orders:
  select sum(total_amount) as revenue from Orders;

  --Advance Questions:
   --1)retrieve the total number of books sold for each genre:
    select b.Genre,sum(o.Quantity)as Total_Books_sold
	from Orders o
	join Books b ON o.book_id = b.book_id
	GROUP BY b.Genre;

--2) find the average price of books in the "Fantasy" genre;
  select avg(price) as Average_Price from Books WHERE Genre = 'Fantasy';

  --3)List customers who have placed at least 2 orders;
 select o.customer_id, c.name, count(o.order_id) as ORDER_COUNT
 FROM orders o 
 join customers c on o.customer_id=c.customer_id
 group by o.customer_id, c.name 
 HAVING COUNT(order_id) >=2;

 --4)Find the most frequently ordered book;
   select o.Book_id,b.Title, count(order_id) as ORDER_COUNT
   from orders o
   join books b on o.book_id=b.book_id
   group by o.book_id,b.Title
   order by ORDER_COUNT DESC LIMIT 1;

   --5)show the top 3 most expensive books of 'Fantasy' Genre:
    select * from books where genre = 'Fantasy'
	order by price DESC LIMIT 3;

	--6) Retrieve the total quantity of books sold by each author:
	 select b.author, sum(o.quantity) as Total_Books_Sold
	 From orders o
	 join books b on o.book_id=b.book_id
	 group by b.Author;

	 --7) List the cities where customers who spent over $30 are located:
	   select DISTINCT c.city,total_amount FROM orders o JOIN customers c ON o.customer_id = c.customer_id
	   where o.total_amount > 30;

	  --8)Find the customer who spent the most on orders:
	  select c.customer_id, c.name, sum(o.total_amount) as Total_Spent
	  from orders o 
	  join customers c on o.customer_id=c.customer_id
	  group by c.customer_id, c.name
	  order by Total_spent DESC LIMIT 3;
	 --9)Calulate the stock remaining after fulfilling all orders:
	    select b.book_id,b.title, b.stock,COALESCE(SUM(o.quantity),0)as order_quantity,
		 b.stock-COALESCE(SUM(o.quantity),0) as Remaining_Quantity
		from books b
		LEFT JOIN orders o ON b.book_id=o.book_id
		GROUP BY b.book_id ORDER BY b.book_id;