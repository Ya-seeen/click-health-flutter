import 'package:drug_delivery/utils/color_util.dart';
import 'package:drug_delivery/widgets/app_bar_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/address.dart' as UserAddress;

class LocationPickPage extends StatefulWidget {
  @override
  _LocationPickPageState createState() => _LocationPickPageState();
}

class _LocationPickPageState extends State<LocationPickPage> {
  UserAddress.Address selectedAddress = UserAddress.Address(name: "");
  GoogleMapController googleMapController;
  LatLng initialLocation = LatLng(0, 0);
  Set<Marker> markers = Set.from([]);
  String lightMode, darkMode;

  @override
  void initState() {
    super.initState();

    initLocation();
  }

  void initLocation() async {
    darkMode = await rootBundle.loadString('assets/styles/dark_mode.json');
    lightMode = await rootBundle.loadString('assets/styles/light_mode.json');

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    if (googleMapController != null) {
      googleMapController.setMapStyle(
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? darkMode
              : lightMode);
      googleMapController.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));
    }
    Marker marker = Marker(
      markerId: MarkerId("1"),
      position: LatLng(position.latitude, position.longitude),
    );

    setState(() {
      markers.add(marker);
    });

    showAddressFromLocation(position.latitude, position.longitude);
  }

  void showAddressFromLocation(double latitude, double longitude) async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    /*List<Placemark> newPlace =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    newPlace = await Geolocator().placemarkFromAddress("Dhaka");

    final location = Location(latitude, longitude);
    final result = await _places.searchNearbyWithRadius(location, 50);*/

    setState(() {
      selectedAddress.name = addresses.first.addressLine;
      selectedAddress.longitude = longitude;
      selectedAddress.latitude = latitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 100),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: initialLocation,
                        tilt: 59.440717697143555,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        googleMapController = controller;
                        initLocation();
                      },
                      myLocationEnabled: true,
                      markers: markers,
                      onTap: (position) {
                        showAddressFromLocation(
                            position.latitude, position.longitude);
                        Marker marker = Marker(
                          markerId: MarkerId("1"),
                          position: position,
                        );

                        print(position);
                        setState(() {
                          markers.add(marker);
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Theme.of(context).bottomAppBarColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 2.0),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).bottomAppBarColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 25,
                                child: Icon(
                                  Icons.location_city,
                                  size: 30,
                                  color: ColorUtil.of(context)
                                      .circleAvatarIconColor,
                                ),
                                backgroundColor:
                                    ColorUtil.of(context).circleAvatarBackColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    selectedAddress.name,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () =>
                                    Navigator.of(context).pop(selectedAddress),
                                child: CircleAvatar(
                                  radius: 25,
                                  child: SvgPicture.asset(
                                    "assets/images/ic_done_all.svg",
                                    color: Theme.of(context).accentColor,
                                    width: 25,
                                    height: 25,
                                  ),
                                  backgroundColor: ColorUtil.of(context)
                                      .circleAvatarBackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppBarBack(
              title: "Select Location",
            ),
          ],
        ),
      ),
    );
  }
}
