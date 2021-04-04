import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts_membercafe/entrycard.dart';
import 'dart:async';
import 'sqlite/dbhelper.dart';
import 'sqlite/itemcard.dart';

class ListCard extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<ListCard> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<ItemCard> itemCard;
  @override
  Widget build(BuildContext context) {
    updateListView();
    if (itemCard == null) {
      itemCard = List<ItemCard>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Member'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
      ]),
    );
  }

  Future<ItemCard> navigateToEntryCard(
      BuildContext context, ItemCard itemcard) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryFormCard(itemcard);
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
              this.itemCard[index].name,
              style: textStyle,
            ),
            subtitle: Text(this.itemCard[index].code),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                dbHelper.deletecard(this.itemCard[index].id);
                updateListView();
              },
            ),
            onTap: () async {
              var itemcard =
                  await navigateToEntryCard(context, this.itemCard[index]);
              //TODO 4 Panggil Fungsi untuk Edit data
              dbHelper.updatecard(itemcard);
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
      Future<List<ItemCard>> itemListFuture = dbHelper.getItemListcard();
      itemListFuture.then((itemCard) {
        setState(() {
          this.itemCard = itemCard;
          this.count = itemCard.length;
        });
      });
    });
  }
}
