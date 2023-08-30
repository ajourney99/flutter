import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:finedust/models/measurement_station_model.dart';

Future<MeasurementStation?> locationAPIService() async {
  var current = MeasurementStation(
      currentAddr: '',
      stationName: '',
      pm10Value: 0,
      pm25Value: 0,
      dataTime: DateTime.now());

  LocationPermission permission = await Geolocator.requestPermission();

  // Get the user's current location
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // Get the placemark information for the current location
  List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude, position.longitude,
      localeIdentifier: 'ko_KR');
  if (placemark.isNotEmpty) {
    if (placemark[1].thoroughfare?.isNotEmpty == true) {
      current.currentAddr = placemark[1].thoroughfare!;
    } else if (placemark[0].thoroughfare?.isNotEmpty == true) {
      current.currentAddr = placemark[0].thoroughfare!;
    } else if (placemark[1].subLocality?.isNotEmpty == true) {
      current.currentAddr = placemark[1].subLocality!;
    } else if (placemark[0].subLocality?.isNotEmpty == true) {
      current.currentAddr = placemark[0].subLocality!;
    } else {
      current.currentAddr = '';
    }
  } else {
    current.currentAddr = '';
  }

  final gps = Projection.get('EPSG:4326')!;
  final tm = Projection.get('EPSG:2097') ??
      Projection.add(
        'EPSG:2097',
        '+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43',
      );

  final gpsCoord = Point(x: position.longitude, y: position.latitude);
  final tmCoord = gps.transform(tm, gpsCoord);

  const searchByTMURL =
      "https://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getNearbyMsrstnList";

  const maxAttempts = 100;
  const retryDelayDuration = Duration(seconds: 2); // Retry every 2 seconds

  for (var attemptCount = 0; attemptCount < maxAttempts; attemptCount++) {
    final nearbyMsrstnURL = Uri.parse(searchByTMURL).replace(
      queryParameters: {
        'serviceKey':
            "jEf2dAOmqGTE1PThfggWWwD6ZHQpg6ba2etzHRDbZP3OVRlXspL0iUmidgbrmEfTRiZyVGtbmbHHVZIsRH2giA==",
        'returnType': 'xml',
        'tmX': tmCoord.x.toString(),
        'tmY': tmCoord.y.toString(),
      },
    );
    final response = await http.get(nearbyMsrstnURL);
    if (response.statusCode == 200) {
      try {
        final responseData = xml.XmlDocument.parse(response.body);
        final firstItem = responseData.findAllElements('item').firstOrNull;

        if (firstItem != null) {
          final stationNameElement =
              firstItem.findElements('stationName').firstOrNull;

          if (stationNameElement != null) {
            final stationName = stationNameElement.innerText;
            if (stationName.isNotEmpty) {
              current.stationName = stationName;
              return current;
            }
          }
        }
      } catch (e) {
        // Errors
      }
    } else {
      await Future.delayed(retryDelayDuration);
    }
  }
  return null;
}
