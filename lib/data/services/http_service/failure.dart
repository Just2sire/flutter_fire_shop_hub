enum FailureType {
  noInternet,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validationError,
  clientError,
  serverError,
  invalidResponse,
  unknown,
}

class Failure {
  const Failure({
    required this.message,
    required this.type,
    this.statusCode,
    this.data,
  });

  final String message;
  final FailureType type;
  final int? statusCode;
  final dynamic data;

  String get userMessage {
    switch (type) {
      case FailureType.noInternet:
        return "Pas de connexion internet. Vérifiez votre connexion.";
      case FailureType.timeout:
        return "La requête a pris trop de temps. Veuillez réessayer.";
      case FailureType.unauthorized:
        return "Votre session a expiré. Veuillez vous reconnecter.";
      case FailureType.forbidden:
        return "Vous n'avez pas l'autorisation d'accéder à cette ressource.";
      case FailureType.notFound:
        return "La ressource demandée n'existe pas.";
      case FailureType.validationError:
        return "Les données fournies sont invalides.";
      case FailureType.serverError:
        return "Erreur serveur. Veuillez réessayer plus tard.";
      default:
        return message;
    }
  }

  @override
  String toString() =>
      "Failure($type, statusCode: $statusCode, message: $message)";
}
