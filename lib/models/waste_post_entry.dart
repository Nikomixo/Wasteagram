import 'package:intl/intl.dart';

class WastePostEntry {
  String imageURL;
  double latitude;
  double longitude;
  int quantity;
  DateTime date;

  WastePostEntry({required this.imageURL, required this.latitude, required this.longitude, required this.quantity, required this.date});

  String dateToString() {
    final DateFormat formatter = DateFormat('EEEE, MMMM dd, yyyy');
    return formatter.format(date);
  }
}