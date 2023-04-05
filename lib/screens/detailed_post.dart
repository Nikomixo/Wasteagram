import 'package:flutter/material.dart';
import 'package:wasteagram/models/waste_post_entry.dart';

class DetailedPost extends StatefulWidget {
  const DetailedPost({super.key});

  @override
  State<DetailedPost> createState() => _DetailedPost();
}

class _DetailedPost extends State<DetailedPost> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WastePostEntry entry = ModalRoute.of(context)?.settings.arguments as WastePostEntry;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Wasteagram"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(entry.dateToString(), style: Theme.of(context).textTheme.headline4),
            Image.network(
              entry.imageURL,
              loadingBuilder:(context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              }),
            Text("Items Wasted: ${entry.quantity.toString()}", style: Theme.of(context).textTheme.headline4),
            Text('Location: (${entry.latitude.toStringAsFixed(2)}, ${entry.longitude.toStringAsFixed(2)})', style: Theme.of(context).textTheme.subtitle1)
          ],
        ),
      )
    );
  }
}