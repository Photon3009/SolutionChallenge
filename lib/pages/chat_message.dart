import 'package:flutter/material.dart';
import 'package:heatlth1/theme/style.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(sender,style: TextStyle(color: Colors.white),)
            .text
            .subtitle1(context)
            .make()
            .box
            .color(sender == "You" ? apnaColor : Color.fromARGB(255, 240, 134, 51))
            .p16
            .rounded
            .alignCenter
            .makeCentered(),
        Expanded(
          child: isImage
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    text,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : const CircularProgressIndicator.adaptive(),
                  ),
                )
              : text.trim().text.bodyText1(context).make().px8(),
        ),
      ],
    ).py8();
  }
}