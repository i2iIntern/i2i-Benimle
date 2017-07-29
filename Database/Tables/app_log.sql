CREATE TABLE IB_app_logs (
            id Number not null ,
            request_date Date,
            function_name Varchar2(50) ,
            function_input Varchar2(1000),
            function_message Varchar2(2000) ,
            processing_time Number ,
            CONSTRAINT app_log_pk PRIMARY KEY (id));
            
CREATE SEQUENCE app_log_id_increment START WITH 1;

CREATE OR REPLACE TRIGGER app_log_id_increment_trigger
  BEFORE INSERT ON IB_app_logs
  FOR EACH ROW
BEGIN
  :new.id := app_log_id_increment.nextval;
END;
/