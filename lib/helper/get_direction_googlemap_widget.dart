import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(double latitude, double longitude) async {
  // Create the Google Maps URL
  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  // Parse the URL into a Uri object
  Uri googleMapsUri = Uri.parse(googleUrl);

  try {
    // Check if the URL can be launched
    if (await canLaunchUrl(googleMapsUri)) {
      // Launch the URL
      await launchUrl(googleMapsUri);
    } else {
      throw 'Could not open the map.';
    }
  } catch (e) {
    // Handle any errors that occur
    throw 'An error occurred: $e';
  }
}