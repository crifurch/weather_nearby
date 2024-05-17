abstract class DataMapper<S, T> {
  T mapToFirst(S value);
  S mapToSecond(T value);
}
