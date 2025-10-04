import 'package:klontong/src/data/network/service/api_result.dart';
import 'package:klontong/src/data/network/service/network_exceptions.dart';
import 'package:klontong/src/data/preferences/app_preferences.dart';
import 'package:klontong/src/utils/logger.dart';

abstract class BaseRepository {
  late AppPreferences appPreferences;
  late String userLogin;

  ApiResult<T> handleErrorApi<T>(dynamic e,
      {String tag = "", forceLogout = true}) {
    logger.e(tag, error: e);
    NetworkExceptions exceptions = NetworkExceptions.getDioException(e);
    if (forceLogout && exceptions is UnauthorizedRequest) {
      // final MainCubit cubit = GetIt.I<MainCubit>();
      // cubit.forceLogOut();
    }
    return ApiResult.failure(error: exceptions);
  }
}
