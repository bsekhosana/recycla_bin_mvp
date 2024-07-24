import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:recycla_bin/core/widgets/custom_elevated_button.dart';
import 'package:recycla_bin/core/widgets/custom_snackbar.dart';
import 'package:recycla_bin/core/widgets/custom_textfield.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:provider/provider.dart';

import '../../../../core/services/location_manager.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../../core/utilities/utils.dart';

import 'package:location/location.dart' as loc;

import '../../data/models/rb_collection.dart';
import '../providers/rb_collection_provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController? _mapController;
  TextEditingController _locationAddressEditingController = new TextEditingController();
  LatLng _currentPosition = LatLng(37.7749, -122.4194); // Default to San Francisco
  loc.Location location = loc.Location();
  final places = GoogleMapsPlaces(apiKey: 'AIzaSyD3P8y3QEASTe_TfRfdS-7QtW3-enAeEfY');
  List<Prediction> _predictions = [];
  Set<Marker> _markers = {};

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
      _markers.add(
        Marker(
          markerId: MarkerId("current_position"),
          position: _currentPosition,
        ),
      );
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition,
            zoom: 12.0, // Increased zoom level
          ),
        ),
      );
    }
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isNotEmpty) {
      final response = await places.autocomplete(query);
      if (response.isOkay) {
        setState(() {
          _predictions = response.predictions;
        });
      } else {
        setState(() {
          _predictions = [];
        });
      }
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  Future<void> _selectPlace(Prediction prediction) async {
    final detail = await places.getDetailsByPlaceId(prediction.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    final newPosition = LatLng(lat, lng);

    setState(() {
      _currentPosition = newPosition;
      _predictions = [];
      _locationAddressEditingController.text = detail.result.formattedAddress ?? "";
      _markers.add(
        Marker(
          markerId: MarkerId("selected_position"),
          position: newPosition,
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newPosition,
          zoom: 15.0, // Increased zoom level
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final provider = Provider.of<RBCollectionProvider>(context);
    return UserScaffold(
      showMenu: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: height*0.7,
            ),
            Container(
                width: double.infinity,
                height: height*0.1,
                child: CustomTextField(
                  controller: _locationAddressEditingController,
                  hintText: '12 Stable Rd, Louisiana, 57B U',
                  leadingIcon: Icons.location_on_outlined,
                  obscureText: false,
                  onChanged: (value) {
                    _searchPlaces(value);
                  },
                )
            ),
        
            Positioned(
              top: height*0.1,
              left: 0,
              right: 0,
              bottom: height*0.11,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: height * 0.48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition,
                      zoom: 13.0,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                  ),
                ),
              ),
            ),
        
            if (_predictions.isNotEmpty)
              Positioned(
                top: height*0.06,
                left: 0,
                right: 0,
                // bottom: height*0.11,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) {
                      final prediction = _predictions[index];
                      return ListTile(
                        title: Text(prediction.description ?? ""),
                        onTap: () {
                          _selectPlace(prediction);
                        },
                      );
                    },
                  ),
                ),
              ),
        
            Positioned(
              top: height*0.63,
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomElevatedButton(
                  text: 'Pick up from here',
                  onPressed: () async {
                    if(_locationAddressEditingController.text.isEmpty){
                      showCustomSnackbar(context, 'Please enter pick up location to save first.', backgroundColor: Colors.orange);
                    }else{
                      if (provider.collection != null) {
                        await provider.updateCollection(
                          address: _locationAddressEditingController.text,
                          lat: _currentPosition.latitude.toString(),
                          lon: _currentPosition.longitude.toString()
                        );
                        showCustomSnackbar(context, 'Collection updated', backgroundColor: Colors.green);
                      } else {
                        RBCollection collection = RBCollection(
                            address: _locationAddressEditingController.text,
                            lat: _currentPosition.latitude.toString(),
                            lon: _currentPosition.longitude.toString()
                        );
                        await provider.saveCollection(collection);
                        showCustomSnackbar(context, 'New collection created', backgroundColor: Colors.green);
                      }
                      Navigator.pop(context);
                    }
                  },
                  primaryButton: true
              ),
            ),
          ],
        ),
      ),
      title: 'Add Location',
    );
  }
}