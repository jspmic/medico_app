import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Map<String?, dynamic> communes = {};
List services = [];
List provinces = [];
List selectedCommunes = [];

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

Future<void> loadServicesAsset() async {
  final String jsonString = await rootBundle.loadString('assets/services.json');
  final List data = jsonDecode(jsonString);
  services = data;
}

void populateCommunes(String province) {
	selectedCommunes = communes[province];
}

// Function to initialize all the required fields
void init() {
	loadCommunesAsset();
	loadServicesAsset();
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

class Services extends StatefulWidget {
  final Color backgroundColor;
  final Function(String province) onSelect;
  final TextEditingController controller;
  const Services({super.key, required this.onSelect, required this.backgroundColor,
  				 required this.controller});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
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
		textStyle: TextStyle(color: getColor(widget.backgroundColor), fontSize: 14),
		enabled: services.isNotEmpty,
		onSelected: (value) => widget.onSelect(value),
		hintText: "Service",
		controller: widget.controller,
		leadingIcon: Icon(Icons.medical_services, color: Colors.red),
		dropdownMenuEntries: services.map((service) {
			return DropdownMenuEntry(value: service, label: service,
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
