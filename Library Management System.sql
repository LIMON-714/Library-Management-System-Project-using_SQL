CREATE DATABASE LibraryManagement;
GO

USE LibraryManagement;
GO



-- Create Authors Table
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Bio VARCHAR(MAX)
);

-- Create Publishers Table
CREATE TABLE Publishers (
    PublisherID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Address VARCHAR(255),
    Phone VARCHAR(20)
);

-- Create Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(50)
);

-- Create Books Table
CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(100),
    AuthorID INT,
    PublisherID INT,
    CategoryID INT,
    PublicationYear INT,
    ISBN VARCHAR(20),
    Pages INT,
    CopiesAvailable INT,
    CONSTRAINT FK_Books_Authors FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    CONSTRAINT FK_Books_Publishers FOREIGN KEY (PublisherID) REFERENCES Publishers(PublisherID),
    CONSTRAINT FK_Books_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Create Members Table
CREATE TABLE Members (
    MemberID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(255),
    MembershipDate DATE
);

-- Create Loans Table
CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT,
    MemberID INT,
    LoanDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    CONSTRAINT FK_Loans_Books FOREIGN KEY (BookID) REFERENCES Books(BookID),
    CONSTRAINT FK_Loans_Members FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

-- Insert Authors
INSERT INTO Authors (FirstName, LastName, Bio) VALUES 
('George', 'Orwell', 'English novelist, essayist, journalist and critic.'),
('J.K.', 'Rowling', 'British author, best known for the Harry Potter series.'),
('J.R.R.', 'Tolkien', 'English writer, poet, philologist, and academic.');

-- Insert Publishers
INSERT INTO Publishers (Name, Address, Phone) VALUES 
('Penguin Books', '80 Strand, London, WC2R 0RL, England', '+44 20 7139 3000'),
('Bloomsbury Publishing', '50 Bedford Square, London, WC1B 3DP, England', '+44 20 7631 5600');

-- Insert Categories
INSERT INTO Categories (CategoryName) VALUES 
('Dystopian'),
('Fantasy'),
('Science Fiction'),
('Biography');

-- Insert Books
INSERT INTO Books (Title, AuthorID, PublisherID, CategoryID, PublicationYear, ISBN, Pages, CopiesAvailable) VALUES 
('1984', 1, 1, 1, 1949, '9780451524935', 328, 5),
('Harry Potter and the Sorcerer''s Stone', 2, 2, 2, 1997, '9780439554930', 309, 3),
('The Hobbit', 3, 1, 2, 1937, '9780547928227', 310, 4);

-- Insert Members
INSERT INTO Members (FirstName, LastName, DateOfBirth, Email, Phone, Address, MembershipDate) VALUES 
('John', 'Doe', '1990-01-01', 'john.doe@example.com', '123-456-7890', '123 Main St, Springfield, USA', '2020-01-15'),
('Jane', 'Smith', '1985-05-15', 'jane.smith@example.com', '098-765-4321', '456 Elm St, Springfield, USA', '2019-06-10');

-- Insert Loans
INSERT INTO Loans (BookID, MemberID, LoanDate, DueDate, ReturnDate) VALUES 
(1, 1, '2024-06-01', '2024-06-15', NULL),
(2, 2, '2024-06-05', '2024-06-19', NULL);


-- List All Books
SELECT B.BookID, B.Title, A.FirstName + ' ' + A.LastName AS Author_Name, P.Name AS Publisher, 
C.CategoryName AS Category, B.PublicationYear, B.ISBN, B.Pages, B.CopiesAvailable
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Publishers P ON B.PublisherID = P.PublisherID
JOIN Categories C ON B.CategoryID = C.CategoryID;

--List All Members
SELECT MemberID, FirstName, LastName, DateOfBirth, Phone, Email, Address, MembershipDate
FROM Members;

--List All Loans
SELECT L.LoanID, B.Title, M.FirstName + ' ' + M.LastName AS Member, L.LoanDate, L.DueDate, L.ReturnDate
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Members M ON L.MemberID = M.MemberID;


--Overdue Books
SELECT L.LoanID, B.Title, M.FirstName + ' ' + M.LastName AS Member, L.LoanDate, L.DueDate, L.ReturnDate
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Members M ON L.MemberID = M.MemberID
WHERE L.DueDate < GETDATE() AND L.ReturnDate IS NULL;




--Find Books by Author
DECLARE @AuthorName NVARCHAR(100) = 'J.K. Rowling';

SELECT B.BookID, B.Title, A.FirstName + ' ' + A.LastName AS Author, P.Name AS Publisher, 
       C.CategoryName AS Category, B.PublicationYear, B.ISBN, B.Pages, B.CopiesAvailable
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Publishers P ON B.PublisherID = P.PublisherID
JOIN Categories C ON B.CategoryID = C.CategoryID
WHERE A.FirstName + ' ' + A.LastName = @AuthorName;

--Find Books by Category
DECLARE @CategoryName VARCHAR(50) = 'Fantasy';

SELECT B.BookID, B.Title, A.FirstName + ' ' + A.LastName AS Author, P.Name AS Publisher, 
       C.CategoryName AS Category, B.PublicationYear, B.ISBN, B.Pages, B.CopiesAvailable
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Publishers P ON B.PublisherID = P.PublisherID
JOIN Categories C ON B.CategoryID = C.CategoryID
WHERE C.CategoryName = @CategoryName;

--Find Books by Publisher
DECLARE @PublisherName VARCHAR(100) = 'Penguin Books';

SELECT B.BookID, B.Title, A.FirstName + ' ' + A.LastName AS Author, P.Name AS Publisher, 
       C.CategoryName AS Category, B.PublicationYear, B.ISBN, B.Pages, B.CopiesAvailable
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Publishers P ON B.PublisherID = P.PublisherID
JOIN Categories C ON B.CategoryID = C.CategoryID
WHERE P.Name = @PublisherName;

-----------------------------------------------------------------------------------------------------------------------------------

--Update Book Copies
SELECT* FROM Books;

UPDATE Books
SET CopiesAvailable = CopiesAvailable + 1
WHERE BookID = 3;

SELECT * FROM Books;


--Delete a Member
select * from Members;

DELETE FROM Members
WHERE MemberID = 2;

select * from Members;



--Stored Procedures
--Add a New Book
CREATE PROCEDURE AddBook
    @Title VARCHAR(100),
    @AuthorID INT,
    @PublisherID INT,
    @CategoryID INT,
    @PublicationYear INT,
    @ISBN VARCHAR(20),
    @Pages INT,
    @CopiesAvailable INT
AS
BEGIN
    INSERT INTO Books (Title, AuthorID, PublisherID, CategoryID, PublicationYear, ISBN, Pages, CopiesAvailable)
    VALUES (@Title, @AuthorID, @PublisherID, @CategoryID, @PublicationYear, @ISBN, @Pages, @CopiesAvailable);
END;




SELECT * FROM Books;


EXEC AddBook 
    @Title = 'The man of great',
    @AuthorID = 2,
    @PublisherID = 2,
    @CategoryID = 1,
    @PublicationYear = 1938,
    @ISBN = '9770547928520',
    @Pages = 220,
    @CopiesAvailable = 6;

SELECT * FROM Books;







--Add a New Member
CREATE PROCEDURE AddMember
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DateOfBirth DATE,
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20),
    @Address NVARCHAR(255),
    @MembershipDate DATE
AS
BEGIN
    INSERT INTO Members (FirstName, LastName, DateOfBirth, Email, Phone, Address, MembershipDate)
    VALUES (@FirstName, @LastName, @DateOfBirth, @Email, @Phone, @Address, @MembershipDate);
END;

SELECT * FROM Members;


EXEC AddMember 
    @FirstName = 'Jony',
    @LastName = 'leam',
    @DateOfBirth = '1980-01-01',
    @Email = 'john.doe@example.com',
    @Phone = '123-456-7590',
    @Address = '123 Main33 St, Anytown, USA',
    @MembershipDate = '2024-06-13';

	
SELECT * FROM Members;
   


-- Loan a Book
CREATE PROCEDURE LoanBook
    @BookID INT,
    @MemberID INT,
    @LoanDate DATE,
    @DueDate DATE
AS
BEGIN
    INSERT INTO Loans (BookID, MemberID, LoanDate, DueDate)
    VALUES (@BookID, @MemberID, @LoanDate, @DueDate);

    UPDATE Books
    SET CopiesAvailable = CopiesAvailable - 1
    WHERE BookID = @BookID;
END;


EXEC LoanBook 
    @BookID = 1,
    @MemberID = 1,
    @LoanDate = '2024-06-13',
    @DueDate = '2024-06-27';


SELECT* FROM Loans;



--view


--View of All Books with Authors and Publishers
CREATE VIEW AllBooks AS
SELECT B.BookID, B.Title, A.FirstName + ' ' + A.LastName AS Author, P.Name AS Publisher, 
       C.CategoryName AS Category, B.PublicationYear, B.ISBN, B.Pages, B.CopiesAvailable
FROM Books B
JOIN Authors A ON B.AuthorID = A.AuthorID
JOIN Publishers P ON B.PublisherID = P.PublisherID
JOIN Categories C ON B.CategoryID = C.CategoryID;

select * from  AllBooks;


--View of All Active Loans
CREATE VIEW ActiveLoans AS
SELECT L.LoanID, B.Title, M.FirstName + ' ' + M.LastName AS Member, L.LoanDate, L.DueDate, L.ReturnDate
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Members M ON L.MemberID = M.MemberID
WHERE L.ReturnDate IS NULL;

select* from ActiveLoans;