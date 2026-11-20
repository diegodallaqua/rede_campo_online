import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rede_campo_online/core/repositories/token_repository.dart';

String _tokenWith(Map<String, dynamic> payload) =>
    JWT(payload).sign(SecretKey('test-secret'), noIssueAt: true);

int _epochSeconds(DateTime date) => date.millisecondsSinceEpoch ~/ 1000;

void main() {
  final now = DateTime.utc(2026, 1, 1, 12);

  group('TokenRepository.isTokenUnexpired', () {
    test('returns true when exp is well in the future', () {
      final token = _tokenWith(
        {'exp': _epochSeconds(now.add(const Duration(hours: 1)))},
      );

      expect(TokenRepository.isTokenUnexpired(token, now: now), isTrue);
    });

    test('returns false when exp is in the past', () {
      final token = _tokenWith(
        {'exp': _epochSeconds(now.subtract(const Duration(minutes: 1)))},
      );

      expect(TokenRepository.isTokenUnexpired(token, now: now), isFalse);
    });

    test('returns false inside the 30s safety margin', () {
      final token = _tokenWith(
        {'exp': _epochSeconds(now.add(const Duration(seconds: 20)))},
      );

      expect(TokenRepository.isTokenUnexpired(token, now: now), isFalse);
    });

    test('returns false when exp is missing', () {
      final token = _tokenWith({'sub': '42'});

      expect(TokenRepository.isTokenUnexpired(token, now: now), isFalse);
    });

    test('throws on a malformed token', () {
      expect(
        () => TokenRepository.isTokenUnexpired('not-a-jwt', now: now),
        throwsA(anything),
      );
    });
  });
}
