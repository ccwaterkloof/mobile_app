class FourOhOneError {}

class FeedbackException implements Exception {
  String feedback;

  FeedbackException(this.feedback);
}
