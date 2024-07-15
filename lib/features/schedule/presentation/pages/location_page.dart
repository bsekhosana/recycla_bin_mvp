import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:provider/provider.dart';

import '../../../../core/services/location_manager.dart';


class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  // GoogleMapController? mapController;
  // LatLng? _currentPosition;
  // final String googleApiKey = 'AIzaSyD3P8y3QEASTe_TfRfdS-7QtW3-enAeEfY';
  // final LocationManager locationManager = LocationManager();
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  // }

  // Future<void> _getCurrentLocation() async {
  //   LatLng? currentLocation = await locationManager.getCurrentLocation();
  //   if (currentLocation != null) {
  //     setState(() {
  //       _currentPosition = currentLocation;
  //       Provider.of<LocationProvider>(context, listen: false).updateLocation(_currentPosition!);
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
      body: Text('test'),
      title: 'Add Location',
      // body: ChangeNotifierProvider(
      //   create: (_) => LocationProvider(googleApiKey),
      //   child: Scaffold(
      //     appBar: AppBar(
      //       title: const Text('Add Location'),
      //     ),
      //     body: Consumer<LocationProvider>(
      //       builder: (context, locationProvider, child) {
      //         return _currentPosition == null
      //             ? const Center(child: CircularProgressIndicator())
      //             : Column(
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: TextField(
      //                 controller: locationProvider.searchController,
      //                 readOnly: true,
      //                 onTap: () async {
      //                   Prediction? p = await PlacesAutocomplete.show(
      //                     context: context,
      //                     apiKey: googleApiKey,
      //                     mode: Mode.overlay, // Mode.fullscreen
      //                     language: "en",
      //                   );
      //                   if (p != null) {
      //                     PlacesDetailsResponse detail = await locationProvider.places.getDetailsByPlaceId(p.placeId!);
      //                     final lat = detail.result.geometry!.location.lat;
      //                     final lng = detail.result.geometry!.location.lng;
      //                     locationProvider.updateLocation(LatLng(lat, lng));
      //                     mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
      //                   }
      //                 },
      //                 decoration: InputDecoration(
      //                   hintText: 'Search location',
      //                   border: OutlineInputBorder(
      //                     borderRadius: BorderRadius.circular(5.0),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Expanded(
      //               child: Container(
      //                 margin: const EdgeInsets.all(8.0),
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(5.0),
      //                   border: Border.all(
      //                     color: Colors.grey,
      //                   ),
      //                 ),
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(5.0),
      //                   child: GoogleMap(
      //                     myLocationEnabled: true,
      //                     myLocationButtonEnabled: true,
      //                     onMapCreated: (controller) {
      //                       mapController = controller;
      //                       mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
      //                     },
      //                     initialCameraPosition: CameraPosition(
      //                       target: _currentPosition!,
      //                       zoom: 15,
      //                     ),
      //                     onTap: (LatLng latLng) async {
      //                       GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: googleApiKey);
      //                       final place = await places.searchByText("${latLng.latitude}, ${latLng.longitude}");
      //                       if (place.results.isNotEmpty) {
      //                         locationProvider.updateLocation(latLng);
      //                         locationProvider.searchController.text = place.results.first.formattedAddress ?? '';
      //                       }
      //                     },
      //                     markers: {
      //                       if (locationProvider.selectedLocation != null)
      //                         Marker(
      //                           markerId: const MarkerId('selected-location'),
      //                           position: locationProvider.selectedLocation!,
      //                         )
      //                     },
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         );
      //       },
      //     ),
      //   ),
      // ), title: 'Add Location',
    );
  }
}

// class LocationProvider with ChangeNotifier {
//   final GoogleMapsPlaces places;
//   TextEditingController searchController = TextEditingController();
//   LatLng? _selectedLocation;
//
//   LocationProvider(String apiKey) : places = GoogleMapsPlaces(apiKey: apiKey);
//
//   LatLng? get selectedLocation => _selectedLocation;
//
//   void updateLocation(LatLng location) {
//     _selectedLocation = location;
//     notifyListeners();
//   }
// }
