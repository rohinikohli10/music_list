import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_list_app/widgets/common.dart';
import 'package:rxdart/rxdart.dart';

class ListTileWidget extends StatefulWidget {
  final String img;
  final String title;
  final String singer;
  final AudioPlayer player;
  final void Function() onPlay;
  final void Function() onPause;
  final void Function() onReplay;

  const ListTileWidget({
    Key? key,
    required this.img,
    required this.title,
    required this.singer,
    required this.player,
    required this.onPlay,
    required this.onPause,
    required this.onReplay,
  }) : super(key: key);

  @override
  State<ListTileWidget> createState() => _ListTileWidgetState();
}

class _ListTileWidgetState extends State<ListTileWidget> {
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          widget.player.positionStream,
          widget.player.bufferedPositionStream,
          widget.player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 90,
      decoration: BoxDecoration(
        border: Border(
          bottom:
              BorderSide(width: 1.5, color: Theme.of(context).backgroundColor),
        ),
      ),
      child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              widget.img,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          title: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
                text: widget.title,
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: ' ${widget.singer}',
                      style: const TextStyle(color: Colors.black45))
                ]),
          ),
          subtitle: Container(
            height: 40,
            color: Colors.transparent,
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: widget.player.seek,
                );
              },
            ),
          ),
          trailing: StreamBuilder<PlayerState>(
            stream: widget.player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 30.0,
                  height: 30.0,
                  child: const CircularProgressIndicator(),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 40.0,
                  onPressed: widget.onPlay,
                );
                //player.play,
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.pause),
                  iconSize: 40.0,
                  onPressed: widget.onPause,
                  //player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 40.0,
                  onPressed: widget.onReplay,
                  //() => player.seek(Duration.zero),
                );
              }
            },
          )),
    );
  }
}

// class playPauseClass extends StatelessWidget {
//   final AudioPlayer player;
//   final int index;
//   const playPauseClass({super.key, required this.player, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<PlayerState>(
//       stream: player.playerStateStream,
//       builder: (context, snapshot) {
//         final playerState = snapshot.data;
//         final processingState = playerState?.processingState;
//         final playing = playerState?.playing;
//         if (processingState == ProcessingState.loading ||
//             processingState == ProcessingState.buffering) {
//           return Container(
//             margin: const EdgeInsets.all(8.0),
//             width: 30.0,
//             height: 30.0,
//             child: const CircularProgressIndicator(),
//           );
//         } else if (playing != true) {
//           return IconButton(
//               icon: const Icon(Icons.play_arrow),
//               iconSize: 40.0,
//               onPressed: () async {
//                 await player.stop();
//                 await player.play();
//               });
//         } else if (processingState != ProcessingState.completed) {
//           return IconButton(
//             color: Theme.of(context).primaryColor,
//             icon: const Icon(Icons.pause),
//             iconSize: 40.0,
//             onPressed: player.pause,
//           );
//         } else {
//           return IconButton(
//             icon: const Icon(Icons.replay),
//             iconSize: 40.0,
//             onPressed: () => player.seek(Duration.zero),
//           );
//         }
//       },
//     );
//   }
// }
