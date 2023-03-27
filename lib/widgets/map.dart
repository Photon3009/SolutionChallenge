import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  double? lat;
  double? long;
  String? address;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  getLatLong() {
    _determinePosition().then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
        getAddress(lat!, long!);
      });
    }).catchError((err) {
      print(err);
    });
  }

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    Placemark place = placemarks[0];

    setState(() {
      address = "${place.locality}, ${place.country}";
    });
  }

  @override
  void initState() {
    super.initState();
    getLatLong();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center:
            (lat == null) ? LatLng(26.9079247, 80.9471215) : LatLng(lat, long),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/adityakulshrestha/cldyx7irq001p01texxcz52rh/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWRpdHlha3Vsc2hyZXN0aGEiLCJhIjoiY2xkeXZ5amcwMGgzcTN1bndjb3M2YTRvNSJ9.6HXyPMZHSuYMuscm9TczHw",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoiYWRpdHlha3Vsc2hyZXN0aGEiLCJhIjoiY2xkeXZ5amcwMGgzcTN1bndjb3M2YTRvNSJ9.6HXyPMZHSuYMuscm9TczHw',
            'id': 'mapbox.mapbox-streets-v8'
          },
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: (lat == null)
                  ? LatLng(26.9079247, 80.9471215)
                  : LatLng(lat, long),
              builder: (ctx) => const Icon(Icons.location_on, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}
