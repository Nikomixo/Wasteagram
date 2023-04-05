import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:wasteagram/models/waste_post_entry_fields.dart';

class PostEntryForm extends StatefulWidget {
  const PostEntryForm({super.key});

  @override
  State<PostEntryForm> createState() => _PostEntryForm();
}

class _PostEntryForm extends State<PostEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final wastePostEntryFields = WastePostEntryFields();

  File? image;
  final picker = ImagePicker();

  void getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      Navigator.of(context).pop();
    } else {
      image = File(pickedFile.path);
    }
    
    setState(() {});
  }

  void postToCloud() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imgref = storage.ref().child("Waste${DateTime.now()}");
    UploadTask upload = imgref.putFile(image!);

    wastePostEntryFields.date = DateTime.now();

    var locationService = Location();
    LocationData locationData = await locationService.getLocation();

    wastePostEntryFields.latitude = locationData.latitude;
    wastePostEntryFields.longitude = locationData.longitude;

    upload.then((res) async {
      wastePostEntryFields.imageURL = await res.ref.getDownloadURL();
      FirebaseFirestore.instance.collection('posts').add(wastePostEntryFields.toMap());   
    });

    await FirebaseAnalytics.instance.logEvent(
      name: "waste",
      parameters: <String, dynamic>{
          "quantity": wastePostEntryFields.quantity,
      },
    );

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("New Post"),
      ),
      body: image != null ? Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Image.file(image!),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Semantics(
                    label: "Waste quantity input field",
                    textField: true,
                    hint: "Enter amount of waste",
                    child: TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "Number of Wasted Items", 
                        hintStyle: TextStyle(fontSize: 24),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
                      ),
                      cursorColor: Colors.tealAccent,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null) {
                          return "Please enter a number";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => wastePostEntryFields.quantity = int.tryParse(value!),
                    ),
                  ),
                ),
              ),
            ]
          ),
          Semantics(
            button: true,
            enabled: true,
            label: 'Press to upload post',
            onTapHint: "Upload food waste post",
            child: ElevatedButton(
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  postToCloud();
                }
              }, 
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.tealAccent,
              ),
              child: const Icon(Icons.cloud_upload, size: 72),
            ),
          ),
        ],
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}