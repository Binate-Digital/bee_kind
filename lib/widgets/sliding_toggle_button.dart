import 'package:bee_kind/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget slidingToggleButton({
    required bool value,
    ValueChanged<bool>? onChanged,
    double width = 40,
    double height = 25,
    Duration animationDuration = const Duration(milliseconds: 200),
    Key? key,
  }) {
    return GestureDetector(
      key: key,
      onTap: () => onChanged?.call(!value),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value ? AppColors.yellow2 : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: height - 4,
            height: height - 4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }