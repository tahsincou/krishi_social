import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';
import 'package:krishi_social/features/auth/domain/entities/auth_status.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/entities/quantity_unit.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/features/feed/domain/params/create_agricultural_post_params.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/features/feed/presentation/widgets/product_search_field.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_button.dart';
import 'package:krishi_social/shared/widgets/app_card.dart';
import 'package:krishi_social/shared/widgets/app_date_range_field.dart';
import 'package:krishi_social/shared/widgets/app_dropdown.dart';
import 'package:krishi_social/shared/widgets/app_loading.dart';
import 'package:krishi_social/shared/widgets/app_text_field.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({
    super.key,
    required this.initialType,
    this.existingPost,
  });

  final PostType initialType;
  final AgriculturePost? existingPost;

  bool get isEditing => existingPost != null;

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

    final post = widget.existingPost;

    _postType = post?.type ?? widget.initialType;

    if (post == null) {
      return;
    }

    _category = post.category;
    _unit = post.unit;
    _productController.text = post.productName;
    _quantityController.text = _formatNumber(post.quantity);
    _locationController.text = post.district;
    _priceController.text = post.pricePerUnit == null
        ? ''
        : _formatNumber(post.pricePerUnit!);
    _qualityController.text = post.qualityRequirement ?? '';
    _descriptionController.text = post.description ?? '';

    _dateRange = DateTimeRange(
      start: post.availableFrom,
      end: post.availableTo,
    );

    _showOptionalFields =
        post.pricePerUnit != null ||
        (post.qualityRequirement?.isNotEmpty ?? false) ||
        (post.description?.isNotEmpty ?? false);
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
    final authState = ref.watch(authNotifierProvider);
    final feedState = ref.watch(feedNotifierProvider);

    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: AppLoading());
    }

    final canChoosePostType = user.activity == AccountActivity.both;

    final isEditing = widget.isEditing;
    final isBuyPost = _postType == PostType.buy;

    final isSubmitting = isEditing
        ? feedState.isUpdating
        : feedState.isCreating;

    if (authState.status == AuthStatus.initial ||
        authState.status == AuthStatus.restoring) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthenticated) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/login'),
            child: Text(context.l10n.login),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? context.l10n.editPost
              : isBuyPost
              ? context.l10n.createBuyPost
              : context.l10n.createSellPost,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            children: [
              if (canChoosePostType) ...[
                _buildPostTypeSelector(),
                const SizedBox(height: AppSpacing.lg),
              ],

              _buildSectionCard(
                context: context,
                icon: Icons.eco_outlined,
                title: context.l10n.productInformation,
                child: Column(
                  children: [
                    AppDropdown<ProductCategory>(
                      value: _category,
                      label: context.l10n.category,
                      prefixIcon: const Icon(Icons.category_outlined),
                      items: ProductCategory.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.displayName(context)),
                            ),
                          )
                          .toList(),
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

                    const SizedBox(height: AppSpacing.md),

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
                            items: QuantityUnit.values
                                .map(
                                  (unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit.displayName),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _unit = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              _buildSectionCard(
                context: context,
                icon: Icons.location_on_outlined,
                title: context.l10n.deliveryInformation,
                child: Column(
                  children: [
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
                      prefixIcon: const Icon(Icons.place_outlined),
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

              _buildOptionalInformation(isBuyPost: isBuyPost),

              const SizedBox(height: AppSpacing.lg),

              if (feedState.isOffline) ...[
                _buildOfflineNotice(context),
                const SizedBox(height: AppSpacing.md),
              ],

              AppButton(
                text: isEditing
                    ? context.l10n.saveChanges
                    : context.l10n.publishPost,
                isLoading: isSubmitting,
                onPressed: isSubmitting || feedState.isOffline ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: SegmentedButton<PostType>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: PostType.buy,
            label: Text(context.l10n.buy),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
          ButtonSegment(
            value: PostType.sell,
            label: Text(context.l10n.sell),
            icon: const Icon(Icons.agriculture_outlined),
          ),
        ],
        selected: {_postType},
        style: ButtonStyle(
          side: const WidgetStatePropertyAll(BorderSide.none),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
        onSelectionChanged: (values) {
          setState(() {
            _postType = values.first;
          });
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }

  Widget _buildOptionalInformation({required bool isBuyPost}) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () {
              setState(() {
                _showOptionalFields = !_showOptionalFields;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _showOptionalFields
                          ? Icons.remove_rounded
                          : Icons.add_rounded,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.moreInformationOptional,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.l10n.optionalInformationHint,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _showOptionalFields
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                ],
              ),
            ),
          ),

          if (_showOptionalFields) ...[
            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
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
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOfflineNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.offlineChangesUnavailable,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
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
      pricePerUnit: _parseOptionalDouble(_priceController.text),
      qualityRequirement: _optionalText(_qualityController.text),
      description: _optionalText(_descriptionController.text),
    );

    final success = widget.isEditing
        ? await ref
              .read(feedNotifierProvider.notifier)
              .updatePost(widget.existingPost!, params)
        : await ref.read(feedNotifierProvider.notifier).createPost(params);

    if (!mounted) {
      return;
    }

    if (!success) {
      final error = ref.read(feedNotifierProvider).error;

      final message = error == 'offline_write_unavailable'
          ? context.l10n.offlineChangesUnavailable
          : context.l10n.actionFailed;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditing
              ? context.l10n.postUpdated
              : context.l10n.postCreated,
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  double? _parseOptionalDouble(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return double.tryParse(text);
  }

  String? _optionalText(String value) {
    final text = value.trim();

    return text.isEmpty ? null : text;
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }
}
