import 'package:my_friends_location/util/app_lat_long.dart';

abstract class AppLocation{
  Future<AppLatLong> getCurrentLocation();

  Future<bool> requestPermission();

  Future<bool> checkPermission();
}