# flutterintent

flutterintent helps you to make your navigation easier and readable. It implements the intent pattern of the Android Framework.

## Getting Started with the plugin

### 1. Add to your pubspec.yaml
```
dependencies:
	flutter:
		sdk: flutter
	flutterintent:
  ```

### 2. Import it
```
import  'package:flutterintent/flutterintent.dart';
  ```
### 3. Use it

***Send an intent:***
```dart
FlutterIntent(context:context,name: "/page2")
..startActivity();
```
***Send an intent and attach data:***
```dart
FlutterIntent(context:context,name: "/page2")
..putExtra("myString","Hello World")
..putObjectExtra("myObject",Car(color: "red")
..startActivity();
```
***Get an intent and the attached data:***

This plugin required the usage of the onGenerateRoute attribute of the MaterialApp or CupertinoApp Widget. For getting the intent we send we have to setup the following:
```dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings)  {
        //Convert settings to flutter intent type
        return FlutterIntentService.fromRouteSettings(settings, (intent) {
            //Do always a null check, because on start the intent is always null
            if(intent == null || intent.name == "/")
              return HomePage();
            if(intent.name == "/page2") {
              //fetch the string which is send with the key "myString"
              var text = intent.getStringExtra("myString"); //Hello World
              return PageTwo(text: text)
            }
        });
      },
    );
  }
```

***Start a widget for getting a result***
If you want to get a result back from a widget when it's closed you can use startForResult():
```dart
//Page 1
FlutterIntent(context: context,name: "/page2")
..startForResult((result,intent,requestCode) {
    if(result == Result.ok && requestCode == 200) {
        print(intent.getStringExtra("hello_world"))
    }
})
..
```
Set Result and send data back to previous widget:

```dart
//Page 2
FlutterIntent.setResult(context: context,result: Result.ok)
..putExtra("hello_world","Hello World")
..finish()
..
```
