import 'package:flutter/material.dart';
import 'package:medico/models/user.dart';
import 'package:medico/customWidgets.dart';

late Color? background;
class ScreenTransition {
  late Color? backgroundColor;
  ScreenTransition({required this.backgroundColor}) {
    background = backgroundColor;
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
      title: Row(
		  mainAxisAlignment: MainAxisAlignment.spaceBetween,
		  children: [
		  	IconButton(onPressed: (){ Navigator.pop(context); }, icon: Icon(Icons.arrow_back, color: Colors.red)), // back button
		  ]
      ) // Row
      ),
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
                          TextFormField(
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
