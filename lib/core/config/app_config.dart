import '../error/exceptions.dart';
import 'env.dart';

/// Application configuration loaded from compile-time environment defines.
final class AppConfig {
  const AppConfig({
    required this.geminiApiKey,
    required this.googleSafeBrowsingApiKey,
    required this.virusTotalApiKey,
  });

  final String geminiApiKey;
  final String googleSafeBrowsingApiKey;
  final String virusTotalApiKey;

  /// Loads configuration using [environmentReader] or Dart defines by default.
  factory AppConfig.load({EnvironmentReader? environmentReader}) {
    final reader = environmentReader ?? const DartDefineEnvironmentReader();

    return AppConfig(
      geminiApiKey: reader.read(EnvKeys.geminiApiKey).trim(),
      googleSafeBrowsingApiKey:
          reader.read(EnvKeys.googleSafeBrowsingApiKey).trim(),
      virusTotalApiKey: reader.read(EnvKeys.virusTotalApiKey).trim(),
    );
  }

  String get geminiApiBaseUrl => EnvDefaults.geminiApiBaseUrl;
  String get googleSafeBrowsingApiBaseUrl =>
      EnvDefaults.googleSafeBrowsingApiBaseUrl;
  String get virusTotalApiBaseUrl => EnvDefaults.virusTotalApiBaseUrl;

  bool get hasGeminiApiKey => geminiApiKey.isNotEmpty;
  bool get hasGoogleSafeBrowsingApiKey => googleSafeBrowsingApiKey.isNotEmpty;
  bool get hasVirusTotalApiKey => virusTotalApiKey.isNotEmpty;

  /// Returns environment keys that are empty for [requiredKeys].
  List<String> missingKeys([
    Iterable<String> requiredKeys = EnvKeys.all,
  ]) {
    final missing = <String>[];

    for (final key in requiredKeys) {
      if (_valueForKey(key).isEmpty) {
        missing.add(key);
      }
    }

    return missing;
  }

  /// Validates that all [requiredKeys] are present.
  ///
  /// Throws [ValidationException] when one or more keys are missing.
  void validate({Iterable<String>? requiredKeys}) {
    final keys = requiredKeys ?? EnvKeys.all;
    final missing = missingKeys(keys);

    if (missing.isNotEmpty) {
      throw ValidationException(
        message:
            'Missing required environment variables: ${missing.join(', ')}. '
            'Provide them via --dart-define-from-file=.env.json',
        field: missing.first,
      );
    }
  }

  /// Validates Gemini-specific configuration.
  void validateGemini() {
    validate(requiredKeys: [EnvKeys.geminiApiKey]);
  }

  /// Validates Google Safe Browsing-specific configuration.
  void validateGoogleSafeBrowsing() {
    validate(requiredKeys: [EnvKeys.googleSafeBrowsingApiKey]);
  }

  /// Validates VirusTotal-specific configuration.
  void validateVirusTotal() {
    validate(requiredKeys: [EnvKeys.virusTotalApiKey]);
  }

  String _valueForKey(String key) {
    return switch (key) {
      EnvKeys.geminiApiKey => geminiApiKey,
      EnvKeys.googleSafeBrowsingApiKey => googleSafeBrowsingApiKey,
      EnvKeys.virusTotalApiKey => virusTotalApiKey,
      _ => '',
    };
  }
}
