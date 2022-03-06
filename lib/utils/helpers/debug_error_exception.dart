import 'package:flutter/material.dart';

class DebugErrorException {
  static void run(FlutterErrorDetails details) {
    runApp(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text("ERROR"),
          ),
          body: ListView(
            children: [
              Text("Summary: ${details.summary.toDescription()}"),
              const Divider(),
              Text("toStringDeep: ${details.summary.toStringDeep()}"),
              const Divider(),
              Text("Exception: ${details.exception}"),
              const Divider(),
              Text("ExceptionStr: ${details.exceptionAsString()}"),
              const Divider(),
              Text(
                "InformationCollector: ${details.informationCollector != null ? details.informationCollector!().join("\n") : null}",
              ),
              const Divider(),
              Text(
                "stackFilter: ${details.stackFilter}",
              ),
              const Divider(),
              Text(
                "stack: ${details.stack}",
              ),
              const Divider(),
              Text(
                "library: ${details.library}",
              ),
              const Divider(),
              Text(
                "library: ${details.silent}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
