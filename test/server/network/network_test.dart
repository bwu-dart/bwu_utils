@TestOn('vm')
library bwu_utils.test.server.network;

import 'dart:io' as io;
import 'package:test/test.dart';
import 'package:bwu_utils/bwu_utils_server.dart';

void isValidPortNumber(int port) {
  expect(port > 1000 && port <= maxIpV4PortNumber, isTrue);
}

void main([List<String> args]) {
  group('network_test', () {
    test('getNextFreeIpPort', () async {
      // set up

      // exercise
      var port = await getFreeIpPort(io.InternetAddress.LOOPBACK_IP_V4.address);
      isValidPortNumber(port);
      port = await getFreeIpPort(io.InternetAddress.LOOPBACK_IP_V6.address);
      isValidPortNumber(port);
      port = await getFreeIpPort(io.InternetAddress.ANY_IP_V4.address);
      isValidPortNumber(port);
      port = await getFreeIpPort(io.InternetAddress.LOOPBACK_IP_V6.address);
      isValidPortNumber(port);
      final someIp = new io.InternetAddress('195.96.0.1');
      expect(getFreeIpPort(someIp),
          throwsA(new isInstanceOf<io.SocketException>()));

      // verification
      // tear down
    });
  });
}
