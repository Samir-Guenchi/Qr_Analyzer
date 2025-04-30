// lib/services/url_checker_service.dart
// If you already have this file, you don't need to create it again

import 'dart:convert';
import 'package:http/http.dart' as http;

class UrlCheckResult {
  final bool safe;
  final String message;

  UrlCheckResult({required this.safe, required this.message});
}

class UrlCheckerService {
  Future<UrlCheckResult> checkUrl(String url) async {
    try {
      // Check if the URL is valid
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        if (url.contains('.') && !url.contains(' ')) {
          url = 'https://$url';
        } else {
          return UrlCheckResult(
            safe: false,
            message: 'Invalid URL format.',
          );
        }
      }

      // You can implement a real API call to check URL safety here
      // For example, using Google Safe Browsing API, Virus Total, etc.
      
      // For now, we'll implement a simple mock check
      final result = await _mockCheckUrl(url);
      return result;
    } catch (e) {
      return UrlCheckResult(
        safe: false,
        message: 'Error checking URL safety: ${e.toString()}',
      );
    }
  }

  Future<UrlCheckResult> _mockCheckUrl(String url) async {
    // Simple mock implementation
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // Consider some domains unsafe for demonstration
    final unsafeDomains = [
      'evil.com',
      'malware.com',
      'phishing.com',
      'scam.com',
      'virus.com',
    ];

    // Check if URL contains any unsafe domain
    for (final domain in unsafeDomains) {
      if (url.contains(domain)) {
        return UrlCheckResult(
          safe: false,
          message: 'This URL may be unsafe. It matches a known malicious pattern.',
        );
      }
    }

    // In a real app, you'd make an API call to a security service here
    return UrlCheckResult(
      safe: true,
      message: 'URL appears to be safe.',
    );
  }
}