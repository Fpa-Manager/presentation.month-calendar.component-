import 'package:flutter/material.dart';

class MontCalendarTheme extends ThemeExtension<MontCalendarTheme> {
  final Color currentDayColor;

  const MontCalendarTheme({
    required this.currentDayColor,
  });

  @override
  ThemeExtension<MontCalendarTheme> copyWith({
    Color? currentDayColor,
  }) {
    return MontCalendarTheme(
      currentDayColor: currentDayColor ?? this.currentDayColor,
    );
  }

  @override
  ThemeExtension<MontCalendarTheme> lerp(
      ThemeExtension<MontCalendarTheme>? other,
      double t,
      ) {
    if (other is! MontCalendarTheme) {
      return this;
    }

    return MontCalendarTheme(
      currentDayColor: Color.lerp(currentDayColor, other.currentDayColor, t)!,
    );
  }

  static get light => const MontCalendarTheme(
    currentDayColor: Color.fromARGB(255, 255, 181, 185),
  );

  static get inactive => const MontCalendarTheme(
    currentDayColor: Color.fromARGB(255, 255, 181, 185),
  );

  static get dark => const MontCalendarTheme(
      currentDayColor: Colors.green);
}
