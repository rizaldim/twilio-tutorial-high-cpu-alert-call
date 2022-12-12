#!/bin/bash

# Usage: ./5-lambda-env.sh <acc-sid> <auth-token> <phone-number> <dest-phone-number>

twilio_acc_sid=$1
twilio_auth_token=$2
twilio_phone_number=$3
dest_phone_number=$4

aws lambda update-function-configuration --function-name high-cpu-call \
  --environment "Variables={TWILIO_ACCOUNT_SID=$twilio_acc_sid,TWILIO_AUTH_TOKEN=$twilio_auth_token,TWILIO_PHONE_NUMBER=$twilio_phone_number,DEST_PHONE_NUMBER=$dest_phone_number}"

