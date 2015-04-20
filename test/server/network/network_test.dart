@TestOn('vm')
library bwu_utils.test.server.network;

import 'dart:io' as io;
import 'package:bwu_utils/testing_server.dart';

void isValidPortNumber(int port) {
  expect(port > 1000 && port <= maxIpV4PortNumber, isTrue);
}

void main([List<String> args]) {
  initLogging(args);
  group('network_test', () {
    test('getNextFreeIpPort', () async {
      // set up

      // exercise
      var port =
          await getNextFreeIpPort(io.InternetAddress.LOOPBACK_IP_V4.address);
      isValidPortNumber(port);
      port = await getNextFreeIpPort(io.InternetAddress.LOOPBACK_IP_V6.address);
      isValidPortNumber(port);
      port = await getNextFreeIpPort(io.InternetAddress.ANY_IP_V4.address);
      isValidPortNumber(port);
      port = await getNextFreeIpPort(io.InternetAddress.LOOPBACK_IP_V6.address);
      isValidPortNumber(port);
      final someIp = new io.InternetAddress('195.96.0.1');
      expect(getNextFreeIpPort(someIp),
          throwsA(new isInstanceOf<io.SocketException>()));

      // verification
      // tear down
    });
  });
}
