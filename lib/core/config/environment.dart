enum Environment { demo, development, staging, production }

extension EnvironmentExtension on Environment {
  String get title {
    switch (this) {
      case Environment.demo:
        return 'Demo';

      case Environment.development:
        return 'Development';

      case Environment.staging:
        return 'Staging';

      case Environment.production:
        return 'Production';
    }
  }

  String get description {
    switch (this) {
      case Environment.demo:
        return 'JSON Server';

      case Environment.development:
        return 'Development API';

      case Environment.staging:
        return 'Staging API';

      case Environment.production:
        return 'Production API';
    }
  }
}
