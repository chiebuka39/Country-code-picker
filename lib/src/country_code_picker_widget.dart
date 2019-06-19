import 'package:country_code_picker/src/base_country_picker.dart';
import 'package:country_code_picker/src/country_code.dart';
import 'package:country_code_picker/src/selection_dialog.dart';
import 'package:flutter/material.dart';

class CountryCodePickerWidget extends BaseCountryCodePicker {
  CountryCodePickerWidget({
    ValueChanged<CountryCode> onChanged,
    String initialSelection,
    List<String> favorite = const [],
    TextStyle textStyle,
    EdgeInsets padding = const EdgeInsets.all(0.0),
    bool showCountryOnly = false,
    InputDecoration searchDecoration = const InputDecoration(),
    TextStyle searchStyle,
    WidgetBuilder emptySearchBuilder,
    bool showOnlyCountryWhenClosed = false,
    bool alignLeft = false,
  }) : super(
          onChanged: onChanged,
          initialSelection: initialSelection,
          favorite: favorite,
          textStyle: textStyle,
          padding: padding,
          showCountryOnly: showCountryOnly,
          searchDecoration: searchDecoration,
          searchStyle: searchStyle,
          emptySearchBuilder: emptySearchBuilder,
          showOnlyCountryWhenClosed: showOnlyCountryWhenClosed,
          alignLeft: alignLeft,
        );

  @override
  State<StatefulWidget> createState() {
    return new _CountryCodePickerWidgetState(getCountryCodes());
  }
}

class _CountryCodePickerWidgetState extends BaseCountryCodePickerState {
  _CountryCodePickerWidgetState(List<CountryCode> elements) : super(elements);

  @override
  Widget build(BuildContext context) => SelectionDialog(
        elements: elements,
        favoriteElements: favoriteElements,
        showCountryOnly: widget.showCountryOnly,
        emptySearchBuilder: widget.emptySearchBuilder,
        searchDecoration: widget.searchDecoration,
        searchStyle: widget.searchStyle,
      );
}
