import 'package:intl/intl.dart';

class AFormatter {
  /// Formats a date as `dd-MM-yyyy`
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MM-yyyy').format(date);
  }

  /// Formats a currency amount with a `$` symbol
  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  /// Formats a phone number based on length
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    } else if (phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)}-${phoneNumber.substring(7)}';
    }

    return phoneNumber;
  }

  /// Formats an international phone number
  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove non-digit characters
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Ensure number is long enough
    if (digitsOnly.length < 3) return phoneNumber;

    // Extract country code (first 1–3 digits)
    int countryCodeLength = (digitsOnly.startsWith('1')) ? 1 : 2;
    String countryCode = '+${digitsOnly.substring(0, countryCodeLength)}';
    digitsOnly = digitsOnly.substring(countryCodeLength);

    // Format remaining digits
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = (i == 0 && countryCode == '+1') ? 3 : 2;

      int end = (i + groupLength > digitsOnly.length) ? digitsOnly.length : i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }

      i = end;
    }

    return formattedNumber.toString();
  }
}
