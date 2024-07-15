import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationManager {
  Future<LatLng?> getCurrentLocation() async {
    // try {
    //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    //   if (!serviceEnabled) {
    //     return Future.error('Location services are disabled.');
    //   }
    //
    //   LocationPermission permission = await Geolocator.checkPermission();
    //   if (permission == LocationPermission.denied) {
    //     permission = await Geolocator.requestPermission();
    //     if (permission == LocationPermission.denied) {
    //       return Future.error('Location permissions are denied');
    //     }
    //   }
    //
    //   if (permission == LocationPermission.deniedForever) {
    //     return Future.error(
    //         'Location permissions are permanently denied, we cannot request permissions.');
    //   }
    //
    //   Position position = await Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.high);
    //   return LatLng(position.latitude, position.longitude);
    // } catch (e) {
    //   print("Error getting location: $e");
    //   return null;
    // }
  }
}
