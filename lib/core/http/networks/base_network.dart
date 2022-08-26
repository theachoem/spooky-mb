import 'package:spooky/core/http/interceptors/default_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class BaseNetwork {
  late final Dio http;
  final String baseUrl;
  final Interceptors _interceptors = Interceptors();

  BaseNetwork(this.baseUrl) {
    http = Dio();
    addInterceptor(DefaultInterceptor(baseUrl: baseUrl), priority: true);
  }

  /// [priority] will be added directly to http [_interceptors]. Otherwise it will add on [build].
  /// Purpose is to make priority _interceptors to front.
  void addInterceptor(Interceptor interceptor, {bool priority = false}) {
    if (priority) {
      http.interceptors.add(interceptor);
    } else {
      _interceptors.add(interceptor);
    }
  }

  void removeInterceptor(Interceptor interceptor) {
    _interceptors.removeWhere((i) => i == interceptor);
    http.interceptors.removeWhere((i) => i == interceptor);
  }

  // ONLY call once when class initialize
  @mustCallSuper
  Future<BaseNetwork> build() async {
    http.interceptors.addAll(_interceptors);
    return this;
  }
}
