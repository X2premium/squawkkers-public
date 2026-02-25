import 'package:flutter/material.dart';
import 'package:squawker/client/client.dart';
import 'package:squawker/tweet/tweet.dart';
import 'package:squawker/utils/iterables.dart';

class TweetConversation extends StatefulWidget {
  final String id;
  final String? username;
  final bool isPinned;
  final List<TweetWithCard> tweets;
  final Map<String,int>? tweetIdxDic;
  final VisiblePositionState? visiblePositionState;

  const TweetConversation(
      {Key? key, required this.id, required this.username, required this.isPinned, required this.tweets, this.tweetIdxDic, this.visiblePositionState})
      : super(key: key);

  @override
  State<TweetConversation> createState() => _TweetConversationState();
}

class _TweetConversationState extends State<TweetConversation> {
  @override
  Widget build(BuildContext context) {
    if (widget.tweets.length == 1) {
      return TweetTile(
          conversationId: widget.id, clickable: true, tweet: widget.tweets.first, currentUsername: widget.username, isPinned: widget.isPinned, tweetIdx: widget.tweetIdxDic == null ? null : widget.tweetIdxDic![widget.tweets.first.idStr], visiblePositionState: widget.visiblePositionState);
    }

    var tiles = [];
    var tweets = widget.tweets;

    // We need to do a simple for loop so we can mark the first item as the thread start
    for (var i = 0; i < tweets.length; i++) {
      tiles.add(TweetTile(
        conversationId: widget.id,
        clickable: true,
        tweet: tweets[i],
        currentUsername: widget.username,
        isPinned: widget.isPinned,
        isThread: i == 0,
        tweetIdx: widget.tweetIdxDic == null ? null : widget.tweetIdxDic![tweets[i].idStr],
        visiblePositionState: widget.visiblePositionState)
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 3),
        ),
      ),
      child: Column(
        children: [
          ...tiles,
        ],
      ),
    );
  }
}
