import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // initDi();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  var localData = "";
  var saveText = "";
  var errorText = "";

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                controller: _controller,
                
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      errorText = "enter something";
                    } else {
                      errorText = "";
                    }
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    labelText: 'Enter here',
                    errorText: errorText,
                    ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.pink, width: 1),
                  textStyle: const TextStyle(
                      fontSize: 25, fontStyle: FontStyle.normal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              onPressed: checkTextEnter() == null
                  ? null
                  : () {
                      setState(() {
                        saveText = _controller.text;
                        saveLocaldata(saveText);
                      });
                    },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: getWidget(),
            )
          ],
        ),
      ),
    );
  }

  bool? checkTextEnter() {
    return _controller.text.isEmpty ? null : true;
  }

  Widget getWidget() {
    if (saveText.isEmpty && localData.isEmpty) {
      return const Text('Enter something in the box and Save');
    } else if (saveText.isEmpty && localData.isNotEmpty) {
      return Text('Local Save Date: $localData');
    } else if (saveText.isNotEmpty) {
      return Text('Update Value: $saveText');
    } else {
      return Text('Default ${_controller.text}');
    }
  }

  Future<void> saveLocaldata(String str) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', str);
  }

  void getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    localData = prefs.getString('key') ?? '';
    setState(() {});
  }
}
