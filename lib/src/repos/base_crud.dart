abstract interface class BaseCrudRepo<T> {
  // Paginated
  Future<List<T>> getItems({int page = 1, int limit = 10});

  Future<T> getItemById(int id);

  Future<int> createItem(T payload);

  Future<T> updateItem(T payload);

  Future<bool> deleteItemById(int id);
}
