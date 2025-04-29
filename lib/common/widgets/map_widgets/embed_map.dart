import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBox extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapBox({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(widget.latitude, widget.longitude);

    return SizedBox(
      height: 200,
      child: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(
          target: location,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("location"),
            position: location,
          ),
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        scrollGesturesEnabled: false,
        rotateGesturesEnabled: false,
        tiltGesturesEnabled: false,
        liteModeEnabled: true, 
      ),
    );
  }
}
