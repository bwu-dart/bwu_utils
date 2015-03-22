library bwu_utils.test.all;

import 'server/network/network_test.dart' as srv_nw;
import 'server/package/package_test.dart' as srv_pkg;

void main() {
  srv_nw.main();
  srv_pkg.main();
}
