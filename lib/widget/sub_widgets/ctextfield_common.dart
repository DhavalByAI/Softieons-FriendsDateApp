// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_friends_date_app/utils/app_colors.dart';

bool obSecure = false;

class cTextFieldCommon extends StatefulWidget {
  final TextEditingController? controller;
  final String? label, hint;
  String? errorText;
  TextInputType? textInputType = TextInputType.text;
  bool? obscureText;
  Function()? validate;
  bool? btnValidate = false;
  Color? fontColor;
  int? maxLines;
  int? maxLength;
  Function()? onTap;
  bool? autoFocus;
  bool? enabled;
  List<TextInputFormatter>? textInputFormatter;
  Function()? onEditingComplete;
  TextStyle? textStyle;
  TextAlign? textAlign;
  Function(String)? onChanged;
  TextCapitalization textCapitalization;

  cTextFieldCommon(
      {super.key,
      this.controller,
      this.label,
      this.hint,
      this.textInputType,
      this.errorText,
      this.obscureText,
      this.validate,
      this.btnValidate,
      this.onTap,
      this.enabled,
      this.maxLines,
      this.autoFocus,
      this.maxLength,
      this.onEditingComplete,
      this.textInputFormatter,
      this.textStyle,
      this.onChanged,
      this.textAlign = TextAlign.start,
      this.textCapitalization = TextCapitalization.none,
      this.fontColor});

  @override
  State<cTextFieldCommon> createState() => _cTextFieldCommonState();
}

class _cTextFieldCommonState extends State<cTextFieldCommon> {
  @override
  void initState() {
    setState(() {
      widget.obscureText != null
          ? obSecure = widget.obscureText!
          : obSecure = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        onTap: widget.onTap,
        onEditingComplete: widget.onEditingComplete,
        autofocus: widget.autoFocus ?? false,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines ?? 1,
        maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        obscureText: obSecure,
        textAlign: widget.textAlign!,
        inputFormatters: widget.textInputFormatter,
        textCapitalization: widget.textCapitalization,
        style: widget.textStyle ??
            TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: widget.fontColor ?? Colors.black,
            ),
        decoration: InputDecoration(
            errorText: widget.errorText,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: const BorderSide(
                    width: 0, color: AppColors.scafflodBackground)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: const BorderSide(
                    width: 0, color: AppColors.scafflodBackground)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide:
                    const BorderSide(width: 0, color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide:
                    const BorderSide(width: 0, color: Colors.transparent)),
            isCollapsed: true,
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 30,
            ),
            suffixIcon: widget.obscureText != null
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        obSecure = !obSecure;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        obSecure ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.mainColor.withOpacity(0.5),
                      ),
                    ),
                  )
                : null,
            labelText: widget.label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black,
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.black.withOpacity(0.4),
            )),
      ),
    );
  }
}
