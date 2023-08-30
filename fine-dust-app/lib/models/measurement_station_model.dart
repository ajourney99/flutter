import 'package:flutter/material.dart';

class MeasurementStation {
  String currentAddr;
  String stationName;
  int pm10Value;
  int pm25Value;
  DateTime dataTime;

  MeasurementStation({
    required this.currentAddr,
    required this.stationName,
    required this.pm10Value,
    required this.pm25Value,
    required this.dataTime,
  });

  String pm10AirQuality() {
    if (pm10Value < 0) {
      return '정보 없음';
    } else if (pm10Value >= 0 && pm10Value <= 15) {
      return '최고';
    } else if (pm10Value >= 16 && pm10Value <= 30) {
      return '좋음';
    } else if (pm10Value >= 31 && pm10Value <= 40) {
      return '양호';
    } else if (pm10Value >= 41 && pm10Value <= 50) {
      return '보통';
    } else if (pm10Value >= 51 && pm10Value <= 75) {
      return '나쁨';
    } else if (pm10Value >= 76 && pm10Value <= 100) {
      return '상당히 나쁨';
    } else if (pm10Value >= 101 && pm10Value <= 150) {
      return '매우 나쁨';
    } else {
      return '최악';
    }
  }

  String pm25AirQuality() {
    if (pm25Value < 0) {
      return '정보 없음';
    } else if (pm25Value >= 0 && pm25Value <= 8) {
      return '매우 좋음';
    } else if (pm25Value >= 9 && pm25Value <= 15) {
      return '좋음';
    } else if (pm25Value >= 16 && pm25Value <= 20) {
      return '양호';
    } else if (pm25Value >= 21 && pm25Value <= 25) {
      return '보통';
    } else if (pm25Value >= 26 && pm25Value <= 37) {
      return '나쁨';
    } else if (pm25Value >= 38 && pm25Value <= 50) {
      return '상당히 나쁨';
    } else if (pm25Value >= 51 && pm25Value <= 75) {
      return '매우 나쁨';
    } else {
      return '최악';
    }
  }

  Color backgroundColor() {
    if (pm10Value < 0) {
      return Colors.grey.shade600;
    } else if (pm10Value >= 0 && pm10Value <= 15) {
      return Colors.blueAccent.shade700;
    } else if (pm10Value >= 16 && pm10Value <= 30) {
      return Colors.blue;
    } else if (pm10Value >= 31 && pm10Value <= 40) {
      return const Color.fromARGB(255, 0, 232, 182);
    } else if (pm10Value >= 41 && pm10Value <= 50) {
      return const Color.fromARGB(255, 31, 170, 36);
    } else if (pm10Value >= 51 && pm10Value <= 75) {
      return const Color.fromARGB(255, 255, 208, 0);
    } else if (pm10Value >= 76 && pm10Value <= 100) {
      return const Color.fromARGB(255, 255, 149, 0);
    } else if (pm10Value >= 101 && pm10Value <= 150) {
      return const Color.fromARGB(255, 221, 11, 0);
    } else {
      return const Color.fromARGB(255, 0, 0, 0);
    }
  }
}
