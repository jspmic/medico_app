import 'package:flutter/material.dart';
import 'package:medico/custom_widgets.dart';
import 'package:medico/api/utilisateur_model.dart';
import 'package:medico/api/utilisateur_api.dart';

late Color? background;
UtilisateurModel utilisateur = UtilisateurModel();
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
  TextEditingController service = TextEditingController();
  TextEditingController hopital = TextEditingController();
  String? selectedHopital;

  @override
  Widget build(BuildContext context) {
	  return Center(
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
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/25),
                          TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Email (optionnel)",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.alternate_email, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/13),
                          FloatingActionButton(onPressed: (){},
							  backgroundColor: Colors.red,
							  child: Icon(Icons.check, color: getColor(background))),
                        ],
                      ))),
						]
					) // Column
				) // Padding
		); // Center
  }
}
