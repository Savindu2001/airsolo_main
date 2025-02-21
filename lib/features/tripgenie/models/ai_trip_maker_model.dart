class TripMakerModel {
  String destination;
  DateTime? startDate;
  DateTime? endDate;
  int guests;
  String travelPreference;
  final List<String> preferences = ["Adventure", "Relaxing", "Cultural", "Budget", "Luxury", "Solo Hike"];

  TripMakerModel({
    this.destination = "",
    this.startDate,
    this.endDate,
    this.guests = 1,
    this.travelPreference = "Adventure",
  });

  void updateDateRange(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
  }

  void increaseGuests() {
    guests++;
  }

  void decreaseGuests() {
    if (guests > 1) guests--;
  }

  void updatePreference(String preference) {
    travelPreference = preference;
  }
}
