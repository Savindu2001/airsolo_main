class AValidator {

  static String? validateEmail(String? value){
    if (value == null || value.isEmpty){
      return 'Email is required!';
    }

    //Regular expressions for email validators
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)){
      return 'Invalid Email Address!';
    }

    return null;

  }

  static String? validatePassword(String? value){
    if (value == null || value.isEmpty){
      return 'Password is required!';
    }

    //check minimum password length
    if (value.length < 6){
      return 'Password must be at least 6 Chracters Long.';
    }

    //check uppercase letters
    if(!value.contains(RegExp(r'[A-Z]'))){
      return 'Password must contain at least one uppercase letter!';
    }

    //check numbers
    if(!value.contains(RegExp(r'[0-9]'))){
      return 'Password must contain at least one number!';
    }

    //check Special chracters
    if(!value.contains(RegExp(r'[!@#$%^&*()_+,.?":{}|<>]'))){
      return 'Password must contain at least one special character';
    }


    return null;

    

  }





    static String? validatePhoneNumber(String? value){
    if (value == null || value.isEmpty){
      return 'Phone Number is required!';
    }

    //Regular expressions for email validators
    final phoneRegExp = RegExp(r'^\d{10}$');

    //check minimum password length
    if (!phoneRegExp.hasMatch(value)){
      return 'Invalid phone number format (10 digits required )';
    }


    return null;

    

  }


}