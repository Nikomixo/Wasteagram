import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/models/waste_post_entry.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Wasteagram"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var post = snapshot.data!.docs[index];
                  WastePostEntry entry = WastePostEntry(
                    date: post['date'].toDate(), 
                    quantity: post['quantity'], 
                    latitude: post['latitude'], 
                    longitude: post['longitude'], 
                    imageURL: post['imageUrl']
                  );

                  return Semantics(
                    label: 'Food waste post on ${entry.dateToString()}',
                    button: true,
                    onTapHint: 'Click here for a detailed view of waste that day',
                    child: ListTile(
                      leading: Text(entry.dateToString(), style: Theme.of(context).textTheme.subtitle1),
                      trailing: Text(entry.quantity.toString(), style: Theme.of(context).textTheme.headline6),
                      onTap: () {Navigator.of(context).pushNamed('detailed', arguments: entry);},
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FittedBox(
          child: Semantics(
            button: true,
            enabled: true,
            label: 'New Post Button',
            onTapHint: 'Select an image of food waste',
            child: FloatingActionButton(
              onPressed: () => {
                pushEntryForm(context)
              },
              tooltip: 'New Post',
              backgroundColor: Colors.tealAccent,
              child: const Icon(Icons.photo_camera),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void pushEntryForm(BuildContext context) {
    Navigator.of(context).pushNamed('entry');
  }
}