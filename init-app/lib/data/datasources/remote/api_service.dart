import "package:dio/dio.dart";
import 'package:mobile_template/data/models/request/category_request.dart';
import 'package:mobile_template/data/models/request/change_password_request.dart';
import 'package:mobile_template/data/models/request/login_request.dart';
import 'package:mobile_template/data/models/request/register_request.dart';
import 'package:mobile_template/data/models/request/update_profile_request.dart';
import 'package:mobile_template/data/models/response/base_pagination_response.dart';
import 'package:mobile_template/data/models/response/base_response.dart';
import 'package:mobile_template/data/models/response/category_response.dart';
import 'package:mobile_template/data/models/response/login_response.dart';
import 'package:mobile_template/data/models/response/profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST('/auth/login')
  Future<BaseResponse<LoginResponse>> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<BaseResponse> register(@Body() RegisterRequest request);

  @GET('/categories/')
  Future<BasePaginationResponse<CategoryResponse>> getCategories(
    @Query('page') int page,
    @Query('per_page') int perPage,
    @Query('sort_by') String sortBy,
    @Query('sort_order') String sortOrder,
  );

  @POST('/categories/')
  Future<BaseResponse> createCategory(@Body() CategoryRequest request);

  @PUT('/categories/{id}')
  Future<BaseResponse> updateCategory(
    @Path('id') int id,
    @Body() CategoryRequest request,
  );

  @DELETE('/categories/{id}')
  Future<void> deleteCategory(@Path('id') int id);

  @GET('/users/')
  Future<BaseResponse<ProfileResponse>> getProfile();

  @PUT('/users/')
  Future<BaseResponse> updateProfile(@Body() UpdateProfileRequest request);

  @DELETE('/users/')
  Future<void> deleteAccount();

  @POST('/users/change-password')
  Future<BaseResponse> changePassword(@Body() ChangePasswordRequest request);
}
