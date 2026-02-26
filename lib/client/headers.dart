import 'dart:convert';
import 'package:pref/pref.dart';
import 'dart:math';
import 'package:squawker/client/app_http_client.dart';
import 'package:squawker/database/entities.dart';
import 'package:squawker/constants.dart';

import 'accounts.dart';

class TwitterHeaders {
  static final Map<String, String> _baseHeaders = {
    'accept': '*/*',
    'accept-language': 'en-US,en;q=0.9',
    'authorization': bearerToken,
    'cache-control': 'no-cache',
    'content-type': 'application/json',
    'pragma': 'no-cache',
    'priority': 'u=1, i',
    'referer': 'https://x.com/',
    'user-agent': userAgentHeader['user-agent']!,
    'x-twitter-active-user': 'yes',
    'x-twitter-client-language': 'en',
  };

  static Future<Map<String, String>?> getXClientTransactionIdHeader(
    Uri? uri,
  ) async {
    if (uri == null) {
      return null;
    }

    final path = uri.path;
    final prefs = await PrefServiceShared.init(prefix: 'pref_');
    final xClientTransactionIdDomain =
        prefs.get(optionXClientTransactionIdProvider) ??
        optionXClientTransactionIdProviderDefaultDomain;
    final xClientTransactionUriEndPoint = Uri.https(
      xClientTransactionIdDomain,
      '/generate-x-client-transaction-id',
      {'path': path},
    );

    try {
      final response = await AppHttpClient.httpGet(
        xClientTransactionUriEndPoint,
      );

      if (response.statusCode == 200) {
        final xClientTransactionId = jsonDecode(
          response.body,
        )['x-client-transaction-id'];
        return {'x-client-transaction-id': xClientTransactionId};
      } else {
        throw Exception(
          'Failed to get x-client-transaction-id. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting x-client-transaction-id: $e');
    }
  }

  static Future<Map<String, String>> getHeaders(
    Uri? uri, {
    Map<String, String>? authHeader,
  }) async {
    final resolvedAuthHeader = authHeader ?? await getAuthHeader();
    final xClientTransactionIdHeader = await getXClientTransactionIdHeader(uri);
    return {
      ..._baseHeaders,
      ...?resolvedAuthHeader,
      ...?xClientTransactionIdHeader,
    };
  }

  static Future<Map<String, String>?> getAuthHeader() async {
    final accounts = await getAccounts();
    if (accounts.isEmpty) {
      return null;
    }
    Account account = accounts[Random().nextInt(accounts.length)];
    final authHeader = Map<String, String>.from(
      json.decode(account.authHeader) as Map,
    );
    return authHeader;
  }
}
