class RegularExpressions {
  RegularExpressions._();

  static RegExp verificationCodeRegex = RegExp(r"^[a-zA-Z0-9\s]*$");

  static RegExp emailValidRegex = RegExp(
      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
}