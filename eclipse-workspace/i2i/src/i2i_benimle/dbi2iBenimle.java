/**
 * This is a Java Web Service. This WS is used for the communication applicaton that named "i2i Benimle".  
 * Before running this project, you need to read README.md file for the preconditions.
 * For any questions, you can send e-mail : yenicead@gmail.com - yenicead@itu.edu.tr
 *
 * @author Adem Yenice
 * @version 1
 * @since  21-07-2017
 */

package i2i_benimle;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.ws.Endpoint;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import oracle.jdbc.OracleTypes;

@WebService
public class dbi2iBenimle{	
	private final static Logger log = Logger.getLogger(dbi2iBenimle.class.getName());
	private static FileHandler logFile = null;	
	private static Connection dbConnTest = null;
	private static CallableStatement procedureQuery = null;
	private static Jdbc dbConnectionParams = new Jdbc();
	
	// This function will read xml file. The xml file should contain your Database information.
	// xml dosyasýndan veritabaný bilgilerini okuyup ilgili class'a aktaran fonksiyon.
	private static void readXml() {
		log.info("readXml function is called.");
		 try {
		     	String filePath = "./jdbc.xml";
		        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
		        DocumentBuilder docBuilder = docFactory.newDocumentBuilder();		 
		        Document doc = docBuilder.parse(filePath);		 
		        NodeList nList = doc.getElementsByTagName("user");		// xml'deki user tagi ile baþlayan kýsýmlarý al. 
			    Node node = nList.item(0);								// Elimizde 3 tane user tagý varsa ilkini alýr.
			    Element element = (Element) node;			        	
			    dbConnectionParams.setDriver(element.getElementsByTagName("jdbc_driver").item(0).getTextContent());
			    dbConnectionParams.setDbInfo(element.getElementsByTagName("jdbc_info").item(0).getTextContent());
			    dbConnectionParams.setUsername(element.getElementsByTagName("jdbc_username").item(0).getTextContent());
			    dbConnectionParams.setPassword(element.getElementsByTagName("jdbc_password").item(0).getTextContent());
			    log.info("readXml function finished succesfully.");
		    } catch (Exception e) {
		        e.printStackTrace();
		        log.warning( e.toString() + " readXml function has failed.");
		    }
	}

	// This function will take IP address of your computer and return it as a String.
	// Bilgisayarýn veya Sunucunun IP Adresini alan fonksiyon.
	private static String getIpAddress() {
		log.info("getIpAddress function is called.");
		try {
			InetAddress ipAddress = InetAddress.getLocalHost();
			log.info("getIpAddress function is ended successfully. It returns the IP address of the host.");
			return ipAddress.getHostAddress();
		} catch (UnknownHostException e) {
			e.printStackTrace();
			log.warning(e.toString() + " getIpAddress function couldn't found the IP address. It will return Null.");
			return null;
		}
	}
	
	// This function tries to connect database using Jdbc class. 
	// Oracle veritabaný'na baðlanmaya çalýþan fonksiyon. Baðlantýyý saðlarsa baðlantýnýn kendisini, baðlantýyý saðlayamazsa null döndürür. 
	private Connection dbConnectionTest() {
		log.info("dbConnectionTest function is called.");
		try{							
			Class.forName(dbConnectionParams.getDriver());
			dbConnTest = DriverManager.getConnection(dbConnectionParams.getDbInfo(), dbConnectionParams.getUsername(), dbConnectionParams.getPassword());
			log.info("dbConnectionTest function connected to db.");
			return dbConnTest;								
		}
		catch(Exception e){
			log.warning(e.toString() + " dbConnectionTest function failed. It returns null.");
			return null;
		}	
	}
	
	// This function will close database and query connection.
	private void closeDbAndQuery(Connection dbConnection, CallableStatement proQuery) {
		log.info("closeDbAndQuery function is called.");
		try {
			dbConnection.close();
			proQuery.close();
			log.info("closeDbAndQuery is ended successfully. con and procedure_query are closed.");
		} catch (SQLException e) {
			log.warning(e.toString() + " closeDbAndQuery couldn't work properly.");
		}		
	}
	
	/* -- Special Query Function For All Web Methods --- */
	
	private CallableStatement getContractIdQuery(String phoneNumber, String password) {
		log.info("getContractIdQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{ ? = call staj.IB.get_contract_id(?, ?) }");
			procedureQuery.registerOutParameter(1, Types.INTEGER);
			procedureQuery.setString(2, phoneNumber);
			procedureQuery.setString(3, password);
			procedureQuery.executeQuery();
			log.info("getContractIdQuery function is ended.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + "getContractIdQuery function returns null");
			return null;
		}
	}
	
	private CallableStatement getCampaignQuery() {
		log.info("getCampaignQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{ ? = call staj.IB.get_campaigns() }");
			procedureQuery.registerOutParameter(1, OracleTypes.CURSOR);				
			procedureQuery.executeQuery();
			
			log.info("getCampaignQuery function is ended.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + " getCampaignQuery function returns null");
			return null;
		}
	}
	
	private CallableStatement getBalanceQuery(int contractId) {
		log.info("getBalanceQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{ ? = call staj.IB.get_balance(?) }");
			procedureQuery.registerOutParameter(1, OracleTypes.CURSOR);		
			procedureQuery.setInt(2, contractId);
			procedureQuery.executeQuery();
			log.info("getBalanceQuery function is ended.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + "getBalanceQuery function returns null");
			return null;
		}
	}
	
	private CallableStatement getCustomerCredentialQuery(int contractId) {
		log.info("getCustomerCredentialQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{? = call staj.IB.get_customer_credentials(?) }");
			procedureQuery.registerOutParameter(1, OracleTypes.CURSOR);
			procedureQuery.setInt(2, contractId);
			procedureQuery.executeQuery();
			log.info("getCustomerCredentialQuery function is ended.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + " getCustomerCredentialQuery function returns null");
			return null;
		}
	}
	
	private CallableStatement getRateplanQuery(int contractId) {
		log.info("getRateplanQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{? = call staj.IB.get_rateplan(?) }");
			procedureQuery.registerOutParameter(1, OracleTypes.CURSOR);
			procedureQuery.setInt(2, contractId);
			procedureQuery.executeQuery();
			log.info("getRateplanQuery function is ended.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + " getRateplanQuery function returns null");
			return null;
		}
	}
	
	private CallableStatement getRateplanListQuery() {
		log.info("getRateplanListQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{? = call staj.IB.get_rateplans }");
			procedureQuery.registerOutParameter(1, OracleTypes.CURSOR);
			procedureQuery.executeQuery();
			log.info("getRateplanListQuery function is ended.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + " getRateplanListQuery function returns null");
			return null;
		}
	}
	
	private CallableStatement getCustomerWalletQuery(int contractId) {
		log.info("getCustomerWalletQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{? = call staj.IB.get_customer_wallet(?) }");
			procedureQuery.registerOutParameter(1, OracleTypes.CURSOR);
			procedureQuery.setInt(2, contractId);
			procedureQuery.executeQuery();
			log.info("getCustomerWalletQuery function is ended.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + " getCustomerWalletQuery function returns null");
			return null;
		}
	}

	private CallableStatement updateCustomerWalletQuery(int amount, String msisdn) {
		log.info("updateCustomerWalletQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{? = call staj.IB.update_customer_wallet(?, ?) }");
			procedureQuery.registerOutParameter(1, OracleTypes.INTEGER);
			procedureQuery.setInt(2, amount);
			procedureQuery.setString(3, msisdn);
			procedureQuery.executeQuery();			
			log.info("updateCustomerWalletQuery function is ended.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + " updateCustomerWalletQuery function returns null");
			return null;
		}
	}
	
	private CallableStatement checkMsisdnQuery(String msisdn) {
		log.info("checkMsisdnQuery function is called.");
		try {
			procedureQuery = dbConnectionTest().prepareCall("{? = call staj.IB.check_if_msisdn_number_exist(?) }");
			procedureQuery.registerOutParameter(1, OracleTypes.INTEGER);
			procedureQuery.setString(2, msisdn);
			procedureQuery.execute();
			log.info("checkMsisdnQuery function has found the phone number in the database.");
			return procedureQuery;
		} catch (SQLException e) {
			log.warning(e.toString() + " checkMsisdnQuery function returns null.");
			return null;
		}
	}
	
	
	// Eðer girilen telefon numarasý ve þifre doðru ise contract_id döndürür, aksi taktirde -1 döndürür.
	@WebMethod
	public int getContractId(@WebParam(name = "phoneNumber")String phoneNumber, @WebParam(name = "password")String password) {
		log.info("getContractId function is called.");
		try {
			procedureQuery = getContractIdQuery(phoneNumber, password);
			int num = procedureQuery.getInt(1);
			if(num == -1)
			{
				closeDbAndQuery(dbConnTest, procedureQuery);
				log.info("getContractId function returns -1. It means that your phone_number and password don't matched.");
			    return num;
			}
			else
			{					
				closeDbAndQuery(dbConnTest, procedureQuery);
				log.info("getContractId function is ended. It returns with contract_id.");
				return num;
			}							
		} catch (SQLException e) {
			log.warning(e.toString() + " getContractId function returns 0.");
			closeDbAndQuery(dbConnTest, procedureQuery);
			return 0;
		}	
	}
			
	// Bütün kampanyalarý liste olarak dönen fonksiyon.
	@WebMethod
	public List<Campaign> getCampaign(){
			log.info("getCampaign function is called.");
			List<Campaign> a = new ArrayList<Campaign>();	
			try{									
				procedureQuery = getCampaignQuery();					
				ResultSet rs = (ResultSet) procedureQuery.getObject(1);				
				for(int i = 0; rs.next(); i++){
					Campaign element = new Campaign();	
					element.setId(rs.getInt(1));		
					element.setName(rs.getString(2));		
					element.setDescription(rs.getString(3));
					element.setRules(rs.getString(4));
					a.add(i, element);
				}			
				closeDbAndQuery(dbConnTest, procedureQuery);
				log.info("getCampaign function is ended succesfuly.");
				return a;										
			}	
			catch(Exception e){
				log.warning(e.toString() + " getCampaign function returns with null.");
				closeDbAndQuery(dbConnTest, procedureQuery);
				return null;	
			}					
		}
		
	// Girilen contract_id'ye ait kalan kullaným deðerlerini dönen fonksiyon.
	@WebMethod
	public Balance getBalance(@WebParam(name = "contractId")int contractId) {
		log.info("getBalance function is called.");
		try{									
			procedureQuery = getBalanceQuery(contractId);
			Balance element = new Balance();
			ResultSet rs = (ResultSet) procedureQuery.getObject(1);
			while(rs.next()){			
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
				element.setId(rs.getInt(1));		
				element.setRemaining_data(rs.getInt(2));	
				element.setRemaining_voice(rs.getInt(3));	
				element.setRemaining_sms(rs.getInt(4));
				element.setContract_id(rs.getInt(5));		
				element.setMsisdn_id(rs.getInt(6));				
				element.setExpiration_date(dateFormat.format(rs.getDate(7)));
			}		
			closeDbAndQuery(dbConnTest, procedureQuery);
			log.info("getBalance function is ended succesfuly.");
			return element;									
		}	
		catch(Exception e){
			log.warning(e.toString() + " getBalance function returns with null.");
			closeDbAndQuery(dbConnTest, procedureQuery);
			return null;
		}								
	}
		
	// Girilen contract_id'ye ait kullanýcýnýn bilgilerini dönen fonksiyon.
	@WebMethod
	public Customer getCustomerCredential(@WebParam(name = "contractId")int contractId) {
		log.info("getCustomerCredential function is called.");
		try{							
			procedureQuery = getCustomerCredentialQuery(contractId);
			ResultSet rs = (ResultSet) procedureQuery.getObject(1);
			Customer element = new Customer();
			while(rs.next()) {
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
				element.setId(rs.getInt(1));
				element.setFirst_name(rs.getString(2));
				element.setLast_name(rs.getString(3));
				element.setBirth_of_date(dateFormat.format(rs.getDate(4)));
			}
			closeDbAndQuery(dbConnTest, procedureQuery);
			log.info("getCustomerCredential function is ended succesfuly. It returns with name and surname.");
			return element;							
		}	
		catch(Exception e){
			log.warning(e.toString() + "getCustomerCredential function is ended. It returns null.");
			closeDbAndQuery(dbConnTest, procedureQuery);
			return null;
		}		
	}
		
	// Girilen contract_id'ye ait kullanýcýnýn sahip olduðu kampanya bilgilerini dönen fonksiyon.
	@WebMethod
	public Tariff getRateplan(@WebParam(name = "contractId")int contractId){
		log.info("getRateplan function is called.");
		Tariff element = new Tariff();		
		try{				
			procedureQuery = getRateplanQuery(contractId);			
			ResultSet rs = (ResultSet) procedureQuery.getObject(1);
			while(rs.next()) {				
				element.setId(rs.getInt(1));			
				element.setName(rs.getString(2));
				element.setDescription(rs.getString(3));
				element.setPrice(rs.getInt(4));
				element.setData_amount(rs.getInt(5));
				element.setVoice_amount(rs.getInt(6));
				element.setSms_amount(rs.getInt(7));	
			}
			closeDbAndQuery(dbConnTest, procedureQuery);
			log.info("getRateplan function is ended succesfuly. It returns the recipe informations.");
			return element;							
		}	
		catch(Exception e)
		{
			log.warning(e.toString() + " getRateplan function returns null.");	
			closeDbAndQuery(dbConnTest, procedureQuery);
			return null;
		}		
	}
			
	// Bütün kampanya bilgilerini liste olarak dönen fonksiyon.
	@WebMethod
	public List<Tariff> getRateplanList(){
		log.info("getRateplanList function is called.");
		List<Tariff> a = new ArrayList<Tariff>();	
		try{				
			procedureQuery = getRateplanListQuery();			
			ResultSet rs = (ResultSet) procedureQuery.getObject(1);
			for(int i = 0; rs.next(); i++) {
				Tariff element = new Tariff();
				element.setId(rs.getInt(1));			
				element.setName(rs.getString(2));
				element.setDescription(rs.getString(3));
				element.setPrice(rs.getInt(4));
				element.setData_amount(rs.getInt(5));
				element.setVoice_amount(rs.getInt(6));
				element.setSms_amount(rs.getInt(7));	
				a.add(i, element);
			}		
			closeDbAndQuery(dbConnTest, procedureQuery);
			log.info("getRateplanList function is ended succesfuly. It returns the recipe informations.");
			return a;							
		}	
		catch(Exception e){
			log.warning(e.toString() + "getRateplanList function returns null.");	
			closeDbAndQuery(dbConnTest, procedureQuery);
			return null;
		}		
	}
			
	// Girilen contract_id'ye ait kullanýcýnýn cüzdan bilgilerini dönen fonksiyon.
	@WebMethod
	public Wallet getCustomerWallet(@WebParam(name = "contractId")int contractId){
			log.info("getCustomerWallet function is called.");
			Wallet element = new Wallet();		
			try{				
				procedureQuery = getCustomerWalletQuery(contractId);				
				ResultSet rs = (ResultSet) procedureQuery.getObject(1);
				while(rs.next()){				
					element.setId(rs.getInt(1));			
					element.setAmount(rs.getInt(2));
					element.setCustomer_id(rs.getInt(3));	
				}
				closeDbAndQuery(dbConnTest, procedureQuery);
				log.info("getCustomerWallet function is ended succesfuly. It returns the recipe informations.");
				return element;								
			}	
			catch(Exception e){
				log.warning(e.toString() + "getCustomerWallet function returns null.");	
				closeDbAndQuery(dbConnTest, procedureQuery);
				return null;
			}			
		}
		
	// Girilen customer_id'ye ait kullanýcýnýn cüzdanýndaki parayý güncellemektedir.
	@WebMethod
	public int updateCustomerWallet(@WebParam(name = "amount")int amount, @WebParam(name = "msisdn")String msisdn){
			log.info("updateCustomerWallet function is called.");		
			try{	
				procedureQuery = checkMsisdnQuery(msisdn);
				if(procedureQuery.getInt(1) == 0) {
					procedureQuery = updateCustomerWalletQuery(amount, msisdn);
					int queryResult = procedureQuery.getInt(1);
					if(queryResult == -1) {
						log.warning("updateCustomerWallet function returned -1. Wallet cannot be negative.");
						closeDbAndQuery(dbConnTest, procedureQuery);
						return -1;
					}
					else{
						log.info("updateCustomerWallet function is ended succesfuly. It returns the recipe informations.");
						closeDbAndQuery(dbConnTest, procedureQuery);
						return queryResult;
					}				
				}
				else{
					log.info("updateCustomerWallet function has failed. The number you request couldn't be found in the database.");
					closeDbAndQuery(dbConnTest, procedureQuery);
					return -2;
				}				
			}	
			catch(Exception e){
				log.warning(e.toString() + " updateCustomerWallet function returns 0.");	
				closeDbAndQuery(dbConnTest, procedureQuery);
				return 0;
			}				
		}
		
	// The log file is created in main function. Also xml file is readed here
	public static void main(String[] args) {
		try {
			logFile = new FileHandler("./log4j.log");
		} catch (SecurityException | IOException e){
			log.warning(e.toString() + " log4j.log file cannot be created.");
		}
		log.setUseParentHandlers(false);							// It won't write anything to console.
		log.addHandler(logFile);									// It will write all the messages to log file.
		SimpleFormatter formatLogFile = new SimpleFormatter();		
		logFile.setFormatter(formatLogFile);				
		log.info("... Log starts here ...");
		readXml();
		String ipAdress = getIpAddress();
		Endpoint.publish("http://" + ipAdress + ":9090/i2i_benimle", new dbi2iBenimle());		
	}
}

