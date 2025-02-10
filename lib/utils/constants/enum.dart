//   Text Sizes (For UI Scaling)
enum TextSizes { small, medium, large }

//  Booking Status (For Hotel & Taxi Booking)
enum BookingStatus { booked, pending, canceled, completed }

//  Payment Methods (Expanded for more options)
enum PaymentMethods { 
  visa, 
  masterCard, 
  googlePay, 
  applePay, 
  creditCard, 
  paypal, 
  stripe
}

//  User Roles (For Role-Based Access)
enum UserRole { 
  tourist, 
  hotelier, 
  driver, 
  admin 
}

//  Hotel Verification Status (For Admin Approval)
enum HotelStatus { 
  pendingApproval, 
  verified, 
  rejected 
}

//  Trip Type (For AI Trip Planner)
enum TripType { 
  solo, 
  adventure, 
  beach, 
  cultural, 
  roadTrip 
}
