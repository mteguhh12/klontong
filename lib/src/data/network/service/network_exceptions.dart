import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:klontong/src/utils/logger.dart';
import 'package:klontong/src/utils/utils.dart';

part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest(String? reason) =
      UnauthorizedRequest;

  const factory NetworkExceptions.badRequest(String? reason) = BadRequest;

  const factory NetworkExceptions.notFound(String reason) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions handleResponse(dynamic data, int? statusCode) {
    String? message;
    logger.e(data);
    if (data.toString().contains("logId")) {
      message = data["logId"];
      Future.delayed(Duration(seconds: 2),
          () => Utils.showToastDefault(data["logId"] ?? "", isLong: true));
    }
    if (data.toString().contains("message")) {
      message = data["message"].toString();
    }
    if (data is String) {
      message = data;
    }
    switch (statusCode) {
      case 400:
      case 403:
        return NetworkExceptions.badRequest(message);
      case 401:
        // case 403:
        return NetworkExceptions.unauthorizedRequest(message);
      case 404:
        return NetworkExceptions.notFound(message ?? "");
      case 409:
        return NetworkExceptions.conflict();
      case 408:
        return NetworkExceptions.requestTimeout();
      case 500:
        return NetworkExceptions.internalServerError();
      case 503:
        return NetworkExceptions.serviceUnavailable();
      case 501:
        return NetworkExceptions.defaultError(message ?? "");
      default:
        //var responseCode = statusCode;
        return NetworkExceptions.defaultError(
          //"Received invalid status code: $responseCode",
          "$message",
        );
    }
  }

  static NetworkExceptions getDioException(error) {
    NetworkExceptions networkExceptions;
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = NetworkExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.connectionError:
              networkExceptions = NetworkExceptions.noInternetConnection();
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = NetworkExceptions.sendTimeout();
              break;
            default:
              networkExceptions = NetworkExceptions.handleResponse(
                  error.response?.data is String
                      ? json.decode(error.response?.data ?? "")
                      : error.response?.data,
                  error.response?.statusCode);
          }
        } else if (error is SocketException) {
          networkExceptions = NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException catch (_) {
        return NetworkExceptions.formatException();
      } catch (_) {
        return NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return NetworkExceptions.unableToProcess();
      } else {
        return NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "";
    networkExceptions.when(notImplemented: () {
      errorMessage = "Not Implemented";
    }, requestCancelled: () {
      errorMessage = "Request Cancelled";
    }, internalServerError: () {
      errorMessage = "Internal Server Error";
    }, notFound: (String reason) {
      errorMessage = reason;
    }, serviceUnavailable: () {
      errorMessage = "Service unavailable";
    }, methodNotAllowed: () {
      errorMessage = "Method Allowed";
    }, badRequest: (String? reason) {
      errorMessage = reason ?? "Bad request";
    }, unauthorizedRequest: (reason) {
      errorMessage = reason ?? "Unauthorized request";
    }, unexpectedError: () {
      errorMessage = "Unexpected error occurred";
    }, requestTimeout: () {
      errorMessage = "Connection request timeout";
    }, noInternetConnection: () {
      errorMessage = "No internet connection";
    }, conflict: () {
      errorMessage = "Error due to a conflict";
    }, sendTimeout: () {
      errorMessage = "Send timeout in connection with API server";
    }, unableToProcess: () {
      errorMessage = "Unable to process the data";
    }, defaultError: (String error) {
      errorMessage = error;
    }, formatException: () {
      errorMessage = "Unexpected error occurred";
    }, notAcceptable: () {
      errorMessage = "Not acceptable";
    });
    return errorMessage;
  }
}
