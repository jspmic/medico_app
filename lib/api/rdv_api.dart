import "rdv_model.dart";
import 'dart:convert';
import 'package:http/http.dart' as http;


class RdvApi {
	Future<List<RdvModel?>> getRdv(int userID) async {
		const host = String.fromEnvironment('HOST');
		if (host.isEmpty) {
		  throw AssertionError('HOST is not set');
		}

		Uri uri = Uri.parse("$host/rdv?id_user=$userID");
		http.Response response = await http.get(uri);
		if (response.statusCode == 200) {
			List<RdvModel?> listRdv = [];
			var bodyDecoded = json.decode(json.decode(response.body));
			List rdv = bodyDecoded['output'];
			for (Map<String, dynamic> rendezvous in rdv) {
				listRdv.add(RdvModel.fromJson(rendezvous));
			}
			return listRdv;
		}
		else {
			return [];
		}
	}
	Future<bool> insertRdv(String host, RdvModel rdv) async {
		const host = String.fromEnvironment('HOST');
		if (host.isEmpty) {
		  throw AssertionError('HOST is not set');
		}

		var uri = Uri.parse("$host/rdv");
		http.Response response = await http.post(
			uri,
			headers: <String, String>{
			  'Content-Type': 'application/json; charset=UTF-8'
			},
			body: rdvToJson(rdv)
		);
		if (response.statusCode == 201) {
			return true;
		}
		return false;
	}
}
