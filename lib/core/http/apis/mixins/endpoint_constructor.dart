mixin EndpointConstructor {
  String get path;
  String get nameInUrl;

  String fetchOneUrl({
    String? id,
    bool collection = true,
  }) {
    if (id == null) assert(collection == false);
    return [
      path,
      nameInUrl,
      if (collection) id,
    ].join("/");
  }

  String fetchAllUrl() {
    return [
      path,
      nameInUrl,
    ].join("/");
  }

  String updatelUrl({
    String? id,
    bool collection = true,
  }) {
    if (id == null) assert(collection == false);
    return [
      path,
      nameInUrl,
      if (collection) id,
    ].join("/");
  }

  String deletelUrl({
    String? id,
    bool collection = true,
  }) {
    if (id == null) assert(collection == false);
    return [
      path,
      nameInUrl,
      if (collection) id,
    ].join("/");
  }

  String createUrl() {
    return [
      path,
      nameInUrl,
    ].join("/");
  }
}
