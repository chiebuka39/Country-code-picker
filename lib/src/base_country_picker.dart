import 'package:country_code_picker/src/country_code.dart';
import 'package:country_code_picker/src/country_codes.dart';
import 'package:country_code_picker/src/selection_dialog.dart';
import 'package:flutter/material.dart';

abstract class BaseCountryCodePicker extends StatefulWidget {
  final ValueChanged<CountryCode> onChanged;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;

  /// shows the name of the country instead of the dialcode
  final bool showOnlyCountryWhenClosed;

  /// aligns the flag and the Text left
  ///
  /// additionally this option also fills the available space of the widget.
  /// this is especially usefull in combination with [showOnlyCountryWhenClosed],
  /// because longer countrynames are displayed in one line
  final bool alignLeft;

  BaseCountryCodePicker({
    this.onChanged,
    this.initialSelection,
    this.favorite,
    this.textStyle,
    this.padding,
    this.showCountryOnly,
    this.searchDecoration,
    this.searchStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed,
    this.alignLeft,
  });

  List<CountryCode> getCountryCodes() {
    List<Map> jsonList = codes;

    return jsonList.map((s) {
      var code = s['code'];
      var currency = currencies[code];
      return new CountryCode(
        name: s['name'],
        code: code,
        dialCode: s['dial_code'],
        flagUri: 'flags/${code.toLowerCase()}.png',
        currency: currency['currency'],
        currencySymbol: currency['symbol'],
      );
    }).toList();
  }
}

abstract class BaseCountryCodePickerState extends State<BaseCountryCodePicker> {
  CountryCode selectedItem;
  List<CountryCode> elements = [];
  List<CountryCode> favoriteElements = [];

  BaseCountryCodePickerState(this.elements);

  @override
  initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection.toString()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((e) =>
            widget.favorite.firstWhere(
                (f) => e.code == f.toUpperCase() || e.dialCode == f.toString(),
                orElse: () => null) !=
            null)
        .toList();
    super.initState();

    if (mounted) {
      publishSelection(selectedItem);
    }
  }

  void publishSelection(CountryCode e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }
}

class CountryCodePicker extends BaseCountryCodePicker {
  CountryCodePicker({
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
    return new _CountryCodePickerState(getCountryCodes());
  }
}

class _CountryCodePickerState extends BaseCountryCodePickerState {
  _CountryCodePickerState(List<CountryCode> elements) : super(elements);

  @override
  Widget build(BuildContext context) => new FlatButton(
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              flex: widget.alignLeft ? 0 : 1,
              fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
              child: Padding(
                padding: widget.alignLeft
                    ? const EdgeInsets.only(right: 16.0, left: 8.0)
                    : const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  selectedItem.flagUri,
                  package: 'country_code_picker',
                  width: 32.0,
                ),
              ),
            ),
            Flexible(
              fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
              child: Text(
                widget.showOnlyCountryWhenClosed
                    ? selectedItem.toCountryStringOnly()
                    : selectedItem.toString(),
                style: widget.textStyle ?? Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
        padding: widget.padding,
        onPressed: _showSelectionDialog,
      );

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (_) => SelectionDialog(
        elements: elements,
        favoriteElements: favoriteElements,
        showCountryOnly: widget.showCountryOnly,
        emptySearchBuilder: widget.emptySearchBuilder,
        searchDecoration: widget.searchDecoration,
        searchStyle: widget.searchStyle,
      ),
    ).then((e) {
      if (e != null) {
        setState(() {
          selectedItem = e;
        });

        publishSelection(e);
      }
    });
  }
}
