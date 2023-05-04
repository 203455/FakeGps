import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String? latitude;
  String? longitude;
  bool? isMock;

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    final permission = await Permission.location.request();
    if (permission == PermissionStatus.granted) {
      TrustLocation.start(10);
      getLocation();
    } else if (permission == PermissionStatus.denied) {
      await Permission.location.request();
    }
  }

  void getLocation() async {
    try {
      TrustLocation.onChange.listen((result) {
        setState(() {
          latitude = result.latitude;
          longitude = result.longitude;
          isMock = result.isMockLocation;
        });
      });
    } catch (e) {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("lat: $latitude\n"),
                  // Text("long: $longitude\n"),
                  Text("FAKE : $isMock\n"),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          initState();
        },
        child: Text("Actualizar ubicación"),
      ),
    );
  }
}
