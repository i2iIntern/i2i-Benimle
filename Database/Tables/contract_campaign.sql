CREATE TABLE Campaigns_Msisdns
        ( msisdn_id Number not null , 
          campaign_id Number not null ,
          CONSTRAINT fk_msisdn_cp
          FOREIGN KEY (msisdn_id)
          REFERENCES Msisdns(id) , 
          CONSTRAINT fk_campaign_cp
          FOREIGN KEY (campaign_id)
          REFERENCES Campaigns(id));