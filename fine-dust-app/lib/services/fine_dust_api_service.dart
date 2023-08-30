import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:finedust/services/location_api_service.dart';
import 'package:finedust/models/measurement_station_model.dart';

Future<MeasurementStation?> fineDustAPIService() async {
  var current = await locationAPIService();

  if (current != null) {
    String searchByMsrstnNameURL =
        "https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty";
    int maxAttempts = 100;
    int attemptCount = 0;

    while (attemptCount < maxAttempts) {
      Uri msrstnURL = Uri.parse(searchByMsrstnNameURL).replace(
        queryParameters: {
          'stationName': current.stationName,
          'dataTerm': 'daily',
          'returnType': 'xml',
          'serviceKey':
              "jEf2dAOmqGTE1PThfggWWwD6ZHQpg6ba2etzHRDbZP3OVRlXspL0iUmidgbrmEfTRiZyVGtbmbHHVZIsRH2giA==",
          'ver': '1.3',
        },
      );

      final response = await http.get(msrstnURL);
      if (response.statusCode == 200) {
        final responseData = xml.XmlDocument.parse(response.body);
        final firstItem = responseData.findAllElements('item').firstOrNull;

        if (firstItem != null) {
          final pm10ValueElement =
              firstItem.findAllElements('pm10Value').single.innerText;
          final pm25ValueElement =
              firstItem.findAllElements('pm25Value').single.innerText;
          final dataTimeElement =
              firstItem.findAllElements('dataTime').single.innerText;

          current.pm10Value = int.tryParse(pm10ValueElement) ?? 0;
          current.pm25Value = int.tryParse(pm25ValueElement) ?? 0;
          current.dataTime = DateTime.parse(dataTimeElement);

          return current;
        }
      }
    }
    attemptCount++;
  }
  return null;
}
