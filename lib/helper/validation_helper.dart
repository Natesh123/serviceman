import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class ValidationHelper {


  static String getValidPhone(String number, {bool withCountryCode = false}) {
    bool isValid = false;
    String phone = "";

    try{
      // Remove any non-numeric characters except +
      String cleanedNumber = number.replaceAll(RegExp(r'[^\+0-9]'), '');
      
      PhoneNumber phoneNumber = PhoneNumber.parse(cleanedNumber);
      isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
      
      // If not valid, check if the NSN starts with '0' and try stripping it (common issue)
      if (!isValid && phoneNumber.nsn.startsWith('0')) {
        String nsnWithoutZero = phoneNumber.nsn.substring(1);
        PhoneNumber altPhone = PhoneNumber(isoCode: phoneNumber.isoCode, nsn: nsnWithoutZero);
        if (altPhone.isValid(type: PhoneNumberType.mobile)) {
          phoneNumber = altPhone;
          isValid = true;
        }
      }

      if(isValid){
        phone =  withCountryCode ? "+${phoneNumber.isoCode}${phoneNumber.nsn}" : phoneNumber.nsn.toString();
        if (kDebugMode) {
          print("Phone Number : $phone");
        }
      }
    }catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return phone;
  }

}