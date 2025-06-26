import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'otp.dart' as otp;
import 'checkers.dart';
import 'package:medico/api/utilisateur_api.dart';
import 'package:medico/api/utilisateur_model.dart';
import 'package:medico/custom_widgets.dart';

late Color? background;
class ScreenTransition {
  late Color? backgroundColor;
  ScreenTransition({required this.backgroundColor}) {
    background = backgroundColor;
  }
}

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  backgroundColor: background,
      appBar: AppBar(
	  backgroundColor: Colors.transparent,
      leading: IconButton(onPressed: (){
			selectedCommunes = [];
	  		Navigator.pop(context);
		}, icon: Icon(Icons.arrow_back, color: Colors.red)), // back button
      ),
	  body: SignupPage(),
	  );
  }
}

enum Sexe {masculin, feminin}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UtilisateurModel user = UtilisateurModel();

  // Necessary controllers
  TextEditingController pssw = TextEditingController();
  TextEditingController confirmPssw = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController commune = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController sexe = TextEditingController();

  // State management booleans
  bool passwordVisible = false;
  bool isLoading = false;
  String _pssw = "";

  String? _validateField(String? value){
    return value == null || value.isEmpty ? "Champ obligatoire" : null;
  }

  String? _validatePasswordFields(String? value){
    return value == null || value.isEmpty || confirmPssw.text != pssw.text ?
	"Mots de passe différents" : null;
  }

  void authenticate() async{
    if (_formKey.currentState!.validate() && sexe.text.isNotEmpty &&
		province.text.isNotEmpty && commune.text.isNotEmpty && user.dateNaissance != null){
      _formKey.currentState?.save();
    }
    else{
      return;
    }

    setState(() {
      isLoading = true;
    });

    String password = sha256.convert(utf8.encode(_pssw)).toString();
	user.password = password;
	bool done = await generateOtp(email);

    setState(() {
      isLoading = false;
    });
	  if (done && mounted) {
		  Navigator.push(context, 
			MaterialPageRoute(builder: (context) {
				otp.ScreenTransition(backgroundColor: background, completeUser: user);
				return otp.Otp();
			}),
			);
	  }
  }

  @override
  Widget build(BuildContext context) {
	  pssw.text = "test";
	  confirmPssw.text = "test";
	  email.text = "micaeljaspe@gmail.com";
	  nom.text = "Jaspe Michaël";
	  sexe.text = "Masculin";
	  province.text = "Bujumbura";
	  commune.text = "Ntahangwa";
	  _pssw = pssw.text;
	  user.email = email.text;
	  user.nom = nom.text;
	  user.sexe = "M";
	  user.province = province.text;
	  user.commune = commune.text;
	  return SingleChildScrollView(
		  child: Center(
			  child: Padding(
			  padding: EdgeInsets.all(MediaQuery.of(context).size.width/12),
			  child:
				  Column(
					  children: [
                    Form(key: _formKey, child: Padding(padding: EdgeInsets.all(16.0), child:
                      Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Nom & Prénom",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 14),
                              suffixIcon: Icon(Icons.person, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							onChanged: (value) => user.nom = value,
							controller: nom,
							validator: _validateField,
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/25),
						  Row(
						  mainAxisAlignment: MainAxisAlignment.spaceBetween,
						  children: [
							  Text("Date de naissance :", style: TextStyle(color: getColor(background))),
							  DatePicker(backgroundColor: background, hintText: "...", onSelect: (value) => user.dateNaissance = value),
						  ]),
                          SizedBox(height: MediaQuery.of(context).size.height/50),
						  DropdownMenu(
							onSelected: (value) => user.sexe = value,
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
									) // ButtonStyle
								), // DropdownMenuEntry
								DropdownMenuEntry(label: "Feminin", value: "F",style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(getColor(background)
										) // WidgetStatePropertyAll
									) // ButtonStyle
								), // DropdownMenuEntry
							],
						  ), // DropdownMenu
						  Province(onSelect: (value) {	// Province
							user.province = value;
						  	setState(() {
						  	  populateCommunes(value);
						  	});
						  }, backgroundColor: background!,
						  controller: province),
						  Commune(onSelect: (value) {	// Commune
						  	user.commune = value;
						  }, backgroundColor: background!,
						  controller: commune),
                          TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Numéro de Téléphone (optionnel)",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.call, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							onChanged: (value) => user.numeroTelephone = value,
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/25),
                          TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Email",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 14),
                              suffixIcon: Icon(Icons.alternate_email, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							onChanged: (value) => user.email = value,
							controller: email,
                            validator: (value) => _validateField(value)
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/25),
                          TextFormField(
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                labelText: "Mot de passe",
								suffixIcon: IconButton(onPressed: () {
								setState(() {
								  passwordVisible = !passwordVisible;
								});
								}, icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off), color: Colors.red),
                              labelStyle: TextStyle(color: getColor(background), fontSize: 14)
                            ),
                            obscureText: !passwordVisible,
                            controller: pssw,
                            style: TextStyle(color: getColor(background)),
                            validator: (value) => _validatePasswordFields(value),
                            onSaved: (value) => _pssw = value!,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/25),
                          TextFormField(
							obscureText: true,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Confirmer le mot de passe",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 14),
                              suffixIcon: Icon(Icons.password, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							controller: confirmPssw,
                            validator: (value) => _validatePasswordFields(value)
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/13),
                          isLoading ? CircularProgressIndicator() : FloatingActionButton(onPressed: () => authenticate(),
							  backgroundColor: Colors.red,
							  child: Icon(Icons.check, color: getColor(background))),
							  ]
					) // Column
				) // Padding
		) // Form
		] // children
		) // Column
		) // Padding
		) // Center
		); // SingleChildScrollView
  }
}
