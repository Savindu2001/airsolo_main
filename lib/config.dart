class Config {
  static const String baseUrl = 'http://127.0.0.1:3000'; 
  static const String googleClientId = '785691024956-sl7fp2jktgtsoh854fr1a5nc9au179e4.apps.googleusercontent.com';
  

  // Auth REST API Endpoints
  static const String loginEndpoint = '$baseUrl/api/users/login';
  static const String registerEndpoint = '$baseUrl/api/users/register';
  static const String socialLoginEndpoint = '$baseUrl/api/users/social-login';
  static const String forgotPassword = '$baseUrl/api/users/forgot-password';
  static const String verifyEmail = '$baseUrl/api/users/verify-email';
  static const String verifyEmailCheck = '$baseUrl/api/users/verify-email/check';
  static const String resetPassword = '$baseUrl/api/users/reset-password';

  // User rest Api 
  static const String userEndpoint = '$baseUrl/api/users';

  // Hostel REST API Endpoints
  static const String hostelEndpoint = '$baseUrl/api/hostels';
  static const String getHostelByIdEndpoint = '$baseUrl/api/hostels';
  static const String facilityEndpoint = '$baseUrl/api/facilities';
  static const String roomsEndpoint = '$baseUrl/api/rooms';
  static const String houseRulesEndpoint = '$baseUrl/api/house-rules';
  static const String bookingEndpoint ='$baseUrl/api/bookings';
  static const String bookingConfirm = '$baseUrl/api/bookings/confirm/';

  // WEBHOOK_URL
  
  static const String payhere = '$baseUrl/api/bookings/payment/';

  // Taxi REST API Endpoints
  static const String getTaxisEndpoint = '$baseUrl/api/taxis';
  static const String getTaxiByIdEndpoint = '$baseUrl/api/taxis';
  static const String getVehicleType = '$baseUrl/api/vehicle-type';

    // Taxi Booking
    static const String getTaxiBooking = '$baseUrl/api/taxi-booking';

  // City REST API Endpoints
  static const String cityEndpoint = '$baseUrl/api/city';

  // Information REST API Endpoints
  static const String informationEndpoint = '$baseUrl/api/information';

  // Activity Rest Api
  static const String activityEndpoint ='$baseUrl/api/activity-events';

  // TripGenie Rest Api
  static const String tripGenieEndpoint = '$baseUrl/api/tripgenie';

  // Card Rest Api
  static const String cardDetailEndpoint = '$baseUrl/api/paymentcards';
  static const String cardDetailsByUserId = '$baseUrl/api/paymentcards/cards';


  // Api Key
  static const String googleMapApiKey = 'AIzaSyC76NiQpUn4Frh1Qijj_D_NLFPel_a8fXM';
}
