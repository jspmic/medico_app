import 'package:flutter/material.dart';
import 'package:medico/customWidgets.dart';
import 'package:medico/user.dart';
import 'package:medico/rdvScreen.dart' as rdvScreen;
import 'package:medico/myselfScreen.dart';
import 'package:medico/anotherScreen.dart';

// These will be defined later depending on the context we're in
// background: will contain the startup background depending on the device's theme
// changeTheme: will determine the boolean value,
// that represents whether to change the theme to dark or light
Color? background = Colors.grey[900];
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
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Medico",
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
      background = background == Colors.white ? Colors.grey[900] : Colors.white;
    });
  }

  String? _validateField(String? value){
    setState(() {
      state = Colors.red;
    });
    return value == null || value.isEmpty ? "Champ obligatoire" : null;
  }

  bool passwordVisible = false;

  Color? fieldColor = Colors.grey[300];

  bool isLoading = false;
  Color state = background == Colors.white ? Colors.black : Colors.white;
  String _uname = "";
  String _pssw = "";

  var username = TextEditingController();
  var pssw = TextEditingController();

  void authenticate() async{
    if (_formKey.currentState!.validate()){
      _formKey.currentState?.save();
    }
    else{
      return;
    }
    setState(() {
      isLoading = false;
    });
    isLoading = true;
    String _hashed = _pssw.toString();
    setState(() {
      isLoading = false;
    });

    if (mounted) {
      username.text = "";
      pssw.text = "";
      Navigator.push(context, 
	  	MaterialPageRoute(builder: (context) {
			rdvScreen.ScreenTransition(backgroundColor: background);
			return rdvScreen.Rdv();
		}),
		);
    }
  }

  @override
  Widget build(BuildContext context){
    if (changeTheme == false) {
      background = getDeviceTheme(context);
    }

    return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: background,
              body: Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.all(20.0),
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
                              labelText: "Nom d'utilisateur...",
                                labelStyle: TextStyle(color: getColor(background), fontSize: 12),
                              suffixIcon: Icon(Icons.person, color: getColor(background)),
                            ),
                            controller: username,
                            style: TextStyle(color: getColor(background)),
                            validator: (value) => _validateField(value),
                            onSaved: (value) => _uname = value!,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                labelText: "Mot de passe...",
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
                          child: Icon(Icons.login_rounded, color: getColor(background))),
                        SizedBox(height: MediaQuery.of(context).size.height/13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Pas encore de compte ?", style: TextStyle(color: getColor(background))),
                            ElevatedButton(onPressed: () => changeThemeFunction(),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: Text("Créer un compte", style: TextStyle(color: getColor(background)))),
                          ]
                        ),
                  ]))),
          ),
        );
  }
}
