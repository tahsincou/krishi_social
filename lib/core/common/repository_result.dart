class RepositoryResult<T> {
  final T data;
  final bool isFromCache;

  const RepositoryResult({required this.data, required this.isFromCache});
}
