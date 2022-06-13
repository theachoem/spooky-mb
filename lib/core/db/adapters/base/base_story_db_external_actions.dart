abstract class BaseStoryDbExternalActions {
  int getDocsCount(int? year);
  Future<Set<int>?> fetchYears();
}
