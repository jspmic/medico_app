import "token_service.dart";
import "utilisateur_model.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;

final String HOST="http://192.168.42.81:5000";


class UtilisateurApi {
	Future<UtilisateurModel?> checkUser({String? email, String? numeroTelephone, required String password}) async {
		Uri uri;
		if (email != null) {
			uri = Uri.parse("$HOST/user?email=$email&password=$password");
		}
		else if (numeroTelephone != null) {
			uri = Uri.parse("$HOST/user?numeroTelephone=$numeroTelephone&password=$password");
		}
		else {
			return null;
		}

		http.Response response = await http.get(uri);
		if (response.statusCode == 200) {
			return utilisateurFromJson(json.decode(response.body));
		}
		return null;
	}
	Future<bool> insertUser(UtilisateurModel user) async {
		var uri = Uri.parse("$HOST/user");
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
