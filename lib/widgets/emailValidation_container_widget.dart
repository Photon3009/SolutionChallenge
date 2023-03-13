import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../theme/style.dart';

class EmailValidationContainerWidget extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? hintText;
  final double? borderRadius;
  final Color? color;
  final iconClickEvent;
  

  EmailValidationContainerWidget(
      {Key? key,
      this.controller,
      this.prefixIcon,
      this.keyboardType,
      this.hintText,
      this.borderRadius = 10,
      this.color,
      this.iconClickEvent,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: color == null ? color747480.withOpacity(.2) : color,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: ((email) =>
                (email != null && EmailValidator.validate(email))
                    ? 'Enter a valid email'
                    : null),
            decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                prefixIcon:
                    InkWell(onTap: iconClickEvent, child: Icon(prefixIcon)))),
      
    );
  }
}
