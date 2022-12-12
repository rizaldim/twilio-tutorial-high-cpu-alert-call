package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SNSEvent;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Call;
import com.twilio.type.PhoneNumber;
import com.twilio.type.Twiml;

public class HandlerSNS implements RequestHandler<SNSEvent, String> {
    Gson gson = new GsonBuilder().setPrettyPrinting().create();

    public static final String ACCOUNT_SID = System.getenv("TWILIO_ACCOUNT_SID");
    public static final String AUTH_TOKEN = System.getenv("TWILIO_AUTH_TOKEN");

    public static final String PHONE_NUMBER = System.getenv("TWILIO_PHONE_NUMBER");
    public static final String DEST_PHONE_NUMBER = System.getenv("DEST_PHONE_NUMBER");

    @Override
    public String handleRequest(SNSEvent event, Context context) {
        String response = "200 OK";

        String message = event.getRecords().get(0).getSNS().getMessage();
        SNSMessage snsMessage = gson.fromJson(message, SNSMessage.class);

        PhoneNumber dest = new PhoneNumber(DEST_PHONE_NUMBER);
        PhoneNumber source = new PhoneNumber(PHONE_NUMBER);
        Twiml twiml = new Twiml(String.format("<Response><Say>Instance cpu utilization exceeds threshold %d %s</Say></Response>",
                (int) snsMessage.trigger.getThreshold(),
                snsMessage.trigger.getUnit()
        ));

        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
        Call call = Call.creator(dest, source, twiml).create();

        call.getSid();

        return response;
    }
}
