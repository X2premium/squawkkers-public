import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cache/flutter_cache.dart' as cache;
import 'package:squawker/client/app_http_client.dart';
import 'package:squawker/utils/iterables.dart';
import 'package:squawker/utils/misc.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

Future<bool> isLanguageSupportedForTranslation(String lang) async {
  // TODO: Cache this response, per host, for x amount of time
  var res = await TranslationAPI.getSupportedLanguages();
  if (res.success) {
    return findInJSONArray(res.body, 'code', lang);
  }

  throw res;
}

class TranslationAPIResult {
  final bool success;
  final dynamic body;
  final String? errorMessage;

  TranslationAPIResult({
    required this.success,
    required this.body,
    this.errorMessage,
  });
}

// TODO
class TranslationAPI {
  static final log = Logger('TranslationAPI');

  // other possibilities not working currently:
  //   translate.astian.org, translate.foxhaven.cyou, trans.zillyhuhn.com
  // other possibilities working but badly translated:
  //   translate.terraprint.co
  static final default_translation_hosts = [
    {'host': 'libretranslate.de', 'api_key': null},
    {'host': 'translate.fedilab.app', 'api_key': null},
    {'host': 'translate.argosopentech.com', 'api_key': null},
  ];
  static List<Map<String, dynamic>>? _translation_hosts;
  static int current_translation_host_idx =
      0; // Random().nextInt(translation_hosts.length);
  static Map<String, String> langCodeReplace = {'iw': 'he', 'in': 'id'};

  static List<Map<String, dynamic>> translationHosts() {
    _translation_hosts ??= default_translation_hosts;
    return _translation_hosts!;
  }

  static int translationHostsLength() {
    _translation_hosts ??= default_translation_hosts;
    return _translation_hosts!.length;
  }

  static Map<String, dynamic> translationHost() {
    _translation_hosts ??= default_translation_hosts;
    return _translation_hosts![current_translation_host_idx];
  }

  static Map<String, dynamic> nextTranslationHost() {
    _translation_hosts ??= default_translation_hosts;
    current_translation_host_idx++;
    if (current_translation_host_idx == _translation_hosts!.length) {
      current_translation_host_idx = 0;
    }
    return translationHost();
  }

  static String setTranslationHosts(
    List<Map<String, dynamic>>? translationHosts,
  ) {
    _translation_hosts = translationHosts;
    _translation_hosts ??= default_translation_hosts;
    return jsonEncode(_translation_hosts);
  }

  static List<Map<String, dynamic>> setTranslationHostsFromStr(
    String? translationHosts,
  ) {
    if (translationHosts == null) {
      _translation_hosts = default_translation_hosts;
    } else {
      List<Map<String, dynamic>> lst = [];
      for (dynamic item in jsonDecode(translationHosts)) {
        lst.add(item);
      }
      _translation_hosts = lst;
    }
    return _translation_hosts!;
  }

  static Future<TranslationAPIResult> getSupportedLanguages() async {
    var key = 'translation.supported_languages';

    return cacheRequest(key, () async {
      int connectTries = 0;
      String? errorMessage;
      while (connectTries < translationHostsLength()) {
        String trHost = translationHost()['host'];
        try {
          var response = await AppHttpClient.httpGet(
            Uri.https(trHost, '/languages'),
          ).timeout(const Duration(seconds: 3));
          TranslationAPIResult rsp = await parseResponse(response);
          if (rsp.success) {
            return rsp;
          } else {
            errorMessage ??=
                'get supported languages error ${rsp.errorMessage} from host $trHost';
            log.warning(
              'get supported languages error ${rsp.errorMessage} from host $trHost',
            );
          }
        } on TimeoutException {
          errorMessage ??= 'get supported languages timeout from host $trHost';
          log.warning('get supported languages timeout from host $trHost');
        } catch (exc) {
          errorMessage ??=
              'get supported languages error from $trHost\n${exc.toString()}';
          log.warning(
            'get supported languages error from $trHost\n${exc.toString()}',
          );
        }
        nextTranslationHost();
        connectTries++;
      }
      return TranslationAPIResult(
        success: false,
        body: '',
        errorMessage: errorMessage ?? 'Unable to get supported languages',
      );
      //throw Exception('Unable to get supported languages');
    });
  }

  static Future<TranslationAPIResult> translate(
    BuildContext context,
    String id,
    List<String> text,
    String sourceLanguage,
  ) async {
    var actualSourceLanguage = langCodeReplace.containsKey(sourceLanguage)
        ? langCodeReplace[sourceLanguage]
        : sourceLanguage;
    var hasTextOrNot = text.map((e) => e.isNotEmpty ? true : false).toList();
    var targetLanguage = Localizations.localeOf(context).languageCode;

    var formData = {
      // We need to strip out any empty parts, as the API barfs on them sometimes
      'q': text.where((e) => e.isNotEmpty).toList(),
      'source': actualSourceLanguage,
      'target': targetLanguage,
      'format': 'text',
    };

    var key = 'translation.$actualSourceLanguage.$targetLanguage.$id';

    var res = await cacheRequest(key, () async {
      int connectTries = 0;
      String? errorMessage;
      while (connectTries < translationHostsLength()) {
        String trHost = translationHost()['host'];
        var data = {...formData, 'api_key': translationHost()['api_key']};
        try {
          var response = await AppHttpClient.httpPost(
            Uri.https(trHost, '/translate'),
            body: jsonEncode(data),
            headers: {'Content-Type': 'application/json'},
          ).timeout(const Duration(seconds: 3));
          TranslationAPIResult rsp = await parseResponse(response);
          if (rsp.success) {
            return rsp;
          } else {
            errorMessage ??=
                'translate error ${rsp.errorMessage} from host $trHost';
            log.warning(
              'translate error ${rsp.errorMessage} from host $trHost',
            );
          }
        } on TimeoutException {
          errorMessage ??= 'translate timeout from host $trHost';
          log.warning('translate timeout from host $trHost');
        } catch (exc) {
          errorMessage ??= 'translate error from $trHost\n${exc.toString()}';
          log.warning('translate error from $trHost\n${exc.toString()}');
        }
        nextTranslationHost();
        connectTries++;
      }
      return TranslationAPIResult(
        success: false,
        body: '',
        errorMessage: errorMessage ?? 'Unable to send translation request',
      );
      //throw Exception('Unable to send translation request');
    });

    if (res.success) {
      // We need to rehydrate the empty text parts that we stripped out earlier
      var translatedTexts = List.from(res.body['translatedText']);

      var translatedIndex = 0;
      var result = hasTextOrNot
          .mapWithIndex(
            (hasText, i) =>
                hasText ? translatedTexts[translatedIndex++] : text[i],
          )
          .toList();

      return TranslationAPIResult(
        success: res.success,
        body: {'translatedText': result},
      );
    }

    return res;
  }

  static Future<TranslationAPIResult> cacheRequest(
    String key,
    Future<TranslationAPIResult> Function() makeRequest,
  ) async {
    var result = await cache.load(key);
    if (result is String && result.isNotEmpty) {
      try {
        return TranslationAPIResult(success: true, body: jsonDecode(result));
      } on FormatException {
        // Ignore invalid cache payloads and fetch a fresh response.
      }
    }

    // Otherwise, make the request
    var response = await makeRequest();
    if (response.success) {
      // Cache the response if it's a successful one
      await cache.write(key, jsonEncode(response.body));

      return TranslationAPIResult(success: true, body: response.body);
    }

    // Otherwise, we always want to return the error without caching
    return response;
  }

  static Future<TranslationAPIResult> parseResponse(
    http.Response response,
  ) async {
    // the server does not return a content-type header with the UTF-8 charset specified, so we must force the decoding from UTF-8
    var body = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return TranslationAPIResult(success: true, body: body);
    }

    String message = '';

    switch (response.statusCode) {
      case 400:
        RegExp languageNotSupported = RegExp(r"^\w+ is not supported$");

        var error = body['error'];
        if (languageNotSupported.hasMatch(error)) {
          message = 'Language $error';
        } else {
          message = error;
        }
        break;
      case 403:
        message = 'Error: Banned from translation API';
        break;
      case 429:
        message = 'Error: Sending too many frequent translation requests';
        break;
      case 500:
        message = 'Error: The translation API failed to translate the tweet';
        break;
      case 502:
        message = 'Error: The translation API site is unreachable';
        break;
    }

    return TranslationAPIResult(
      success: false,
      body: body,
      errorMessage: message,
    );
  }
}
