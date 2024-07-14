import 'package:flutter/material.dart';

class VerificationCodeInput extends StatefulWidget {
  final Function(bool) onInputChanged;

  const VerificationCodeInput({super.key, required this.onInputChanged});

  @override
  _VerificationCodeInputState createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final int _numSlots = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  final List<bool> _isFilled = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _numSlots; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      _isFilled.add(false);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    setState(() {
      _isFilled[index] = value.isNotEmpty;
      widget.onInputChanged(_allInputsFilled());
      if (value.isNotEmpty && index < _numSlots - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    });
  }

  bool _allInputsFilled() {
    return _isFilled.every((isFilled) => isFilled);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_numSlots, (index) {
        return SizedBox(
          width: 40,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _isFilled[index] ? Colors.green : Colors.grey,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _isFilled[index] ? Colors.green : Colors.grey,
                ),
              ),
            ),
            onChanged: (value) => _onChanged(index, value),
          ),
        );
      }),
    );
  }
}
