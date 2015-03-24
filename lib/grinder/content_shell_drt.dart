library bwu_utils.grinder.content_shell_drt;

import 'dart:io' as io;
import 'dart:async' show Future, Stream;
import 'package:grinder/grinder.dart';

/// A browser implementation which runs ContentShell with --dump-render-tree
/// for headless web test runs.
class ContentShellDrt extends ContentShell {
  io.Directory _tempDir;

  ContentShellDrt() {
    _tempDir = io.Directory.systemTemp.createTempSync('userDataDir-');
  }

  void launchFile(GrinderContext context, String filePath,
      {bool verbose: false, Map envVars}) {
    String url;

    if (new io.File(filePath).existsSync()) {
      url = 'file:/' + new io.Directory(filePath).absolute.path;
    } else {
      url = filePath;
    }

    List<String> args = [
      '--dump-render-tree',
      '--no-default-browser-check',
      '--no-first-run',
      '--user-data-dir=${_tempDir.path}'
    ];

    if (verbose) {
      args.addAll(['--enable-logging=stderr', '--v=1']);
    }

    args.add(url);

    // TODO: This process often won't terminate, so that's a problem.
    context.log("starting chrome...");
    runProcess(context, browserPath, arguments: args, environment: envVars);
  }

  Future<BrowserInstance> launchUrl(GrinderContext context, String url,
      {List<String> args, bool verbose: false, Map envVars}) {
    final _args = ['--dump-render-tree'];
    if (args != null) {
      _args.addAll(args);
    }

    return super.launchUrl(context, url,
        args: _args, verbose: verbose, envVars: envVars);
  }
}
