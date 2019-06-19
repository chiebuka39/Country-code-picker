import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class MyCountryCodePickerWidget extends StatefulWidget {
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final bool showOnlyCountryWhenClosed;
  final bool alignLeft;

  MyCountryCodePickerWidget({
    this.initialSelection,
    this.favorite = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
  });

  @override
  _MyCountryCodePickerWidgetState createState() => _MyCountryCodePickerWidgetState();
}

class _MyCountryCodePickerWidgetState extends State<MyCountryCodePickerWidget> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var topCircleSize = MediaQuery.of(context).size.width / 0.99;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -topCircleSize / 1.50,
            right: -topCircleSize / 1.50,
            child: Container(
              width: topCircleSize,
              height: topCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top + 10),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          iconTheme: Theme.of(context)
                              .iconTheme
                              .copyWith(color: Colors.red)),
                      child: CloseButton()),
                ),
                Expanded(
                    child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Expanded(
                        child: CountryCodePickerWidget(
                            onChanged: (value) => Navigator.of(context).pop(value),
                            initialSelection: widget.initialSelection,
                            favorite: ['NG', 'US'],
                            textStyle: widget.textStyle,
                            padding: widget.padding,
                            showCountryOnly: widget.showCountryOnly,
                            searchDecoration: widget.searchDecoration,
                            searchStyle: widget.searchStyle,
                            emptySearchBuilder: widget.emptySearchBuilder,
                            showOnlyCountryWhenClosed: widget.showOnlyCountryWhenClosed,
                            alignLeft: widget.alignLeft),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
