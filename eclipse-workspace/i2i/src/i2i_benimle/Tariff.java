package i2i_benimle;

public class Tariff {
	int id;
	String name;
	String description;
	int price;
	int dataAmount;
	int voiceAmount;
	int smsAmount;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getData_amount() {
		return dataAmount;
	}
	public void setData_amount(int data_amount) {
		this.dataAmount = data_amount;
	}
	public int getVoice_amount() {
		return voiceAmount;
	}
	public void setVoice_amount(int voice_amount) {
		this.voiceAmount = voice_amount;
	}
	public int getSms_amount() {
		return smsAmount;
	}
	public void setSms_amount(int sms_amount) {
		this.smsAmount = sms_amount;
	}	
}
