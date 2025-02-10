class APriceCalculator {
  APriceCalculator._(); // Private constructor to prevent instantiation

  /// Commission and tax rates
  static const double touristCommissionRate = 0.025; // 2.5% from tourist booking
  static const double hotelCommissionRate = 0.05; // 5% from hotel earnings
  static const double taxRate = 0.05; // 5% tax on every booking

  /// Calculates the total amount the **tourist** pays (including 2.5% commission & 5% tax)
  static double calculateTouristBookingPrice(double basePrice) {
    double commission = basePrice * touristCommissionRate; // 2.5% commission
    double tax = basePrice * taxRate; // 5% tax
    return basePrice + commission + tax;
  }

  /// Calculates the amount **hotel receives** after deducting 5% commission and 5% tax
  static double calculateHotelEarnings(double basePrice) {
    double totalDeductions = (basePrice * hotelCommissionRate) + (basePrice * taxRate);
    return basePrice - totalDeductions;
  }
}
