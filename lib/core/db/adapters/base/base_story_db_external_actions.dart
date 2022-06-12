abstract class BaseStoryDbExternalActions {
  Future<int> getDocsCount(int? year);
  Future<Set<int>?> fetchYears();
}
