import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4287187559),
      surfaceTint: Color(4287187559),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4294957286),
      onPrimaryContainer: Color(4281927458),
      secondary: Color(4285749089),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294892006),
      onSecondaryContainer: Color(4280947998),
      tertiary: Color(4286469432),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4294958278),
      onTertiaryContainer: Color(4281340928),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294965496),
      onSurface: Color(4280359196),
      onSurfaceVariant: Color(4283450184),
      outline: Color(4286804856),
      outlineVariant: Color(4292133575),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281806385),
      inversePrimary: Color(4294947024),
      primaryFixed: Color(4294957286),
      onPrimaryFixed: Color(4281927458),
      primaryFixedDim: Color(4294947024),
      onPrimaryFixedVariant: Color(4285412175),
      secondaryFixed: Color(4294892006),
      onSecondaryFixed: Color(4280947998),
      secondaryFixedDim: Color(4292984266),
      onSecondaryFixedVariant: Color(4284038986),
      tertiaryFixed: Color(4294958278),
      onTertiaryFixed: Color(4281340928),
      tertiaryFixedDim: Color(4294032280),
      onTertiaryFixedVariant: Color(4284694051),
      surfaceDim: Color(4293252826),
      surfaceBright: Color(4294965496),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963443),
      surfaceContainer: Color(4294634222),
      surfaceContainerHigh: Color(4294239464),
      surfaceContainerHighest: Color(4293844962),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4285083467),
      surfaceTint: Color(4287187559),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4288897149),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4283776070),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4287261816),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4284430879),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288113484),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965496),
      onSurface: Color(4280359196),
      onSurfaceVariant: Color(4283187012),
      outline: Color(4285160288),
      outlineVariant: Color(4287002492),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281806385),
      inversePrimary: Color(4294947024),
      primaryFixed: Color(4288897149),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4287055972),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4287261816),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4285551711),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4288113484),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4286272310),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293252826),
      surfaceBright: Color(4294965496),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963443),
      surfaceContainer: Color(4294634222),
      surfaceContainerHigh: Color(4294239464),
      surfaceContainerHighest: Color(4293844962),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4282453545),
      surfaceTint: Color(4287187559),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4285083467),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281408549),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4283776070),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4281866755),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284430879),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294965496),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4281082149),
      outline: Color(4283187012),
      outlineVariant: Color(4283187012),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281806385),
      inversePrimary: Color(4294960877),
      primaryFixed: Color(4285083467),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4283308340),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4283776070),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282197551),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4284430879),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282721547),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293252826),
      surfaceBright: Color(4294965496),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963443),
      surfaceContainer: Color(4294634222),
      surfaceContainerHigh: Color(4294239464),
      surfaceContainerHighest: Color(4293844962),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294947024),
      surfaceTint: Color(4294947024),
      onPrimary: Color(4283637048),
      primaryContainer: Color(4285412175),
      onPrimaryContainer: Color(4294957286),
      secondary: Color(4292984266),
      onSecondary: Color(4282460723),
      secondaryContainer: Color(4284038986),
      onSecondaryContainer: Color(4294892006),
      tertiary: Color(4294032280),
      onTertiary: Color(4282984463),
      tertiaryContainer: Color(4284694051),
      onTertiaryContainer: Color(4294958278),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279832852),
      onSurface: Color(4293844962),
      onSurfaceVariant: Color(4292133575),
      outline: Color(4288515218),
      outlineVariant: Color(4283450184),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293844962),
      inversePrimary: Color(4287187559),
      primaryFixed: Color(4294957286),
      onPrimaryFixed: Color(4281927458),
      primaryFixedDim: Color(4294947024),
      onPrimaryFixedVariant: Color(4285412175),
      secondaryFixed: Color(4294892006),
      onSecondaryFixed: Color(4280947998),
      secondaryFixedDim: Color(4292984266),
      onSecondaryFixedVariant: Color(4284038986),
      tertiaryFixed: Color(4294958278),
      onTertiaryFixed: Color(4281340928),
      tertiaryFixedDim: Color(4294032280),
      onTertiaryFixedVariant: Color(4284694051),
      surfaceDim: Color(4279832852),
      surfaceBright: Color(4282398522),
      surfaceContainerLowest: Color(4279438351),
      surfaceContainerLow: Color(4280359196),
      surfaceContainer: Color(4280687904),
      surfaceContainerHigh: Color(4281346091),
      surfaceContainerHighest: Color(4282135093),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294948563),
      surfaceTint: Color(4294947024),
      onPrimary: Color(4281467421),
      primaryContainer: Color(4291001242),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293247438),
      onSecondary: Color(4280553497),
      secondaryContainer: Color(4289235092),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294360987),
      onTertiary: Color(4280815360),
      tertiaryContainer: Color(4290152038),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279832852),
      onSurface: Color(4294965753),
      onSurfaceVariant: Color(4292462283),
      outline: Color(4289765028),
      outlineVariant: Color(4287594372),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293844962),
      inversePrimary: Color(4285477968),
      primaryFixed: Color(4294957286),
      onPrimaryFixed: Color(4280942615),
      primaryFixedDim: Color(4294947024),
      onPrimaryFixedVariant: Color(4284097342),
      secondaryFixed: Color(4294892006),
      onSecondaryFixed: Color(4280158996),
      secondaryFixedDim: Color(4292984266),
      onSecondaryFixedVariant: Color(4282855225),
      tertiaryFixed: Color(4294958278),
      onTertiaryFixed: Color(4280355584),
      tertiaryFixedDim: Color(4294032280),
      onTertiaryFixedVariant: Color(4283444756),
      surfaceDim: Color(4279832852),
      surfaceBright: Color(4282398522),
      surfaceContainerLowest: Color(4279438351),
      surfaceContainerLow: Color(4280359196),
      surfaceContainer: Color(4280687904),
      surfaceContainerHigh: Color(4281346091),
      surfaceContainerHighest: Color(4282135093),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294965753),
      surfaceTint: Color(4294947024),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294948563),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294965753),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4293247438),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294966008),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294360987),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279832852),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294965753),
      outline: Color(4292462283),
      outlineVariant: Color(4292462283),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293844962),
      inversePrimary: Color(4283110961),
      primaryFixed: Color(4294958825),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294948563),
      onPrimaryFixedVariant: Color(4281467421),
      secondaryFixed: Color(4294958825),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4293247438),
      onSecondaryFixedVariant: Color(4280553497),
      tertiaryFixed: Color(4294959567),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294360987),
      onTertiaryFixedVariant: Color(4280815360),
      surfaceDim: Color(4279832852),
      surfaceBright: Color(4282398522),
      surfaceContainerLowest: Color(4279438351),
      surfaceContainerLow: Color(4280359196),
      surfaceContainer: Color(4280687904),
      surfaceContainerHigh: Color(4281346091),
      surfaceContainerHighest: Color(4282135093),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
