package i2i_benimle;

public class Jdbc {
	private static String driver;
	private static String dbInfo;
	private static String username;
	private static String password;
	public String getDriver() {
		return driver;
	}
	public void setDriver(String driver) {
		Jdbc.driver = driver;
	}
	public String getDbInfo() {
		return dbInfo;
	}
	public void setDbInfo(String dbInfo) {
		Jdbc.dbInfo = dbInfo;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		Jdbc.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		Jdbc.password = password;
	}	
}
