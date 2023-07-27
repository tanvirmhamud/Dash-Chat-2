part of dash_chat_2;

/// {@category Default widgets}
Widget Function(Function send) defaultSendButton({
  required Color color,
  IconData icon = Icons.send,
  EdgeInsets? padding,
}) =>
    (Function fct) => InkWell(
          onTap: () => fct(),
          child: Padding(
            padding: padding ??
                const EdgeInsets.only(left: 5,right: 10),
            // child: Icon(
            //   Icons.send,
            //   color: color,
            // ),
            child: SvgPicture.asset("assets/send.svg",package: 'dash_chat_2'),
          ),
        );
