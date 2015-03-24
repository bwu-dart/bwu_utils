library bwu_utils.test.server.network;

import 'dart:io' as io;
import 'package:bwu_utils/testing_server.dart';

void isValidPortNumber(int port) {
  print(port);
  expect(port > 1000 && port <= maxIpV4PortNumber, isTrue);
}

void main() {
  initLogging();
  group('network_test', () {
    test('getNextFreeIpPort', () {
      // set up
      //final done = expectAsync((){}, count: 5);

      // exercise
      return getNextFreeIpPort(io.InternetAddress.LOOPBACK_IP_V4.address)
          .then(isValidPortNumber)
          .then((_) => getNextFreeIpPort(
                  io.InternetAddress.LOOPBACK_IP_V6.address)
              .then(isValidPortNumber))
          .then((_) => getNextFreeIpPort(io.InternetAddress.ANY_IP_V4.address)
              .then(isValidPortNumber))
          .then((_) => getNextFreeIpPort(
                  io.InternetAddress.LOOPBACK_IP_V6.address)
              .then(isValidPortNumber))
          .then((_) {
        final someIp = new io.InternetAddress('195.96.0.1');
        final done = expectAsync(() {});
        return getNextFreeIpPort(someIp).catchError((e) {
          expect(e, isException);
          done();
        });
      });

      // verification
      // tear down
    });
  });
}
