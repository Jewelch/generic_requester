extension IterableSecond<E> on Iterable<E> {
  E get second {
    Iterator<E> it = iterator;
    if (!(it.moveNext() && it.moveNext())) {
      throw StateError("No second element");
    }
    return it.current;
  }
}

extension ListExt<E> on List<E> {
  void ifNotNullAdd(E? element) {
    if (element == null) return;
    this[length++] = element;
  }

  void addBasedOnCondition(E? element, {required bool condition}) {
    if (condition && element != null) this[length++] = element;
  }
}
