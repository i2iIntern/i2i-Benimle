CREATE TABLE Campaigns
    ( id Number not null , 
      name Varchar2(255) not null , 
      description Varchar2(255) ,
      rules Varchar2(1000) , 
      CONSTRAINT campaign_pk PRIMARY KEY (id));
    
CREATE SEQUENCE campaign_id_increment START WITH 1;

CREATE OR REPLACE TRIGGER campaign_id_increment_trigger
  BEFORE INSERT ON Campaigns
  FOR EACH ROW
BEGIN
  :new.id := campaign_id_increment.nextval;
END;
/