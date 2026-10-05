import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ubi extends StatefulWidget {
  const ubi({super.key});

  @override
  State<ubi> createState() => _ubiState();
}

class _ubiState extends State<ubi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("UBICACIÓN")),

      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(20.496089424665346, -99.18257514179388),
        ),
      ),
    );
  }
}
