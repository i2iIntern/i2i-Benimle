CREATE TABLE Customers
    (id Number not null ,
     first_name Varchar2(50) not null , 
     last_name Varchar2(50) not null ,
     birth_of_date Date,
     CONSTRAINT customer_pk PRIMARY KEY (id));
CREATE SEQUENCE customer_id_increment START WITH 1;

CREATE OR REPLACE TRIGGER customer_id_increment_trigger
  BEFORE INSERT ON Customers
  FOR EACH ROW
BEGIN
  :new.id := customer_id_increment.nextval;
END;
/