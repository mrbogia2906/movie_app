import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class KeepAliveYoutubePlayer extends StatefulWidget {
  const KeepAliveYoutubePlayer({Key? key, required this.controller})
      : super(key: key);

  final YoutubePlayerController controller;

  @override
  _KeepAliveYoutubePlayerState createState() => _KeepAliveYoutubePlayerState();
}

class _KeepAliveYoutubePlayerState extends State<KeepAliveYoutubePlayer>
    with AutomaticKeepAliveClientMixin<KeepAliveYoutubePlayer> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return YoutubePlayerScaffold(
      controller: widget.controller,
      autoFullScreen: false,
      builder: (context, player) {
        return player;
      },
    );
  }
}
