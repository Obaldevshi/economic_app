import 'package:equatable/equatable.dart';
import 'package:mobile_template/core/errors/failure.dart';
import 'package:mobile_template/data/models/request/category_request.dart';
import 'package:mobile_template/data/repositories/category_repository.dart';
import 'package:mobile_template/data/models/response/category_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repository;

  CategoryBloc(this._repository) : super(CategoryInitial()) {
    on<GetCategoryEvent>(_onGetCategory);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onGetCategory(
    GetCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (!event.append) {
      emit(CategoryLoading());
    }

    final currentCategories = state is CategoryLoaded && event.append
        ? (state as CategoryLoaded).categories
        : <CategoryResponse>[];

    final result = await _repository.getCategories(page: event.page);
    result.fold((failure) => emit(CategoryError(failure: failure)), (
      paginated,
    ) {
      final categories = event.append
          ? [...currentCategories, ...paginated.data]
          : paginated.data;
      emit(
        CategoryLoaded(
          categories: categories,
          total: paginated.total,
          page: paginated.page,
          hasMore: paginated.page * paginated.perPage < paginated.total,
        ),
      );
    });
  }

  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CreateCategoryLoading());
    final request = CategoryRequest(name: event.name);
    final result = await _repository.createCategory(request);
    result.fold(
      (failure) => emit(CreateCategoryError(failure: failure)),
      (message) => emit(CreateCategorySuccess(message: message)),
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(UpdateCategoryLoading());
    final result = await _repository.updateCategory(
      event.id,
      CategoryRequest(name: event.name),
    );
    result.fold(
      (failure) => emit(UpdateCategoryError(failure: failure)),
      (message) => emit(UpdateCategorySuccess(message: message)),
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(DeleteCategoryLoading());
    final result = await _repository.deleteCategory(event.id);
    result.fold(
      (failure) => emit(DeleteCategoryError(failure: failure)),
      (_) => emit(DeleteCategorySuccess()),
    );
  }
}
