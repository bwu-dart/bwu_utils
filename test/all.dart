library bwu_utils.test.all;

import 'server/network/network_test.dart' as snn;
import 'server/package/package_test.dart' as spp;
import 'shared/parse_num_test.dart' as sp;

main() {
  snn.main();
  spp.main();
  sp.main();
}
