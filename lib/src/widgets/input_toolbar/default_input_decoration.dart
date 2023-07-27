part of dash_chat_2;

/// {@category Default widgets}
InputDecoration defaultInputDecoration({
  String hintText = 'Write a message...',
  TextStyle hintStyle = const TextStyle(color: Colors.grey),
  Color? fillColor,
  GestureTapCallback? onTap,
}) =>
    InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: hintStyle,
        filled: false,
        fillColor: fillColor ?? Colors.grey[100],
        suffixIconConstraints: const BoxConstraints(
          minWidth: 30.09,
          minHeight: 21,
        ),
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: SvgPicture.asset("assets/emoji.svg", package: 'dash_chat_2'),
        ),
        contentPadding: const EdgeInsets.only(
          left: 16,
          top: 9,
          bottom: 9,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            // borderSide: const BorderSide(
            //   width: 0,
            //   style: BorderStyle.none,
            // ),
            borderSide: const BorderSide(width: 0.25, color: Color(0xFF8E8E93))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            // borderSide: const BorderSide(
            //   width: 0,
            //   style: BorderStyle.none,
            // ),
            borderSide: const BorderSide(width: 0.25, color: Color(0xFF8E8E93))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            // borderSide: const BorderSide(
            //   width: 0,
            //   style: BorderStyle.none,
            // ),
            borderSide: const BorderSide(width: 0.25, color: Color(0xFF8E8E93))));
