import "package:dio/dio.dart";
import 'package:mobile_template/data/models/request/category_request.dart';
import 'package:mobile_template/data/models/request/change_password_request.dart';
import 'package:mobile_template/data/models/request/login_request.dart';
import 'package:mobile_template/data/models/request/register_request.dart';
import 'package:mobile_template/data/models/request/update_profile_request.dart';
import 'package:mobile_template/data/models/request/savings_request.dart';
import 'package:mobile_template/data/models/response/base_pagination_response.dart';
import 'package:mobile_template/data/models/response/base_response.dart';
import 'package:mobile_template/data/models/response/category_response.dart';
import 'package:mobile_template/data/models/response/login_response.dart';
import 'package:mobile_template/data/models/response/profile_response.dart';
import 'package:mobile_template/data/models/response/savings_response.dart';
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

  @GET('/savings/dashboard')
  Future<BaseResponse<SavingsDashboardResponse>> getSavingsDashboard();

  @GET('/savings/receipts/week')
  Future<BaseResponse<WeeklyReceiptResponse>> getWeeklyReceipt();

  @PUT('/savings/goals/{id}/allocation')
  Future<BaseResponse> allocateSavingsGoal(
    @Path('id') int id,
    @Body() GoalAllocationRequest request,
  );

  @GET('/savings/settings')
  Future<BaseResponse<SavingsSettingsResponse>> getSavingsSettings();

  @GET('/savings/impulses')
  Future<BaseResponse<List<ImpulseItemResponse>>> getImpulseItems(
    @Query('include_inactive') bool includeInactive,
  );

  @POST('/savings/impulses')
  Future<BaseResponse> createImpulseItem(@Body() ImpulseItemRequest request);

  @PUT('/savings/impulses/{id}')
  Future<BaseResponse> updateImpulseItem(
    @Path('id') int id,
    @Body() ImpulseItemRequest request,
  );

  @DELETE('/savings/impulses/{id}')
  Future<void> deleteImpulseItem(@Path('id') int id);

  @GET('/savings/events')
  Future<BasePaginationResponse<SavingEventResponse>> getSavingEvents(
    @Query('page') int page,
    @Query('per_page') int perPage,
  );

  @POST('/savings/events')
  Future<BaseResponse> createSavingEvent(@Body() SavingEventRequest request);

  @PUT('/savings/events/{id}')
  Future<BaseResponse> updateSavingEvent(
    @Path('id') int id,
    @Body() SavingEventRequest request,
  );

  @DELETE('/savings/events/{id}')
  Future<void> deleteSavingEvent(@Path('id') int id);

  @POST('/savings/goals')
  Future<BaseResponse> createSavingsGoal(@Body() SavingsGoalRequest request);

  @PUT('/savings/goals/{id}')
  Future<BaseResponse> updateSavingsGoal(
    @Path('id') int id,
    @Body() SavingsGoalRequest request,
  );

  @PUT('/savings/settings')
  Future<BaseResponse> updateSavingsSettings(
    @Body() SavingsSettingsRequest request,
  );

  @GET('/users/')
  Future<BaseResponse<ProfileResponse>> getProfile();

  @PUT('/users/')
  Future<BaseResponse> updateProfile(@Body() UpdateProfileRequest request);

  @DELETE('/users/')
  Future<void> deleteAccount();

  @POST('/users/change-password')
  Future<BaseResponse> changePassword(@Body() ChangePasswordRequest request);
}
