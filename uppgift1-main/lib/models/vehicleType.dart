enum VehicleType {
Bil, Motorcycle,Lastbil, Car
}
extension VehicleTypeExtension on VehicleType {
  static VehicleType fromJson(String json) {
    switch (json) {
      case 'car':
        return VehicleType.Car;
      case 'truck':
        return VehicleType.Bil;
      case 'motorcycle':
        return VehicleType.Motorcycle;
      default:
        throw Exception('Unknown VehicleType: $json');
    }
  }
}