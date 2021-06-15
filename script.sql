ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:NONE';

DROP TABLE "ADDRESSES";
DROP TABLE "ARTISTS";
DROP TABLE "AUCTIONS";
DROP TABLE "CLIENTS";
DROP TABLE "EMPLOYEES";
DROP TABLE "EXHIBITS";
DROP TABLE "INSTITUTIONS";
DROP TABLE "LOGS";
DROP TABLE "PERSONAL_DATA";
DROP TABLE "TRANSACTIONS";
/
--------------------------------------------------------
--  Tabela Addressses
--------------------------------------------------------

CREATE TABLE "ADDRESSES" (
"ID" NUMBER(*,0) NOT NULL,
"STREET" NVARCHAR2(50) NOT NULL,
"CITY" NVARCHAR2(50) NOT NULL,
"COUNTRY" NVARCHAR2(20) NOT NULL,
"POST_CODE" NVARCHAR2(10) NOT NULL
);

ALTER TABLE ADDRESSES ADD (
CONSTRAINT addr_pk PRIMARY KEY (ID));

CREATE SEQUENCE addr_seq START WITH 1;

CREATE OR REPLACE TRIGGER addr_bir 
BEFORE INSERT ON ADDRESSES
FOR EACH ROW

BEGIN
  SELECT addr_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

--------------------------------------------------------
--  Tabela Personal_Data
--------------------------------------------------------

CREATE TABLE "PERSONAL_DATA" (
"ID" NUMBER(*,0) NOT NULL,
"FIRST_NAME" NVARCHAR2(50) NOT NULL,
"LAST_NAME" NVARCHAR2(50) NOT NULL,
"PHONE_NUMBER" VARCHAR2(20) NOT NULL
);

ALTER TABLE "PERSONAL_DATA" ADD (
CONSTRAINT pers_pk PRIMARY KEY (ID));

CREATE SEQUENCE pers_seq START WITH 1;

CREATE OR REPLACE TRIGGER pers_bir 
BEFORE INSERT ON PERSONAL_DATA
FOR EACH ROW

BEGIN
  SELECT pers_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

--------------------------------------------------------
--  Tabela Artists
--------------------------------------------------------

CREATE TABLE "ARTISTS" (
"ID" NUMBER(*,0) NOT NULL,
"PERSONAL_DATA_ID" NUMBER(*,0) NOT NULL,
"DATE_OF_BIRTH" DATE NOT NULL,
"DATE_OF_DEATH" DATE,
"COUNTRY_OF_BIRTH" NVARCHAR2(25) NOT NULL,
"DESCRIPTION" NVARCHAR2(800),
CONSTRAINT "Art_Personal_FK" FOREIGN KEY (PERSONAL_DATA_ID) REFERENCES PERSONAL_DATA(ID)
);

ALTER TABLE "ARTISTS" ADD (
CONSTRAINT art_pk PRIMARY KEY (ID));

CREATE SEQUENCE art_seq START WITH 1;

CREATE OR REPLACE TRIGGER art_bir 
BEFORE INSERT ON ARTISTS
FOR EACH ROW

BEGIN
  SELECT art_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

--------------------------------------------------------
--  Tabela Clients
--------------------------------------------------------

CREATE TABLE "CLIENTS" (
"ID" NUMBER(*,0) NOT NULL,
"PERSONAL_DATA_ID" NUMBER(*,0) NOT NULL,
"ADDRESS_ID" NUMBER(*,0) NOT NULL,
CONSTRAINT "Cli_Personal_FK" FOREIGN KEY (PERSONAL_DATA_ID) REFERENCES PERSONAL_DATA(ID),
CONSTRAINT "Cli_Address_FK" FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESSES(ID)
);

ALTER TABLE "CLIENTS" ADD (
CONSTRAINT cli_pk PRIMARY KEY (ID));

CREATE SEQUENCE cli_seq START WITH 1;

CREATE OR REPLACE TRIGGER cli_bir 
BEFORE INSERT ON CLIENTS
FOR EACH ROW

BEGIN
  SELECT cli_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/
--------------------------------------------------------
--  Tabela Employees
--------------------------------------------------------

CREATE TABLE "EMPLOYEES" (
"ID" NUMBER(*,0) NOT NULL,
"SALARY" NUMBER(10,4) NOT NULL,
"CLIENT_ID" NUMBER(*,0) NOT NULL,
CONSTRAINT "Emp_Client_FK" FOREIGN KEY (CLIENT_ID) REFERENCES CLIENTS(ID)
);

ALTER TABLE "EMPLOYEES" ADD (
CONSTRAINT emp_pk PRIMARY KEY (ID));

CREATE SEQUENCE emp_seq START WITH 1;

CREATE OR REPLACE TRIGGER emp_bir 
BEFORE INSERT ON EMPLOYEES
FOR EACH ROW

BEGIN
  SELECT emp_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

--------------------------------------------------------
--  Tabela Institutions
--------------------------------------------------------

CREATE TABLE "INSTITUTIONS" (
"ID" NUMBER(*,0) NOT NULL, 
"NAME" NVARCHAR2(50) NOT NULL, 
"ADDRESS_ID" NUMBER(*,0) NOT NULL,
CONSTRAINT "Ins_Address_FK" FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESSES(ID)
);

ALTER TABLE "INSTITUTIONS" ADD (
CONSTRAINT ins_pk PRIMARY KEY (ID));

CREATE SEQUENCE ins_seq START WITH 1;

CREATE OR REPLACE TRIGGER ins_bir 
BEFORE INSERT ON INSTITUTIONS
FOR EACH ROW

BEGIN
  SELECT ins_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

-----------------------------------------------------
--  Tabela Auctions
--------------------------------------------------------

CREATE TABLE "AUCTIONS" (
"ID" NUMBER(*,0) NOT NULL,
"AUCTION_DATE" DATE NOT NULL, 
"INSTITUTION_ID" NUMBER(*,0) NOT NULL, 
"EMPLOYEE_ID" NUMBER(*,0) NOT NULL,
CONSTRAINT "Auc_Institutions_FK" FOREIGN KEY (INSTITUTION_ID) REFERENCES INSTITUTIONS(ID),
CONSTRAINT "Auc_Employees_FK" FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(ID)
);

ALTER TABLE "AUCTIONS" ADD (
CONSTRAINT auc_pk PRIMARY KEY (ID));

CREATE SEQUENCE auc_seq START WITH 1;

CREATE OR REPLACE TRIGGER auc_bir 
BEFORE INSERT ON AUCTIONS
FOR EACH ROW

BEGIN
  SELECT auc_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/
--------------------------------------------------------
--  Tabela Exhibits
--------------------------------------------------------

CREATE TABLE "EXHIBITS" (
"ID" NUMBER(*,0) NOT NULL, 
"NAME" NVARCHAR2(50) NOT NULL, 
"DESCRIPTION" NVARCHAR2(800),
"AUTHOR_ID" NUMBER(*,0) NOT NULL, 
"STARTING_BID" NUMBER(10,4) NOT NULL, 
"AUCTION_ID" NUMBER(*,0), 
"PLACE_OF_ORIGIN" NVARCHAR2(50) NOT NULL, 
"IS_AUTHENTIC" NUMBER(1,0) NOT NULL,
CONSTRAINT "Exh_Artists_FK" FOREIGN KEY (AUTHOR_ID) REFERENCES ARTISTS(ID),
CONSTRAINT "Exh_Auctions_FK" FOREIGN KEY (AUCTION_ID) REFERENCES AUCTIONS(ID)
);

ALTER TABLE "EXHIBITS" ADD (
CONSTRAINT exh_pk PRIMARY KEY (ID));

CREATE SEQUENCE exh_seq START WITH 1;

CREATE OR REPLACE TRIGGER exh_bir 
BEFORE INSERT ON EXHIBITS
FOR EACH ROW

BEGIN
  SELECT exh_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

--------------------------------------------------------
--  Tabela Transactions
--------------------------------------------------------

CREATE TABLE "TRANSACTIONS" (
"ID" NUMBER(*,0) NOT NULL,
"PRICE" NUMBER(10,4) NOT NULL,
"EXHIBIT_ID" NUMBER(*,0) NOT NULL,
"CLIENT_ID" NUMBER(*,0) NOT NULL,
CONSTRAINT "Tran_Exhibits_FK" FOREIGN KEY (EXHIBIT_ID) REFERENCES EXHIBITS(ID),
CONSTRAINT "Tran_Clients_FK" FOREIGN KEY (CLIENT_ID) REFERENCES CLIENTS(ID)
);

ALTER TABLE "TRANSACTIONS" ADD (
CONSTRAINT tran_pk PRIMARY KEY (ID));

CREATE SEQUENCE tran_seq START WITH 1;

CREATE OR REPLACE TRIGGER tran_bir 
BEFORE INSERT ON TRANSACTIONS
FOR EACH ROW

BEGIN
  SELECT tran_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

--------------------------------------------------------
--  Tabela Logs
--------------------------------------------------------

CREATE TABLE "LOGS" (
"ID" NUMBER(*,0) NOT NULL, 
"TABLE_NAME" VARCHAR2(50) NOT NULL, 
"EVENT_TYPE" VARCHAR2(50) NOT NULL, 
"SQL_COMMAND" VARCHAR2(3000) NOT NULL, 
"EVENT_DATE" DATE NOT NULL
);

ALTER TABLE "LOGS" ADD (
CONSTRAINT log_pk PRIMARY KEY (ID));

CREATE SEQUENCE log_seq START WITH 1;

CREATE OR REPLACE TRIGGER log_bir 
BEFORE INSERT ON LOGS
FOR EACH ROW

BEGIN
  SELECT log_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;
/

--------------------------------------------------------
--  Widoki
--------------------------------------------------------
CREATE OR REPLACE VIEW MONTHLY_EMPLOYEE_REPORT
("FIRST_NAME", "LAST_NAME", "DATE", "SOLD_EXHIBIT_ID", "SOLD_EXHIBIT_NAME", "TRANSACTION_ID")
AS
SELECT p.first_name, p.last_name, a.auction_date, e.Id, e.Name, t.Id
FROM Transactions t
JOIN Exhibits e ON t.exhibit_id = e.Id
JOIN Auctions a ON e.auction_id = a.Id
JOIN Employees em ON a.employee_id = em.Id
JOIN Clients c ON em.client_id = c.Id
JOIN Personal_data p ON c.personal_data_id = p.Id
WHERE EXTRACT(MONTH FROM a.auction_date) = EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM a.auction_date) = EXTRACT(YEAR FROM CURRENT_DATE);

--SELECT * FROM MONTHLY_EMPLOYEE_REPORT;

CREATE OR REPLACE VIEW EXHIBITS_READY_FOR_AUCTION
("NAME", "DESCRIPTION", "AUTHOR_FIRST_NAME", "AUTHOR_LAST_NAME", "STARTING_BID", "PLACE_OF_ORIGIN")
AS
SELECT e.name, e.description, p.first_name, p.last_name, e.starting_bid, e.place_of_origin
FROM exhibits e
JOIN artists a ON e.author_id = a.Id
JOIN personal_data p ON a.personal_data_id = p.Id
WHERE e.is_authentic = 1 and e.auction_id is  null;


--SELECT * FROM EXHIBITS_READY_FOR_AUCTION;

CREATE OR REPLACE VIEW UPCOMING_AUCTIONS
("DATE", "EMPLOYEE_FIRST_NAME", "EMPLOYEE_LAST_NAME", "INSTITUTION_NAME", "STREET", "CITY", "COUNTRY", "POST_CODE")
AS
SELECT a.auction_date, p.first_name, p.last_name, i.name, addresses.street, addresses.city, addresses.country, addresses.post_code
FROM auctions a
JOIN employees e ON e.Id = a.employee_id
JOIN clients c ON c.Id = e.client_id
JOIN personal_data p ON p.Id = c.personal_data_id
JOIN institutions i ON i.Id = a.institution_id
JOIN addresses ON addresses.Id = i.address_id
ORDER BY a.auction_date;

--SELECT * FROM UPCOMING_AUCTIONS;

--------------------------------------------------------
--  Triggery
--------------------------------------------------------


CREATE OR REPLACE TRIGGER ADDRESSES_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON ADDRESSES
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('ADDRESSES', 'INSERT',
        CONCAT('INSERT INTO ADRESSES(Id, Street, City, Country, Post_Code) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.STREET, CONCAT(' , ',
        CONCAT(:NEW.CITY, CONCAT(' , ',
        CONCAT(:NEW.COUNTRY, CONCAT(' , ',
        CONCAT(:NEW.POST_CODE,');'
        )))))))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('ADDRESSES', 'UPDATE', 
        CONCAT('UPDATE ADDRESSES SET Street = ',
        CONCAT(:NEW.STREET ,
        CONCAT(' ,  City = ',
        CONCAT(:NEW.CITY ,
        CONCAT(' ,  Country = ',
        CONCAT(:NEW.COUNTRY , 
        CONCAT(' ,  Post_Code = ',
        CONCAT(:NEW.POST_CODE , 
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('ADDRESSES', 'DELETE',
        CONCAT('DELETE FROM ADDRESSES WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER ARTISTS_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON ARTISTS
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('ARTISTS', 'INSERT',
        CONCAT('INSERT INTO ARTISTS(Id, Personal_Data_Id, Date_Of_Birth, Date_Of_Death, Country_Of_Birth, Description) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.Personal_Data_Id, CONCAT(' , ',
        CONCAT(:NEW.Date_Of_Birth, CONCAT(' , ',
        CONCAT(:NEW.Date_Of_Death, CONCAT(' , ',
        CONCAT(:NEW.Country_Of_Birth, CONCAT(' , ',
        CONCAT(:NEW.DESCRIPTION, ');'
        )))))))))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('ARTISTS', 'UPDATE', 
        CONCAT('UPDATE ARTISTS SET Personal_Data_Id = ',
        CONCAT(:NEW.PERSONAL_DATA_ID ,
        CONCAT(' ,  Date_Of_Birth = ',
        CONCAT(:NEW.DATE_OF_BIRTH ,
        CONCAT(' ,  Date_Of_Death = ',
        CONCAT(:NEW.DATE_OF_DEATH , 
        CONCAT(' ,  Country_Of_Birth = ',
        CONCAT(:NEW.COUNTRY_OF_BIRTH , 
        CONCAT(' ,  Description = ',
        CONCAT(:NEW.DESCRIPTION , 
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))))))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('ARTISTS', 'DELETE',
        CONCAT('DELETE FROM ARTISTS WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER AUCTIONS_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON AUCTIONS
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('AUCTIONS', 'INSERT',
        CONCAT('INSERT INTO AUCTIONS(Id, Auction_Date, Institution_Id, Employee_Id) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.AUCTION_DATE, CONCAT(' , ',
        CONCAT(:NEW.INSTITUTION_ID, CONCAT(' , ',
        CONCAT(:NEW.EMPLOYEE_ID,');'
        )))))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('AUCTIONS', 'UPDATE', 
        CONCAT('UPDATE AUCTIONS SET Auction_Date = ',
        CONCAT(:NEW.Auction_Date ,
        CONCAT(' ,  Insitution_Id = ',
        CONCAT(:NEW.Institution_Id ,
        CONCAT(' ,  Employee_Id = ',
        CONCAT(:NEW.Employee_Id , 
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('AUCTIONS', 'DELETE',
        CONCAT('DELETE FROM AUCTIONS WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER CLIENTS_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON CLIENTS
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('CLIENTS', 'INSERT',
        CONCAT('INSERT INTO CLIENTS(Id, Personal_Data_Id, Address_Id) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.Personal_Data_Id, CONCAT(' , ',
        CONCAT(:NEW.Address_Id,');'
        )))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('CLIENTS', 'UPDATE', 
        CONCAT('UPDATE CLIENTS SET Personal_Data_Id = ',
        CONCAT(:NEW.Personal_Data_Id ,
        CONCAT(' ,  Address_Id = ',
        CONCAT(:NEW.Address_Id ,
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('CLIENTS', 'DELETE',
        CONCAT('DELETE FROM CLIENTS WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER EMPLOYEES_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON EMPLOYEES
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('EMPLOYEES', 'INSERT',
        CONCAT('INSERT INTO EMPLOYEES(Id, Salary, Client_Id) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.SALARY, CONCAT(' , ',
        CONCAT(:NEW.CLIENT_ID,');'
        )))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('EMPLOYEES', 'UPDATE', 
        CONCAT('UPDATE EMPLOYEES SET Salary = ',
        CONCAT(:NEW.SALARY ,
        CONCAT(' ,  Client_Id = ',
        CONCAT(:NEW.CLIENT_ID ,
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('EMPLOYEES', 'DELETE',
        CONCAT('DELETE FROM EMPLOYEES WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER EXHIBITS_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON EXHIBITS
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('EXHIBITS', 'INSERT',
        CONCAT('INSERT INTO EXHIBITS(Id, Name, Description, Author_Id, Starting_Bid, Auction_Id, Place_Of_Origin, Is_Authentic) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.NAME, CONCAT(' , ',
        CONCAT(:NEW.Description, CONCAT(' , ',
        CONCAT(:NEW.Author_Id, CONCAT(' , ',
        CONCAT(:NEW.Starting_Bid, CONCAT(' , ',
        CONCAT(:NEW.Auction_Id, CONCAT(' , ',
        CONCAT(:NEW.Place_Of_Origin, CONCAT(' , ',
        CONCAT(:NEW.Is_Authentic,');'
        )))))))))))))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('EXHIBITS', 'UPDATE', 
        CONCAT('UPDATE EXHIBITS SET Name = ',
        CONCAT(:NEW.NAME ,
        CONCAT(' ,  Description = ',
        CONCAT(:NEW.DESCRIPTION ,
        CONCAT(' ,  Author_Id = ',
        CONCAT(:NEW.Author_Id ,
        CONCAT(' ,  Starting_Bid = ',
        CONCAT(:NEW.Starting_Bid ,
        CONCAT(' ,  Auction_Id = ',
        CONCAT(:NEW.Auction_Id ,
        CONCAT(' ,  Place_Of_Origin = ',
        CONCAT(:NEW.Place_Of_Origin ,
        CONCAT(' ,  Is_Authentic = ',
        CONCAT(:NEW.Is_Authentic ,
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))))))))))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('EXHIBITS', 'DELETE',
        CONCAT('DELETE FROM EXHIBITS WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/


CREATE OR REPLACE TRIGGER INSTITUTIONS_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON INSTITUTIONS
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('INSTITUTIONS', 'INSERT',
        CONCAT('INSERT INTO INSTITUTIONS(Id, Name, Address_Id) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.NAME, CONCAT(' , ',
        CONCAT(:NEW.ADDRESS_ID,');'
        )))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('INSTITUTIONS', 'UPDATE', 
        CONCAT('UPDATE INSTITUTIONS SET Name = ',
        CONCAT(:NEW.NAME ,
        CONCAT(' ,  Address_Id = ',
        CONCAT(:NEW.ADDRESS_ID ,
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('INSTITUTIONS', 'DELETE',
        CONCAT('DELETE FROM INSTITUTIONS WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER PERSONAL_DATA_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON PERSONAL_DATA
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('PERSONAL_DATA', 'INSERT',
        CONCAT('INSERT INTO PERSONAL_DATA(Id, First_Name, Last_Name, Phone_Number) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.First_Name, CONCAT(' , ',
        CONCAT(:NEW.Last_Name, CONCAT(' , ',
        CONCAT(:NEW.Phone_Number,');'
        )))))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('PERSONAL_DATA', 'UPDATE', 
        CONCAT('UPDATE PERSONAL_DATA SET First_Name = ',
        CONCAT(:NEW.First_Name ,
        CONCAT(' ,  Last_Name = ',
        CONCAT(:NEW.Last_Name ,
        CONCAT(' ,  Phone_Number = ',
        CONCAT(:NEW.Phone_Number , 
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('PERSONAL_DATA', 'DELETE',
        CONCAT('DELETE FROM PERSONAL_DATA WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER INSTITUTIONS_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON INSTITUTIONS
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('INSTITUTIONS', 'INSERT',
        CONCAT('INSERT INTO INSTITUTIONS(Id, Name, Address_Id) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.NAME, CONCAT(' , ',
        CONCAT(:NEW.ADDRESS_ID,');'
        )))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('INSTITUTIONS', 'UPDATE', 
        CONCAT('UPDATE INSTITUTIONS SET Name = ',
        CONCAT(:NEW.NAME ,
        CONCAT(' ,  Address_Id = ',
        CONCAT(:NEW.ADDRESS_ID ,
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('INSTITUTIONS', 'DELETE',
        CONCAT('DELETE FROM INSTITUTIONS WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRANSACTIONS_LOG 
AFTER INSERT OR UPDATE OR DELETE
ON TRANSACTIONS
FOR EACH ROW
DECLARE
BEGIN
    IF inserting THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('TRANSACTIONS', 'INSERT',
        CONCAT('INSERT INTO TRANSACTIONS(Id, Price, Exhibit_Id, Client_Id) VALUES (',
        CONCAT(:NEW.ID,CONCAT(' , ', 
        CONCAT(:NEW.Price, CONCAT(' , ',
        CONCAT(:NEW.Exhibit_Id, CONCAT(' , ',
        CONCAT(:NEW.Client_Id,');'
        )))))))), 
        SYSDATE);
    ELSIF updating THEN
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('TRANSACTIONS', 'UPDATE', 
        CONCAT('UPDATE TRANSACTIONS SET Price = ',
        CONCAT(:NEW.Price ,
        CONCAT(' ,  Exhibit_Id = ',
        CONCAT(:NEW.Exhibit_Id ,
        CONCAT(' ,  Client_Id = ',
        CONCAT(:NEW.Client_Id , 
        CONCAT(' WHERE Id = ', 
        CONCAT(:OLD.Id, ';'
        )))))))),
        SYSDATE);
    ELSE 
        INSERT INTO LOGS (TABLE_NAME, EVENT_TYPE, SQL_COMMAND, EVENT_DATE)
        VALUES ('TRANSACTIONS', 'DELETE',
        CONCAT('DELETE FROM TRANSACTIONS WHERE ID = ', 
        CONCAT(:OLD.ID, ';'
        ))
        , SYSDATE);
    END IF;
END;
/

--------------------------------------------------------
--  Dane
--------------------------------------------------------

-- Addresses

insert into ADDRESSES (street, city, country, post_code) values ('031 Warner Road', 'Zakliczyn', 'Poland', '32-840');
insert into ADDRESSES (street, city, country, post_code) values ('7754 Transport Terrace', 'Pruchnik', 'Poland', '37-560');
insert into ADDRESSES (street, city, country, post_code) values ('7565 East Road', 'Targowisko', 'Poland', '32-015');
insert into ADDRESSES (street, city, country, post_code) values ('41749 Beilfuss Plaza', 'Pokój', 'Poland', '46-034');
insert into ADDRESSES (street, city, country, post_code) values ('81785 Bunker Hill Circle', 'Sabnie', 'Poland', '08-331');
insert into ADDRESSES (street, city, country, post_code) values ('45070 Crest Line Drive', 'Walichnowy', 'Poland', '85-056');
insert into ADDRESSES (street, city, country, post_code) values ('13 Anderson Center', 'Kiernozia', 'Poland', '99-412');
insert into ADDRESSES (street, city, country, post_code) values ('1 Northridge Lane', 'Stryszów', 'Poland', '34-146');
insert into ADDRESSES (street, city, country, post_code) values ('8801 Service Point', 'Prusice', 'Poland', '55-110');
insert into ADDRESSES (street, city, country, post_code) values ('58052 American Hill', 'Gozdowo', 'Poland', '09-213');
insert into ADDRESSES (street, city, country, post_code) values ('32699 Carpenter Circle', 'Skarbimierz Osiedle', 'Poland', '20-282');
insert into ADDRESSES (street, city, country, post_code) values ('3416 Lakeland Junction', 'Mszana Dolna', 'Poland', '34-730');
insert into ADDRESSES (street, city, country, post_code) values ('1 Havey Center', 'Wi?lica', 'Poland', '28-160');
insert into ADDRESSES (street, city, country, post_code) values ('3 Brown Pass', 'Brudzew', 'Poland', '62-720');
insert into ADDRESSES (street, city, country, post_code) values ('34476 Northwestern Park', 'Grojec', 'Poland', '32-615');
insert into ADDRESSES (street, city, country, post_code) values ('159 Shasta Avenue', 'Skórcz', 'Poland', '83-220');
insert into ADDRESSES (street, city, country, post_code) values ('7999 Acker Point', 'Góra', 'Poland', '56-200');
insert into ADDRESSES (street, city, country, post_code) values ('63754 Grayhawk Place', 'Trawniki', 'Poland', '21-044');
insert into ADDRESSES (street, city, country, post_code) values ('96808 Vernon Pass', 'Brok', 'Poland', '07-306');
insert into ADDRESSES (street, city, country, post_code) values ('19882 Toban Alley', 'Drawsko', 'Poland', '64-733');
insert into ADDRESSES (street, city, country, post_code) values ('7 Marcy Court', 'Gniechowice', 'Poland', '55-042');
insert into ADDRESSES (street, city, country, post_code) values ('3195 Karstens Street', 'Ko?biel', 'Poland', '05-340');
insert into ADDRESSES (street, city, country, post_code) values ('614 American Ash Park', 'Stoszowice', 'Poland', '57-215');
insert into ADDRESSES (street, city, country, post_code) values ('4 Elka Drive', 'Pi?awa Górna', 'Poland', '58-240');
insert into ADDRESSES (street, city, country, post_code) values ('81768 Atwood Hill', 'Kalwaria Zebrzydowska', 'Poland', '34-130');
insert into ADDRESSES (street, city, country, post_code) values ('0331 Rigney Lane', 'Jab?onica Polska', 'Poland', '38-421');
insert into ADDRESSES (street, city, country, post_code) values ('2274 Westport Avenue', 'Jastrowie', 'Poland', '64-915');
insert into ADDRESSES (street, city, country, post_code) values ('6100 Schmedeman Crossing', 'Wle?', 'Poland', '59-610');
insert into ADDRESSES (street, city, country, post_code) values ('45305 Sherman Crossing', 'Trzciana', 'Poland', '36-071');
insert into ADDRESSES (street, city, country, post_code) values ('534 Mockingbird Alley', 'Mnich', 'Poland', '43-523');
insert into ADDRESSES (street, city, country, post_code) values ('966 Morning Road', 'Giedlarowa', 'Poland', '40-401');
insert into ADDRESSES (street, city, country, post_code) values ('27664 Novick Park', 'Barwa?d ?redni', 'Poland', '34-103');
insert into ADDRESSES (street, city, country, post_code) values ('12 Browning Center', 'Czchów', 'Poland', '32-860');
insert into ADDRESSES (street, city, country, post_code) values ('52 Rigney Plaza', 'Czernice Borowe', 'Poland', '06-415');
insert into ADDRESSES (street, city, country, post_code) values ('184 Thackeray Alley', 'Wilkowice', 'Poland', '43-365');
insert into ADDRESSES (street, city, country, post_code) values ('9 Schurz Crossing', 'Debrzno', 'Poland', '77-310');
insert into ADDRESSES (street, city, country, post_code) values ('352 Acker Road', '?abieniec', 'Poland', '05-509');
insert into ADDRESSES (street, city, country, post_code) values ('2 Heath Crossing', 'Lubin', 'Poland', '59-339');
insert into ADDRESSES (street, city, country, post_code) values ('93296 Charing Cross Junction', 'Inowroc?aw', 'Poland', '88-115');
insert into ADDRESSES (street, city, country, post_code) values ('358 Hudson Place', 'Miejsce Piastowe', 'Poland', '38-430');
insert into ADDRESSES (street, city, country, post_code) values ('209 Hovde Lane', 'Zwierzy?', 'Poland', '66-542');
insert into ADDRESSES (street, city, country, post_code) values ('3337 Nobel Parkway', 'Lisków', 'Poland', '62-850');
insert into ADDRESSES (street, city, country, post_code) values ('2 Ramsey Way', 'Malec', 'Poland', '43-356');
insert into ADDRESSES (street, city, country, post_code) values ('242 Bluestem Way', 'Studzienice', 'Poland', '77-143');
insert into ADDRESSES (street, city, country, post_code) values ('97611 Northfield Pass', 'Iwonicz-Zdrój', 'Poland', '38-440');
insert into ADDRESSES (street, city, country, post_code) values ('31 Colorado Terrace', 'Trzcianka', 'Poland', '64-980');
insert into ADDRESSES (street, city, country, post_code) values ('2 Moose Court', 'Przasnysz', 'Poland', '06-302');
insert into ADDRESSES (street, city, country, post_code) values ('16394 Merry Crossing', 'Popielów', 'Poland', '46-090');
insert into ADDRESSES (street, city, country, post_code) values ('6 Browning Point', 'W?brze?no', 'Poland', '87-201');
insert into ADDRESSES (street, city, country, post_code) values ('37346 Dixon Road', 'Parczew', 'Poland', '21-200');

-- Personal Data

insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Clarance', 'Di Francecshi', '2651683434');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Vick', 'Elverstone', '1489561889');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Myrlene', 'Stodit', '3967621494');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Claybourne', 'Garbott', '5708503247');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Ethe', 'Statter', '8632662259');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Joeann', 'Chartman', '7785012808');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Nobie', 'Norrington', '9613672348');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Rustin', 'Kestell', '3172297509');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Noemi', 'Inman', '2645999878');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Aubree', 'Gilliard', '9967245031');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Roseanne', 'Keast', '9504585961');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Padget', 'Irnis', '7699273113');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Karalee', 'Penright', '7382992356');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Lewie', 'Hamelyn', '8706655720');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Cameron', 'MacCracken', '8571453973');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Hurlee', 'Gerram', '1201967602');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Lacy', 'Warkup', '7919939225');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Shep', 'Clayfield', '9078294356');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Juliette', 'MacAlinden', '3229878783');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Chelsie', 'Warlock', '7881558978');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Melodee', 'Huggett', '2951954129');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Hakim', 'Marlor', '7279351858');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Chip', 'O''Longain', '7771859889');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Anstice', 'Whetson', '9367463461');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Damon', 'Comello', '7205163205');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Orren', 'Colleford', '4159578829');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Leisha', 'Reidshaw', '4935302370');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Reamonn', 'Alder', '9494386230');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Loreen', 'Schuh', '1692498644');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Peder', 'Puvia', '6573854956');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Gusty', 'Lechmere', '9617161542');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Patric', 'Greenroyd', '4833159348');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Leona', 'Dreschler', '9784039998');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Neron', 'Guitton', '6008322378');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Theressa', 'Bisgrove', '1453275219');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Ike', 'Sheppey', '8104137896');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Jefferey', 'Cobson', '6694130733');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Amie', 'Maddison', '6376691038');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Luis', 'Keays', '8587695578');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Jeramey', 'Mansuer', '6515842125');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Emmet', 'Wason', '6648891204');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Hedvige', 'Staff', '4052094453');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Sanson', 'Carren', '7558830053');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Adi', 'Meas', '7488265195');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Bartel', 'Jerok', '2577286582');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Lindon', 'Warnock', '2995819847');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Jarrad', 'Turpin', '6358163692');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Spense', 'Shimony', '3307640826');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Erica', 'Langtry', '3419957299');
insert into PERSONAL_DATA (first_name, last_name, phone_number) values ('Egbert', 'Balsellie', '9911013401');

-- Artists

insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (50, to_date('11/08/1996', 'DD/MM/YYYY'), null, 'Sweden', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (40, to_date('07/10/1952', 'DD/MM/YYYY'), to_date('20/07/2019', 'DD/MM/YYYY'), 'China', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (35, to_date('05/02/1961', 'DD/MM/YYYY'), to_date('10/01/1996', 'DD/MM/YYYY'), 'China', 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (17, to_date('20/11/1947', 'DD/MM/YYYY'), to_date('30/01/2004', 'DD/MM/YYYY'), 'Canada', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (18, to_date('04/02/1938', 'DD/MM/YYYY'), to_date('09/01/1993', 'DD/MM/YYYY'), 'China', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (22, to_date('03/07/1951', 'DD/MM/YYYY'), to_date('27/10/2002', 'DD/MM/YYYY'), 'Poland', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (43, to_date('06/03/1975', 'DD/MM/YYYY'), to_date('15/11/2011', 'DD/MM/YYYY'), 'Russia', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (41, to_date('09/09/1956', 'DD/MM/YYYY'), to_date('06/08/2010', 'DD/MM/YYYY'), 'Ireland', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (34, to_date('14/05/1987', 'DD/MM/YYYY'), to_date('06/10/1993', 'DD/MM/YYYY'), 'Costa Rica', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (40, to_date('10/06/1999', 'DD/MM/YYYY'), to_date('13/08/2018', 'DD/MM/YYYY'), 'Brazil', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (15, to_date('25/04/1935', 'DD/MM/YYYY'), to_date('14/12/1993', 'DD/MM/YYYY'), 'Greece', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (44, to_date('06/07/1985', 'DD/MM/YYYY'), to_date('13/01/2011', 'DD/MM/YYYY'), 'Canada', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (41, to_date('25/07/1938', 'DD/MM/YYYY'), to_date('03/04/2005', 'DD/MM/YYYY'), 'China', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (8, to_date('23/06/1955', 'DD/MM/YYYY'), to_date('23/12/1990', 'DD/MM/YYYY'), 'Indonesia', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (6, to_date('25/04/2020', 'DD/MM/YYYY'), null, 'Indonesia', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (49, to_date('18/10/2013', 'DD/MM/YYYY'), null, 'Brazil', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (15, to_date('07/02/1939', 'DD/MM/YYYY'), to_date('23/10/2019', 'DD/MM/YYYY'), 'Thailand', 'Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (45, to_date('28/08/1971', 'DD/MM/YYYY'), to_date('08/05/1992', 'DD/MM/YYYY'), 'China', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (1, to_date('23/07/1985', 'DD/MM/YYYY'), to_date('30/09/2008', 'DD/MM/YYYY'), 'Malaysia', 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (15, to_date('12/05/2016', 'DD/MM/YYYY'), null, 'Sweden', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (11, to_date('08/03/2016', 'DD/MM/YYYY'), null, 'Indonesia', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (4, to_date('25/01/1952', 'DD/MM/YYYY'), to_date('29/06/2018', 'DD/MM/YYYY'), 'Canada', 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (50, to_date('13/10/1971', 'DD/MM/YYYY'), to_date('23/04/1998', 'DD/MM/YYYY'), 'China', 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (34, to_date('05/03/1994', 'DD/MM/YYYY'), to_date('11/05/2004', 'DD/MM/YYYY'), 'Palestinian Territory', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (4, to_date('06/10/2001', 'DD/MM/YYYY'), null, 'Poland', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (50, to_date('19/01/1951', 'DD/MM/YYYY'), to_date('26/06/2002', 'DD/MM/YYYY'), 'Ukraine', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (11, to_date('11/04/2020', 'DD/MM/YYYY'), null, 'Portugal', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (9, to_date('03/11/2018', 'DD/MM/YYYY'), null, 'China', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (42, to_date('10/01/1952', 'DD/MM/YYYY'), to_date('10/08/2016', 'DD/MM/YYYY'), 'Sweden', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (45, to_date('17/09/2014', 'DD/MM/YYYY'), to_date('06/05/2019', 'DD/MM/YYYY'), 'China', 'Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (27, to_date('02/02/1998', 'DD/MM/YYYY'), to_date('14/12/2001', 'DD/MM/YYYY'), 'Indonesia', 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (20, to_date('26/10/1948', 'DD/MM/YYYY'), to_date('05/12/2014', 'DD/MM/YYYY'), 'China', 'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (38, to_date('09/11/1999', 'DD/MM/YYYY'), null, 'Czech Republic', 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (11, to_date('11/08/1972', 'DD/MM/YYYY'), to_date('27/08/2018', 'DD/MM/YYYY'), 'Colombia', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (16, to_date('12/06/1999', 'DD/MM/YYYY'), to_date('09/02/2009', 'DD/MM/YYYY'), 'China', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (42, to_date('05/12/1999', 'DD/MM/YYYY'), to_date('20/03/2012', 'DD/MM/YYYY'), 'Czech Republic', 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (22, to_date('28/03/1947', 'DD/MM/YYYY'), to_date('14/06/1996', 'DD/MM/YYYY'), 'Netherlands', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (32, to_date('06/05/1954', 'DD/MM/YYYY'), to_date('25/11/2004', 'DD/MM/YYYY'), 'China', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (2, to_date('05/11/1951', 'DD/MM/YYYY'), to_date('22/11/2020', 'DD/MM/YYYY'), 'Russia', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (32, to_date('12/02/1931', 'DD/MM/YYYY'), to_date('12/05/2009', 'DD/MM/YYYY'), 'Sweden', 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (25, to_date('03/12/1991', 'DD/MM/YYYY'), to_date('23/11/2006', 'DD/MM/YYYY'), 'Guatemala', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (36, to_date('10/02/1990', 'DD/MM/YYYY'), to_date('09/10/1996', 'DD/MM/YYYY'), 'Mexico', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (20, to_date('02/12/1991', 'DD/MM/YYYY'), to_date('26/12/2009', 'DD/MM/YYYY'), 'China', 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (45, to_date('21/01/1949', 'DD/MM/YYYY'), to_date('12/06/1990', 'DD/MM/YYYY'), 'Philippines', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (32, to_date('03/05/1961', 'DD/MM/YYYY'), to_date('08/03/1996', 'DD/MM/YYYY'), 'Czech Republic', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (39, to_date('09/07/2000', 'DD/MM/YYYY'), null, 'Cambodia', 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (18, to_date('12/04/1975', 'DD/MM/YYYY'), to_date('04/02/2016', 'DD/MM/YYYY'), 'Thailand', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (10, to_date('25/12/2002', 'DD/MM/YYYY'), to_date('27/11/2007', 'DD/MM/YYYY'), 'China', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.');
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (40, to_date('13/07/1975', 'DD/MM/YYYY'), to_date('28/06/2014', 'DD/MM/YYYY'), 'China', null);
insert into ARTISTS (personal_data_id, date_of_birth, date_of_death, country_of_birth, description) values (47, to_date('18/04/2010', 'DD/MM/YYYY'), to_date('14/09/2010', 'DD/MM/YYYY'), 'Papua New Guinea', null);

-- Clients

insert into CLIENTS (personal_data_id, address_id) values (23, 42);
insert into CLIENTS (personal_data_id, address_id) values (8, 7);
insert into CLIENTS (personal_data_id, address_id) values (24, 46);
insert into CLIENTS (personal_data_id, address_id) values (21, 7);
insert into CLIENTS (personal_data_id, address_id) values (48, 38);
insert into CLIENTS (personal_data_id, address_id) values (27, 42);
insert into CLIENTS (personal_data_id, address_id) values (2, 22);
insert into CLIENTS (personal_data_id, address_id) values (34, 32);
insert into CLIENTS (personal_data_id, address_id) values (45, 9);
insert into CLIENTS (personal_data_id, address_id) values (33, 13);
insert into CLIENTS (personal_data_id, address_id) values (23, 44);
insert into CLIENTS (personal_data_id, address_id) values (19, 35);
insert into CLIENTS (personal_data_id, address_id) values (32, 20);
insert into CLIENTS (personal_data_id, address_id) values (22, 24);
insert into CLIENTS (personal_data_id, address_id) values (23, 47);
insert into CLIENTS (personal_data_id, address_id) values (41, 34);
insert into CLIENTS (personal_data_id, address_id) values (23, 28);
insert into CLIENTS (personal_data_id, address_id) values (49, 10);
insert into CLIENTS (personal_data_id, address_id) values (12, 33);
insert into CLIENTS (personal_data_id, address_id) values (33, 39);
insert into CLIENTS (personal_data_id, address_id) values (8, 10);
insert into CLIENTS (personal_data_id, address_id) values (6, 2);
insert into CLIENTS (personal_data_id, address_id) values (8, 15);
insert into CLIENTS (personal_data_id, address_id) values (50, 18);
insert into CLIENTS (personal_data_id, address_id) values (48, 33);
insert into CLIENTS (personal_data_id, address_id) values (45, 25);
insert into CLIENTS (personal_data_id, address_id) values (15, 18);
insert into CLIENTS (personal_data_id, address_id) values (49, 42);
insert into CLIENTS (personal_data_id, address_id) values (30, 4);
insert into CLIENTS (personal_data_id, address_id) values (11, 19);

-- Employees

insert into EMPLOYEES (salary, client_id) values (9939.57, 1);
insert into EMPLOYEES (salary, client_id) values (7419.37, 2);
insert into EMPLOYEES (salary, client_id) values (5417.64, 3);
insert into EMPLOYEES (salary, client_id) values (8075.69, 4);
insert into EMPLOYEES (salary, client_id) values (2937.62, 5);
insert into EMPLOYEES (salary, client_id) values (5095.07, 6);
insert into EMPLOYEES (salary, client_id) values (7885.1, 7);
insert into EMPLOYEES (salary, client_id) values (5862.63, 8);
insert into EMPLOYEES (salary, client_id) values (7247.84, 9);
insert into EMPLOYEES (salary, client_id) values (8708.53, 10);
insert into EMPLOYEES (salary, client_id) values (7408.87, 11);
insert into EMPLOYEES (salary, client_id) values (3160.05, 12);
insert into EMPLOYEES (salary, client_id) values (3280.39, 13);
insert into EMPLOYEES (salary, client_id) values (7771.57, 14);
insert into EMPLOYEES (salary, client_id) values (1312.81, 15);
insert into EMPLOYEES (salary, client_id) values (2959.35, 16);
insert into EMPLOYEES (salary, client_id) values (4567.84, 17);
insert into EMPLOYEES (salary, client_id) values (3378.87, 18);
insert into EMPLOYEES (salary, client_id) values (1332.65, 19);
insert into EMPLOYEES (salary, client_id) values (1819.77, 20);
insert into EMPLOYEES (salary, client_id) values (9660.37, 21);
insert into EMPLOYEES (salary, client_id) values (7123.85, 22);
insert into EMPLOYEES (salary, client_id) values (3093.64, 23);
insert into EMPLOYEES (salary, client_id) values (6555.72, 24);
insert into EMPLOYEES (salary, client_id) values (7389.72, 25);
insert into EMPLOYEES (salary, client_id) values (6284.74, 26);
insert into EMPLOYEES (salary, client_id) values (2729.05, 27);
insert into EMPLOYEES (salary, client_id) values (6102.13, 28);
insert into EMPLOYEES (salary, client_id) values (2069.68, 29);
insert into EMPLOYEES (salary, client_id) values (1480.25, 30);

-- Institutions

insert into INSTITUTIONS (name, address_id) values ('Pagac, Crona and Russel', 11);
insert into INSTITUTIONS (name, address_id) values ('Brakus-Bernhard', 12);
insert into INSTITUTIONS (name, address_id) values ('Lang and Sons', 13);
insert into INSTITUTIONS (name, address_id) values ('Marks Group', 14);
insert into INSTITUTIONS (name, address_id) values ('Heidenreich-Denesik', 15);
insert into INSTITUTIONS (name, address_id) values ('Lakin, Gerlach and Lind', 16);
insert into INSTITUTIONS (name, address_id) values ('McCullough and Sons', 17);
insert into INSTITUTIONS (name, address_id) values ('Collins-Romaguera', 18);
insert into INSTITUTIONS (name, address_id) values ('Mann, Turner and Ward', 19);
insert into INSTITUTIONS (name, address_id) values ('McKenzie-Goyette', 20);
insert into INSTITUTIONS (name, address_id) values ('Prosacco LLC', 21);
insert into INSTITUTIONS (name, address_id) values ('Lehner, Morissette and Hahn', 22);
insert into INSTITUTIONS (name, address_id) values ('Runolfsdottir, Orn and Herzog', 23);
insert into INSTITUTIONS (name, address_id) values ('Armstrong and Sons', 24);
insert into INSTITUTIONS (name, address_id) values ('Davis-Kertzmann', 25);
insert into INSTITUTIONS (name, address_id) values ('Schoen, Kassulke and Hand', 26);
insert into INSTITUTIONS (name, address_id) values ('Grant Group', 27);
insert into INSTITUTIONS (name, address_id) values ('Waters LLC', 28);
insert into INSTITUTIONS (name, address_id) values ('Jast-Olson', 29);
insert into INSTITUTIONS (name, address_id) values ('Pfeffer-Mills', 30);
insert into INSTITUTIONS (name, address_id) values ('McGlynn-Barton', 31);
insert into INSTITUTIONS (name, address_id) values ('Bergstrom-Sporer', 32);
insert into INSTITUTIONS (name, address_id) values ('McDermott-Hoeger', 33);
insert into INSTITUTIONS (name, address_id) values ('Crona, O''Kon and Labadie', 34);
insert into INSTITUTIONS (name, address_id) values ('Hills Inc', 35);
insert into INSTITUTIONS (name, address_id) values ('Bruen, Parisian and O''Hara', 36);
insert into INSTITUTIONS (name, address_id) values ('Fadel LLC', 37);
insert into INSTITUTIONS (name, address_id) values ('Dickinson, Koepp and Schmeler', 38);
insert into INSTITUTIONS (name, address_id) values ('Howe, Hermiston and Feil', 39);
insert into INSTITUTIONS (name, address_id) values ('Jacobson LLC', 40);

-- Auctions
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('05/06/2021','DD/MM/YYYY'), 3, 14);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('21/06/2021','DD/MM/YYYY'), 2, 2);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('23/03/2021','DD/MM/YYYY'), 22, 22);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('17/10/2020','DD/MM/YYYY'), 16, 15);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('14/07/2020','DD/MM/YYYY'), 2, 23);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('19/03/2021','DD/MM/YYYY'), 23, 19);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('31/07/2020','DD/MM/YYYY'), 3, 22);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('01/07/2020','DD/MM/YYYY'), 15, 24);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('15/01/2021','DD/MM/YYYY'), 7, 29);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('03/07/2020','DD/MM/YYYY'), 7, 21);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('24/04/2021','DD/MM/YYYY'), 19, 23);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('02/09/2020','DD/MM/YYYY'), 12, 28);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('15/07/2020','DD/MM/YYYY'), 15, 11);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('06/12/2020','DD/MM/YYYY'), 19, 30);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('10/11/2020','DD/MM/YYYY'), 25, 14);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('03/11/2020','DD/MM/YYYY'), 9, 26);
insert into AUCTIONS (auction_date, institution_id, employee_id) values (to_date('26/01/2021','DD/MM/YYYY'), 4, 16);

-- Exhibits

insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('expectorant', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', 18, 13603, null, 'Croatia', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('SINGULAIR', 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.', 49, 81271, 8, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Detox Liver', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 38, 52700, 10, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('LEADER ORIGINAL FORMULA', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.', 14, 68740, 14, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Vindicator Instant Hand Sanitizer', 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 43, 85511, 2, 'Belarus', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('MSM (MoSaengMo)', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 46, 1927, null, 'Indonesia', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Aplicare Povidone-iodine Scrub', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', 48, 34549, 13, 'Vietnam', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('WHITE FLOWER STRAIN RELIEF', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', 43, 83655, 5, 'Poland', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('TopCare', 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 46, 55564, 12, 'China', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Qutenza', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 28, 31901, 11, 'Nigeria', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Tyzeka', 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', 13, 35472, 11, 'Canada', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Trazodone Hydrochloride', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 4, 16145, 4, 'Albania', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('PureLife APF', 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', 19, 33536, null, 'China', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Olanzapine', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 14, 88868, 2, 'China', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('lice', 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', 29, 66885, 3, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('SENSAI FLUID FINISH LASTING VELVET FV205', 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 17, 70646, 11, 'Canada', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Mucus Relief', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 32, 99141, 2, 'Indonesia', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Amoxicillin and Clavulanate Potassium', 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', 32, 54795, 14, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Methadone Hydrochloride', 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', 34, 10512, 4, 'Russia', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Standardized Grass Pollen, Fescue, Meadow', 'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus.', 44, 91413, null, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Asepxia', 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 35, 67622, 4, 'China', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Dove Ultimate Beauty Care Smooth Cashmere', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 13, 73415, 1, 'South Africa', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('RISPERIDONE', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.', 30, 12806, 9, 'Philippines', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Tizanidine Hydrochloride', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', 6, 53814, 12, 'China', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Hydrocodone bitartrate and ibuprofen', 'Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 44, 25953, null, 'China', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Metronidazole', 'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 26, 52430, 11, 'China', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Midazolam hydrochloride', 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', 2, 10693, 15, 'Guatemala', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Pollens - Trees, Pecan Carya Carya illinoensis', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 7, 65273, 4, 'Indonesia', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Equate Naproxen Sodium', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 47, 3905, 2, 'Poland', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Artistry Hydrating Foundation', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 26, 65310, 14, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Health Smart Aloe Vera Petroleum', 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 33, 79497, 6, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Nisoldipine', 'Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 46, 89555, 2, 'Czech Republic', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Topical Anesthetic', 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', 38, 10263, 15, 'Philippines', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Metaxalone', 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.', 1, 97402, 3, 'Philippines', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Sunmark Childrens Pain and Fever', 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 49, 22752, 5, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Axe', 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', 25, 6362, 3, 'Poland', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Synthroid', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', 50, 95878, 12, 'Burkina Faso', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('topiramate', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', 33, 98056, 4, 'Japan', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('DocQLace', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', 3, 49249, null, 'France', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Allergy Relief', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', 24, 1786, null, 'Peru', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('UltraSensitive Tint', 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 39, 11336, 2, 'France', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Cactus Grandiflorus Kit Refill', 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.', 38, 6771, 12, 'Vietnam', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Flor-Opal Sustained-Release Fluoride', 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 2, 51627, 4, 'Thailand', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Cherry Plum', 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 27, 71978, 5, 'Sweden', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Natrum Phos Kit Refill', 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', 18, 3839, 1, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('CVS Long Lasting Lubricant Eye', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 30, 80586, null, 'Philippines', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Doxazosin', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', 19, 51220, 13, 'Russia', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Fever - Infection', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 9, 5741, 11, 'China', 1);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('Methylphenidate Hydrochloride', 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', 26, 69447, 11, 'Poland', 0);
insert into EXHIBITS (name, description, author_id, starting_bid, auction_id, place_of_origin, is_authentic) values ('LBEL', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', 42, 5356, 11, 'Russia', 0);

-- Transactions

insert into TRANSACTIONS (price, exhibit_id, client_id) values (151903, 11, 13);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (279879, 12, 12);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (218083, 13, 15);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (207760, 14, 1);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (248142, 15, 3);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (190657, 16, 2);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (275411, 17, 15);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (216158, 18, 17);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (138046, 19, 18);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (164853, 20, 15);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (235766, 21, 15);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (228193, 22, 9);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (160245, 23, 2);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (196696, 24, 3);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (248806, 25, 14);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (140296, 26, 11);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (225837, 27, 18);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (295728, 28, 11);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (228728, 29, 20);
insert into TRANSACTIONS (price, exhibit_id, client_id) values (139349, 30, 11);