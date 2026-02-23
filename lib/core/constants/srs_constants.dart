abstract final class SrsConstants {
  // FSRS configuration
  static const desiredRetention = 0.9;

  // Rating labels mapping to FSRS ratings 1-4
  static const ratingAgain = 1; // A revoir
  static const ratingHard = 2; // Difficile
  static const ratingGood = 3; // Bien
  static const ratingEasy = 4; // Facile

  // Mastery threshold for autodidact mode suggestion
  static const masteryThreshold = 0.8;
}
