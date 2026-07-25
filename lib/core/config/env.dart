/// Environment variable keys injected via `--dart-define-from-file=.env.json`.
abstract final class EnvKeys {
  static const geminiApiKey = 'GEMINI_API_KEY';
  static const googleSafeBrowsingApiKey = 'GOOGLE_SAFE_BROWSING_API_KEY';
  static const virusTotalApiKey = 'VIRUSTOTAL_API_KEY';

  static const all = <String>[
    geminiApiKey,
    googleSafeBrowsingApiKey,
    virusTotalApiKey,
  ];
}

/// Public, non-secret API base URLs for external providers.
abstract final class EnvDefaults {
  static const geminiApiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const googleSafeBrowsingApiBaseUrl =
      'https://safebrowsing.googleapis.com/v4';
  static const virusTotalApiBaseUrl = 'https://www.virustotal.com/api/v3';
}

/// Reads compile-time environment values supplied through Dart defines.
abstract interface class EnvironmentReader {
  String read(String key);
}

/// Production reader backed by `String.fromEnvironment`.
final class DartDefineEnvironmentReader implements EnvironmentReader {
  const DartDefineEnvironmentReader();

  @override
  String read(String key) => String.fromEnvironment(key);
}

/// Test reader backed by an in-memory key-value map.
final class MapEnvironmentReader implements EnvironmentReader {
  const MapEnvironmentReader(this.values);

  final Map<String, String> values;

  @override
  String read(String key) => values[key] ?? '';
}
