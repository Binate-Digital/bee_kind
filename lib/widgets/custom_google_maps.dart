import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final Set<Marker> markers;
  final Set<Circle> circles;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final bool mapToolbarEnabled;
  final bool compassEnabled;
  final bool buildingsEnabled;
  final Function(GoogleMapController)? onMapCreated;
  final Function(LatLng)? onTap;
  final Widget widget;

  const CustomGoogleMap({
    super.key,
    required this.initialCameraPosition,
    this.markers = const {},
    this.circles = const {},
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,
    this.zoomControlsEnabled = false,
    this.mapToolbarEnabled = false,
    this.compassEnabled = false,
    this.buildingsEnabled = true,
    this.onMapCreated,
    this.onTap,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: markers,
          circles: circles,
          myLocationEnabled: myLocationEnabled,
          myLocationButtonEnabled: myLocationButtonEnabled,
          zoomControlsEnabled: zoomControlsEnabled,
          mapToolbarEnabled: mapToolbarEnabled,
          compassEnabled: compassEnabled,
          buildingsEnabled: buildingsEnabled,
          onMapCreated: (controller) {
            if (onMapCreated != null) onMapCreated!(controller);
          },
          onTap: (position) {
            if (onTap != null) onTap!(position);
          },
        ),
        widget,
      ],
    );
  }
}
