import "package:flutter/cupertino.dart";

/// Palette de couleurs de l'application shop_hub.
///
/// Identité visuelle moderne & élégante :
/// - **Primary** (`#1C1B1F`) → Quasi-noir charbon, base de l'identité.
/// - **Light Scaffold** (`#FFFFFF`) → 
/// Fond blanc pur pour les écrans principaux.
/// - **Light Container** (`#E9E9E7`) → Gris chaud pour cards & conteneurs.
/// - **Dark Background** (`#0F0F0F`) → Noir profond pour le scaffold dark.
/// - **Dark Surface** (`#1A1A1A`) → Surface élevée dark (cards, drawers).
/// - **Dark Container** (`#242424`) → Conteneurs imbriqués en dark mode.
class AppColors {
  const AppColors._();

  // ───────────────────────────────────────────────
  // BRAND — Couleurs de marque Netflix
  // ───────────────────────────────────────────────

  /// Charbon quasi-noir (#1C1B1F) — Couleur d'ancrage principale.
  static const Color primary = Color(0xFF1C1B1F);

  /// Charbon atténué (#3D3B41) — Secondaire / Dégradés / États survol.
  static const Color secondary = Color(0xFF3D3B41);

  /// Or ambré (#E5A00D) — Badges & accents premium.
  static const Color tertiary = Color(0xFFE5A00D);

  /// Blanc pur.
  static const Color white = Color(0xFFFFFFFF);

  /// Noir pur.
  static const Color black = Color(0xFF000000);

  // Alias legacy (conservés pour compatibilité)
  static const Color netflixRed = Color(0xFFE50914);
  static const Color netflixDarkRed = Color(0xFFB81D24);
  static const Color netflixBlack = Color(0xFF141414);
  static const Color netflixDarkGray = Color(0xFF1F1F1F);
  static const Color netflixMediumGray = Color(0xFF2B2B2B);
  static const Color netflixLightGray = Color(0xFF757575);

  // ───────────────────────────────────────────────
  // ACCENTS — Catégories, Badges & Streaming Indicators
  // ───────────────────────────────────────────────

  static const Color accentRed = Color(0xFFE50914);
  static const Color accentAmber = Color(0xFFE5A00D);
  static const Color accentGreen = Color(0xFF46D369); // Netflix Match Green
  static const Color accentBlue = Color(0xFF0071EB); // 4K / Ultra HD
  static const Color accentPurple = Color(0xFF8C52FF);

  /// Liste pratique pour assigner une couleur à chaque catégorie/carte.
  static const List<Color> categoryColors = [
    accentRed,
    accentAmber,
    accentGreen,
    accentBlue,
    accentPurple,
  ];

  // ───────────────────────────────────────────────
  // ÉTATS
  // ───────────────────────────────────────────────

  static const Color error = Color(0xFFE50914);
  static const Color warning = Color(0xFFE5A00D);
  static const Color success = Color(0xFF46D369);
  static const Color info = Color(0xFF0071EB);

  // ───────────────────────────────────────────────
  // ENCRE & TEXTES — Light Mode
  // ───────────────────────────────────────────────

  /// Charbon profond Netflix — remplace le noir pur
  /// pour les textes en Light Mode.
  static const Color ink = Color(0xFF141414);
  static const Color ink87 = Color(0xDE141414);
  static const Color ink54 = Color(0x8A141414);
  static const Color ink38 = Color(0x61141414);

  // ───────────────────────────────────────────────
  // BLANC CASSÉ & TEXTES — Dark Mode
  // ───────────────────────────────────────────────

  /// Blanc lumineux Netflix — Texte principal en Dark Mode.
  static const Color paleMint = Color(0xFFFFFFFF);
  static const Color paleMint87 = Color(0xDEFFFFFF);
  static const Color paleMint70 = Color(0xB3FFFFFF); // Muted gray Netflix
  static const Color paleMint54 = Color(0x8AFFFFFF);
  static const Color paleMint38 = Color(0x61FFFFFF);

  // ───────────────────────────────────────────────
  // LIGHT MODE — Surfaces
  // ───────────────────────────────────────────────

  /// Fond général (scaffold) light mode — Blanc pur (#FFFFFF).
  static const Color surface = Color(0xFFFFFFFF);

  /// Carte / Conteneur élevé light mode — Gris chaud (#E9E9E7).
  static const Color surfaceContainer = Color(0xFFE9E9E7);

  /// Champ de saisie light mode — Gris très doux (#F0EFEF).
  static const Color lightInput = Color(0xFFF0EFEF);

  // ───────────────────────────────────────────────
  // DARK MODE — Surfaces (Signature Dark)
  // ───────────────────────────────────────────────

  /// Fond général (scaffold) dark mode — Noir profond (#0F0F0F).
  static const Color darkBackground = Color(0xFF0F0F0F);

  /// Surface élevée level 1 (cartes, bottom sheets) — (#1A1A1A).
  static const Color darkSurface = Color(0xFF1A1A1A);

  /// Surface élevée level 2 (conteneurs imbriqués) — (#242424).
  static const Color darkSurfaceContainer = Color(0xFF242424);

  /// Champ de saisie dark mode (#2E2E2E).
  static const Color darkInput = Color(0xFF2E2E2E);

  // ───────────────────────────────────────────────
  // GRADIENTS
  // ───────────────────────────────────────────────

  /// Dégradé Or premium.
  static const goldenGradient = LinearGradient(
    colors: [Color(0xFFF5C518), Color(0xFFE5A00D), Color(0xFFB87B00)],
  );

  static const fullGoldenGradient = LinearGradient(
    colors: [
      Color(0xFFFFDF6D),
      Color(0xFFF5C518),
      Color(0xFFE5A00D),
      Color(0xFFB87B00),
    ],
  );

  /// Dégradé Brand principal (Charbon foncé → Charbon moyen).
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const softSurfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surfaceContainer, surface],
  );

  /// Fondu héroïque (overlay images).
  static const heroOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0x800F0F0F), darkBackground],
  );

  // ───────────────────────────────────────────────
  // PRIMARY LUSH GRADIENTS
  // ───────────────────────────────────────────────

  static const primaryDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF000000), Color(0xFF0F0F0F), primary],
  );

  static const primaryLush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBackground, secondary, primary],
  );

  static const primaryDeepLush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF000000), darkBackground, secondary],
  );

  static const primaryLightLush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary, white],
  );

  static const primarySoftLush = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary, surface],
  );

  // ───────────────────────────────────────────────
  // ACCENT GRADIENTS
  // ───────────────────────────────────────────────

  static const purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, Color(0xFF6325D3)],
  );

  static const redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentRed, secondary],
  );

  static const amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentAmber, Color(0xFFB87B00)],
  );

  static const greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGreen, Color(0xFF269447)],
  );

  static const blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBlue, Color(0xFF004999)],
  );

  // ───────────────────────────────────────────────
  // SEMANTIC GRADIENTS
  // ───────────────────────────────────────────────

  static const successGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentGreen, Color(0xFF269447)],
  );

  static const errorGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentRed, secondary],
  );

  static const infoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentBlue, Color(0xFF004999)],
  );

  static const warningGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accentAmber, Color(0xFFB87B00)],
  );

  // ───────────────────────────────────────────────
  // NEUTRES — Échelle de gris Netflix
  // ───────────────────────────────────────────────

  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF0F0F0);
  static const Color neutral200 = Color(0xFFE0E0E0);
  static const Color neutral300 = Color(0xFFCCCCCC);
  static const Color neutral400 = Color(0xFFA3A3A3);
  static const Color neutral500 = Color(0xFF737373);
  static const Color neutral600 = Color(0xFF525252);
  static const Color neutral700 = Color(0xFF333333);
  static const Color neutral800 = Color(0xFF1F1F1F);
  static const Color neutral900 = Color(0xFF141414);
}
