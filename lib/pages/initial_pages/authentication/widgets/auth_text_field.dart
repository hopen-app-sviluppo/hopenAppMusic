import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/pages/initial_pages/authentication/helper/models.dart';
import 'package:provider/provider.dart';
import '../helper/auth_validator.dart';
import '../../../../theme.dart';

class AuthTextField extends StatefulWidget {
  final IconData prefixIcon;
  final double? height;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final AuthField authField;

  const AuthTextField({
    Key? key,
    required this.prefixIcon,
    required this.maxLength,
    required this.authField,
    this.height,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFieldValid = widget.authField.isCorrect();
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: TextField(
        controller: _controller,
        style: TextStyle(
          color: isFieldValid ? MainColor.primaryColor : MainColor.redColor,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.maxLength),
        ],
        obscureText: widget.authField.authFieldType == AuthFieldType.psw,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onChanged: (newVal) {
          final res = widget.authField.onFieldValiding(newVal);
          if (res) {
            context.read<AuthValidator>().canAuth();
          }
          setState(() {});
        },
        //quando utente preme text input action, lo chiamo solo se preme il Done
        onSubmitted: widget.textInputAction != TextInputAction.done
            ? null
            : (newVal) {
                // print("ciao");
                widget.authField.onFieldValiding(newVal);
                setState(() {});
                //devo far ribuildare authentication page
                context.read<AuthValidator>().rebuild();
              },
        decoration:
            _buildDecoration(isFieldValid, widget.authField.error, true),
      ),
    );
  }

  InputDecoration _buildDecoration(
    bool isFieldValid,
    String? currentError,
    bool isFieldMandatory,
  ) =>
      InputDecoration(
        label: Text(
          widget.authField.name,
          style: isFieldValid
              ? Theme.of(context).textTheme.bodyText1
              : Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: MainColor.redColor),
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: isFieldValid ? MainColor.primaryColor : MainColor.redColor,
          size: Theme.of(context).iconTheme.size,
        ),
        suffixIcon: isFieldValid
            ? null
            : GestureDetector(
                onTap: () async => await _buildShowDialog(
                  context,
                  currentError,
                ),
                child: Icon(
                  Icons.error,
                  color: MainColor.redColor,
                  size: Theme.of(context).iconTheme.size,
                ),
              ),
        border: InputBorder.none,
      );

  _buildShowDialog(
    BuildContext context,
    String? contentText,
  ) {
    List<String> arrayErrors = [];
    if (contentText != null) {
      arrayErrors = contentText.split("\n");
    }
    arrayErrors.insert(0, "Il campo è obbligatorio");
    //se campo obbligatorio
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.all(10.0),
        elevation: 10.0,
        backgroundColor: MainColor.primaryColor.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: arrayErrors
              .map((String currentError) => currentError == ""
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: 30.0,
                          ),
                          Expanded(child: Text(currentError)),
                        ],
                      ),
                    ))
              .toList(),
        ),
      ),
    );
  }
}
