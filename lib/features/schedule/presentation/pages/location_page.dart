import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:provider/provider.dart';

import '../../../../core/services/location_manager.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../core/utilities/utils.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(37.7749, -122.4194); // Default to San Francisco
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UserScaffold(
      showMenu: false,
      body: Column(
        children: [
          SizedBox(
            height: height*0.013,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: height * 0.57,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 10.0,
                ),
                myLocationEnabled: true,
              ),
            ),
          ),

          SizedBox(
            height: height*0.04,
          ),

          CustomElevatedButton(
              text: 'Pick up from here',
              onPressed: (){

              },
              primaryButton: true
          ),
        ],
      ),
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
