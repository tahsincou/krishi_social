import 'package:flutter/material.dart';

class AppDateRangeField extends FormField<DateTimeRange> {
  AppDateRangeField({
    super.key,
    required String label,
    required String emptyText,
    required String validationMessage,
    required DateTimeRange? value,
    required Future<DateTimeRange?> Function() onSelect,
  }) : super(
         initialValue: value,
         validator: (range) {
           if (range == null) {
             return validationMessage;
           }

           return null;
         },
         builder: (field) {
           final range = field.value;

           return InkWell(
             borderRadius: BorderRadius.circular(10),
             onTap: () async {
               final selectedRange = await onSelect();

               if (selectedRange != null) {
                 field.didChange(selectedRange);
               }
             },
             child: InputDecorator(
               decoration: InputDecoration(
                 labelText: label,
                 errorText: field.errorText,
                 prefixIcon: const Icon(Icons.date_range_outlined),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
               ),
               child: Text(
                 range == null
                     ? emptyText
                     : '${_formatDate(range.start)} - '
                           '${_formatDate(range.end)}',
               ),
             ),
           );
         },
       );

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
