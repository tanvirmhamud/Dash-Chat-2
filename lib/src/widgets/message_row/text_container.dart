part of dash_chat_2;

/// @nodoc
class TextContainer extends StatefulWidget {
  const TextContainer({
    required this.message,
    this.messageOptions = const MessageOptions(),
    this.previousMessage,
    this.nextMessage,
    this.isOwnMessage = false,
    this.isPreviousSameAuthor = false,
    this.isNextSameAuthor = false,
    this.isAfterDateSeparator = false,
    this.isBeforeDateSeparator = false,
    this.messageTextBuilder,
    Key? key,
    this.onHorizontalDragStart,
    this.onPanStart,
    this.onPanEnd,
    this.positionleft,
    this.positionright,
    this.duration,
    this.transform,
  }) : super(key: key);

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  /// Message that contains the text to show
  final ChatMessage message;

  /// Previous message in the list
  final ChatMessage? previousMessage;

  /// Next message in the list
  final ChatMessage? nextMessage;

  /// If the message is from the current user
  final bool isOwnMessage;

  /// If the previous message is from the same author as the current one
  final bool isPreviousSameAuthor;

  /// If the next message is from the same author as the current one
  final bool isNextSameAuthor;

  /// If the message is preceded by a date separator
  final bool isAfterDateSeparator;

  /// If the message is before by a date separator
  final bool isBeforeDateSeparator;
  final Function(DragUpdateDetails, ChatMessage)? onHorizontalDragStart;
  final Function(DragStartDetails, ChatMessage)? onPanStart;
  final Function(DragEndDetails, ChatMessage)? onPanEnd;
  final double? positionleft;
  final double? positionright;
  final Duration? duration;
  final Matrix4? transform;

  /// We could acces that from messageOptions but we want to reuse this widget
  /// for media and be able to override the text builder
  final Widget Function(ChatMessage, ChatMessage?, ChatMessage?)?
      messageTextBuilder;

  @override
  State<TextContainer> createState() => _TextContainerState();
}

class _TextContainerState extends State<TextContainer>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _animation = Tween<double>(
      begin: 0.0,
      end: 50.0,
    ).animate(_controller);

    _controller.addListener(() {
      // if (_controller.) {
      //   movevalue = _animation.value;
      // }
      if (_controller.isAnimating && reverse == true) {
        movevalue = _animation.value;
        if (_controller.isCompleted) {
          _controller.reset();
          reverse = false;
        }
      }
      setState(() {});
    });
    super.initState();
  }

  bool reverse = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double movevalue = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        print(movevalue);
        // Swiping in right direction.
        setState(() {
          if (movevalue <= 50.0) {
            movevalue = details.delta.dx * movevalue + 5;
          }
        });
      },
      onPanStart: (details) {
        setState(() {
          _controller.forward();
        });
      },
      onPanEnd: (details) {
        setState(() {
          reverse = true;
        });
        _controller.reverse();
        widget.messageOptions.onPanEnd!(details, widget.message);

        // print(_animation.value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: Matrix4.translationValues(movevalue, 0, 0),
        decoration: widget.messageOptions.messageDecorationBuilder != null
            ? widget.messageOptions.messageDecorationBuilder!(
                widget.message, widget.previousMessage, widget.nextMessage)
            : defaultMessageDecoration(
                color: widget.isOwnMessage
                    ? widget.messageOptions.currentUserContainerColor(context)
                    : widget.messageOptions.containerColor,
                borderTopLeft: widget.isPreviousSameAuthor &&
                        !widget.isOwnMessage &&
                        !widget.isAfterDateSeparator
                    ? 0.0
                    : widget.messageOptions.borderRadius,
                borderTopRight: widget.isPreviousSameAuthor &&
                        widget.isOwnMessage &&
                        !widget.isAfterDateSeparator
                    ? 0.0
                    : widget.messageOptions.borderRadius,
                borderBottomLeft: !widget.isOwnMessage &&
                        !widget.isBeforeDateSeparator &&
                        widget.isNextSameAuthor
                    ? 0.0
                    : widget.messageOptions.borderRadius,
                borderBottomRight: widget.isOwnMessage &&
                        !widget.isBeforeDateSeparator &&
                        widget.isNextSameAuthor
                    ? 0.0
                    : widget.messageOptions.borderRadius,
              ),
        padding: widget.messageOptions.messagePadding,
        child: widget.messageTextBuilder != null
            ? widget.messageTextBuilder!(
                widget.message, widget.previousMessage, widget.nextMessage)
            : DefaultMessageText(
                message: widget.message,
                isOwnMessage: widget.isOwnMessage,
                messageOptions: widget.messageOptions,
              ),
      ),
    );
  }
}
