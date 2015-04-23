@TestOn('vm')
library bwu_utils.test.grinder.dart_archive_downloader;

import 'dart:io' as io;
import 'package:path/path.dart' as path;
import 'package:bwu_utils/testing_server.dart';
import 'package:bwu_utils/grinder/dart_archive_downloader.dart';

void main([List<String> args]) {
  initLogging(args);

  group('getVersions', () {
    test('release channel', () async {
      // set up
      final downloader = new DartArchiveDownloader(StableChannel.release);

      // exercise
      final versions = await downloader.getVersions().expand((e) => e).toList();

      // verification
      expect(versions, contains('29803'));
      expect(versions, contains('45104'));
      // tear down
    });

    test('all channels', () async {
      // set up
      int maxCount = 0;
      int minCount = 10000;
      final allChannels = <Channel>[]
        ..addAll(BleedingEdgeChannel.values)
        ..addAll(DevChannel.values)
        ..addAll(StableChannel.values);

      for (final channel in allChannels) {
        // exercise
        final downloader = new DartArchiveDownloader(channel);
        final versions =
            await downloader.getVersions(2001).expand((e) => e).toList();

        // verification
        if (versions.length > maxCount) {
          maxCount = versions.length;
        }
        if (versions.length < minCount) {
          minCount = versions.length;
        }
        expect(versions.length, greaterThan(10));
        expect(versions, everyElement(isNum));
      }
      expect(maxCount, greaterThan(2000));
      expect(maxCount, greaterThan(0));
      print('minCount. $minCount');
      print('maxCount. $maxCount');
      // tear down
    }, timeout: const Timeout(const Duration(seconds: 60)), skip: 'slow');

    test('load specific version info', () async {
      // set up

      // exercise
      final versionInfo =
          await new DartArchiveDownloader(BleedingEdgeChannel.raw)
              .getVersionInfo('45373');

      // verification
      expect(versionInfo['revision'], '45373');
      expect(versionInfo['version'], '1.11.0-edge.45373');
      expect(versionInfo['date'], startsWith('2015042303'));

      // tear down
    });

    test('load latest version info', () async {
      // set up

      // exercise
      final versionInfo = await new DartArchiveDownloader(StableChannel.release)
          .getVersionInfo('latest');

      // verification
      expect(versionInfo['revision'].length, greaterThanOrEqualTo(5));
      expect(versionInfo['version'].length, greaterThanOrEqualTo(5));
      expect(versionInfo['date'].length, 12);
      print(versionInfo);
      // tear down
    });
  });

  group('getFileRequest', () {
    test('load file', () async {
      // set up
      const fileName = 'chromedriver-linux-x64-release.zip';
      // exercise
      //io.Directory.createTemp()
      final downloader = new DartArchiveDownloader(BleedingEdgeChannel.raw);
      io.Directory tempDir;
      try {
        tempDir = await io.Directory.systemTemp.createTemp();
        final io.File destination =
            await new io.File(path.join(tempDir.absolute.path, fileName))
                .create();
        print(destination.absolute.path);

        final fileSink = destination.openWrite();

        final request =
            await downloader.getFileRequest('latest', 'dartium/${fileName}');
        final response = await request.close();

        await fileSink.addStream(response);

        // verification
        final fileSize = await destination.length();
        expect(fileSize, 2744935);
      } finally {
        // tear down
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      }
    });
  } /*, timeout: const Timeout(const Duration(seconds: 60))*/, skip: 'temporary');

  group('downloadFile', () {
    test('load file', () async {
      // set up
      const fileName = 'chromedriver-linux-x64-release.zip';
      // exercise
      //io.Directory.createTemp()
      final downloader = new DartArchiveDownloader(BleedingEdgeChannel.raw);
      io.Directory tempDir;
      try {
        tempDir = await io.Directory.systemTemp.createTemp();
        final io.File destination =
            new io.File(path.join(tempDir.absolute.path, fileName));
        print(destination.absolute.path);
        await downloader.downloadFile('latest', 'dartium/${fileName}', destination);
                // verification
        final fileSize = await destination.length();
        expect(fileSize, 2744935);

      } finally {
        // tear down
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      }
    });
  });
}
