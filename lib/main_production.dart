import 'package:spooky/flavor_config.dart';
import 'package:spooky/main.dart' as app;

void main() {
  FlavorConfig(flavor: Flavor.production);
  app.main();
}
