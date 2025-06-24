import 'package:flutter/material.dart';
import 'package:medico/anotherScreen.dart' as anotherScreen;
import 'package:medico/myselfScreen.dart' as myselfScreen;
import 'package:medico/models/user.dart';
import 'package:medico/customWidgets.dart';

late Color? background;
class ScreenTransition {
  late Color? backgroundColor;
  ScreenTransition({required this.backgroundColor}) {
    background = backgroundColor;
  }
}

class Rdv extends StatelessWidget {
  const Rdv({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
	  backgroundColor: background,
      appBar: AppBar(
		  backgroundColor: Colors.transparent,
		  title: Align(
			  alignment: Alignment.topRight,
			  child: IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back, color: Colors.red)), // back button
		  ), // Align
		  leading: Builder(
			  builder: (context) {
				return Align(
				alignment: Alignment.topCenter,
				child: IconButton(
				  color: Colors.red,
				  icon: const Icon(Icons.menu),
				  onPressed: () {
					Scaffold.of(context).openDrawer();
          },
        ) // IconButton
		); // Align
      },
    ),
      ), // AppBar
	  drawer: Drawer(
		  backgroundColor: background,
		  elevation: 0,
		  child: ListView(
			children: [
				DrawerHeader(
				  decoration: BoxDecoration(color: getSubtitlesColor(background)),
				  child: Text('Menu', style: TextStyle(color: getColor(background))),
            ),
			]
		  ) // ListView
	  ),
	  body: RdvPage(),
	  );
  }
}

class RdvPage extends StatefulWidget {
  const RdvPage({super.key});

  @override
  State<RdvPage> createState() => _RdvPageState();
}

class _RdvPageState extends State<RdvPage> {

  @override
  Widget build(BuildContext context) {
	  return Center(
			  child: Padding(
			  padding: EdgeInsets.all(MediaQuery.of(context).size.width/8),
			  child:
				  Column(
					  children: [
						  SizedBox(height: MediaQuery.of(context).size.height/15),
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
											myselfScreen.ScreenTransition(backgroundColor: background);
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
											anotherScreen.ScreenTransition(backgroundColor: background);
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
			); // Center
  }
}
