sealed class Either<L, R> {
  const Either();

  B fold<B>(B Function(L) onLeft, B Function(R) onRight);

  bool get isLeft;
  bool get isRight;
}

final class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  B fold<B>(B Function(L) onLeft, B Function(R) onRight) => onLeft(value);
}

final class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  B fold<B>(B Function(L) onLeft, B Function(R) onRight) => onRight(value);
}

Either<L, R> left<L, R>(L value) => Left<L, R>(value);
Either<L, R> right<L, R>(R value) => Right<L, R>(value);
