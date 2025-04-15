class CalculationQubit {
  static const double gravitationalConstant = 6.67430e-11;

  double calculateAcceleration(double mass, double radius) {
    if (mass <= 0 || radius <= 0) {
      throw ArgumentError('Масса и радиус должны быть положительными числами');
    }
    return (gravitationalConstant * mass) / (radius * radius);
  }
}