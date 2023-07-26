part of dash_chat_2;

/// @nodoc
class MessageRow extends StatefulWidget {
  const MessageRow({
    required this.message,
    required this.currentUser,
    this.previousMessage,
    this.nextMessage,
    this.isAfterDateSeparator = false,
    this.isBeforeDateSeparator = false,
    this.messageOptions = const MessageOptions(),
    Key? key,

  }) : super(key: key);

  /// Current message to show
  final ChatMessage message;

  /// Previous message in the list
  final ChatMessage? previousMessage;

  /// Next message in the list
  final ChatMessage? nextMessage;

  /// Current user of the chat
  final ChatUser currentUser;

  /// If the message is preceded by a date separator
  final bool isAfterDateSeparator;

  /// If the message is before a date separator
  final bool isBeforeDateSeparator;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;



  @override
  State<MessageRow> createState() => _MessageRowState();
}

class _MessageRowState extends State<MessageRow> with TickerProviderStateMixin {
  /// Get the avatar widget
  Widget getAvatar() {
    return widget.messageOptions.avatarBuilder != null
        ? widget.messageOptions.avatarBuilder!(
            widget.message.user,
            widget.messageOptions.onPressAvatar,
            widget.messageOptions.onLongPressAvatar,
          )
        : DefaultAvatar(
            user: widget.message.user,
            onLongPressAvatar: widget.messageOptions.onLongPressAvatar,
            onPressAvatar: widget.messageOptions.onPressAvatar,
          );
  }


  @override
  Widget build(BuildContext context) {
    final bool isOwnMessage = widget.message.user.id == widget.currentUser.id;
    bool isPreviousSameAuthor = false;
    bool isNextSameAuthor = false;
    if (widget.previousMessage != null &&
        widget.previousMessage!.user.id == widget.message.user.id) {
      isPreviousSameAuthor = true;
    }
    if (widget.nextMessage != null &&
        widget.nextMessage!.user.id == widget.message.user.id) {
      isNextSameAuthor = true;
    }

    return Container(
      margin: widget.isAfterDateSeparator
          ? EdgeInsets.zero
          : isPreviousSameAuthor
              ? widget.messageOptions.marginSameAuthor
              : widget.messageOptions.marginDifferentAuthor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (widget.messageOptions.showOtherUsersAvatar)
            Opacity(
              opacity: !isOwnMessage &&
                      (!isNextSameAuthor || widget.isBeforeDateSeparator)
                  ? 1
                  : 0,
              child: getAvatar(),
            ),
          if (!widget.messageOptions.showOtherUsersAvatar)
            SizedBox(width: widget.messageOptions.spaceWhenAvatarIsHidden),
          GestureDetector(
            
            onLongPress: widget.messageOptions.onLongPressMessage != null
                ? () =>
                    widget.messageOptions.onLongPressMessage!(widget.message)
                : null,
            onTap: widget.messageOptions.onPressMessage != null
                ? () => widget.messageOptions.onPressMessage!(widget.message)
                : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.messageOptions.maxWidth ??
                    MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: isOwnMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (widget.messageOptions.top != null)
                    widget.messageOptions.top!(widget.message,
                        widget.previousMessage, widget.nextMessage),
                  if (!isOwnMessage &&
                      widget.messageOptions.showOtherUsersName &&
                      (!isPreviousSameAuthor || widget.isAfterDateSeparator))
                    widget.messageOptions.userNameBuilder != null
                        ? widget.messageOptions
                            .userNameBuilder!(widget.message.user)
                        : DefaultUserName(user: widget.message.user),
                  if (widget.message.medias != null &&
                      widget.message.medias!.isNotEmpty &&
                      widget.messageOptions.textBeforeMedia)
                    widget.messageOptions.messageMediaBuilder != null
                        ? widget.messageOptions.messageMediaBuilder!(
                            widget.message,
                            widget.previousMessage,
                            widget.nextMessage)
                        : MediaContainer(
                            message: widget.message,
                            isOwnMessage: isOwnMessage,
                            messageOptions: widget.messageOptions,
                          ),
                  if (widget.message.text.isNotEmpty)
                    TextContainer(
                      duration: widget.messageOptions.duration,
                      messageOptions: widget.messageOptions,
                      message: widget.message,
                      previousMessage: widget.previousMessage,
                      nextMessage: widget.nextMessage,
                      isOwnMessage: isOwnMessage,
                      isNextSameAuthor: isNextSameAuthor,
                      isPreviousSameAuthor: isPreviousSameAuthor,
                      isAfterDateSeparator: widget.isAfterDateSeparator,
                      isBeforeDateSeparator: widget.isBeforeDateSeparator,
                      messageTextBuilder:
                          widget.messageOptions.messageTextBuilder,
                    ),
                  if (widget.message.medias != null &&
                      widget.message.medias!.isNotEmpty &&
                      !widget.messageOptions.textBeforeMedia)
                    widget.messageOptions.messageMediaBuilder != null
                        ? widget.messageOptions.messageMediaBuilder!(
                            widget.message,
                            widget.previousMessage,
                            widget.nextMessage)
                        : MediaContainer(
                            message: widget.message,
                            isOwnMessage: isOwnMessage,
                            messageOptions: widget.messageOptions,
                          ),
                  if (widget.messageOptions.bottom != null)
                    widget.messageOptions.bottom!(widget.message,
                        widget.previousMessage, widget.nextMessage),
                ],
              ),
            ),
          ),
          if (widget.messageOptions.showCurrentUserAvatar)
            Opacity(
              opacity: isOwnMessage && !isNextSameAuthor ? 1 : 0,
              child: getAvatar(),
            ),
          if (!widget.messageOptions.showCurrentUserAvatar)
            SizedBox(width: widget.messageOptions.spaceWhenAvatarIsHidden),
        ],
      ),
    );
  }
}
