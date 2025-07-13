import 'package:flutter/material.dart';
import 'package:medico/checkers.dart';
import 'custom_widgets.dart';
import 'package:medico/api/utilisateur_api.dart';
import 'package:medico/api/utilisateur_model.dart';

late Color? background;
late UtilisateurModel user;
class ScreenTransition {
  late Color? backgroundColor;
  UtilisateurModel completeUser;
  ScreenTransition({required this.backgroundColor,
  required this.completeUser}) {
    background = backgroundColor;
	user = completeUser;
  }
}

class Otp extends StatelessWidget {
  const Otp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  backgroundColor: background,
      appBar: AppBar(
	  backgroundColor: Colors.transparent,
      leading: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back, color: Colors.red)), // back button
      ), // AppBar
	  body: OtpPage(),
	  );
  }
}

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading  = false;
  TextEditingController otp = TextEditingController();

  String? _validateField(String? value){
    return value == null || value.isEmpty ? "Entrer le code OTP" : null;
  }

  void createAccount() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
    }
    else{
      return;
    }

    setState(() {
      isLoading = true;
    });
	bool status = verifyOtp(otp);
	if (status) {
		bool accountStatus = await UtilisateurApi().insertUser(user);
		setState(() {
		  isLoading = false;
		});
		if (accountStatus && mounted) {
			showDialog(
				context: context,
				builder: (BuildContext context) {
					return AlertDialog(
						backgroundColor: background,
						elevation: 4.0,
						title: Text("Bravo", style: TextStyle(color: getColor(background))),
						content: Text("Votre compte a été créé", style: TextStyle(color: getColor(background))),
						actions: [
							TextButton(
								onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
								child: Text("Continuer", style: TextStyle(color: getColor(background))),
							)
						],
					); // AlertDialog
				}
			); // showDialog
		}
	}
  }

  @override
  Widget build(BuildContext context) {
	  return Center(
			  child: Padding(
			  padding: EdgeInsets.all(MediaQuery.of(context).size.width/8),
			  child:
				  Column(
					  children: [
						  SizedBox(height: MediaQuery.of(context).size.height/15),
                    Form(key: _formKey, child: Padding(padding: EdgeInsets.all(16.0), child:
                      Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "OTP",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.call, color: Colors.red),
                            ),
                            style: TextStyle(color: getColor(background)),
							controller: otp,
							validator: _validateField,
                          ), // TextFormField
                          SizedBox(height: MediaQuery.of(context).size.height/25),
                          isLoading ? CircularProgressIndicator() : ElevatedButton(onPressed: (){
						  	createAccount();
						  },
							  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
							  child: Text("Créer le compte", style: TextStyle(color: getColor(background)))),
                        ],
                      ))),
						]
					) // Column
				) // Padding
		); // Center
  }
}
