import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

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
              FlatButton(onPressed: _showCountryPicker, child: _getButtonText())
            ],
          ),
        ));
  }

  Widget _getButtonText() {
    if (_selectedCountry == null) {
      return Text('Pick Country');
    } else {
      return Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                _selectedCountry.flagUri,
                package: 'country_code_picker',
                width: 32.0,
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              '${_selectedCountry.name} ${_selectedCountry.currency} ${_selectedCountry.dialCode}',
            ),
          ),
        ],
      );
    }
  }

  void _showCountryPicker() async {
    var country =
        await showDialog(context: context, builder: (_) => CountryCodePickerWidget());
    setState(() {
      this._selectedCountry = country;
    });
  }
}
