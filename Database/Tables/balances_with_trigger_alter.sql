CREATE TABLE Balances
    ( id Number not null , 
      remaining_data Number , 
      remaining_voice Number , 
      remaining_sms Number,
      contract_id Number , 
      CONSTRAINT balances_pk PRIMARY KEY (id),
      CONSTRAINT fk_contracts_balances
        FOREIGN KEY (contract_id)
        REFERENCES Contracts(id));
        
CREATE SEQUENCE balance_id_increment START WITH 1;

CREATE OR REPLACE TRIGGER balance_id_increment_trigger
  BEFORE INSERT ON Balances
  FOR EACH ROW
BEGIN
  :new.id := balance_id_increment.nextval;
END;
/

ALTER TABLE balances
    ADD msisdn_id Number;

ALTER TABLE balances 
    ADD CONSTRAINT fk_msisdn_id
    FOREIGN KEY (msisdn_id)
    REFERENCES Msisdns(id);