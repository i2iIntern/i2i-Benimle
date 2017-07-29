create or replace PACKAGE BODY  IB AS

    TYPE log_params IS RECORD(
          request_date STAJ.IB_App_Logs.request_date%type  ,
          function_name STAJ.IB_App_Logs.function_name%type , 
          function_input STAJ.IB_App_Logs.function_input%type , 
          function_message STAJ.IB_App_Logs.function_message%type , 
          processing_time STAJ.IB_App_Logs.processing_time%type);

    TYPE customer IS RECORD (
          id STAJ.IB_Customers.id%type ,
          first_name STAJ.IB_Customers.first_name%type ,
          last_name STAJ.IB_Customers.last_name%type ,
          birth_of_date STAJ.IB_Customers.birth_of_date%type);

    TYPE balance IS RECORD (
          id STAJ.IB_balances.id%type ,
          remaining_data STAJ.IB_Balances.remaining_data%type :=0 ,
          remaining_voice STAJ.IB_Balances.remaining_voice%type :=0, 
          remaining_sms  STAJ.IB_Balances.remaining_sms%type :=0 ,
          contract_id STAJ.IB_Balances.contract_id%type  ,
          msisdn_id STAJ.IB_Balances.msisdn_id%type ,
          expiration_date STAJ.IB_Balances.expiration_date%type);

    TYPE rate_plan IS RECORD (
          id STAJ.IB_Rateplans.id%type,
          name STAJ.IB_Rateplans.name%type ,
          description STAJ.IB_Rateplans.description%type,
          price STAJ.IB_Rateplans.price%type,
          data_amount STAJ.IB_Rateplans.data_amount%type ,
          voice_amount STAJ.IB_Rateplans.voice_amount%type ,
          sms_amount STAJ.IB_Rateplans.sms_amount%type );

     TYPE campaign IS RECORD (
          id STAJ.IB_Campaigns.id%type,
          name STAJ.IB_Campaigns.name%type,
          description STAJ.IB_Campaigns.description%type,
          rules STAJ.IB_Campaigns.rules%type );

    TYPE contract IS RECORD (
          id STAJ.IB_Contracts.id%type,
          secret_question STAJ.IB_Contracts.secret_question%type,
          secret_answer STAJ.IB_Contracts.secret_answer%type,
          customer_id STAJ.IB_Contracts.customer_id%type);

    TYPE msisdn IS RECORD (
          id STAJ.IB_Msisdns.id%type,
          msisdn_number STAJ.IB_Msisdns.msisdn_number%type,
          contract_id STAJ.IB_Msisdns.contract_id%type,
          balance_id STAJ.IB_Msisdns.balance_id%type,
          rateplan_id STAJ.IB_Msisdns.rateplan_id%type,
          password STAJ.IB_Msisdns.password%type );

    TYPE wallet IS RECORD (
          id STAJ.IB_Wallet.id%type,
          amount STAJ.IB_Wallet.amount%type,
          customer_id STAJ.IB_Wallet.customer_id%type);

    PROCEDURE create_log_query (pilp_log_params log_params);
    FUNCTION get_date RETURN DATE;
    FUNCTION get_core_time RETURN NUMBER;
    FUNCTION get_processing_time(pin_start_time NUMBER) RETURN NUMBER;
    FUNCTION get_balance_query (pin_contract_id IB_Balances.contract_id%type) RETURN SYS_REFCURSOR;
    FUNCTION get_rateplan_query  (pin_contract_id IB_Contracts.id%type ) RETURN SYS_REFCURSOR;
    FUNCTION get_contract_id_query(pis_msisdn_number IB_Msisdns.msisdn_number%type , pis_encrypted_password Varchar2) RETURN NUMBER;
    FUNCTION get_customer_credentials_query  (pin_contract_id IB_Contracts.id%type) RETURN SYS_REFCURSOR;
    FUNCTION get_customer_wallet_query (pin_customer_id IB_Wallet.customer_id%type) RETURN SYS_REFCURSOR;
    FUNCTION update_customer_wallet_query (pin_amount IB_Wallet.amount%type , pis_msisdn_number IB_Msisdns.msisdn_number%type) RETURN NUMBER;
    FUNCTION encrypt_string (pis_text VARCHAR2) RETURN VARCHAR2;
    FUNCTION check_msisdn_query(pis_msisdn_number IB_Msisdns.msisdn_number%type) RETURN BOOLEAN;

    PROCEDURE create_customer_query (pis_first_name IB_Customers.first_name%type , pis_last_name IB_Customers.last_name%type , pid_birth_of_date IB_Customers.birth_of_date%type)  IS
    BEGIN
        INSERT INTO STAJ.IB_Customers (first_name , last_name , birth_of_date) VALUES
                              (pis_first_name , pis_last_name , pid_birth_of_date);
    END create_customer_query;

    FUNCTION encrypt_string (pis_text VARCHAR2) RETURN VARCHAR2 IS
        vs_encrypted_string Varchar2(100);
    BEGIN
    dbms_obfuscation_toolkit.md5(input_string => pis_text,
    checksum_string => vs_encrypted_string);
    RETURN (utl_raw.cast_to_raw(vs_encrypted_string));
    END encrypt_string;

    FUNCTION get_customer_credentials_query (pin_contract_id IB_Contracts.id%type) RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;
    BEGIN
        OPEN result_set FOR
            SELECT c.* FROM STAJ.IB_Customers c WHERE c.id = (SELECT co.customer_id FROM STAJ.IB_Contracts co WHERE co.id = pin_contract_id);
        RETURN result_set;
    END get_customer_credentials_query;

    PROCEDURE create_customer_wallet_query (pin_amount IB_Wallet.amount%type, pin_customer_id IB_Wallet.customer_id%type) IS
    BEGIN
        INSERT INTO STAJ.IB_Wallet (amount , customer_id) VALUES
                           (pin_amount , pin_customer_id);
    END create_customer_wallet_query;

    FUNCTION get_customer_wallet_query (pin_customer_id IB_Wallet.customer_id%type) RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;
    BEGIN
        OPEN result_set FOR
            SELECT va.* FROM STAJ.IB_Wallet va WHERE va.customer_id = pin_customer_id;
        RETURN result_set;
    END get_customer_wallet_query;

    FUNCTION update_customer_wallet_query (pin_amount IB_Wallet.amount%type , pis_msisdn_number IB_Msisdns.msisdn_number%type) RETURN NUMBER IS
        vn_old_amount Number;
        vn_new_amount Number;
        vn_customer_id Number;
        CHECK_CONSTRAINT_VIOLATED EXCEPTION;
        Pragma exception_init (CHECK_CONSTRAINT_VIOLATED, -2290);
    BEGIN
        FOR c IN (SELECT customer_id FROM STAJ.IB_Wallet WHERE customer_id = (SELECT co.customer_id FROM STAJ.IB_Contracts co WHERE co.id = (SELECT m.contract_id FROM STAJ.IB_Msisdns m WHERE m.msisdn_number = pis_msisdn_number))) LOOP
            vn_customer_id := c.customer_id;
        END LOOP;
       FOR a IN (SELECT amount FROM STAJ.IB_Wallet WHERE customer_id = vn_customer_id) LOOP
            vn_old_amount := a.amount;
       END LOOP;
            vn_new_amount := (vn_old_amount + pin_amount);
        UPDATE STAJ.IB_Wallet
            SET amount = vn_new_amount
            WHERE customer_id = vn_customer_id;
        COMMIT;
        RETURN vn_new_amount;
        EXCEPTION
            WHEN CHECK_CONSTRAINT_VIOLATED THEN
                vn_new_amount := -1;
            RETURN vn_new_amount;
    END update_customer_wallet_query;

    PROCEDURE create_rateplan_query (pis_name IB_Rateplans.name%type , pis_decription IB_Rateplans.description%type ,
                                     pin_price IB_Rateplans.price%type, pin_data_amount IB_Rateplans.data_amount%type,
                                     pin_voice_amount IB_Rateplans.voice_amount%type, pin_sms_amount IB_Rateplans.sms_amount%type) IS
    BEGIN
        INSERT INTO STAJ.IB_Rateplans (name , description , price , data_amount , voice_amount , sms_amount) VALUES
                              (pis_name , pis_decription , pin_price , pin_data_amount , pin_voice_amount ,pin_sms_amount);
    END create_rateplan_query;

    FUNCTION get_rateplan_query  (pin_contract_id IB_Contracts.id%type ) RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;
    BEGIN
        OPEN result_set FOR
            SELECT * FROM STAJ.IB_rateplans WHERE id = (SELECT rateplan_id FROM ib_msisdns WHERE contract_id = pin_contract_id);
        RETURN result_set;
    END get_rateplan_query;

    PROCEDURE create_contract_query (pis_secret_question IB_Contracts.secret_question%type , pis_secret_answer IB_Contracts.secret_answer%type , 
                                     pin_customer_id IB_Contracts.customer_id%type) IS
    BEGIN
        INSERT INTO STAJ.IB_Contracts (secret_question , secret_answer , customer_id) VALUES 
                              (pis_secret_question  , pis_secret_answer , pin_customer_id);
    END create_contract_query;

    PROCEDURE create_msisdn_query (pis_msisdn_number IB_Msisdns.msisdn_number%type , pis_password IB_Msisdns.password%type ,
                                   pin_contract_id IB_Msisdns.contract_id%type, pin_rateplan_id IB_Msisdns.rateplan_id%type) IS
    BEGIN
        INSERT INTO STAJ.IB_Msisdns (msisdn_number  , password,contract_id ,  rateplan_id ) VALUES
                            (pis_msisdn_number , pis_password , pin_contract_id , pin_rateplan_id);
    END create_msisdn_query;

    PROCEDURE create_balance_query (pin_remaining_data IB_Balances.remaining_data%type, pin_remaining_voice IB_Balances.remaining_voice%type,
                                    pin_remaining_sms IB_Balances.remaining_sms%type , pin_contract_id IB_Balances.contract_id%type) IS
    BEGIN
        INSERT INTO STAJ.IB_Balances (remaining_data , remaining_voice , remaining_sms , contract_id) VALUES
                             (pin_remaining_data , pin_remaining_voice , pin_remaining_sms , pin_contract_id);
    END create_balance_query;

    FUNCTION get_balance_query (pin_contract_id IB_Balances.contract_id%type) RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;
    BEGIN
        OPEN result_set FOR
            SELECT * FROM STAJ.IB_Balances b WHERE b.contract_id = pin_contract_id;
        RETURN result_set;
    END get_balance_query;

    PROCEDURE create_campaign_query (pis_name IB_Campaigns.name%type , pis_description  IB_Campaigns.description%type, 
                                     pis_rules IB_Campaigns.rules%type) IS
    BEGIN
        INSERT INTO STAJ.IB_Campaigns (name , description , rules) VALUES
                              (pis_name , pis_description , pis_rules);
    END create_campaign_query;

    FUNCTION get_contract_id_query(pis_msisdn_number IB_Msisdns.msisdn_number%type , pis_encrypted_password Varchar2) RETURN NUMBER IS
        vn_contract_id Number;
    BEGIN
        SELECT m.contract_id INTO vn_contract_id FROM STAJ.IB_Msisdns m WHERE msisdn_number = pis_msisdn_number AND password = pis_encrypted_password;
        RETURN vn_contract_id;
    END get_contract_id_query;

    PROCEDURE create_seed_data IS
    BEGIN
        dbms_output.put_line('TODO');
    END create_seed_data;

    FUNCTION get_date RETURN DATE IS
    BEGIN
        RETURN SYSDATE;
    END get_date;

    FUNCTION get_core_time RETURN NUMBER IS
    BEGIN
        RETURN dbms_utility.get_time;
    END get_core_time;

    FUNCTION get_processing_time (pin_start_time NUMBER) RETURN NUMBER IS
        vn_current_time Number;
    BEGIN
        vn_current_time := get_core_time();
        RETURN (vn_current_time - pin_start_time);
    END;

    PROCEDURE create_log_query (pilp_log_params log_params) IS
    BEGIN
        INSERT INTO STAJ.IB_app_logs (request_date , function_name , function_input , function_message , processing_time)
                      VALUES   (pilp_log_params.request_date , pilp_log_params.function_name , pilp_log_params.function_input , pilp_log_params.function_message ,  pilp_log_params.processing_time);      
    END create_log_query;

    FUNCTION check_msisdn_query(pis_msisdn_number IB_Msisdns.msisdn_number%type) RETURN BOOLEAN IS
        vb_exist Boolean;
        vs_msisdn_number Varchar2(11);
    BEGIN
        vb_exist := true;
        SELECT m.msisdn_number INTO vs_msisdn_number FROM IB_Msisdns m WHERE m.msisdn_number = pis_msisdn_number;
        RETURN vb_exist;
        EXCEPTION WHEN NO_DATA_FOUND THEN
        vb_exist := false;
        RETURN vb_exist;
    END check_msisdn_query;

    FUNCTION check_if_msisdn_number_exist (pis_msisdn_number IB_Msisdns.msisdn_number%type) RETURN NUMBER IS 
        vb_exist Boolean;
        vn_number_response Number;
    BEGIN
        vb_exist := check_msisdn_query(pis_msisdn_number);
        if vb_exist then
            vn_number_response := 0;
        else  
            vn_number_response := -1;
        end if;
        RETURN vn_number_response;
    END check_if_msisdn_number_exist;

    FUNCTION get_campaigns RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;   
    BEGIN
        OPEN result_set FOR
            SELECT * FROM STAJ.IB_Campaigns;
        RETURN result_set;
    END get_campaigns;

    FUNCTION get_balance (pin_contract_id IB_Balances.contract_id%type) RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;
        lp_log_params log_params;
        vb_balance balance;
        vn_start_time Number;
    BEGIN
        vn_start_time := get_core_time();
        lp_log_params.function_name := 'get_balance';
        lp_log_params.request_date := get_date();
        lp_log_params.function_input := 'contract_id =' || pin_contract_id;
        result_set := get_balance_query(pin_contract_id);
        LOOP
        FETCH result_set INTO vb_balance.id , vb_balance.remaining_data , vb_balance.remaining_voice , vb_balance.remaining_sms , vb_balance.contract_id , vb_balance.msisdn_id , vb_balance.expiration_date;
        lp_log_params.function_message := 'Balance_ID = ' || vb_balance.id || ',' ||
                                          'Balance_remaining_data = ' || vb_balance.remaining_data || ',' ||
                                          'Balance_remaining_voice = ' || vb_balance.remaining_voice || ',' ||
                                          'Balance_remaining_sms = ' || vb_balance.remaining_sms || ',' ||
                                          'Contract_ID = ' || vb_balance.contract_id ||',' ||
                                          'Msisdn_ID = ' || vb_balance.contract_id || ',' ||
                                          'Expiration_Date = ' || vb_balance.expiration_date;
                EXIT WHEN result_set%notfound;
        END LOOP;
        lp_log_params.processing_time := get_processing_time(vn_start_time);
        create_log_query(lp_log_params);
        result_set := get_balance_query(pin_contract_id);
        RETURN result_set;
    END get_balance;

    FUNCTION get_rateplan  (pin_contract_id IB_Contracts.id%type ) RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;
        lp_log_params log_params;
        vrp_rateplan rate_plan;
        vn_start_time Number;
    BEGIN
        vn_start_time := get_core_time();
        lp_log_params.request_date := get_date();
        lp_log_params.function_name := 'get_rateplan';
        lp_log_params.function_input := 'Contract_id = ' || pin_contract_id;
        result_set := get_rateplan_query(pin_contract_id);
       LOOP
        FETCH result_set INTO vrp_rateplan.id , vrp_rateplan.name , 
                              vrp_rateplan.description ,vrp_rateplan.price,
                              vrp_rateplan.data_amount , vrp_rateplan.voice_amount , vrp_rateplan.sms_amount;
        lp_log_params.function_message := 'Rateplan_ID = ' || vrp_rateplan.id || ',' ||
                                          'Rateplan_Name = ' || vrp_rateplan.name || ',' ||
                                          'Rateplan_Description = ' || vrp_rateplan.description || ',' ||
                                          'Rateplan_Price = ' || vrp_rateplan.price || ',' ||
                                          'Rateplan_data_amount = ' || vrp_rateplan.data_amount || ',' ||
                                          'Rateplan_voice_amount = ' || vrp_rateplan.voice_amount || ',' ||
                                          'Rateplan_sms_amount = ' || vrp_rateplan.sms_amount ;
                    EXIT WHEN result_set%notfound;
        END LOOP;
        lp_log_params.processing_time := get_processing_time(vn_start_time);
        create_log_query(lp_log_params);
        result_set := get_rateplan_query(pin_contract_id);
       RETURN result_set;
    END get_rateplan;

    FUNCTION get_rateplans RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;     
    BEGIN
        OPEN result_set FOR
            SELECT * FROM STAJ.IB_Rateplans;
        RETURN result_set;
    END get_rateplans;

    FUNCTION get_contract_id(pis_msisdn_number IB_Msisdns.msisdn_number%type , pis_password IB_Msisdns.password%type) RETURN NUMBER IS
        vn_contract_id Number;
        lp_log_params log_params;
        vn_start_time Number;
        vs_encrypted_password Varchar2(100);
    BEGIN
        vn_start_time := get_core_time();
        lp_log_params.request_date := get_date();
        lp_log_params.function_name := 'login';
        vs_encrypted_password := encrypt_string(pis_password);
        lp_log_params.function_input := 'Msisdn_Number =' || pis_msisdn_number || ', '  || 'Password = ' || vs_encrypted_password;
        vn_contract_id := get_contract_id_query(pis_msisdn_number ,vs_encrypted_password );
        lp_log_params.function_message := 'Contract_ID = ' || vn_contract_id;
        lp_log_params.processing_time := get_processing_time(vn_start_time);
        create_log_query(lp_log_params);
        RETURN vn_contract_id;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            vn_contract_id := -1;
            -- Bu adimlari fonksiyon olarak ayir
            lp_log_params.function_message := 'Contract_ID = ' || vn_contract_id;
            lp_log_params.processing_time := get_processing_time(vn_start_time);
            create_log_query(lp_log_params);
            RETURN vn_contract_id;
    END get_contract_id;

    FUNCTION get_customer_credentials  (pin_contract_id IB_Contracts.id%type) RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;
        vc_customer customer;
        lp_log_params log_params;
        vn_start_time Number;
    BEGIN
        vn_start_time := get_core_time();
        lp_log_params.request_date := get_date();
        lp_log_params.function_name := 'get_credentials';
        lp_log_params.function_input := 'Contract_ID =' || pin_contract_id;
        result_set := get_customer_credentials_query(pin_contract_id);        
        LOOP
        FETCH result_set INTO vc_customer.id , vc_customer.first_name , vc_customer.last_name , vc_customer.birth_of_date;
        lp_log_params.function_message := 'customer_id = ' || to_char(vc_customer.id) || ',' ||
                                          'customer_first_name = ' || vc_customer.first_name || ',' ||
                                          'customer_last_name = ' || vc_customer.last_name || ',' ||
                                          'customer_birth_of_date = ' || vc_customer.birth_of_date;
                EXIT WHEN result_set%notfound;
        END LOOP;
        lp_log_params.processing_time := get_processing_time(vn_start_time);
        create_log_query(lp_log_params);       
        result_set := get_customer_credentials_query(pin_contract_id);
        RETURN result_set;    
    END get_customer_credentials;

    FUNCTION get_customer_wallet (pin_customer_id IB_Wallet.customer_id%type) RETURN SYS_REFCURSOR IS
        result_set Sys_Refcursor;
        lp_log_params log_params;
        vn_start_time Number;
        vv_wallet wallet;
    BEGIN
        vn_start_time := get_core_time();
        lp_log_params.request_date := get_date();
        lp_log_params.function_name := 'get_customer_wallet';
        lp_log_params.function_input := 'Customer_ID = ' || pin_customer_id;
        result_set := get_customer_wallet_query(pin_customer_id);
        LOOP
            FETCH result_set INTO vv_wallet.id , vv_wallet.amount , vv_wallet.customer_id;
            lp_log_params.function_message := 'Wallet_ID = ' || vv_wallet.id || ',' ||
                                              'Amount := ' || vv_wallet.amount || ',' ||
                                              'Customer_ID ' || vv_wallet.customer_id ;
            EXIT WHEN result_set%notfound;
        lp_log_params.processing_time := get_processing_time(vn_start_time);
        create_log_query(lp_log_params);
        END LOOP;
        result_set := get_customer_wallet_query(pin_customer_id);
        RETURN result_set;
    END get_customer_wallet;


    FUNCTION update_customer_wallet (pin_amount IB_Wallet.amount%type , pis_msisdn_number IB_Msisdns.msisdn_number%type) RETURN NUMBER IS
        vv_wallet wallet;
        lp_log_params log_params;
        vn_start_time Number;
        vn_new_amount Number;
    BEGIN
        vn_start_time := get_core_time();
        lp_log_params.request_date := get_date();
        lp_log_params.function_name := 'update_customer_wallet';
        lp_log_params.function_input := 'Amount = ' || pin_amount || ',' ||
                                        'Msisdn_Number = ' || pis_msisdn_number;
        vn_new_amount := update_customer_wallet_query(pin_amount , pis_msisdn_number);
        lp_log_params.function_message := 'New_Amount = ' || vn_new_amount;
        lp_log_params.processing_time := get_processing_time(vn_start_time);
        create_log_query(lp_log_params);
        RETURN vn_new_amount;
    END update_customer_wallet;
END IB;