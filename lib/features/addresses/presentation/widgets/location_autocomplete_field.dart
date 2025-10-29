import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import '../../../addresses/domain/services/location_autocomplete_service.dart';

class LocationAutocompleteField extends StatefulWidget {
  final LocationAutocompleteService service;
  final String label;
  final String hint;
  final ValueChanged<String>? onSelected;

  const LocationAutocompleteField({
    super.key,
    required this.service,
    this.label = 'ابحث عن العنوان',
    this.hint = 'اكتب على الأقل 3 أحرف',
    this.onSelected,
  });

  @override
  State<LocationAutocompleteField> createState() => _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<String> _suggestions = <String>[];
  bool _loading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      if (value.trim().length < 3) {
        setState(() => _suggestions = <String>[]);
        return;
      }
      setState(() => _loading = true);
      final results = await widget.service.suggest(value);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _suggestions = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.colorTitleBlack,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : const Icon(Icons.search, color: AppColors.grey2),
            filled: true,
            fillColor: AppColors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.colorViewSeparators),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.washyBlue, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        if (_suggestions.isNotEmpty) const SizedBox(height: 8),
        if (_suggestions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.colorViewSeparators),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.colorViewSeparators),
              itemBuilder: (context, index) {
                final item = _suggestions[index];
                return ListTile(
                  dense: true,
                  title: Text(item, style: const TextStyle(color: AppColors.colorActionBlack)),
                  onTap: () {
                    _controller.text = item;
                    setState(() => _suggestions = <String>[]);
                    widget.onSelected?.call(item);
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}


