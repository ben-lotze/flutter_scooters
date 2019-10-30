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
  final int batteryLevel;
  final DateTime timestamp;
  final int price;  // price in cents
  final int priceTime;  // Specified the The specified price is due for each started time frame of priceTime-length
  final String currency; // TODO: currency: why string? use enum? (not cool in Dart)

  
  Vehicle._create({
    this.id, this.name, this.description, 
    this.latitude, this.longitude,
    this.batteryLevel, this.timestamp, 
    this.price, this.priceTime, this.currency
  }); 



  factory Vehicle.fromJson(Map<String, dynamic> map) {
    return Vehicle._create(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      latitude: map["latitude"],
      longitude: map["longitude"],
      batteryLevel: map["batteryLevel"],
      timestamp: DateTime.parse(map["timestamp"]),
      price: map["price"],
      priceTime: map["priceTime"],
      currency: map["currency"],
    );
  }



}