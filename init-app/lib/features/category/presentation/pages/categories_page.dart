import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/response/category_response.dart';
import 'package:mobile_template/features/category/presentation/pages/bloc/category_bloc.dart';
import 'package:mobile_template/features/category/presentation/widgets/add_category_bottom_sheet.dart';
import 'package:mobile_template/features/category/presentation/widgets/categories_search_field.dart';
import 'package:mobile_template/features/category/presentation/widgets/category_item.dart';
import 'package:mobile_template/presentation/widgets/common/confirmation_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/generated/assets.gen.dart';
import 'package:mobile_template/presentation/widgets/common/app_svg_icon.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<CategoryBloc>();
    bloc.add(GetCategoryEvent());
    await bloc.stream.firstWhere((state) => state is! CategoryLoading);
  }

  List<CategoryResponse> _filterCategories(List<CategoryResponse> categories) {
    if (_searchQuery.isEmpty) return categories;
    return categories
        .where(
          (category) =>
              category.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        _handleCategoryState(context, state);
        _handleDeleteCategoryState(context, state);
      },
      builder: (context, state) {
        final isLoading = state is CategoryLoading;

        return ScrollShell(
          isLoading: isLoading,
          expandedHeaderHeight: AppDimensions.textFieldHeight,
          onRefresh: _onRefresh,
          title: context.l10n.categories,
          actions: [
            IconButton(
              onPressed: _addCategory,
              icon: AppSvgIcon(icon: Assets.icons.plus),
              tooltip: context.l10n.addNewCategoryTooltip,
            ),
          ],
          headerContent: CategoriesSearchField(
            controller: _searchController,
            query: _searchQuery,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CategoryState state) {
    if (state is CategoryLoading) {
      return const SizedBox.shrink();
    }

    if (state is CategoryLoaded) {
      final filteredCategories = _filterCategories(state.categories);

      if (filteredCategories.isEmpty) {
        return _buildEmptyState();
      }

      final categories = AppLayoutItemBuilder<Widget>(
        narrow: () => Column(
          children: [
            for (final category in filteredCategories)
              _buildCategoryItem(category),
          ],
        ),
        wide: () => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredCategories.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 420,
            mainAxisExtent: 88,
            crossAxisSpacing: AppDimensions.spaceM,
            mainAxisSpacing: AppDimensions.spaceM,
          ),
          itemBuilder: (context, index) => GlassSurfaceCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS,
            ),
            child: _buildCategoryItem(filteredCategories[index]),
          ),
        ),
      )(context);

      return Column(
        children: [
          categories,
          if (state.hasMore && _searchQuery.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppDimensions.spaceS),
              child: Center(
                child: TextButton(
                  onPressed: () => context.read<CategoryBloc>().add(
                    GetCategoryEvent(page: state.page + 1, append: true),
                  ),
                  child: Text(context.l10n.loadMore),
                ),
              ),
            ),
        ],
      );
    }

    return _buildEmptyState();
  }

  Widget _buildCategoryItem(CategoryResponse category) {
    return CategoryItem(
      category: category,
      onTap: () async {
        final bloc = context.read<CategoryBloc>();
        final shouldRefresh = await _editCategory(category);
        if (shouldRefresh == true && mounted) {
          bloc.add(GetCategoryEvent());
        }
      },
      onDelete: () => _deleteCategory(category),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXL),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.category_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Text(
              _searchQuery.isEmpty
                  ? context.l10n.noCategoriesYet
                  : context.l10n.noCategoriesFound,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Text(
              _searchQuery.isEmpty
                  ? context.l10n.addFirstCategory
                  : context.l10n.tryDifferentSearch,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: AppDimensions.spaceL),
              TextButton.icon(
                onPressed: _addCategory,
                icon: AppSvgIcon(
                  icon: Assets.icons.plus,
                  color: AppColors.primary,
                  size: 20,
                ),
                label: Text(context.l10n.addCategory),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _addCategory() async {
    final shouldRefresh = await AddCategoryBottomSheet.show(context);

    if (shouldRefresh == true && mounted) {
      context.read<CategoryBloc>().add(GetCategoryEvent());
    }
  }

  Future<bool?> _editCategory(CategoryResponse category) {
    return AddCategoryBottomSheet.show(
      context,
      category: category,
      isEdit: true,
    );
  }

  Future<void> _deleteCategory(CategoryResponse category) {
    return ConfirmationDialog.show(
      context,
      title: context.l10n.deleteCategory,
      content: context.l10n.deleteCategoryConfirmation,
      confirmText: context.l10n.delete,
      isDestructive: true,
      onConfirm: () => context.read<CategoryBloc>().add(
        DeleteCategoryEvent(id: category.id),
      ),
    );
  }

  void _handleCategoryState(BuildContext context, CategoryState state) {
    if (state is CategoryError) {
      ErrorDialog.show(context, state.failure);
    }
  }

  void _handleDeleteCategoryState(BuildContext context, CategoryState state) {
    if (state is DeleteCategorySuccess) {
      context.read<CategoryBloc>().add(GetCategoryEvent());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.categoryDeletedSuccessfully),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (state is DeleteCategoryError) {
      ErrorDialog.show(context, state.failure);
    }
  }
}
