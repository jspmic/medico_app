import 'package:flutter/material.dart';
import 'package:medico/custom_widgets.dart';
import 'package:medico/rdvScreen.dart' as rdv_screen;
import 'package:medico/signup.dart' as signup;
import 'package:medico/api/utilisateur_model.dart';
import 'package:medico/api/utilisateur_api.dart';
import 'package:medico/checkers.dart';

// These will be defined later depending on the context we're in
// background: will contain the startup background depending on the device's theme
// changeTheme: will determine the boolean value,
// that represents whether to change the theme to dark or light
Color? background;
bool changeTheme = false;

// Function that returns the Color depending on the device's theme
Color? getDeviceTheme(BuildContext context){
  Brightness brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  return isDarkMode ? Colors.blueGrey[900] : Colors.white;
}

void main() => runApp(const Login());

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Medico",
		initialRoute: '/',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
            primarySwatch: Colors.red),
        home: LoginPage()
    );
  }
}
class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void changeThemeFunction() {
    setState(() {
      changeTheme = true;
      background = background == Colors.white ? Colors.blueGrey[900] : Colors.white;
    });
  }

  String? _validateField(String? value){
    setState(() {
      state = Colors.red;
    });
    return value == null || value.isEmpty ? "Champ obligatoire" : null;
  }

  UtilisateurModel utilisateur = UtilisateurModel();
  bool passwordVisible = false;

  Color? fieldColor = Colors.grey[300];

  bool isLoading = false;
  Color state = background == Colors.white ? Colors.black : Colors.white;
  String _contact = "";
  String _pssw = "";

  TextEditingController contact = TextEditingController();
  TextEditingController pssw = TextEditingController();

  void authenticate() async{
    if (_formKey.currentState!.validate()){
      _formKey.currentState?.save();
    }
    else{
      return;
    }
    setState(() {
      isLoading = true;
    });

	String contactDetail = _contact.toString();
    String password = _pssw.toString();
	SnackBar? info;
	UtilisateurModel? user;
	bool status = false;
	if (checkPhoneNumber(contactDetail)) {
		try {
			user = await UtilisateurApi().checkUser(password: password, numeroTelephone: contactDetail);
		}
		on Exception {
			info = customSnackBar(background, "Problème de connexion");
		}
		if (user != null) {
			utilisateur = user;
			status = true;
		}
	}
	else {
		try {
			user = await UtilisateurApi().checkUser(password: password, email: contactDetail);
		}
		on Exception {
			info = customSnackBar(background, "Problème de connexion");
		}
		if (user != null) {
			utilisateur = user;
			status = true;
		}
	}

    setState(() {
      isLoading = false;
    });

	if (mounted && (info != null)) {
		ScaffoldMessenger.of(context).showSnackBar(info);
		return;
	}

    if (mounted && status) {
      contact.text = "";
      pssw.text = "";
      Navigator.push(context, 
	  	MaterialPageRoute(builder: (context) {
			rdv_screen.ScreenTransition(backgroundColor: background, user: utilisateur);
			return rdv_screen.RdvPage();
		}),
		);
    }
	else if (mounted && !status) {
		var snack = customSnackBar(background, "Utilisateur non existant");
		ScaffoldMessenger.of(context).showSnackBar(snack);
	}
  }

  @override
  Widget build(BuildContext context){
    if (changeTheme == false) {
      background = getDeviceTheme(context);
    }
    return SizedBox(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: background,
              body: Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height/40),
                  margin: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height/10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/logo/medico_logo2.png",
                          fit: BoxFit.cover, width: 200, height: 200),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                        SizedBox(height: 8),
                    Form(key: _formKey, child: Padding(padding: EdgeInsets.all(16.0), child:
                      Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              labelText: "Email (ou numero de téléphone)",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.person, color: getColor(background)),
                            ),
                            controller: contact,
                            style: TextStyle(color: getColor(background)),
                            validator: (value) => _validateField(value),
                            onSaved: (value) => _contact = value!,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                labelText: "Mot de passe",
								suffixIcon: IconButton(onPressed: () {
								setState(() {
								  passwordVisible = !passwordVisible;
								});
								}, icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off), color: getColor(background)),
                              labelStyle: TextStyle(color: getColor(background), fontSize: 12)
                            ),
                            obscureText: !passwordVisible,
                            controller: pssw,
                            style: TextStyle(color: getColor(background)),
                            validator: (value) => _validateField(value),
                            onSaved: (value) => _pssw = value!,
                          )
                        ],
                      ))),
                        SizedBox(height: MediaQuery.of(context).size.height/25),
                        isLoading ? CircularProgressIndicator()
                            : FloatingActionButton(onPressed: authenticate,
                          backgroundColor: Colors.red,
						  elevation: 2,
                          child: Icon(Icons.login_rounded, color: getColor(background))),
						IconButton(icon: Icon(Icons.dark_mode, color: Colors.red), onPressed: () => changeThemeFunction()),
                        SizedBox(height: MediaQuery.of(context).size.height/13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Pas de compte?", style: TextStyle(color: getColor(background))),
                            ElevatedButton(onPressed: () {
							      Navigator.push(context, 
									MaterialPageRoute(builder: (context) {
										signup.ScreenTransition(backgroundColor: background);
										return signup.Signup();
									}),
									);
							},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: Text("Créer un compte", style: TextStyle(color: getColor(background)))),
                          ]
                        ),
                  ]))),
          ),
        );
  }
}
