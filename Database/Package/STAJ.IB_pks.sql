create or replace PACKAGE   IB AS 

    FUNCTION get_contract_id(pis_msisdn_number IB_Msisdns.msisdn_number%type , pis_password IB_Msisdns.password%type) RETURN NUMBER;
    FUNCTION get_balance (pin_contract_id IB_Balances.contract_id%type) RETURN sys_refcursor;
    FUNCTION get_rateplan (pin_contract_id IB_Contracts.id%type ) RETURN sys_refcursor;
    FUNCTION get_rateplans RETURN sys_refcursor;
    FUNCTION get_campaigns RETURN sys_refcursor;
    FUNCTION get_customer_credentials  (pin_contract_id IB_Contracts.id%type) RETURN sys_refcursor;
    FUNCTION get_customer_wallet (pin_customer_id IB_Wallet.customer_id%type) RETURN sys_refcursor;
    FUNCTION update_customer_wallet (pin_amount IB_Wallet.amount%type , pis_msisdn_number IB_Msisdns.msisdn_number%type) RETURN NUMBER;
    FUNCTION check_if_msisdn_number_exist (pis_msisdn_number IB_Msisdns.msisdn_number%type) RETURN NUMBER; 
    PROCEDURE create_customer_query (pis_first_name IB_Customers.first_name%type , pis_last_name IB_Customers.last_name%type ,
                                     pid_birth_of_date IB_Customers.birth_of_date%type);
    PROCEDURE create_customer_wallet_query (pin_amount IB_Wallet.amount%type, pin_customer_id IB_Wallet.customer_id%type);
    PROCEDURE create_rateplan_query (pis_name IB_Rateplans.name%type , pis_decription IB_Rateplans.description%type ,
                                     pin_price IB_Rateplans.price%type, pin_data_amount IB_Rateplans.data_amount%type,
                                     pin_voice_amount IB_Rateplans.voice_amount%type, pin_sms_amount IB_Rateplans.sms_amount%type);
    PROCEDURE create_contract_query (pis_secret_question IB_Contracts.secret_question%type , pis_secret_answer IB_Contracts.secret_answer%type , 
                                     pin_customer_id IB_Contracts.customer_id%type);
    PROCEDURE create_msisdn_query (pis_msisdn_number IB_Msisdns.msisdn_number%type , pis_password IB_Msisdns.password%type ,
                                   pin_contract_id IB_Msisdns.contract_id%type, pin_rateplan_id IB_Msisdns.rateplan_id%type);
    PROCEDURE create_balance_query (pin_remaining_data IB_Balances.remaining_data%type, pin_remaining_voice IB_Balances.remaining_voice%type,
                                    pin_remaining_sms IB_Balances.remaining_sms%type , pin_contract_id IB_Balances.contract_id%type);
    PROCEDURE create_campaign_query (pis_name IB_Campaigns.name%type , pis_description  IB_Campaigns.description%type, 
                                     pis_rules IB_Campaigns.rules%type);
    PROCEDURE create_seed_data;
END IB;