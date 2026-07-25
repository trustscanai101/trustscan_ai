/// API endpoint paths for external service integrations.
abstract final class ApiEndpoints {
  ApiEndpoints._();

  // Gemini AI endpoints
  static const String geminiModels = '/models';
  static const String geminiGenerateContent = '/models/{model}:generateContent';
  static const String geminiStreamGenerateContent = '/models/{model}:streamGenerateContent';

  // Google Safe Browsing endpoints
  static const String safeBrowsingThreatMatches = '/threatMatches:find';
  static const String safeBrowsingThreatLists = '/threatLists';
  static const String safeBrowsingThreatListUpdates = '/threatListUpdates:fetch';

  // VirusTotal endpoints
  static const String virusTotalUrls = '/urls';
  static const String virusTotalFiles = '/files';
  static const String virusTotalDomains = '/domains';
  static const String virusTotalIpAddresses = '/ip_addresses';
}
