import 'package:flutter_test/flutter_test.dart';
import 'package:trustscan_ai/core/config/app_config.dart';
import 'package:trustscan_ai/core/config/env.dart';
import 'package:trustscan_ai/core/error/exceptions.dart';

void main() {
  group('AppConfig.load', () {
    test('loads and trims environment values from reader', () {
      final config = AppConfig.load(
        environmentReader: MapEnvironmentReader({
          EnvKeys.geminiApiKey: '  gemini-key  ',
          EnvKeys.googleSafeBrowsingApiKey: 'safe-browsing-key',
          EnvKeys.virusTotalApiKey: 'virustotal-key',
        }),
      );

      expect(config.geminiApiKey, 'gemini-key');
      expect(config.googleSafeBrowsingApiKey, 'safe-browsing-key');
      expect(config.virusTotalApiKey, 'virustotal-key');
    });

    test('exposes typed provider accessors', () {
      final config = AppConfig.load(
        environmentReader: MapEnvironmentReader({
          EnvKeys.geminiApiKey: 'gemini-key',
          EnvKeys.googleSafeBrowsingApiKey: 'safe-browsing-key',
          EnvKeys.virusTotalApiKey: 'virustotal-key',
        }),
      );

      expect(config.hasGeminiApiKey, isTrue);
      expect(config.hasGoogleSafeBrowsingApiKey, isTrue);
      expect(config.hasVirusTotalApiKey, isTrue);
      expect(
        config.geminiApiBaseUrl,
        EnvDefaults.geminiApiBaseUrl,
      );
      expect(
        config.googleSafeBrowsingApiBaseUrl,
        EnvDefaults.googleSafeBrowsingApiBaseUrl,
      );
      expect(
        config.virusTotalApiBaseUrl,
        EnvDefaults.virusTotalApiBaseUrl,
      );
    });
  });

  group('AppConfig.missingKeys', () {
    test('returns all missing keys when values are empty', () {
      const config = AppConfig(
        geminiApiKey: '',
        googleSafeBrowsingApiKey: '',
        virusTotalApiKey: '',
      );

      expect(config.missingKeys(), EnvKeys.all);
    });

    test('returns only missing keys from required subset', () {
      const config = AppConfig(
        geminiApiKey: 'gemini-key',
        googleSafeBrowsingApiKey: '',
        virusTotalApiKey: 'virustotal-key',
      );

      expect(
        config.missingKeys([EnvKeys.googleSafeBrowsingApiKey]),
        [EnvKeys.googleSafeBrowsingApiKey],
      );
    });
  });

  group('AppConfig.validate', () {
    test('passes when all required keys are present', () {
      const config = AppConfig(
        geminiApiKey: 'gemini-key',
        googleSafeBrowsingApiKey: 'safe-browsing-key',
        virusTotalApiKey: 'virustotal-key',
      );

      expect(() => config.validate(), returnsNormally);
    });

    test('throws ValidationException when keys are missing', () {
      const config = AppConfig(
        geminiApiKey: '',
        googleSafeBrowsingApiKey: 'safe-browsing-key',
        virusTotalApiKey: '',
      );

      expect(
        () => config.validate(),
        throwsA(
          isA<ValidationException>()
              .having(
                (error) => error.message,
                'message',
                allOf(
                  contains(EnvKeys.geminiApiKey),
                  contains(EnvKeys.virusTotalApiKey),
                  contains('--dart-define-from-file=.env.json'),
                ),
              )
              .having((error) => error.field, 'field', EnvKeys.geminiApiKey),
        ),
      );
    });

    test('validateGemini validates only Gemini key', () {
      const config = AppConfig(
        geminiApiKey: '',
        googleSafeBrowsingApiKey: 'safe-browsing-key',
        virusTotalApiKey: 'virustotal-key',
      );

      expect(() => config.validateGemini(), throwsA(isA<ValidationException>()));
      expect(() => config.validateGoogleSafeBrowsing(), returnsNormally);
      expect(() => config.validateVirusTotal(), returnsNormally);
    });

    test('validateGoogleSafeBrowsing validates only Safe Browsing key', () {
      const config = AppConfig(
        geminiApiKey: 'gemini-key',
        googleSafeBrowsingApiKey: '',
        virusTotalApiKey: 'virustotal-key',
      );

      expect(() => config.validateGemini(), returnsNormally);
      expect(
        () => config.validateGoogleSafeBrowsing(),
        throwsA(isA<ValidationException>()),
      );
      expect(() => config.validateVirusTotal(), returnsNormally);
    });

    test('validateVirusTotal validates only VirusTotal key', () {
      const config = AppConfig(
        geminiApiKey: 'gemini-key',
        googleSafeBrowsingApiKey: 'safe-browsing-key',
        virusTotalApiKey: '',
      );

      expect(() => config.validateGemini(), returnsNormally);
      expect(() => config.validateGoogleSafeBrowsing(), returnsNormally);
      expect(
        () => config.validateVirusTotal(),
        throwsA(isA<ValidationException>()),
      );
    });
  });
}
