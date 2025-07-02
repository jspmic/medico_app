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

class Another extends StatelessWidget {
  const Another({super.key});

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
      ),
	  body: AnotherPage(),
	  );
  }
}

class AnotherPage extends StatefulWidget {
  const AnotherPage({super.key});

  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  TextEditingController service = TextEditingController();
  TextEditingController hopital = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController commune = TextEditingController();
  TextEditingController sexe = TextEditingController();
  String? selectedHopital;

  String? _validateField(String? value){
    return value == null || value.isEmpty ? "Champ obligatoire" : null;
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
								setState(() {
									selectedServices = hopitaux[selectedHopital];
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
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Nom & Prenom",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.person, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							validator: _validateField,
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/25),
						  DropdownMenu(
							onSelected: (value) {},
							menuStyle: MenuStyle(backgroundColor: WidgetStatePropertyAll<Color?>(background),
							elevation: WidgetStatePropertyAll<double>(2.0),
							),
							inputDecorationTheme: InputDecorationTheme(
								border: InputBorder.none,
								enabledBorder: InputBorder.none,
								focusedBorder: InputBorder.none,
								hintStyle: TextStyle(color: getColor(background), fontSize: 14)
							),
							expandedInsets: EdgeInsetsGeometry.directional(start: 0, end: MediaQuery.of(context).size.width/20),
							textStyle: TextStyle(color: getColor(background), fontSize: 14),
							hintText: "Sexe",
							controller: sexe,
							leadingIcon: Icon(Icons.wc, color: Colors.red),
							dropdownMenuEntries: [
								DropdownMenuEntry(label: "Masculin", value: "M",style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(getColor(background)
										) // WidgetStatePropertyAll
									), leadingIcon: Icon(Icons.person) // ButtonStyle
								), // DropdownMenuEntry
								DropdownMenuEntry(label: "Feminin", value: "F",style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(getColor(background)
										) // WidgetStatePropertyAll
									), leadingIcon: Icon(Icons.woman) // ButtonStyle
								), // DropdownMenuEntry
							],
						  ), // DropdownMenu
                          SizedBox(height: MediaQuery.of(context).size.height/25),
						  Province(onSelect: (value) {	// Province
						  	setState(() {
							  selectedCommunes = [];
						  	  populateCommunes(value);
						  	});
						  }, backgroundColor: background!,
						  controller: province),
                          SizedBox(height: MediaQuery.of(context).size.height/25),
						  Commune(onSelect: (value) {	// Commune
						  }, backgroundColor: background!,
						  controller: commune),
                          SizedBox(height: MediaQuery.of(context).size.height/25),
                          TextFormField(
			    enabled: false,
                            decoration: InputDecoration(
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
                              labelText: "Email",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.alternate_email, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							validator: _validateField,
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
		) // Center
		); // SingleChildScrollView
  }
}
