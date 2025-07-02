import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medico/api/rdv_api.dart';
import 'package:medico/api/rdv_model.dart';
import 'package:medico/api/utilisateur_model.dart';
import 'package:medico/rdvScreen.dart';
import 'api/utilisateur_api.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:board_datetime_picker/board_datetime_picker.dart';

Map<String?, dynamic> communes = {};
List provinces = [];
List selectedServices = [];
List selectedCommunes = [];

// Function to clear all fields when returning back from a page
void clearFields() {
	selectedServices = [];
	selectedCommunes = [];
}


// Particular functions to get colors depending on the background color
Color? getColor(Color? backgroundColor) {
  return backgroundColor == Colors.white ? Colors.black : Colors.white;
}

Color? getSubtitlesColor(Color? backgroundColor) {
  return backgroundColor == Colors.white ? Colors.grey[900] : Colors.grey[400];
}

// Functions to load the json data from the assets
Future<void> loadCommunesAsset() async {
  final String jsonString = await rootBundle.loadString('assets/communes.json');
  final Map<String?, dynamic> data = jsonDecode(jsonString);
  communes = data;
  provinces = data.keys.toList();
}

void populateCommunes(String province) {
	selectedCommunes = communes[province];
}

// Function to initialize all the required fields
void init() {
	loadCommunesAsset();
}

// Function to pretty print a DateTime
String prettyPrint(DateTime? d) {
	return "\nDate: ${d?.day}/${d?.month}/${d?.year}\nHeure: ${d?.hour}:${d?.minute}";
}

// Custom DateTime picker
Widget timePicker(BuildContext context, {required BoardDateTimeTextController controller,
			 	  required Function(DateTime) onChanged, required Color? backgroundColor}) {
  controller.setText("Jour et heure du rendez-vous");
  return SingleChildScrollView(
  child: SizedBox(
    width: MediaQuery.of(context).size.width/3,
    child: BoardDateTimeInputField(
      controller: controller,
	  minimumDate: DateTime.now(),
	  maximumDate: DateTime.now().add(const Duration(hours: 24)),
      pickerType: DateTimePickerType.datetime,
      options: BoardDateTimeOptions(
		languages: BoardPickerLanguages(
			locale: 'fr',
			today: 'Aujourd’hui',
			tomorrow: 'Demain',
			now: 'Maintenant',
		  ),
		backgroundColor: backgroundColor,
		foregroundColor: Colors.red,
		textColor: getColor(backgroundColor),
		withSecond: false,
		inputable: false,
      ),
      textStyle: TextStyle(color: getColor(backgroundColor)),
      onChanged: (date) => onChanged(date),
    ),
  ));
}

// Custom Widgets to print Rdv

class RdvDisplayer extends StatefulWidget {
  final Color? backgroundColor;
  final UtilisateurModel utilisateur;
  const RdvDisplayer({super.key,
					  required this.backgroundColor,
					  required this.utilisateur});
  @override
  State<RdvDisplayer> createState() => _RdvDisplayerState();
}

class _RdvDisplayerState extends State<RdvDisplayer> {
  bool isLoading = false;
  List<RdvModel?> rdv = [];
  
  void fetchRdv() async {
	if (utilisateur.id == null) {
		return;
	}
  	setState(() {
  	  isLoading = true;
  	});
	rdv = await RdvApi().getRdv(utilisateur.id!);
	setState(() {
	  isLoading = false;
	});
  }
  @override
  void initState() {
	fetchRdv();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  	return SingleChildScrollView(
		child: isLoading ? CircularProgressIndicator()
		: Column(
		    mainAxisAlignment: MainAxisAlignment.center,
		    crossAxisAlignment: CrossAxisAlignment.center,
			children: rdv.map(
				(value) {
				  return Card(
					elevation: 3,
					color: background,
					child: Column(
					  mainAxisSize: MainAxisSize.min,
					  children: <Widget>[
						ListTile(
						  leading: Icon(Icons.article, color: Colors.red),
						  title: Text("Nom: ${value!.nom!}",
						  				style: TextStyle(color: getColor(background))),
						  subtitle: Text("Hopital: ${value.hopital!}\nService: ${value.service!.toUpperCase()} ${prettyPrint(value.datetime)}",
							  style: TextStyle(color: getSubtitlesColor(background))),
						),
						  ],
						),
					); // Card
				}
			).toList(),
		)
	);
  }
}


// Dropdowns for province, commune and service
class Province extends StatefulWidget {
  final Function(String province) onSelect;
  final TextEditingController controller;
  final Color backgroundColor;
  const Province({super.key, required this.onSelect, required this.backgroundColor,
  				  required this.controller});

  @override
  State<Province> createState() => _ProvinceState();
}

class _ProvinceState extends State<Province> {
  @override
  Widget build(BuildContext context) {
  	return Align(
	alignment: Alignment.topLeft,
	child: DropdownMenu(
			menuStyle: MenuStyle(backgroundColor: WidgetStatePropertyAll<Color>(widget.backgroundColor),
			elevation: WidgetStatePropertyAll<double>(2.0),
			),
			inputDecorationTheme: InputDecorationTheme(
				border: InputBorder.none,
				enabledBorder: InputBorder.none,
				focusedBorder: InputBorder.none,
				hintStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14)
			),
			expandedInsets: EdgeInsetsGeometry.directional(start: 0, end: MediaQuery.of(context).size.width/20),
			textStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14),
			hintText: "Province",
			controller: widget.controller,
			leadingIcon: Icon(Icons.public, color: Colors.red),
			onSelected: (value) => widget.onSelect(value),
			dropdownMenuEntries: provinces.map((province) {
				return DropdownMenuEntry(value: province, label: province,
				style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(getColor(widget.backgroundColor))
				)
				);
			}).toList(),
		) // DropdownMenu
	); // Align
  }
}

class Commune extends StatefulWidget {
  final Color backgroundColor;
  final Function(String province) onSelect;
  final TextEditingController controller;
  const Commune({super.key, required this.onSelect, required this.backgroundColor,
  				 required this.controller});

  @override
  State<Commune> createState() => _CommuneState();
}

class _CommuneState extends State<Commune> {
  @override
  Widget build(BuildContext context) {
  	return Align(
	alignment: Alignment.topLeft,
	child: DropdownMenu(
		menuStyle: MenuStyle(backgroundColor: WidgetStatePropertyAll<Color>(widget.backgroundColor),
		elevation: WidgetStatePropertyAll<double>(2.0),
		),
		inputDecorationTheme: InputDecorationTheme(
			border: InputBorder.none,
			enabledBorder: InputBorder.none,
			focusedBorder: InputBorder.none,
			hintStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14)
		),
		expandedInsets: EdgeInsetsGeometry.directional(start: 0, end: MediaQuery.of(context).size.width/20),
		textStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14),
		enabled: selectedCommunes.isNotEmpty,
		onSelected: (value) => widget.onSelect(value),
		hintText: "Commune",
		controller: widget.controller,
		leadingIcon: Icon(Icons.cabin, color: Colors.red),
		dropdownMenuEntries: selectedCommunes.map((commune) {
			return DropdownMenuEntry(value: commune, label: commune,
				style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(getColor(widget.backgroundColor))));
		}).toList(),
	) // DropdownMenu
	); // Align
  }
}

class Hopital extends StatefulWidget {
  final Color backgroundColor;
  final Function(String? hopital) onSelect;
  final TextEditingController controller;
  const Hopital({super.key, required this.onSelect, required this.backgroundColor,
  				 required this.controller});

  @override
  State<Hopital> createState() => _HopitalState();
}

class _HopitalState extends State<Hopital> {
  @override
  Widget build(BuildContext context) {
  	return Align(
	alignment: Alignment.topLeft,
	child: DropdownMenu(
		menuStyle: MenuStyle(backgroundColor: WidgetStatePropertyAll<Color>(widget.backgroundColor),
		elevation: WidgetStatePropertyAll<double>(2.0),
		),
		inputDecorationTheme: InputDecorationTheme(
			border: InputBorder.none,
			enabledBorder: InputBorder.none,
			focusedBorder: InputBorder.none,
			hintStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14)
		),
		expandedInsets: EdgeInsetsGeometry.directional(start: 0, end: MediaQuery.of(context).size.width/20),
		textStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14),
		enabled: hopitaux.isNotEmpty,
		onSelected: (value) => widget.onSelect(value),
		hintText: "Hopital",
		controller: widget.controller,
		leadingIcon: Icon(Icons.cabin, color: Colors.red),
		dropdownMenuEntries: hopitaux.keys.map((hopital) {
			return DropdownMenuEntry(value: hopital, label: hopital,
				style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(getColor(widget.backgroundColor))));
		}).toList(),
	) // DropdownMenu
	); // Align
  }
}

class Service extends StatefulWidget {
  final Color backgroundColor;
  final Function(String province) onSelect;
  final TextEditingController controller;
  const Service({super.key, required this.onSelect, required this.backgroundColor,
  				 required this.controller});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  @override
  Widget build(BuildContext context) {
  	return Align(
	alignment: Alignment.topLeft,
	child: DropdownMenu(
		menuStyle: MenuStyle(backgroundColor: WidgetStatePropertyAll<Color>(widget.backgroundColor),
		elevation: WidgetStatePropertyAll<double>(2.0),
		),
		inputDecorationTheme: InputDecorationTheme(
			border: InputBorder.none,
			enabledBorder: InputBorder.none,
			focusedBorder: InputBorder.none,
			hintStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14)
		),
		expandedInsets: EdgeInsetsGeometry.directional(start: 0, end: MediaQuery.of(context).size.width/20),
		textStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14),
		enabled: selectedServices.isNotEmpty,
		onSelected: (value) => widget.onSelect(value),
		hintText: "Service",
		controller: widget.controller,
		leadingIcon: Icon(Icons.cabin, color: Colors.red),
		dropdownMenuEntries: selectedServices.map((commune) {
			return DropdownMenuEntry(value: commune, label: commune,
				style: ButtonStyle(foregroundColor: WidgetStatePropertyAll(getColor(widget.backgroundColor))));
		}).toList(),
	) // DropdownMenu
	); // Align
  }
}

// Custom DatePicker widget

DateTime? dateSelected;

class DatePicker extends StatefulWidget {
  final Function(DateTime?) onSelect;
  final Color? backgroundColor;
  final String hintText;
  const DatePicker({super.key, required this.backgroundColor,
  					required this.hintText, required this.onSelect});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _date;
  Future _selectDate(BuildContext context) async => showDatePicker(context: context,
      firstDate: DateTime(1930), lastDate: DateTime(DateTime.now().year+1), initialDate: DateTime.now(),
	  helpText: widget.hintText
  ).then((DateTime? selected) {
    if (selected != null && selected != _date) {
      setState(() {
        _date = selected;
      });
	  widget.onSelect(_date);
    }
  });
  @override
  Widget build(BuildContext context) {
    return Align(
	  alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(backgroundColor: widget.backgroundColor),
              child: Text(_date == null ? widget.hintText : "${_date?.day}/${_date?.month}/${_date?.year}",
                style: TextStyle(color: getColor(widget.backgroundColor)),
              )),
        ],
      ),
    );
  }
}
