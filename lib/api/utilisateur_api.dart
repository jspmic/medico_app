import "token_service.dart";
import "utilisateur_model.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

// Keys: hospitals' name
// Values: List of services available
Map<String, dynamic> hopitaux = {};

class UtilisateurApi {
	Future<UtilisateurModel?> checkUser({String? email, String? numeroTelephone, required String password}) async {
		const host = String.fromEnvironment('HOST');
		if (host.isEmpty) {
		  throw AssertionError('HOST is not set');
		}
		Uri uri;
		if (email != null) {
			uri = Uri.parse("$host/user?email=$email&password=$password");
		}
		else if (numeroTelephone != null) {
			uri = Uri.parse("$host/user?numeroTelephone=$numeroTelephone&password=$password");
		}
		else {
			return null;
		}

		http.Response response = await http.get(uri);
		if (response.statusCode == 200) {
			Uri uri2 = Uri.parse("$host/hopital");
			http.Response response2 = await http.get(uri2);
			String body = json.decode(response.body);
			Map<String, dynamic> body2 = json.decode(response2.body);
			hopitaux = body2['hopitaux'];
			return utilisateurFromJson(body);
		}
		return null;
	}
	Future<bool> insertUser(UtilisateurModel user) async {
		const host = String.fromEnvironment('HOST');
		if (host.isEmpty) {
		  throw AssertionError('HOST is not set');
		}
		var uri = Uri.parse("$host/user");
		http.Response response = await http.post(
			uri,
			headers: <String, String>{
			  'Content-Type': 'application/json; charset=UTF-8'
			},
			body: utilisateurToJson(user)
		);
		if (response.statusCode == 201) {
			return true;
		}
		return false;
	}
}
