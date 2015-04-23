library bwu_utils.grinder.download_content_shell;

import 'dart:io' as io;
import 'dart:async' show Completer, Future, Stream;
import 'package:html/parser.dart' show parse;

abstract class Channel {
  const Channel();
}

class BleedingEdgeChannel extends Channel {
  static const raw = const BleedingEdgeChannel('be/raw');

  static const values = const [raw];

  final String value;

  const BleedingEdgeChannel(this.value);

  @override
  String toString() => value;
}

class DevChannel extends Channel {
  static const raw = const DevChannel('dev/raw');
  static const release = const DevChannel('dev/release');
  static const signed = const DevChannel('dev/signed');

  static const values = const [raw, release, signed];

  final String value;

  const DevChannel(this.value);

  @override
  String toString() => value;
}

class StableChannel extends Channel {
  static const raw = const StableChannel('stable/raw');
  static const release = const StableChannel('stable/release');
  static const signed = const StableChannel('stable/signed');

  final String value;

  const StableChannel(this.value);

  static const values = const [raw, release, signed];

  @override
  String toString() => value;
}

class DartArchiveDownloader {
  final Channel channel;

  DartArchiveDownloader([this.channel = StableChannel.release]);

  Stream<Iterable<String>> getVersions([int loadCount = 100]) async* {

    int valuesReturned = 0;
    _ParseResult parseResult;
    Uri nextPage = Uri.parse('http://gsdview.appspot.com/dart-archive/channels/${channel}/');
    do {
      final data = await _loadUrl(nextPage);
      parseResult = _parseVersions(data);
      yield parseResult.versions;

      valuesReturned = parseResult.versions.length;
    }
    while(valuesReturned < loadCount && parseResult.nextPage != null);

  }

  static Future<List<int>> _loadUrl(Uri uri) async {
    final doneCompleter = new Completer<List<int>>();
    print(uri);
    final io.HttpClientRequest request = await new io.HttpClient().getUrl(uri);
      final responseData = <int>[];
      request.close().then((response) {
        response.listen((data) {
          responseData.addAll(data);
        }, onDone: () {
          doneCompleter.complete(responseData);
        });
      });
    return doneCompleter.future;

  }

  static _ParseResult _parseVersions(List<int> html) {
    final Iterable<String> links = parse(html)
        .querySelectorAll('a[href]')
        .map((a) =>
            a.attributes['href'].split('/').where((e) => e.isNotEmpty).last);
    final versions = links
        .where((a) => new RegExp(r'^\d*$').hasMatch(a));
    final nextPageLinks = links.where((a) => a.startsWith('?marker='));
    final nextPageLink = nextPageLinks.length == 1 ? Uri.parse(nextPageLinks.first) : null;
    return new _ParseResult(versions, nextPageLink);
  }
}

class _ParseResult {
  Iterable<String> versions;
  Uri nextPage;
  _ParseResult(this.versions, this.nextPage);
}
