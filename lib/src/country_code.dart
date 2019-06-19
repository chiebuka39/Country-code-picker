import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';

mixin ToAlias {}

@deprecated
class CElement = CountryCode with ToAlias;

/// Country element. This is the element that contains all the information
class CountryCode {
  /// the name of the country
  String name;

  /// the flag of the country
  String flagUri;

  /// the country code (IT,AF..)
  String code;

  /// the dial code (+39,+93..)
  String dialCode;

  /// The currency text
  String currency;

  /// The currency symbol
  String currencySymbol;

  CountryCode(
      {@required this.name,
      @required this.flagUri,
      @required this.code,
      @required this.dialCode,
      @required this.currency,
      @required this.currencySymbol});

  @override
  String toString() {
    return 'CountryCode{name: $name, flagUri: $flagUri, code: $code, dialCode: $dialCode, currency: $currency, currencySymbol: $currencySymbol}';
  }

  String toLongString() => "$dialCode $name";

  String toCountryStringOnly() => '$name';
}


CountryCode getCountryCode(String countryCode) {
  countryCode = countryCode.toUpperCase();
  var code = countryCodes.firstWhere((map) => map['code'] == countryCode);
  var currency = countryCurrencies[countryCode];
  return CountryCode(
      name: code['name'],
      flagUri: 'flags/${code['code'].toLowerCase()}.png',
      code: code['code'],
      dialCode: code['dial_code'],
      currency: currency['currency'],
      currencySymbol: currency['symbol']);
}
