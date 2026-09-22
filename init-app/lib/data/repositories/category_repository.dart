import 'package:mobile_template/core/errors/error_handler.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/datasources/remote/api_service.dart';
import 'package:mobile_template/data/models/request/category_request.dart';
import 'package:mobile_template/data/models/response/base_pagination_response.dart';
import 'package:mobile_template/data/models/response/category_response.dart';
import 'package:fpdart/fpdart.dart';

class CategoryRepository {
  final ApiService _apiService;

  CategoryRepository(this._apiService);

  Future<Either<Failure, BasePaginationResponse<CategoryResponse>>>
  getCategories({
    int page = 1,
    int perPage = 20,
    String sortBy = 'id',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _apiService.getCategories(
        page,
        perPage,
        sortBy,
        sortOrder,
      );
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  Future<Either<Failure, String>> createCategory(
    CategoryRequest request,
  ) async {
    try {
      final response = await _apiService.createCategory(request);
      return Right(response.message);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  Future<Either<Failure, String>> updateCategory(
    int id,
    CategoryRequest request,
  ) async {
    try {
      final response = await _apiService.updateCategory(id, request);
      return Right(response.message);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await _apiService.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }
}
