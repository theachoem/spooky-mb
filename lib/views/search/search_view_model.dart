import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';

class SearchViewModel extends BaseViewModel {
  final StoryQueryOptionsModel? initialQuery;
  SearchViewModel(this.initialQuery);
}
