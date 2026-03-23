import 'dart:async';
import 'package:flutter/material.dart';

class SearchDropdownField<T> extends StatefulWidget {
  final String hint;
  final IconData? prefixIcon;

  /// Optional external controller
  final TextEditingController? controller;

  final Future<List<T>> Function(String query) onSearch;
  final String Function(T item) displayText;
  final Function(T value)? onSelected;

  const SearchDropdownField({
    Key? key,
    required this.hint,
    required this.onSearch,
    required this.displayText,
    this.prefixIcon,
    this.onSelected,
    this.controller, // 👈 NEW
  }) : super(key: key);

  @override
  State<SearchDropdownField<T>> createState() => _SearchDropdownFieldState<T>();
}

class _SearchDropdownFieldState<T> extends State<SearchDropdownField<T>> {
  late TextEditingController _controller;

  List<T> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  int _searchId = 0;

  bool get _isExternalController => widget.controller != null;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) return;

      if (query.isEmpty) {
        setState(() => _results = []);
        return;
      }

      final currentSearch = ++_searchId;

      setState(() => _isLoading = true);

      try {
        final data = await widget.onSearch(query);

        if (!mounted || currentSearch != _searchId) return;

        setState(() {
          _results = data;
          _isLoading = false;
        });
      } catch (_) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _results = [];
        });
      }
    });
  }

  void _onSelect(T value) {
    if (!mounted) return;

    _controller.text = widget.displayText(value);

    setState(() {
      _results = [];
    });

    widget.onSelected?.call(value);
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();

    // ✅ dispose ONLY if internally created
    if (!_isExternalController) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// TEXT FIELD
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF1F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: widget.hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: const Color(0xFF3F51B5))
                  : null,
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),

        /// DROPDOWN
        if (_results.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];

                return ListTile(
                  title: Text(widget.displayText(item)),
                  onTap: () => _onSelect(item),
                );
              },
            ),
          ),
      ],
    );
  }
}
