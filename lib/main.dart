import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tambahkan Item',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Column(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text("Tambah Member"),
                onPressed: () async {
                  var item = await navigateToEntryForm(context, null);
                  if (item != null) {
                    //TODO 2 Panggil Fungsi untuk Insert ke DB
                    int result = await dbHelper.insert(item);
                    if (result > 0) {
                      updateListView();
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
