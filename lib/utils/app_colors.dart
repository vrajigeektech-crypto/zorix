import 'dart:ui';

class AppColors {
  static final Color primaryBGColor = hexToColor('F7F9FB');
  static final Color primaryTextColor = hexToColor('191C1E');
  static final Color whiteColor = hexToColor('FFFFFF');
  static final Color blackColor = hexToColor('000000');
  static final Color lightGrayColor = hexToColor('D9D9D9');
  static final Color borderColor = hexToColor('EDEDED');
  static final Color grayColor = hexToColor('838383');
  static final Color primaryColor = hexToColor('1A7065');
  static final Color darkGreenColor = hexToColor('0F766E');
  static final Color circleBorderColor = hexToColor('2DD4BF');
  static final Color lightGreenColor = hexToColor('2DD4BF');
  static final Color greenColor = hexToColor('005C55');
  static final Color lightRedColor = hexToColor('FFDAD6');
  static final Color redColor = hexToColor('BA1A1A');
  static final Color radiumGreenColor = hexToColor('CAEAD6');
  static final Color lightGrayColor2 = hexToColor('E6E8EA');
  static final Color lightGrayText = hexToColor('3E4947');
}

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse(hex, radix: 16));
}
