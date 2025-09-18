import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.warning,
    required this.critical,
    required this.info,
    required this.surfaceTint,
  });

  final Color success;
  final Color warning;
  final Color critical;
  final Color info;
  final Color surfaceTint;

  static const AppColors light = AppColors(
    success: Color(0xFF146C43),
    warning: Color(0xFF8A6112),
    critical: Color(0xFFB3261E),
    info: Color(0xFF005AC2),
    surfaceTint: Color(0xFFE6EEF9),
  );

  static const AppColors dark = AppColors(
    success: Color(0xFF86E8B2),
    warning: Color(0xFFF6C945),
    critical: Color(0xFFFFB4AB),
    info: Color(0xFF9CCAFF),
    surfaceTint: Color(0xFF1B2838),
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? light;
  }

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? critical,
    Color? info,
    Color? surfaceTint,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      critical: critical ?? this.critical,
      info: info ?? this.info,
      surfaceTint: surfaceTint ?? this.surfaceTint,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      critical: Color.lerp(critical, other.critical, t) ?? critical,
      info: Color.lerp(info, other.info, t) ?? info,
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t) ?? surfaceTint,
    );
  }
}
