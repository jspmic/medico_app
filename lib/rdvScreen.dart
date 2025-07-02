import 'package:flutter/material.dart';
import 'package:medico/anotherScreen.dart' as anotherScreen;
import 'package:medico/myselfScreen.dart' as myselfScreen;
import 'package:medico/custom_widgets.dart';
import 'package:medico/api/utilisateur_model.dart';

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

class DrawerOptions {
	final String label;
	final Widget icon;
	final Widget selectedIcon;
	const DrawerOptions({required this.label, required this.icon, required this.selectedIcon});
}

const List<DrawerOptions> options = [
	DrawerOptions(label: "Accueil", icon: Icon(Icons.home_outlined, color: Colors.red), selectedIcon: Icon(Icons.home, color: Colors.red)),
	DrawerOptions(label: "Profil", icon: Icon(Icons.person_outlined, color: Colors.red), selectedIcon: Icon(Icons.person, color: Colors.red)),
	DrawerOptions(label: "Se déconnecter", icon: Icon(Icons.logout_outlined, color: Colors.red), selectedIcon: Icon(Icons.logout, color: Colors.red)),
];

Widget index0(BuildContext context) {
  return SingleChildScrollView(
	  child: Center(
			  child: Padding(
			  padding: EdgeInsets.all(MediaQuery.of(context).size.width/10),
			  child:
				  Column(
					  mainAxisAlignment: MainAxisAlignment.center,
					  crossAxisAlignment: CrossAxisAlignment.center,
					  children: [
						  SizedBox(height: MediaQuery.of(context).size.height/5),
						  Card(
							elevation: 9,
							color: background,
							child: Column(
							  mainAxisSize: MainAxisSize.min,
							  children: <Widget>[
								ListTile(
								  onTap: (){
									  Navigator.push(context, 
										MaterialPageRoute(builder: (context) {
											myselfScreen.ScreenTransition(backgroundColor: background, user: utilisateur);
											return myselfScreen.Myself();
										}),
										);
								  },
								  leading: Icon(Icons.person, color: Colors.red),
								  trailing: Icon(Icons.arrow_circle_right, color: getColor(background)),
								  title: Text('Prendre un rendez-vous pour moi', style: TextStyle(color: getColor(background))),
								  subtitle: Text('Utiliser ce compte pour prendre votre rendez-vous medical',
									  style: TextStyle(color: getSubtitlesColor(background))),
								),
								  ],
								),
							), // Card

						  SizedBox(height: MediaQuery.of(context).size.height/20),

						  Card(
							elevation: 9,
							color: background,
							child: Column(
							  mainAxisSize: MainAxisSize.min,
							  children: <Widget>[
								ListTile(
								  onTap: (){
									  Navigator.push(context, 
										MaterialPageRoute(builder: (context) {
											anotherScreen.ScreenTransition(backgroundColor: background, user: utilisateur);
											return anotherScreen.Another();
										}),
										);
								  },
								  leading: Icon(Icons.group, color: Colors.red),
								  trailing: Icon(Icons.arrow_circle_right, color: getColor(background)),
								  title: Text('Prendre un rendez-vous pour une autre', style: TextStyle(color: getColor(background))),
								  subtitle: Text('Utiliser ce compte pour prendre un rendez-vous medical pour une autre personne',
									  style: TextStyle(color: getSubtitlesColor(background))),
								),
								  ],
								),
							), // Card
						]
					) // Column
				) // Padding
			) // Center
		); // SingleChildScrollView
}

Widget index1(BuildContext context) {
  TextEditingController email = TextEditingController();
  TextEditingController numeroTelephone = TextEditingController();
  TextEditingController dateNaissance = TextEditingController();
  DateTime date = utilisateur.dateNaissance!;
  email.text = utilisateur.email!;
  numeroTelephone.text = utilisateur.numeroTelephone!;
  dateNaissance.text = "${date.day}/${date.month}/${date.year}";
  return SingleChildScrollView(
	  child: Center(
		  child: Padding(
		  padding: EdgeInsets.all(MediaQuery.of(context).size.width/10),
		  child:
			  Column(
				  mainAxisAlignment: MainAxisAlignment.center,
				  crossAxisAlignment: CrossAxisAlignment.center,
				  children: [
					Row(
						children: [
							Text("Email: ", style: TextStyle(color: getColor(background))),
							SizedBox(
								width: MediaQuery.of(context).size.width/1.8,
								child: TextField(
									controller: email,
									style: TextStyle(color: getSubtitlesColor(background)),
									decoration: InputDecoration(
										border: InputBorder.none
									),
								), // TextField
							),
					]), // Row
					Row(
						children: [
							Text("Numéro: ", style: TextStyle(color: getColor(background))),
							SizedBox(
								width: MediaQuery.of(context).size.width/3,
								child: TextField(
									controller: numeroTelephone,
									style: TextStyle(color: getSubtitlesColor(background)),
									decoration: InputDecoration(
										border: InputBorder.none
									),
								), // TextField
							), // SizedBox
					]), // Row
					Row(
						children: [
							Text("Date de naissance: ", style: TextStyle(color: getColor(background))),
							SizedBox(
								width: MediaQuery.of(context).size.width/3,
								child: TextField(
									enabled: false,
									controller: dateNaissance,
									style: TextStyle(color: getSubtitlesColor(background)),
									decoration: InputDecoration(
										border: InputBorder.none
									),
								), // TextField
							),
					]), // Row
					Divider(),
					RdvDisplayer(utilisateur: utilisateur,
								 backgroundColor: background)
				  ]
				) // Column
			) // Padding
		) // Center
	); // SingleChildScrollView
}

class RdvPage extends StatefulWidget {
  const RdvPage({super.key});

  @override
  State<RdvPage> createState() => _RdvPageState();
}

class _RdvPageState extends State<RdvPage> {
  int screenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  backgroundColor: background,
	  bottomNavigationBar: NavigationBar(
		  backgroundColor: background,
		  labelTextStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(color: getColor(background))),
		  elevation: 10,
		  selectedIndex: screenIndex,
		  onDestinationSelected: (int index) {
		  	setState(() {
			  if (index == 2) {
			  	Navigator.pop(context);
			  }
		  	  screenIndex = index;
		  	});
		  },
		  destinations: options.map((value) {
		  	return NavigationDestination(
				label: value.label,
				icon: value.icon,
				selectedIcon: value.selectedIcon,
				tooltip: value.label
			);
		  }).toList(),
	  ), // NavigationBar
	  body: screenIndex == 0 ? index0(context) : index1(context),
	  );
  }
}
