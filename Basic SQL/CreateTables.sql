CREATE TABLE shoes
( id        char(10)      PRIMARY KEKY,
Brand       char(10)      NOT NULL, 
Type        char(255)     NOT NULL,
Color       char(255)     NOT NULL,
Price       decimal(8,2)  NOT NULL,
Desc        Varchar(750)  NULL
); 

INSERT INTO shoes 
(ID, 
Brand,
Type,
Color,
Price,
Desc,
)
VALUES 
( '2343',
'Gucci',
'Slippers',
'Blue',
'695.00',
NULL
);

#Creating temporary tables; Good to know they arefaster than creating real tables, allowing you to simplify complex queries and is deleted after use. 

CREATE TEMPORARY TABLE Sandals AS 
(
SELECT *
From shoes
where shoe_type = 'Sandals')
