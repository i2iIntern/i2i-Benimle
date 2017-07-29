CREATE TABLE Contracts
        ( id Number not null,
          secret_question Varchar2(255) , 
          secret_answer Varchar2(255) , 
          customer_id Number , 
          CONSTRAINT contracts_pk PRIMARY KEY (id) , 
          CONSTRAINT fk_customers_contracts
            FOREIGN KEY (customer_id) 
            REFERENCES Customers(id));
CREATE SEQUENCE contract_id_increment START WITH 1;

CREATE OR REPLACE TRIGGER contract_id_increment_trigger
  BEFORE INSERT ON Contracts
  FOR EACH ROW
BEGIN
  :new.id := contract_id_increment.nextval;
END;
/