import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter/services.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:squawker/client/app_http_client.dart';
import 'package:squawker/constants.dart';
import 'package:squawker/generated/l10n.dart';
import 'package:squawker/ui/errors.dart';
import 'package:path/path.dart' as p;
import 'package:pref/pref.dart';

const MethodChannel _flutterFileDialogChannel = MethodChannel(
  'flutter_file_dialog',
);
const MethodChannel _androidInfoChannel = MethodChannel(
  'squawker/android_info',
);

Future<void> downloadUriToPickedFile(
  BuildContext context,
  Uri uri,
  String fileName, {
  required Function() onStart,
  required Function() onSuccess,
}) async {
  var sanitizedFilename = _sanitizeFilename(fileName, uri);

  try {
    onStart();
    Future<Uint8List?> responseTask = downloadFile(context, uri);

    var response = await responseTask;
    if (response == null) {
      return;
    }

    final downloadType = PrefService.of(context).get(optionDownloadType);
    final downloadPathPref = PrefService.of(context).get(optionDownloadPath);
    final downloadPath = downloadPathPref is String ? downloadPathPref : '';

    // If the user wants to pick a file every time a download happens
    if (downloadType == optionDownloadTypeAsk) {
      var fileInfo = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          fileName: sanitizedFilename,
          data: response,
        ),
      );
      if (fileInfo == null) {
        return;
      }

      onSuccess();
      return;
    }

    bool saved = false;
    if (Platform.isAndroid && downloadPath.isEmpty) {
      final savedToDownloads = await _saveFileToAndroidDownloads(
        data: response,
        fileName: sanitizedFilename,
        mimeType: _guessMimeType(sanitizedFilename, uri),
      );
      saved = savedToDownloads != null;
    } else if (downloadPath.startsWith(optionDownloadPathDirectoryUriPrefix)) {
      final savedToPickedDirectory = await _saveFileToDirectoryUri(
        directoryUri: downloadPath.substring(
          optionDownloadPathDirectoryUriPrefix.length,
        ),
        data: response,
        fileName: sanitizedFilename,
        mimeType: _guessMimeType(sanitizedFilename, uri),
      );
      saved = savedToPickedDirectory != null;
    } else {
      saved = await _saveFileToPath(
        downloadPath: downloadPath,
        fileName: sanitizedFilename,
        data: response,
      );
    }

    if (!saved && Platform.isAndroid) {
      final savedToDownloads = await _saveFileToAndroidDownloads(
        data: response,
        fileName: sanitizedFilename,
        mimeType: _guessMimeType(sanitizedFilename, uri),
      );
      saved = savedToDownloads != null;
    }

    if (!saved) {
      // Legacy absolute paths may fail on scoped storage. Fall back to save dialog.
      var fileInfo = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          fileName: sanitizedFilename,
          data: response,
        ),
      );
      if (fileInfo != null) {
        onSuccess();
        return;
      }
      return;
    }

    onSuccess();
  } catch (e) {
    showSnackBar(context, icon: '🙊', message: e.toString());
  }
}

Future<String?> _saveFileToAndroidDownloads({
  required Uint8List data,
  required String fileName,
  required String mimeType,
}) async {
  try {
    return await _androidInfoChannel.invokeMethod<String>(
      'saveBytesToDownloads',
      {'data': data, 'fileName': fileName, 'mimeType': mimeType},
    );
  } catch (_) {
    return null;
  }
}

Future<bool> _saveFileToPath({
  required String downloadPath,
  required String fileName,
  required Uint8List data,
}) async {
  try {
    var savedFile = p.join(downloadPath, fileName);
    await Directory(downloadPath).create(recursive: true);
    await File(savedFile).writeAsBytes(data);
    if (Platform.isAndroid) {
      MediaScanner.loadMedia(path: savedFile);
    }
    return true;
  } catch (_) {
    return false;
  }
}

Future<String?> _saveFileToDirectoryUri({
  required String directoryUri,
  required Uint8List data,
  required String fileName,
  required String mimeType,
}) async {
  try {
    return await _flutterFileDialogChannel
        .invokeMethod<String>('saveFileToDirectory', {
          'directory': directoryUri,
          'data': data,
          'fileName': fileName,
          'mimeType': mimeType,
          'replace': true,
        });
  } catch (_) {
    return null;
  }
}

String _guessMimeType(String fileName, Uri uri) {
  var extension = p.extension(fileName).toLowerCase();
  if (extension.isEmpty) {
    extension = p.extension(uri.path).toLowerCase();
  }
  if (extension.isEmpty) {
    var formatExtension = _getExtensionFromUriFormat(uri);
    if (formatExtension != null) {
      extension = '.$formatExtension';
    }
  }

  switch (extension) {
    case '.jpg':
    case '.jpeg':
      return 'image/jpeg';
    case '.png':
      return 'image/png';
    case '.gif':
      return 'image/gif';
    case '.webp':
      return 'image/webp';
    case '.mp4':
      return 'video/mp4';
    case '.webm':
      return 'video/webm';
    case '.mov':
      return 'video/quicktime';
    case '.m4v':
      return 'video/x-m4v';
    case '.mp3':
      return 'audio/mpeg';
    case '.m4a':
      return 'audio/mp4';
    default:
      return 'application/octet-stream';
  }
}

String _sanitizeFilename(String fileName, Uri uri) {
  var sanitized = p.basename(fileName.split("?")[0]);
  sanitized = sanitized.replaceFirst(RegExp(r':[A-Za-z0-9_]+$'), '');
  sanitized = sanitized.replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_').trim();
  if (sanitized.isEmpty) {
    sanitized = 'download';
  }

  if (p.extension(sanitized).isEmpty) {
    var formatExtension = _getExtensionFromUriFormat(uri);
    if (formatExtension != null) {
      sanitized = '$sanitized.$formatExtension';
    }
  }

  return sanitized;
}

String? _getExtensionFromUriFormat(Uri uri) {
  var format = uri.queryParameters['format'];
  if (format == null || format.isEmpty) {
    return null;
  }

  format = format.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  if (format.isEmpty) {
    return null;
  }

  if (format == 'jpeg') {
    return 'jpg';
  }

  return format;
}

Uri buildBestPhotoDownloadUri(String mediaUrl) {
  var parsed = Uri.parse(mediaUrl);
  var format = parsed.queryParameters['format'];
  if (format != null && format.isNotEmpty) {
    var queryParameters = Map<String, String>.from(parsed.queryParameters);
    queryParameters['name'] = 'orig';
    return parsed.replace(queryParameters: queryParameters);
  }

  var path = parsed.path.contains(':')
      ? parsed.path.replaceFirst(RegExp(r':[A-Za-z0-9_]+$'), ':orig')
      : '${parsed.path}:orig';
  return parsed.replace(path: path);
}

class UnableToSaveMedia {
  final Uri uri;
  final Object e;

  UnableToSaveMedia(this.uri, this.e);

  @override
  String toString() {
    return 'Unable to save the media {uri: $uri, e: $e}';
  }
}

Future<Uint8List?> downloadFile(BuildContext context, Uri uri) async {
  var response = await AppHttpClient.httpGet(uri);
  if (response.statusCode != 200) {
    response = await AppHttpClient.httpGet(
      uri,
      headers: {
        'User-Agent': 'Mozilla/5.0',
        'Referer': 'https://x.com/',
        'Origin': 'https://x.com',
        'Accept': '*/*',
      },
    );
  }

  if (response.statusCode == 200) {
    return response.bodyBytes;
  }

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        L10n.of(
          context,
        ).unable_to_save_the_media_twitter_returned_a_status_of_response_statusCode(
          response.statusCode,
        ),
      ),
    ),
  );

  return null;
}
