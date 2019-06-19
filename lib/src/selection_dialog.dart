import 'package:country_code_picker/src/country_code.dart';
import 'package:flutter/material.dart';

/// selection widget used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final ValueChanged<CountryCode> onChanged;
  final List<CountryCode> elements;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog({
    Key key,
    this.elements,
    this.favoriteElements,
    this.showCountryOnly,
    this.emptySearchBuilder,
    this.onChanged,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
  })  : assert(searchDecoration != null, 'searchDecoration must not be null!'),
        this.searchDecoration = searchDecoration.copyWith(prefixIcon: Icon(Icons.search)),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectionDialogState();
  }
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  List<CountryCode> filteredElements;

  @override
  Widget build(BuildContext context) => Material(
    child: Container(
          child: Column(
            children: <Widget>[
              TextField(
                style: widget.searchStyle,
                decoration: widget.searchDecoration,
                onChanged: _filterElements,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                        children: [
                      widget.favoriteElements.isEmpty
                          ? const DecoratedBox(decoration: BoxDecoration())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[]
                                ..addAll(widget.favoriteElements
                                    .map(
                                      (f) => SimpleDialogOption(
                                        child: _buildOption(f),
                                        onPressed: () {
                                          _selectItem(f);
                                        },
                                      ),
                                    )
                                    .toList())
                                ..add(const Divider())),
                    ]..addAll(filteredElements.isEmpty
                            ? [_buildEmptySearchWidget(context)]
                            : filteredElements.map((e) => SimpleDialogOption(
                                  key: Key(e.toLongString()),
                                  child: _buildOption(e),
                                  onPressed: () {
                                    _selectItem(e);
                                  },
                                ))))),
              ))
            ],
          ),
        ),
  );

  Widget _buildOption(CountryCode e) {
    return Container(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                e.flagUri,
                package: 'country_code_picker',
                width: 32.0,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              widget.showCountryOnly ? e.toCountryStringOnly() : e.toLongString(),
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder(context);
    }

    return Center(child: Text('No Country Found'));
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              e.code.contains(s) ||
              e.dialCode.contains(s) ||
              e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    if (widget.onChanged == null) {
      Navigator.pop(context, e);
    } else {
      widget.onChanged(e);
    }
  }
}