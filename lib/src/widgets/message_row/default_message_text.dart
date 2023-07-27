// ignore_for_file: always_specify_types

part of dash_chat_2;

/// {@category Default widgets}
class DefaultMessageText extends StatelessWidget {
  DefaultMessageText({
    required this.message,
    required this.isOwnMessage,
    this.messageOptions = const MessageOptions(),
    Key? key,
  }) : super(key: key);

  /// Message tha contains the text to show
  final ChatMessage message;

  /// If the message is from the current user
  final bool isOwnMessage;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;
  GlobalKey<State<StatefulWidget>> sizekey = GlobalKey();
  Size? redboxSize;

  Size getRedBoxSize(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.end,
      children: <Widget>[
        Wrap(
          alignment: isOwnMessage ? WrapAlignment.end : WrapAlignment.end,
          children: getMessage(context),
        ),

        // if (messageOptions.showTime)
        //   messageOptions.messageTimeBuilder != null
        //       ? messageOptions.messageTimeBuilder!(message, isOwnMessage)
        //       : Padding(
        //           padding: messageOptions.timePadding,
        //           child: Text(
        //             (messageOptions.timeFormat ?? intl.DateFormat('HH:mm'))
        //                 .format(message.createdAt),
        //             style: TextStyle(
        //               color: isOwnMessage
        //                   ? messageOptions.currentUserTimeTextColor(context)
        //                   : messageOptions.timeTextColor(),
        //               fontSize: messageOptions.timeFontSize,
        //             ),
        //           ),
        //         ),
      ],
    );
  }

  List<Widget> getMessage(BuildContext context) {
    if (message.mentions != null && message.mentions!.isNotEmpty) {
      String stringRegex = r'([\s\S]*)';
      String stringMentionRegex = '';
      for (final Mention mention in message.mentions!) {
        stringRegex += '(${mention.title})' r'([\s\S]*)';
        stringMentionRegex += stringMentionRegex.isEmpty
            ? '(${mention.title})'
            : '|(${mention.title})';
      }
      final RegExp mentionRegex = RegExp(stringMentionRegex);
      final RegExp regexp = RegExp(stringRegex);

      RegExpMatch? match = regexp.firstMatch(message.text);
      if (match != null) {
        List<Widget> res = <Widget>[];
        match
            .groups(List<int>.generate(match.groupCount, (int i) => i + 1))
            .forEach((String? part) {
          if (mentionRegex.hasMatch(part!)) {
            Mention mention = message.mentions!.firstWhere(
              (Mention m) => m.title == part,
            );
            res.add(getMention(context, mention));
          } else {
            res.add(getParsePattern(context, part));
          }
        });
        if (res.isNotEmpty) {
          return res;
        }
      }
    }
    return <Widget>[
      getParsePattern(context, message.text),
      const SizedBox(width: 3),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Padding(
          //   padding: messageOptions.timePadding,
          //   child: Text(
          //     (messageOptions.timeFormat ?? intl.DateFormat('HH:mm'))
          //         .format(message.createdAt),
          //     style: TextStyle(
          //       color: isOwnMessage
          //           ? messageOptions.currentUserTimeTextColor(context)
          //           : messageOptions.timeTextColor(),
          //       fontSize: messageOptions.timeFontSize,
          //       fontFamily: 'Roboto',
          //       fontWeight: FontWeight.w400,
          //       letterSpacing: messageOptions.letterSpacing,
          //     ),
          //   ),
          // ),
        ],
      ),
      // SizedBox(width: 3),
      // Container(
      //   height: 14,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       SvgPicture.asset(
      //         "assets/messageseen.svg",
      //         package: 'dash_chat_2',
      //       ),
      //     ],
      //   ),
      // ),

      // Row(
      //   mainAxisSize: MainAxisSize.min,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     SizedBox(width: 3),
      //     Padding(
      //       padding: messageOptions.timePadding,
      //       child: Text(
      //         (messageOptions.timeFormat ?? intl.DateFormat('HH:mm'))
      //             .format(message.createdAt),

      //         style: TextStyle(
      //           color: isOwnMessage
      //               ? messageOptions.currentUserTimeTextColor(context)
      //               : messageOptions.timeTextColor(),
      //           fontSize: messageOptions.timeFontSize,
      //         ),
      //       ),
      //     )
      //   ],
      // )

      // Padding(
      //   padding: messageOptions.timePadding,
      //   child: Text(
      //     (messageOptions.timeFormat ?? intl.DateFormat(' HH:mm'))
      //         .format(message.createdAt),
      //     style: TextStyle(
      //       color: isOwnMessage
      //           ? messageOptions.currentUserTimeTextColor(context)
      //           : messageOptions.timeTextColor(),
      //       fontSize: messageOptions.timeFontSize,
      //     ),
      //   ),
      // ),
    ];
  }

  Widget getParsePattern(BuildContext context, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: text,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: isOwnMessage
                        ? messageOptions.currentUserTextColor(context)
                        : messageOptions.textColor,
                  ),
                ),
                WidgetSpan(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize:
                        text.length <= 30 ? MainAxisSize.min : MainAxisSize.max,
                    children: [
                      SizedBox(width: 3),
                      Padding(
                        padding: messageOptions.timePadding,
                        child: Text(
                          (messageOptions.timeFormat ??
                                  intl.DateFormat('HH:mm'))
                              .format(message.createdAt),
                          style: TextStyle(
                            color: isOwnMessage
                                ? messageOptions
                                    .currentUserTimeTextColor(context)
                                : messageOptions.timeTextColor(),
                            fontSize: messageOptions.timeFontSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            letterSpacing: messageOptions.letterSpacing,
                          ),
                        ),
                      ),
                      if (isOwnMessage) const SizedBox(width: 3),
                      if (isOwnMessage)
                        Container(
                          height: 12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/messageseen.svg",
                                package: 'dash_chat_2',
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // TextSpan(
                //   text: (messageOptions.timeFormat ?? intl.DateFormat('HH:mm'))
                //       .format(message.createdAt),
                //   style: TextStyle(
                //     color: isOwnMessage
                //         ? messageOptions.currentUserTimeTextColor(context)
                //         : messageOptions.timeTextColor(),
                //     fontSize: messageOptions.timeFontSize,
                //     fontFamily: 'Roboto',
                //     fontWeight: FontWeight.w400,
                //     letterSpacing: messageOptions.letterSpacing,
                //   ),
                // )
              ],
            ),
          ),
          // child: ParsedText(
          //   parse: messageOptions.parsePatterns != null
          //       ? messageOptions.parsePatterns!
          //       : defaultPersePatterns,
          //   text: text,
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontFamily: 'Roboto',
          //     fontWeight: FontWeight.w400,
          //     color: isOwnMessage
          //         ? messageOptions.currentUserTextColor(context)
          //         : messageOptions.textColor,
          //   ),
          // ),
        ),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Padding(
        //       padding: messageOptions.timePadding,
        //       child: Text(
        //         (messageOptions.timeFormat ?? intl.DateFormat('HH:mm'))
        //             .format(message.createdAt),
        //         style: TextStyle(
        //           color: isOwnMessage
        //               ? messageOptions.currentUserTimeTextColor(context)
        //               : messageOptions.timeTextColor(),
        //           fontSize: messageOptions.timeFontSize,
        //           fontFamily: 'Roboto',
        //           fontWeight: FontWeight.w400,
        //           letterSpacing: messageOptions.letterSpacing,
        //         ),
        //       ),
        //     ),
        //     if (isOwnMessage) const SizedBox(width: 3),
        //     if (isOwnMessage)
        //       Container(
        //         height: 12,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: [
        //             SvgPicture.asset(
        //               "assets/messageseen.svg",
        //               package: 'dash_chat_2',
        //             ),
        //           ],
        //         ),
        //       ),
        //     const SizedBox(width: 10.47),
        //   ],
        // ),
      ],
    );
  }

  Widget getMention(BuildContext context, Mention mention) {
    return RichText(
      text: TextSpan(
        text: mention.title,
        recognizer: TapGestureRecognizer()
          ..onTap = () => messageOptions.onPressMention != null
              ? messageOptions.onPressMention!(mention)
              : null,
        style: TextStyle(
          color: isOwnMessage
              ? messageOptions.currentUserTextColor(context)
              : messageOptions.textColor,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
