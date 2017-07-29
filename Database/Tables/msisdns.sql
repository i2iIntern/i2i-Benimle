CREATE TABLE Msisdns
		(id Number , 
		 msisdn_number Varchar2(11) ,
     password Varchar2(25) not null ,
		 contract_id Number , 
		 balance_id Number , 
		 rateplan_id Number ,
		 CONSTRAINT msisdn_pk PRIMARY KEY (id) ,
		 CONSTRAINT fk_contracts_msisdns
         FOREIGN KEY (contract_id) 
         REFERENCES Contracts(id) , 
         --CONSTRAINT fk_balances_msisdns
         --FOREIGN KEY (balance_id) 
         --REFERENCES Balances(id) , 
         CONSTRAINT fk_rateplan_msisdns
         FOREIGN KEY (rateplan_id) 
         REFERENCES Rateplans(id));

CREATE SEQUENCE msisdn_id_increment START WITH 1;
CREATE OR REPLACE TRIGGER msisdn_id_increment_trigger
  BEFORE INSERT ON Msisdns
  FOR EACH ROW
BEGIN
  :new.id := msisdn_id_increment.nextval;
END;
/