import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hello_example/my_country_code_picker_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  CountryCode _selectedCountry;

  @override
  void initState() {
    _selectedCountry = getCountryCode('NG');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('CountryPicker Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CountryCodePicker(
                  onChanged: print,
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'IT',
                  favorite: ['+39', 'FR']),
              SizedBox(
                width: 400,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CountryCodePicker(
                    onChanged: print,
                    initialSelection: 'TF',
                    showCountryOnly: true,
                    showOnlyCountryWhenClosed: true,
                    alignLeft: true,
                  ),
                ),
              ),
              SizedBox(
                width: 400,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CountryCodePicker(
                      onChanged: print,
                      initialSelection: 'TF',
                      showCountryOnly: true,
                      showOnlyCountryWhenClosed: true,
                      favorite: ['+39', 'FR']),
                ),
              ),
              _CurrencyWidget(
                onSelected: (value) {
                  setState(() => _selectedCountry = value);
                },
                countryCode: _selectedCountry,
              ),
            ],
          ),
        ));
  }
}

class _CurrencyWidget extends StatelessWidget {
  final ValueChanged<CountryCode> onSelected;
  final CountryCode countryCode;
  final String initialSelection;
  final List<String> favorite;
  final bool showCountryOnly;

  _CurrencyWidget(
      {@required this.onSelected,
      @required this.countryCode,
      this.showCountryOnly,
      this.favorite,
      this.initialSelection});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () async {
          var countryCode = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => MyCountryCodePickerWidget()));
          if (countryCode != null) {
            onSelected(countryCode);
          }
        },
        child: Row(
          children: <Widget>[
            Image.asset(
              countryCode.flagUri,
              package: 'country_code_picker',
              width: 30,
            ),
            Text(countryCode.currency),
            Icon(Icons.keyboard_arrow_down)
          ],
        ));
  }
}
