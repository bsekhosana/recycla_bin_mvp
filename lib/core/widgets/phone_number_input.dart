import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:country_code_picker/country_code_picker.dart';

class PhoneNumberInput extends StatefulWidget {
  final TextEditingController? controller;

  const PhoneNumberInput({super.key, this.controller});

  @override
  PhoneNumberInputState createState() => PhoneNumberInputState();

  static String getFormattedPhoneNumber(GlobalKey<PhoneNumberInputState> key) {
    return key.currentState?.getFormattedPhoneNumber() ?? '';
  }
}

class PhoneNumberInputState extends State<PhoneNumberInput> {
  final TextEditingController _internalController = TextEditingController();
  late TextEditingController _controller;
  String _initialCountry = 'ZA';
  PhoneNumber _number = PhoneNumber(isoCode: 'ZA');
  bool _isValid = false;

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      _initialCountry = countryCode.code!;
      _number = PhoneNumber(isoCode: _initialCountry);
    });
  }

  void _onInputChanged(PhoneNumber number) {
    print('_onInputChanged:${number} old number:${_number}');
    _number = number;
  }

  void _onInputValidated(bool value) {
    if(value != _isValid){
      print('_onInputValidated');
      setState(() {
        _isValid = value;
      });
    }
  }

  String getFormattedPhoneNumber() {
    return _number.phoneNumber ?? '';
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? _internalController;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          child: InternationalPhoneNumberInput(
            onInputChanged: _onInputChanged,
            onInputValidated: _onInputValidated,
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DROPDOWN,
              useEmoji: true,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectorTextStyle: const TextStyle(color: Colors.black),
            initialValue: _number,
            textFieldController: _controller,
            inputDecoration: InputDecoration(
              hintText: 'Enter phone number',
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              suffixIcon: _isValid
                  ? const Icon(
                Icons.check,
                color: Colors.green,
              )
                  : null,
            ),
            formatInput: true,
            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            inputBorder: InputBorder.none,
            onSaved: (PhoneNumber number) {
              print('On Saved: $number');
            },
          ),
        ),
        if (_isValid)
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              'Valid phone number',
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
