import 'package:flutter/material.dart';

class DebugErrorException {
  static void run(FlutterErrorDetails details) {
    runApp(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("ERROR"),
          ),
          body: ListView(
            children: [
              Text("Summary: ${details.summary.toDescription()}"),
              Divider(),
              Text("toStringDeep: ${details.summary.toStringDeep()}"),
              Divider(),
              Text("Exception: ${details.exception}"),
              Divider(),
              Text("ExceptionStr: ${details.exceptionAsString()}"),
              Divider(),
              Text(
                "InformationCollector: ${details.informationCollector != null ? details.informationCollector!().join("\n") : null}",
              ),
              Divider(),
              Text(
                "stackFilter: ${details.stackFilter}",
              ),
              Divider(),
              Text(
                "stack: ${details.stack}",
              ),
              Divider(),
              Text(
                "library: ${details.library}",
              ),
              Divider(),
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
