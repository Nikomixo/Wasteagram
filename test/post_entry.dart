
import 'package:test/test.dart';

import 'package:wasteagram/models/waste_post_entry.dart';
import 'package:intl/intl.dart';

import 'package:wasteagram/models/waste_post_entry_fields.dart';


void main() {
  test('WastePostEntry\'s Datetime object should be returned as string when dateToString() is called', () {
    // Build our app and trigger a frame.
    final date = DateTime.now();
    const quantity = 1;
    const latitude = 1.0;
    const longitude = 1.0;
    const url = 'FAKE';

    final DateFormat formatter = DateFormat('EEEE, MMMM dd, yyyy');

    final post = WastePostEntry(imageURL: url, latitude: latitude, longitude: longitude, quantity: quantity, date: date);

    expect(post.dateToString(), formatter.format(date));
  });

  test('WastePostEntryFields toMap() should return an appropriate map', () {
    final date = DateTime.now();
    const quantity = 1;
    const latitude = 1.0;
    const longitude = 1.0;
    const url = 'FAKE';

    final postMap = {
      'date': date, 
      'quantity': quantity,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': url
    };

    final WastePostEntryFields posts = WastePostEntryFields();
    posts.date = date;
    posts.quantity = quantity;
    posts.latitude = latitude;
    posts.longitude = longitude;
    posts.imageURL = url;

    expect(posts.toMap(), postMap);
  });
}
