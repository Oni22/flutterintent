import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterintent/src/results.dart';

class FlutterIntent {

  Map<String,dynamic> _extras = {};
  BuildContext context;
  String name;
  dynamic _object;
  Result result;

  FlutterIntent({
    @required this.context,
    @required this.name
  });

  FlutterIntent.withNoContext({this.name});
  FlutterIntent.setResult({this.context,this.result});

  void putExtra(String key, dynamic value) {
    _extras[key] = value;
  }

  void putObjectExtra(dynamic object) {
    _object = object;
  }

  T getObjectExtra<T>() => _object as T;

  String getStringExtra(String key, {String defaultValue = ""}) {
    if(_extras.containsKey(key)) {
      return _extras[key] as String;
    }
    return defaultValue;
  }

  bool getBoolExtra(String key, {bool defaultValue = false}) {
    if(_extras.containsKey(key)) {
      return _extras[key] as bool;
    }
    return defaultValue;
  }

  int getIntExtra(String key, {int defaultValue = 0}) {
    if(_extras.containsKey(key)) {
      return _extras[key] as int;
    }
    return defaultValue;
  }

  double getDoubleExtra(String key, {double defaultValue = 0.0}) {
    if(_extras.containsKey(key)) {
      return _extras[key] as double;
    }
    return defaultValue;
  }

  dynamic getExtra<T>(String key) {
    if(_extras.containsKey(key)) {
      return _extras[key] as T;
    }
    return null;
  }

  /// start next widget
  void startActivity() {
    Navigator.pushNamed(context, name,arguments: this);
  }

  bool hasData () {
    return _extras.isNotEmpty || _object != null;
  }

  Future<void> startForResult(Function(Result result,FlutterIntent intent, int requestCode) onResult, int requestCode) async {
    var intentData = await Navigator.of(context).pushNamed(name,arguments: this);
    if(intentData is FlutterIntent) {
      onResult(result,intentData,requestCode);
    }
  }

  void finish() {
    if(result != null)
      Navigator.of(context).pop(this);
    else 
      Navigator.of(context).pop();
  }

  /// Force overlay the bottom navigation bar
  startAsRootNavigator(BuildContext context,page) {
    Navigator.of(context,rootNavigator: true).pushNamed(page,arguments: this);
  }

}

class FlutterIntentService {

  FlutterIntentService({
    this.onIntent
  });

  /// Converts the onGenerateSettings data to a FlutterIntent structure
  static Route<dynamic> fromRouteSettings(RouteSettings settings,Widget Function(FlutterIntent intent) builder, {bool iOSPageRoute = false}) {
    if(settings.arguments is FlutterIntent) {
      return iOSPageRoute ? CupertinoPageRoute(builder: (_) => builder(settings.arguments)) : MaterialPageRoute(builder: (_) => builder(settings.arguments));
    }
    else {
      throw Exception("Settings argument attribute is not type of FlutterIntent!");
    }
  }

  Widget Function(FlutterIntent intent) onIntent;

}