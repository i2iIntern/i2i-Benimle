CREATE TABLE RatePlans
    ( id Number not null , 
      name Varchar2(100) not null , 
      description Varchar2(500) , 
      price Number , 
      data_amount Number,
      voice_amount Number, 
      sms_amount Number , 
      CONSTRAINT rateplans_pk PRIMARY KEY (id));
      
CREATE SEQUENCE rateplans_id_increment START WITH 1;

CREATE OR REPLACE TRIGGER rateplans_id_increment_trigger
  BEFORE INSERT ON Rateplans
  FOR EACH ROW
BEGIN
  :new.id := rateplans_id_increment.nextval;
END;
/