import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'sqlite/dbhelper.dart';
import 'entryprofile.dart';
import 'sqlite/item.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<ItemProfile> itemList;
  @override
  Widget build(BuildContext context) {
    updateListView();
    if (itemList == null) {
      itemList = List<ItemProfile>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Member'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.all(10),
          width: double.infinity,
          child: FloatingActionButton(
            child: Icon(Icons.add),
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
        // Container(
        //   alignment: Alignment.bottomCenter,
        //   child: SizedBox(
        //     width: double.infinity,
        //     child: RaisedButton(
        //       child: Text("Lihat Card Member"),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => ListCard()),
        //         );
        //       },
        //     ),
        //   ),
        // )
      ]),
    );
  }

  Future<ItemProfile> navigateToEntryForm(
      BuildContext context, ItemProfile item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.brown,
              child: Icon(Icons.account_circle),
            ),
            title: Text(
              "Id : " +
                  this.itemList[index].id.toString() +
                  "\n" +
                  this.itemList[index].name,
              style: textStyle,
            ),
            subtitle: Text("Alamat : " +
                this.itemList[index].address +
                "\n" +
                "Code :  " +
                this.itemList[index].code +
                " \n" +
                "No.TLP : " +
                this.itemList[index].phone.toString()),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                dbHelper.delete(this.itemList[index].id);
                updateListView();
              },
            ),
            onTap: () async {
              var item =
                  await navigateToEntryForm(context, this.itemList[index]);
              //TODO 4 Panggil Fungsi untuk Edit data
              dbHelper.update(item);
              updateListView();
            },
          ),
        );
      },
    );
  }

//update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
//TODO 1 Select data dari DB
      Future<List<ItemProfile>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
