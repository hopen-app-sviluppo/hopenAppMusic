import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import '../helpers/crea_assistito_provider.dart';

class ClientTextField extends StatefulWidget {
  final int maxLength;
  final TextInputAction? textInputAction;
  final String labelText;
  final IconData prefixIcon;
  final bool readOnly;
  final void Function()? onTap;
  final TextInputType? textInputType;
  final String valToValidate;

  const ClientTextField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    required this.valToValidate,
    this.maxLength = 15,
    this.textInputAction,
    this.readOnly = false,
    this.onTap,
    this.textInputType,
  }) : super(key: key);

  @override
  State<ClientTextField> createState() => _ClientTextFieldState();
}

class _ClientTextFieldState extends State<ClientTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final String? initialValue = context
        .read<CreaAssistitoProvider>()
        .getCurrentField(widget.valToValidate);
    _controller = TextEditingController(text: initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(
        color: MainColor.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      readOnly: widget.readOnly,
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      keyboardType: widget.textInputType ?? TextInputType.text,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      onTap: widget.onTap,
      onChanged: (val) => context
          .read<CreaAssistitoProvider>()
          .updateField(widget.valToValidate, val),
      decoration: InputDecoration(
        label: Text(
          widget.labelText,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: MainColor.primaryColor,
          size: Theme.of(context).iconTheme.size,
        ),
        border: InputBorder.none,
      ),
    );
  }
}

//text field ma per scegliere la data
class DatePickerField extends StatefulWidget {
  final String labelText;
  final String valToValidate;
  const DatePickerField({
    Key? key,
    required this.labelText,
    required this.valToValidate,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final String? initialValue = context
        .read<CreaAssistitoProvider>()
        .getCurrentField(widget.valToValidate);
    _dateController = TextEditingController(
      text: initialValue,
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateController,
      style: const TextStyle(
        color: MainColor.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1920),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          //2022-07-12
          _dateController.text = date.toString().substring(0, 10);

          context.read<CreaAssistitoProvider>().updateDate(
                widget.valToValidate,
                _dateController.text,
              );
        }
      },
      decoration: InputDecoration(
        label: Text(
          widget.labelText,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        prefixIcon: const Icon(
          Icons.edit_calendar,
          color: MainColor.primaryColor,
        ),
        border: InputBorder.none,
      ),
    );
  }
}
