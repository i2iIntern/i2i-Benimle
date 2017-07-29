CREATE TABLE Addresses
		(id Number , 
		 name Varchar2(50) , 
		 description Varchar2(1000) , 
		 contract_id Number , 
		 CONSTRAINT addresses_pk PRIMARY KEY (id),
      	 CONSTRAINT fk_contracts_addresses
         FOREIGN KEY (contract_id)
         REFERENCES Contracts(id));


CREATE SEQUENCE addresses_id_increment START WITH 1;

CREATE OR REPLACE TRIGGER addresses_id_increment_trigger
  BEFORE INSERT ON Addresses
  FOR EACH ROW
BEGIN
  :new.id := addresses_id_increment.nextval;
END;
/