import 'package:flutter/material.dart';

class ServieceNeeded extends StatefulWidget {
  final Function(String selected) onSelectionChanged; // Storing the callback

  const ServieceNeeded(
      {super.key, required this.onSelectionChanged}); // Updated constructor

  @override
  _ServieceNeeded createState() => _ServieceNeeded();
}

class _ServieceNeeded extends State<ServieceNeeded> {
  bool _isExpanded = false;
  final TextEditingController _controller = TextEditingController();
  String _selectedHintText = 'Choose Service';

  void _addToTextField(String mainText, String hintText) {
    setState(() {
      _selectedHintText = mainText;
      _controller.text = hintText;
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: hintText.length));
      _isExpanded = false;
    });

    widget.onSelectionChanged(hintText); // Notify the parent of the selection
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Container(
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: _selectedHintText,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded)
                Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF57CC99)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPartition(
                          'Nursing (basic nursing services)', 'Nursing'),
                      const Divider(color: Colors.grey),
                      _buildPartition(
                          'Assistance (accompanying to places such as hospitals, banks, shops etc and also going on behalf of them)',
                          'Assistance'),
                      const Divider(color: Colors.grey),
                      _buildPartition(
                          'Companionship (This includes engaging in conversations, listening to their stories, and offering a comforting presence. Additionally, companions assist with practical needs such as giving food, medication, and ensuring the patient feels cared for and attended to.)',
                          'Companionship'),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPartition(String mainText, String hintText) {
    final bracketStart = mainText.indexOf('(');
    final bracketEnd = mainText.indexOf(')') + 1;

    final beforeBracketText = mainText.substring(0, bracketStart);
    final bracketText = mainText.substring(bracketStart, bracketEnd);
    final afterBracketText = mainText.substring(bracketEnd);

    return GestureDetector(
      onTap: () {
        _addToTextField(mainText, hintText);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: beforeBracketText,
                style: const TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: bracketText,
                style: const TextStyle(color: Colors.grey),
              ),
              TextSpan(
                text: afterBracketText,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
