import 'package:flutter/material.dart';

class VerificationCodeInput extends StatefulWidget {
  final Function(String) onInputChanged;

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
      widget.onInputChanged(_getCode());
      if (value.isNotEmpty && index < _numSlots - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    });
  }

  String _getCode() {
    return _controllers.map((controller) => controller.text).join();
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
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.048,
                color: Colors.black,
                fontWeight: FontWeight.bold),
            maxLength: 1,
            decoration: InputDecoration(
              hintText: "0",
              hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.048,
                  color: Colors.grey.shade400),
              counterText: "",
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _isFilled[index] ? Colors.green : Colors.grey,
                  width: _isFilled[index] ? 2 : 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: _isFilled[index] ? Colors.green : Colors.grey,
                  width: _isFilled[index] ? 2 : 1,
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
