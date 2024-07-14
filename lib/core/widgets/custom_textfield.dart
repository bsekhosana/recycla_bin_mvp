import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData leadingIcon;
  final IconData? trailingIcon;
  final String hintText;
  final String? labelText;
  final TextInputType inputType;
  final bool obscureText;
  final String? validationMessage;

  const CustomTextField({super.key, 
    required this.controller,
    required this.leadingIcon,
    this.trailingIcon,
    required this.hintText,
    this.labelText,
    this.inputType = TextInputType.text,
    required this.obscureText,
    this.validationMessage,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _validate() {
    setState(() {
      if (widget.controller.text.isEmpty) {
        _errorMessage = widget.validationMessage ?? 'This field cannot be empty';
      } else {
        _errorMessage = null;
      }
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: widget.controller,
          keyboardType: widget.inputType,
          obscureText: _obscureText,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 0.0, end: 15),
              child: Icon(widget.leadingIcon, color: Colors.grey), // Prefix icon padding for alignment
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: _toggleObscureText,
            )
                : (widget.trailingIcon != null
                ? Icon(widget.trailingIcon, color: Colors.grey)
                : null),
            hintText: widget.hintText,
            labelText: widget.labelText,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            errorText: _errorMessage,
          ),
          onChanged: (text) {
            _validate();
          },
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
