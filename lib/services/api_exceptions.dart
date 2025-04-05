
/// [EnumAPIExceptions] - ENUM for API exceptions
enum EnumAPIExceptions {
  /// When the API Result returns empty
  apiResultEmpty,

  /// When the success field in data is false
  dataSuccessFalse,

  /// When bad certificate
  badCertificate,

  /// When http status error is returned from server
  httpStatusError,

  /// When an invalid token error is returned from server
  invalidToken,

  /// When an empty token is returned from server
  emptyTokenFromServer,

  /// When an invalid result type is returned from server
  invalidResultType,

  /// When an Session expired result type is returned from server
  sessionExpired,
  // When the data field is empty
  dataFieldEmpty,
}

/// The api exceptions handles the api calls and responses
class APIException implements Exception {
  /// The default constructor of the exception
  /// The exception can be thrown if any error occured in api calls or results
  ///
  /// [enumProperty] - Represent the type of error [EnumAPIExceptions]
  /// [message] A string message [String]
  /// [data] - API Response data
  APIException({
    required this.enumProperty,
    required this.message,
    this.data,
  }) : super();

  /// exception variable
  final EnumAPIExceptions enumProperty;

  /// exception message
  final String message;

  /// API Response data
  dynamic data;

  @override
  String toString() => '$enumProperty:$message:$data';
}
