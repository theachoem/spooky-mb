import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/models/product_list_model.dart';

class AddOnsViewModel extends BaseViewModel {
  late final ProductListModel productList;
  AddOnsViewModel(BuildContext context) {
    productList = ProductListModel.getter(context);
  }
}
