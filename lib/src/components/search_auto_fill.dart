import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SearchAutoFill extends StatefulWidget {
  final int minCharactersForSuggestions;
  final Future<List<String>> Function(String) fetchSuggestions;

  const SearchAutoFill({
    Key? key,
    required this.minCharactersForSuggestions,
    required this.fetchSuggestions,
  }) : super(key: key);

  @override
  _SearchAutoFillState createState() => _SearchAutoFillState();
}

class _SearchAutoFillState extends State<SearchAutoFill> {
  final TextEditingController _controller = TextEditingController();
  final BehaviorSubject<String> _debounce = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_controller.text.length >= widget.minCharactersForSuggestions) {
      _debounce.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
        StreamBuilder<String>(
          stream:
              _debounce.stream.debounceTime(const Duration(milliseconds: 500)),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.length >= widget.minCharactersForSuggestions) {
              return FutureBuilder<List<String>>(
                future: widget.fetchSuggestions(snapshot.data!),
                builder: (context, suggestionsSnapshot) {
                  if (suggestionsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (suggestionsSnapshot.hasData &&
                      suggestionsSnapshot.data!.isNotEmpty) {
                    return _buildSuggestionsDropdown(suggestionsSnapshot.data!);
                  }
                  return Container();
                },
              );
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildSuggestionsDropdown(List<String> suggestions) {
    return DropdownButton<String>(
      items: suggestions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        _controller.text = newValue ?? '';
      },
    );
  }
}
