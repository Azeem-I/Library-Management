drop database if exists library_management;
create database library_management;
use library_management; 

create table publisher(
publisher_PublisherName varchar(100) primary key,
publisher_PublisherAddress varchar(100),
publisher_PublisherPhone varchar(50));
select* from publisher;

create table books(
book_BookID int auto_increment primary key,
book_Title varchar(100),
book_PublisherName varchar(50),
foreign key(book_Publishername) references publisher(publisher_publisherName));
select* from books; 

create table authors(
book_authors_AuthorID int auto_increment primary key,
book_authors_BookID int ,
book_authors_AuthorName varchar(50),
foreign key(book_authors_BookID) references books(book_BookID));
select * from authors;

create table library_branch(
library_branch_BranchID int auto_increment primary key,
library_branch_BranchName varchar(100),
library_branch_BranchAddress varchar(100));
select* from library_branch;

create table book_copies(
book_copies_copyID int auto_increment primary key,
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_Of_Copies int,
foreign key(book_copies_BookID) references books(book_BookID),
foreign key(book_copies_BranchID) references library_branch(library_branch_BranchID));

create table borrower(
borrower_CardNo int auto_increment primary key,
borrower_BorrowerName varchar(100),
borrower_BorrowerAddress varchar(100),
borrower_BorrowerPhone varchar(100));
select * from borrower; 

create table book_loans(
book_loans_LoansID int auto_increment primary key,
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo int,
book_loans_DateOut date,
book_loans_DueDate date,
foreign key(book_loans_BookID) references books(book_BookID),
foreign key(book_loans_BranchID) references library_branch(library_branch_BranchID),
foreign key(book_loans_CardNo) references borrower(borrower_CardNo));
select * from book_loans;

/* 1. How many copies of the book titled "The Lost Tribe" are owned by the library
branch whose name is "Sharpstown"? */ 
select sum(bc.book_copies_No_Of_Copies) as totalBooks 
from book_copies as bc join library_branch as lb
on bc.book_copies_BranchID=lb.library_branch_BranchID
join books as bk 
on bk.book_BookID=bc.book_copies_BookID
where bk.book_title="The Lost Tribe" and lb.library_branch_BranchName="Sharpstown";


/*2. How many copies of the book titled "The Lost Tribe" are owned by each library
branch?*/
select  
lb.library_branch_BranchName,sum(bc.book_copies_No_of_Copies) as numberofBooks
from books as b join book_copies as bc
on b.book_BookID=bc.book_copies_BookID
join library_branch as lb 
on bc.book_copies_BranchID=lb.library_branch_BranchID
where b.book_title='The Lost Tribe' 
group by library_branch_BranchName;

/*3. Retrieve the names of all borrowers who do not have any books checked out*/ 
select borrower_Borrowername from borrower where borrower_CardNo not in 
(select book_loans_CardNo from book_loans); 


/* 4. For each book that is loaned out from the "Sharpstown" branch and whose
DueDate is 2/3/18, retrieve the book title, the borrower's name, and the
borrower's address.*/
select b.borrower_BorrowerName,b.borrower_BorrowerAddress,bk.book_Title
 from borrower as b
join book_loans as bl
on b.borrower_CardNo=bl.book_loans_CardNo
join books as bk 
on bl.book_loans_BookID=bk.book_BookID
where bl.book_loans_DueDate='0002-03-18' and book_loans_BranchID 
in (select library_branch_BranchID from library_branch where library_branch_BranchName='Sharpstown');

/*5. For each library branch, retrieve the branch name and the total number of books
loaned out from that branch*/
select lb.library_branch_BranchName,count(bl.book_loans_LoansID) as NumberOfBooksLoanedOut 
from library_branch as lb join book_loans as bl
on lb.library_branch_BranchID=bl.book_loans_BranchID
group by lb.library_branch_BranchName; 

/*6-Retrieve the names, addresses, and number of books checked out for all
borrowers who have more than five books checked out.*/
select b.borrower_BorrowerName,b.borrower_BorrowerAddress,count(bl.book_loans_CardNo) as counts
from borrower as b join book_loans as bl
group by b.borrower_BorrowerName,b.borrower_BorrowerAddress,
bl.book_loans_CardNo having counts>5; 

/*7-For each book authored by "Stephen King", retrieve the title and the number of
copies owned by the library branch whose name is "Central"*/
select bk.book_Title,sum(bc.book_copies_No_Of_Copies) as totalCopies
from books as bk join book_copies as bc
on bk.book_BookID=bc.book_copies_BookID
join authors as a on 
bk.book_BookID=a.book_authors_BookID 
join library_branch as lb
on lb.library_branch_BranchID=bc.book_copies_BranchID
where a.book_authors_AuthorName='Stephen king' and lb.library_branch_BranchName='Central'
group by bk.book_Title; 
