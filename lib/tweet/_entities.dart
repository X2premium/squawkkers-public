import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

abstract class TweetEntity {
  List<int>? indices;

  TweetEntity(this.indices);

  InlineSpan getContent();

  int getEntityStart() {
    return indices![0];
  }

  int getEntityEnd() {
    return indices![1];
  }
}

class TweetHashtag extends TweetEntity {
  final Hashtag hashtag;
  final Function onTap;
  final Color color;

  TweetHashtag(this.hashtag, this.onTap, this.color) : super(hashtag.indices);

  @override
  InlineSpan getContent() {
    return TextSpan(
        text: '#${hashtag.text}',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onTap();
          });
  }
}

class TweetUserMention extends TweetEntity {
  final UserMention mention;
  final Function onTap;
  final Color color;

  TweetUserMention(this.mention, this.onTap, this.color) : super(mention.indices);

  @override
  InlineSpan getContent() {
    return TextSpan(
        text: '@${mention.screenName}',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onTap();
          });
  }
}

class TweetUrl extends TweetEntity {
  final Url url;
  final Function onTap;
  final Color color;

  TweetUrl(this.url, this.onTap, this.color) : super(url.indices);

  @override
  InlineSpan getContent() {
    return TextSpan(
        text: url.displayUrl,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onTap();
          });
  }
}
