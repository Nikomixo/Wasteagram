class WastePostEntryFields {
  String? imageURL;
  double? latitude;
  double? longitude;
  int? quantity;
  DateTime? date; 

  WastePostEntryFields();

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageURL,
      'latitude': latitude,
      'longitude': longitude,
      'quantity': quantity,
      'date': date
    };
  }
}