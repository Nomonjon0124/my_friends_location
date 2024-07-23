import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_friends_location/data/model/friend_model.dart';
import 'package:my_friends_location/data/remote/service/location_service.dart';
import 'package:my_friends_location/util/app_lat_long.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  final FriendModel friendModel;

  const MapScreen({super.key, required this.friendModel});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapControllerCompleter = Completer<YandexMapController>();
  final List<MapObject> mapObjects = [];
  late FriendModel friendModel;
  bool isCheckedFriend = true;

  void getBranches() async {
    print("tushyapti");
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('users1').get();
    print("ma'lumotlar olindi");
    List<FriendModel> list = snapshot.docs.map((doc) => FriendModel.fromFirestore(doc)).toList();
    print('kast qilindi');
    /*for(var element in list){
      print("tsiklga tushti");
      mapObjects.add(PlacemarkMapObject(
          mapId: MapObjectId(1.toString()),
          point: Point(latitude: element.latitude, longitude: element.longitude),
        icon:PlacemarkIcon.single(PlacemarkIconStyle(
          scale:0.8,
          image: BitmapDescriptor.fromAssetImage('assets/pin.png'),
        ))
      ));
    }*/
    for (int i = 0; i < list.length; i++) {
      print("tsiklga tushti ${list[i].name}");
      setState(() {
        mapObjects.add(PlacemarkMapObject(
            mapId: MapObjectId(i.toString()),
            point: Point(latitude: list[i].latitude, longitude: list[i].longitude),
            text: PlacemarkText(text: list[i].name, style: const PlacemarkTextStyle(size: 10, placement: TextStylePlacement.bottom)),
            icon: PlacemarkIcon.single(PlacemarkIconStyle(
              scale: 2,
              image: BitmapDescriptor.fromAssetImage('assets/pin.png'),
            ))));
      });
    }
  }

  Future<void> _moveToCurrentLocation(double lat, double lon) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: lat,
            longitude: lon,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    var defLocation = FerghanaLocation();
    try {
      location = AppLatLong(lat: friendModel.latitude, long: friendModel.longitude);
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location.lat, location.long);
  }

  @override
  void initState() {
    friendModel = widget.friendModel;
    _initPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isCheckedFriend = true;
              mapObjects.clear();
            });
            _fetchCurrentLocation();
          },
          backgroundColor: Theme.of(context).colorScheme.background,
          child: const Icon(Icons.location_on),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          automaticallyImplyLeading: false,
          title: Center(
              child: Text(
            'Yandex Map',
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 18, fontWeight: FontWeight.bold),
          )),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: GestureDetector(
              onTap: () {
                print("bottom bosilyapti");
                setState(() {
                  isCheckedFriend = false;
                  getBranches();
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xFF47495E)),
                child: Center(
                    child: Text(
                  'All Friends',
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 18),
                )),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            YandexMap(
                onMapCreated: (controller) {
                  mapControllerCompleter.complete(controller);
                },
                onMapTap: (point) {
                  print('LAT ----------------------');
                  print(point.latitude);
                },
                onObjectTap: (geoObject) {
                  print('NAMEEE -[-------------------');
                  print(geoObject.name);
                },
                zoomGesturesEnabled: true,
                onCameraPositionChanged: (cameraPosition, reason, finished) {
                  if (finished) {}
                },
                mapObjects: mapObjects
                /*[
              PlacemarkMapObject(
                onTap: (object, point) {
                  print('Object tappeppp');
                  print(object.mapId.value);
                },
                text: PlacemarkText(
                    text: "BUTTON", style: PlacemarkTextStyle(size: 12,placement: TextStylePlacement.bottom)),
                mapId: MapObjectId('154'),
                icon: PlacemarkIcon.single(PlacemarkIconStyle(
                    scale: 2,
                    image: BitmapDescriptor.fromAssetImage('assets/pin.png'))),
                point: Point(latitude: widget.friendModel.latitude, longitude: widget.friendModel.longitude))

            ],*/
                ),
            (isCheckedFriend)
                ? Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(friendModel.name),
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.red,
                          size: 40,
                        )
                      ],
                    ))
                : Container()
          ],
        ));
  }
}
