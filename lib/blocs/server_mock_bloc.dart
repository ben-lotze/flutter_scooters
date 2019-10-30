/// collection of functionality that would normally be available via REST API on a server
/// None of the methods takes user ids into account. It is assumed that they work for the currently logged-in user.
class ServerMockBloc {

  /// a user can rent multiple vehicles (atm this is allowed for E-scooters,
  /// but this may change depending on the vehicle type in the future)
  bool unlockVehicle(int id) {

  }

  bool endRentingVehicle(int id) {
    // check that vehicle was rented
  }

  bool isUnlocked(int id) {

  }

  int getFinalPrice(int id) {
    // TODO: maybe merge with endRenting
  }
}