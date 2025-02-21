abstract class Repository<T, ID> {
  T findById(ID id);
  List<T> findAll();
  T add(T entity);
  void update(T entity);
  void deleteById(ID id);
}
