import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

Future<bool> generateOtp(TextEditingController email) async {
	EmailOTP.config(
		appName: 'Medico',
		otpType: OTPType.numeric,
		expiry : 600000,
		emailTheme: EmailTheme.v6,
		appEmail: 'me@rohitchouhan.com',
		otpLength: 6,
	);
	return await EmailOTP.sendOTP(email: email.text);
}

bool verifyOtp(TextEditingController otp) {
	return EmailOTP.verifyOTP(otp: otp.text);
}

bool checkPhoneNumber(String numero) {
	RegExp exp = RegExp(r"[0-9]{8}");
	return exp.hasMatch(numero);
}
