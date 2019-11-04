import 'dart:convert';

/// Scan result from scanning a vehicle's qr code, containing the vehicles's [id] and [name].
class VehicleQrCode {

  final int id;
  final String name;

  VehicleQrCode(this.id, this.name);

  factory VehicleQrCode.fromJsonString(String jsonStr) {
    Map<String, dynamic> map = json.decode(jsonStr);
    return VehicleQrCode.fromJson(map);
  }

  factory VehicleQrCode.fromJson(Map<String, dynamic> jsonMap) {
    return VehicleQrCode(
      jsonMap["id"],
      jsonMap["name"],
    );
  }

  @override
  String toString() {
    return 'VehicleQrCode{id: $id, name: $name}';
  }


}