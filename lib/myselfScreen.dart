import 'package:flutter/material.dart';
import 'package:medico/api/rdv_model.dart';
import 'package:medico/api/rdv_api.dart';
import 'package:medico/custom_widgets.dart';
import 'package:medico/api/utilisateur_model.dart';
import 'package:medico/api/utilisateur_api.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

late Color? background;
UtilisateurModel utilisateur = UtilisateurModel();
RdvModel rdv = RdvModel();
class ScreenTransition {
  late Color? backgroundColor;
  UtilisateurModel user;
  ScreenTransition({required this.backgroundColor, required this.user}) {
    background = backgroundColor;
	utilisateur = user;
  }
}

class Myself extends StatelessWidget {
  const Myself({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  backgroundColor: background,
      appBar: AppBar(
	  backgroundColor: Colors.transparent,
      leading: IconButton(onPressed: (){
		clearFields();
	  	Navigator.pop(context);
	  }, icon: Icon(Icons.arrow_back, color: Colors.red)), // back button
      ), // AppBar
	  body: MyselfPage(),
	  );
  }
}

class MyselfPage extends StatefulWidget {
  const MyselfPage({super.key});

  @override
  State<MyselfPage> createState() => _MyselfPageState();
}

class _MyselfPageState extends State<MyselfPage> {
  TextEditingController email = TextEditingController();
  TextEditingController numeroTelephone = TextEditingController();
  TextEditingController service = TextEditingController();
  TextEditingController hopital = TextEditingController();
  BoardDateTimeTextController controller = BoardDateTimeTextController();
  String? selectedHopital;
  bool isLoading = false;
  String stateText = "";
  Color? stateColor = getColor(background);

  void submit() async {
	if (hopital.text == "" || service.text == "" || rdv.datetime == null) {
		setState(() {
			stateText = "Remplissez toutes les cases";
			stateColor = Colors.red;
		});
		return;
	}
  	if (email.text != "") {
		rdv.contact = email.text;
	}
  	else if (numeroTelephone.text != "") {
		rdv.contact = numeroTelephone.text;
	}

	else {
		utilisateur.email != "" ? rdv.contact = utilisateur.email
		: rdv.contact = utilisateur.numeroTelephone;
	}

	rdv.nom = utilisateur.nom;
	rdv.sexe = utilisateur.sexe;
	rdv.idRef = utilisateur.id;
	rdv.hopital = hopital.text;
	rdv.service = service.text;

	setState(() {
	  isLoading = true;
	});
	bool status = await RdvApi().insertRdv(rdv);
	setState(() {
	  isLoading = false;
	});
	
	if (status && mounted) {
		setState(() {
		  stateText = "Opération réussie";
		  stateColor = Colors.green;
		});
		Navigator.pop(context);
	}
	else {
		setState(() {
		  stateText = "L'opération a échoué";
		  stateColor = Colors.red;
		});
	}

  }

  @override
  Widget build(BuildContext context) {
	  return SingleChildScrollView(
	  child: Center(
			  child: Padding(
			  padding: EdgeInsets.all(MediaQuery.of(context).size.width/8),
			  child:
				  Column(
					  children: [
						  SizedBox(height: MediaQuery.of(context).size.height/15),
                    Form(child: Padding(padding: EdgeInsets.all(16.0), child:
                      Column(
                        children: [
						  Hopital(
						  	controller: hopital,
							backgroundColor: background!,
							onSelect: (value) {
								setState(() {
									service.text = "";
									selectedServices = [];
								});
								selectedHopital = value;
								selectedServices = hopitaux[selectedHopital];
								setState(() {
								});
							}
						  ),
						  Service(
						  	controller: service,
							backgroundColor: background!,
							onSelect: (value){},
						  ),
                          TextFormField(
                            decoration: InputDecoration(
							  enabled: false,
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Numéro de Téléphone (optionnel)",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.call, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							controller: numeroTelephone,
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/25),
                          TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Email",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.alternate_email, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							controller: email,
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/13),
						  timePicker(context, controller: controller, onChanged: (value) { rdv.datetime = value; },
						  			 backgroundColor: background),
                          SizedBox(height: MediaQuery.of(context).size.height/13),
						  Text(stateText, style: TextStyle(backgroundColor: stateColor)),
                          SizedBox(height: MediaQuery.of(context).size.height/13),
                          isLoading? CircularProgressIndicator() : FloatingActionButton(onPressed: () => submit(),
							  backgroundColor: Colors.red,
							  child: Icon(Icons.check, color: getColor(background))),
                        ],
                      ))),
						]
					) // Column
				) // Padding
		) // Center
	); // SingleChildScrollView
  }
}
