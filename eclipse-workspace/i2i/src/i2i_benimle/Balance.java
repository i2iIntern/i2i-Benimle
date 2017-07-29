package i2i_benimle;

public class Balance {
	int id;
	int remainingData;
	int remainingVoice;
	int remainingSms;
	int contractId;
	int msisdnId;
	String expirationDate;
	
	public String getExpiration_date() {
		return expirationDate;
	}
	public void setExpiration_date(String expiration_date) {
		this.expirationDate = expiration_date;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getRemaining_data() {
		return remainingData;
	}
	public void setRemaining_data(int remaining_data) {
		this.remainingData = remaining_data;
	}
	public int getRemaining_voice() {
		return remainingVoice;
	}
	public void setRemaining_voice(int remaining_voice) {
		this.remainingVoice = remaining_voice;
	}
	public int getRemaining_sms() {
		return remainingSms;
	}
	public void setRemaining_sms(int remaining_sms) {
		this.remainingSms = remaining_sms;
	}
	public int getContract_id() {
		return contractId;
	}
	public void setContract_id(int contract_id) {
		this.contractId = contract_id;
	}
	public int getMsisdn_id() {
		return msisdnId;
	}
	public void setMsisdn_id(int msisdn_id) {
		this.msisdnId = msisdn_id;
	}
}
