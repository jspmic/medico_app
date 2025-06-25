bool checkPhoneNumber(String numero) {
	RegExp exp = RegExp(r"[0-9]{8}");
	return exp.hasMatch(numero);
}
