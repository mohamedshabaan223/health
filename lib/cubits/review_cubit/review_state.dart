part of 'review_cubit.dart';

@immutable
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewSuccess extends ReviewState {
  final String message;

  ReviewSuccess(this.message);
}

class ReviewListSuccess extends ReviewState {
  final List<ReviewModel> reviews;

  ReviewListSuccess(this.reviews);
}

class ReviewError extends ReviewState {
  final String error;

  ReviewError(this.error);
}
