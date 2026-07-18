import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/entities/quantity_unit.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/features/feed/domain/params/create_agricultural_post_params.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/features/feed/presentation/widgets/product_search_field.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_button.dart';
import 'package:krishi_social/shared/widgets/app_card.dart';
import 'package:krishi_social/shared/widgets/app_date_range_field.dart';
import 'package:krishi_social/shared/widgets/app_dropdown.dart';
import 'package:krishi_social/shared/widgets/app_text_field.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  final PostType initialType;

  const CreatePostPage({super.key, required this.initialType});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();

  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _qualityController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _productFocusNode = FocusNode();

  late PostType _postType;

  ProductCategory? _category;
  QuantityUnit _unit = QuantityUnit.kg;
  DateTimeRange? _dateRange;

  bool _showOptionalFields = false;

  @override
  void initState() {
    super.initState();
    _postType = widget.initialType;
  }

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _qualityController.dispose();
    _descriptionController.dispose();
    _productFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBuyPost = _postType == PostType.buy;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isBuyPost ? context.l10n.createBuyPost : context.l10n.createSellPost,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _buildPostTypeSelector(),
              const SizedBox(height: AppSpacing.md),

              AppCard(
                child: Column(
                  children: [
                    AppDropdown<ProductCategory>(
                      value: _category,
                      label: context.l10n.category,
                      prefixIcon: const Icon(Icons.category_outlined),
                      items: ProductCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.displayName(context)),
                        );
                      }).toList(),
                      onChanged: _onCategoryChanged,
                      validator: (value) {
                        if (value == null) {
                          return context.l10n.selectCategory;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    ProductSearchField(
                      controller: _productController,
                      focusNode: _productFocusNode,
                      suggestions:
                          _category?.suggestedProducts ?? const <String>[],
                      enabled: _category != null,
                      label: context.l10n.productName,
                      hint: _category == null
                          ? context.l10n.selectCategoryFirst
                          : context.l10n.productSearchHint,
                      validationMessage: context.l10n.enterProductName,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              AppCard(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppTextField(
                            controller: _quantityController,
                            label: context.l10n.quantity,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            prefixIcon: const Icon(Icons.scale_outlined),
                            validator: _validateQuantity,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppDropdown<QuantityUnit>(
                            value: _unit,
                            label: context.l10n.unit,
                            items: QuantityUnit.values.map((unit) {
                              return DropdownMenuItem(
                                value: unit,
                                child: Text(unit.displayName),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value == null) return;

                              setState(() {
                                _unit = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    AppDateRangeField(
                      label: isBuyPost
                          ? context.l10n.requiredBetween
                          : context.l10n.availableBetween,
                      emptyText: context.l10n.selectDateRange,
                      validationMessage: context.l10n.dateRangeRequired,
                      value: _dateRange,
                      onSelect: _selectDateRange,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    AppTextField(
                      controller: _locationController,
                      label: context.l10n.location,
                      hint: context.l10n.locationExample,
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.l10n.locationRequired;
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              AppCard(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showOptionalFields = !_showOptionalFields;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            _showOptionalFields
                                ? Icons.remove_circle_outline
                                : Icons.add_circle_outline,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              context.l10n.moreInformationOptional,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Icon(
                            _showOptionalFields
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                          ),
                        ],
                      ),
                    ),
                    if (_showOptionalFields) ...[
                      const SizedBox(height: AppSpacing.md),

                      AppTextField(
                        controller: _priceController,
                        label: isBuyPost
                            ? context.l10n.targetPriceOptional
                            : context.l10n.expectedPriceOptional,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixIcon: const Icon(Icons.payments_outlined),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      AppTextField(
                        controller: _qualityController,
                        label: context.l10n.qualityOptional,
                        prefixIcon: const Icon(Icons.fact_check_outlined),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      AppTextField(
                        controller: _descriptionController,
                        label: context.l10n.descriptionOptional,
                        prefixIcon: const Icon(Icons.notes_outlined),
                        maxLines: 3,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              AppButton(text: context.l10n.publishPost, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostTypeSelector() {
    return SegmentedButton<PostType>(
      segments: [
        ButtonSegment(
          value: PostType.buy,
          label: Text(context.l10n.buy),
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
        ButtonSegment(
          value: PostType.sell,
          label: Text(context.l10n.sell),
          icon: const Icon(Icons.agriculture_outlined),
        ),
      ],
      selected: {_postType},
      showSelectedIcon: false,
      onSelectionChanged: (values) {
        setState(() {
          _postType = values.first;
        });
      },
    );
  }

  void _onCategoryChanged(ProductCategory? value) {
    setState(() {
      _category = value;
      _productController.clear();
    });

    _productFocusNode.unfocus();
  }

  String? _validateQuantity(String? value) {
    final quantity = double.tryParse(value ?? '');

    if (quantity == null || quantity <= 0) {
      return context.l10n.enterValidQuantity;
    }

    return null;
  }

  Future<DateTimeRange?> _selectDateRange() async {
    final now = DateTime.now();

    final selectedRange = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );

    if (selectedRange != null) {
      setState(() {
        _dateRange = selectedRange;
      });
    }

    return selectedRange;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_category == null || _dateRange == null) {
      return;
    }

    final params = CreateAgriculturalPostParams(
      type: _postType,
      category: _category!,
      productName: _productController.text.trim(),
      quantity: double.parse(_quantityController.text.trim()),
      unit: _unit,
      availableFrom: _dateRange!.start,
      availableTo: _dateRange!.end,
      location: _locationController.text.trim(),
      pricePerUnit: _nullableDouble(_priceController.text),
      qualityRequirement: _nullableText(_qualityController.text),
      description: _nullableText(_descriptionController.text),
    );

    final created = await ref
        .read(feedNotifierProvider.notifier)
        .createPost(params);

    if (!mounted) return;

    if (!created) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(feedNotifierProvider).error ??
                context.l10n.enterProductName,
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.postCreated)));

    Navigator.of(context).pop();
  }

  double? _nullableDouble(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return null;
    }

    return double.tryParse(trimmed);
  }

  String? _nullableText(String value) {
    final trimmed = value.trim();

    return trimmed.isEmpty ? null : trimmed;
  }
}
