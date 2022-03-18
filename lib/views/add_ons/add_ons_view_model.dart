import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/models/product_list_model.dart';

class AddOnsViewModel extends BaseViewModel {
  AddOnsViewModel();

  ProductListModel productList = ProductListModel.getter();
}
