@TestOn('vm')
library bwu_utils.test.grinder.dart_archive_downloader;

import 'package:bwu_utils/testing_server.dart';
import 'package:bwu_utils/grinder/download_content_shell.dart';


void main([List<String> args]) {
  initLogging(args);
  group('getVersions', () {
    test('release channel', () async {
      // set up
      final downloader = new DartArchiveDownloader(StableChannel.release);

      // exercise
      final versions = await downloader.getVersions().expand((e) => e).toList();
      print(versions);

      // verification
      print(versions);
      expect(versions, contains('29803'));
      expect(versions, contains('45104'));
      // tear down
    });

    test('all channels', () async {
      // set up
      final allChannels = <Channel>[]..addAll(BleedingEdgeChannel.values)..addAll(DevChannel.values)..addAll(StableChannel.values);
      for(final channel in allChannels) {
        // exercise
        final downloader = new DartArchiveDownloader(channel);
        final versions = await downloader.getVersions(100).drain();

        // verification
        expect(versions.length, greaterThan(10));
        expect(versions, everyElement(isNum));
      }
      // tear down
    });
  });
}
