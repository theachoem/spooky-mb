import 'package:spooky/core/http/apis/base_error_handling_api.dart';
import 'package:spooky/core/http/networks/app_token_network.dart';
import 'package:spooky/core/http/networks/base_network.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/constants/api_constant.dart';

abstract class BaseAppApi<T extends BaseModel> extends BaseErrorHandlingApi<T> {
  @override
  BaseNetwork buildNetwork() {
    return AppTokenNetwork(ApiConstant.baseUrl);
  }
}
