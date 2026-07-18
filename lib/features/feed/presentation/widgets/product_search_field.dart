import 'package:flutter/material.dart';
import 'package:krishi_social/shared/widgets/app_text_field.dart';

class ProductSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> suggestions;
  final bool enabled;
  final String label;
  final String hint;
  final String validationMessage;

  const ProductSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.enabled,
    required this.label,
    required this.hint,
    required this.validationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: focusNode,
      displayStringForOption: (option) => option,
      optionsBuilder: (value) {
        if (!enabled) {
          return const Iterable<String>.empty();
        }

        final query = value.text.trim().toLowerCase();

        if (query.isEmpty) {
          return suggestions;
        }

        return suggestions.where(
          (product) => product.toLowerCase().contains(query),
        );
      },
      fieldViewBuilder: (context, textController, fieldFocusNode, onSubmitted) {
        return AppTextField(
          controller: textController,
          focusNode: fieldFocusNode,
          enabled: enabled,
          label: label,
          hint: hint,
          prefixIcon: const Icon(Icons.search),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return validationMessage;
            }

            return null;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        final values = options.toList();

        if (values.isEmpty) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240, maxWidth: 340),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: values.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = values[index];

                  return ListTile(
                    leading: const Icon(Icons.agriculture_outlined),
                    title: Text(product),
                    onTap: () => onSelected(product),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
