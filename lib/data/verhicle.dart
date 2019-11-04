import 'package:flutter/foundation.dart';

/// Currently all vehicles are E-scooters. More attributes are necessary to allow for more vehicle types.
class Vehicle {
  /// unique id of a vehicle (Circ-wide unique)
  final int id;
  final String name;
  final String description;
  /// latitude where this vehicle is currently located
  final double latitude;
  /// longitude where this vehicle is currently located
  final double longitude;
  /// battery level between 0 and 100
  final int batteryLevel;
  final DateTime timestamp;
  /// price in cents
  final int price;
  /// time frame in seconds. The specified price is due for each started time frame of priceTime-length
  final int priceTime;
  /// currency symbol to be used for formatted prices
  final String currency;


  /// private constructor, vehicles should only created via [Vehicle.fromJson] method
  Vehicle._create({
    @required this.id,
    this.name,
    this.description,
    @required this.latitude,
    @required this.longitude,
    this.batteryLevel,
    this.timestamp,
    @required this.price,
    @required this.priceTime,
    @required this.currency
  }) {
    if (id == null) throw ArgumentError.notNull("id must not be null");
  }


  /// [jsonMap] from REST endpoint
  factory Vehicle.fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap == null || jsonMap.length == 0) {
      throw Exception("cannot parse Vehicle from provided map which is either null or empty");
    }
    return Vehicle._create(
      id: jsonMap["id"],
      name: jsonMap["name"],
      description: jsonMap["description"],
      latitude: jsonMap["latitude"],
      longitude: jsonMap["longitude"],
      batteryLevel: jsonMap["batteryLevel"],
      timestamp: DateTime.parse(jsonMap["timestamp"]),
      price: jsonMap["price"],
      priceTime: jsonMap["priceTime"],
      currency: jsonMap["currency"],
    );
  }

  @override
  String toString() {
    return 'Vehicle{id: $id, name: $name, description: $description, latitude: $latitude, '
        'longitude: $longitude, batteryLevel: $batteryLevel, timestamp: $timestamp, '
        'price: $price, priceTime: $priceTime, currency: $currency}';
  }

}