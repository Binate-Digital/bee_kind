// ignore_for_file: must_be_immutable

import 'package:bee_kind/utils/app_colors.dart';
import 'package:bee_kind/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  void Function()? onPrefixTap, onTap;
  String? prefxicon;
  Widget? suffixIcon;
  bool? isSuffixIcon;
  TextInputType? keyboardType;
  int? maxlines;
  bool readOnly;
  bool isObscure;
  bool isEditable;
  Color? color, bgColor, textColor;
  EdgeInsetsGeometry? contentPadding;
  final String hint;
  final double? fontsize, width, verticalPadding;
  final Color? bdColor, hintColor;
  FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  TextEditingController? controller;
  String? Function(String?)? validator;
  void Function(String)? onchange;
  final void Function()? onclick;
  List<TextInputFormatter>? inputFormatters;
  final double radius;

  CustomTextField({
    super.key,
    this.onPrefixTap,
    this.hintColor,
    this.prefxicon,
    this.verticalPadding,
    this.isSuffixIcon,
    this.isEditable = true,
    this.isObscure = false,
    this.maxlines,
    this.bdColor,
    required this.hint,
    this.fontsize,
    this.width,
    this.suffixIcon,
    this.textColor,
    this.contentPadding,
    this.onclick,
    this.controller,
    this.validator,
    this.onchange,
    this.onTap,
    this.bgColor,
    this.keyboardType,
    this.focusNode,
    this.readOnly = false,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.radius = 30,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: onTap,
      readOnly: readOnly,
      obscureText: isObscure,
      textInputAction: TextInputAction.done,
      keyboardType: keyboardType,
      onChanged: onchange,
      enabled: isEditable,
      validator: validator,
      cursorColor: textColor ?? AppColors.yellow2,
      maxLines: maxlines ?? 1,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      autofocus: false,
      onEditingComplete: onEditingComplete,
      inputFormatters: inputFormatters,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: fontsize ?? 15.sp,
        color: textColor ?? AppColors.yellow2,
        fontFamily: AppFonts.ralewayMedium,
      ),
      decoration: colorInputDecoration(),
    );
  }

  InputDecoration colorInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: verticalPadding ?? 18.sp,
        horizontal: 14.sp,
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: hintColor ?? AppColors.yellow2,
        fontSize: 16.sp,
        fontFamily: AppFonts.ralewayMedium,
      ),
      alignLabelWithHint: true, // Add this single line
      border: _outlineInputBorder(),
      enabledBorder: _outlineInputBorder(),
      focusedBorder: _outlineInputBorder(),
      errorBorder: _outlineInputBorder(),
      focusedErrorBorder: _outlineInputBorder(),
      focusColor: AppColors.transparentColor,
      errorMaxLines: 2,
      isDense: true,
      fillColor: bgColor ?? AppColors.yellow1.withValues(alpha: 0.2),
      filled: true,
      errorStyle: const TextStyle(overflow: TextOverflow.visible),
      prefixIcon: prefxicon != null
          ? GestureDetector(
              onTap: onPrefixTap,
              child: Container(
                height: 20.h,
                margin: EdgeInsets.only(left: 15.w, right: 5.w),
                padding: EdgeInsets.only(right: 5.w),
                child: Image.asset(prefxicon!),
              ),
            )
          : null,
      prefixIconConstraints: BoxConstraints(),
      suffixIconConstraints: BoxConstraints(),
      suffixIcon: isSuffixIcon == true
          ? Container(
              height: 25.h,
              width: 100.w,
              padding: EdgeInsets.only(right: 23.w),
              child: suffixIcon,
            )
          : null,
    );
  }

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: bdColor ?? AppColors.blackColor.withValues(alpha: 0.3),
      ),
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }
}
