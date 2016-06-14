library bwu_utils.server.network;

import 'dart:io' as io;
import 'dart:async' show Future;

/// validIpAddressRegExp matches valid IP addresses and ValidHostnameRegex valid
/// host names.
/// See also http://stackoverflow.com/questions/106179
const String validHostIpRegExp =
    r'(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])';

/// ValidHostnameRegex is valid as per
/// [RFC 1123](http://tools.ietf.org/html/rfc1123). Originally,
/// [RFC 952](http://tools.ietf.org/html/rfc952) specified
/// that hostname segments could not start with a digit.
const String validHostnameRegExp =
    r'(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|'
    r'[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])';

/// The original specification of hostnames in
/// [RFC 952](http://tools.ietf.org/html/rfc952), mandated that labels could not
/// start with a digit or with a hyphen, and must not end with a hyphen. However,
/// a subsequent specification ([RFC 1123](http://tools.ietf.org/html/rfc1123)
/// permitted hostname labels to start with digits.
const String valid952HostnameRegExp =
    r'(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z]'
    r'[A-Za-z0-9\-]*[A-Za-z0-9])';

/// The maximal valid port number for IPV4 and IPV6
const int maxIpV4PortNumber = 65535;

/// Returns a free IP port form the specified interface.
Future<int> getFreeIpPort([dynamic host]) async {
  if (host == null) {
    host = io.InternetAddress.LOOPBACK_IP_V4;
  }
  final io.ServerSocket socket = await io.ServerSocket.bind(host, 0);
  final int port = socket.port;
  await socket.close();
  return port;
}
