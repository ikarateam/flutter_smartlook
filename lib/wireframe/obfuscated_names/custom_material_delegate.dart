import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//CustomWidgetsLocalizationsDelegate cant be used in LocalizationsDelegate<> because of internal implementation of localizations.dart  the casts dont work then

class CustomWidgetsLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    return SynchronousFuture(CustomMaterialLocalization());
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<WidgetsLocalizations> old) {
    return false;
  }
}

class CustomMaterialLocalization extends WidgetsLocalizations {
  @override
  // TODO: implement reorderItemDown
  String get reorderItemDown => throw UnimplementedError();

  @override
  // TODO: implement reorderItemLeft
  String get reorderItemLeft => throw UnimplementedError();

  @override
  // TODO: implement reorderItemRight
  String get reorderItemRight => throw UnimplementedError();

  @override
  // TODO: implement reorderItemToEnd
  String get reorderItemToEnd => throw UnimplementedError();

  @override
  // TODO: implement reorderItemToStart
  String get reorderItemToStart => throw UnimplementedError();

  @override
  // TODO: implement reorderItemUp
  String get reorderItemUp => throw UnimplementedError();

  @override
  // TODO: implement textDirection
  TextDirection get textDirection => TextDirection.ltr;

  @override
  String get copyButtonLabel => throw UnimplementedError();

  @override
  String get cutButtonLabel => throw UnimplementedError();

  @override
  String get pasteButtonLabel => throw UnimplementedError();

  /// Label for "select all" edit buttons and menu items.
  @override
  String get selectAllButtonLabel => throw UnimplementedError();

  /// Label for "look up" edit buttons and menu items.
  @override
  String get lookUpButtonLabel => throw UnimplementedError();

  /// Label for "search web" edit buttons and menu items.
  @override
  String get searchWebButtonLabel => throw UnimplementedError();

  /// Label for "share" edit buttons and menu items.
  @override
  String get shareButtonLabel => throw UnimplementedError();

  /// Label for "share" edit buttons and menu items.
  @override
  String get radioButtonUnselectedLabel => throw UnimplementedError();
}