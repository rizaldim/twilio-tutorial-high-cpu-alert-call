package example;

import com.google.gson.annotations.SerializedName;

public class SNSMessage {

    @SerializedName("AlarmName") String alarmName;
    @SerializedName("AlarmDescription") String alarmDescription;
    @SerializedName("Trigger") Trigger trigger;

}
