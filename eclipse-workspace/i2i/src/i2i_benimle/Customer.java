package i2i_benimle;

public class Customer {	
	int id;
	String firstName;
	String lastName;
	String birthOfDate;
	
	public String getBirth_of_date() {
		return birthOfDate;
	}
	public void setBirth_of_date(String birth_of_date) {
		this.birthOfDate = birth_of_date;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}	
	public String getFirst_name() {
		return firstName;
	}
	public void setFirst_name(String first_name) {
		this.firstName = first_name;
	}	
	public String getLast_name() {
		return lastName;
	}
	public void setLast_name(String last_name) {
		this.lastName = last_name;
	}		
}
