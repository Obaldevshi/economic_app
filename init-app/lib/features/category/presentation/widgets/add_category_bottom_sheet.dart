import 'package:mobile_template/app/theme/app_colors.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/data/models/response/category_response.dart';
import 'package:mobile_template/features/category/presentation/pages/bloc/category_bloc.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_bottom_sheet.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:mobile_template/presentation/widgets/common/global_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({super.key, this.category, this.isEdit = false});

  final CategoryResponse? category;
  final bool isEdit;

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();

  static Future<bool?> show(
    BuildContext context, {
    CategoryResponse? category,
    bool isEdit = false,
  }) {
    return GlassBottomSheet.show<bool>(
      context,
      title: isEdit ? context.l10n.editCategory : context.l10n.addCategory,
      child: BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: AddCategoryBottomSheet(category: category, isEdit: isEdit),
      ),
    );
  }
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.category != null) {
      _nameController.text = widget.category!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        _handleCategoryState(state);
        _handleUpdateCategoryState(state);
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              GlobalTextFormField(
                controller: _nameController,
                labelText: context.l10n.categoryName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return context.l10n.categoryNameRequired;
                  }
                  if (value.length < 2) {
                    return context.l10n.categoryNameTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spaceXL),
              GlobalButton(
                onPressed: _saveCategory,
                text: widget.isEdit
                    ? context.l10n.updateCategory
                    : context.l10n.addCategory,
                isLoading: _isLoading,
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<CategoryBloc>();
      if (widget.isEdit) {
        bloc.add(
          UpdateCategoryEvent(
            id: widget.category!.id,
            name: _nameController.text,
          ),
        );
      } else {
        bloc.add(CreateCategoryEvent(name: _nameController.text));
      }
    }
  }

  void _handleCategoryState(CategoryState state) {
    if (state is CreateCategoryLoading) {
      _setLoading(true);
    } else if (state is CreateCategorySuccess) {
      _setLoading(false);
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (state is CreateCategoryError) {
      _setLoading(false);
      Navigator.of(context).pop();
      ErrorDialog.show(context, state.failure);
    }
  }

  void _handleUpdateCategoryState(CategoryState state) {
    if (state is UpdateCategoryLoading) {
      _setLoading(true);
    } else if (state is UpdateCategorySuccess) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.categoryUpdatedSuccessfully),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (state is UpdateCategoryError) {
      Navigator.of(context).pop();
      ErrorDialog.show(context, state.failure);
    }
  }

  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }
}
