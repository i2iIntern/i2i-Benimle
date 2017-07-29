CREATE TABLE Wallet (
        id Number not null ,
        amount Number not null , 
        customer_id Number not null ,
        CONSTRAINT vallet_pk PRIMARY KEY (id),
        CONSTRAINT fk_customer_vallet
        FOREIGN KEY (customer_id) 
        REFERENCES Customers(id));
        
CREATE SEQUENCE wallet_id_increment START WITH 1;

CREATE OR REPLACE TRIGGER wallet_id_increment_trigger
  BEFORE INSERT ON Wallet
  FOR EACH ROW
BEGIN
  :new.id := wallet_id_increment.nextval;
END;
/