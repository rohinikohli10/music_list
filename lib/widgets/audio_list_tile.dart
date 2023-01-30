import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_list_app/widgets/common.dart';
import 'package:rxdart/rxdart.dart';

class AudioListTile extends StatefulWidget {
  final List<dynamic> audioExamples;
  final int index;

  const AudioListTile({
    Key? key,
    required this.audioExamples,
    required this.index,
  }) : super(key: key);

  @override
  State<AudioListTile> createState() => _AudioListTileState();
}

class _AudioListTileState extends State<AudioListTile>
    with WidgetsBindingObserver {
  final _player = AudioPlayer();
  int? selectedIndex;
  bool isplaying = false;

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(AudioSource.uri(
          Uri.parse(widget.audioExamples[widget.index]['song'])));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
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
            widget.audioExamples[widget.index]['img'],
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              text: widget.audioExamples[widget.index]['title'],
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: ' ${widget.audioExamples[widget.index]['singer']}',
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
                onChangeEnd: _player.seek,
              );
            },
          ),
        ),
        trailing: playPauseClass(player: _player, index: widget.index),
      ),
    );
  }
}

class playPauseClass extends StatelessWidget {
  final AudioPlayer player;
  final int index;
  const playPauseClass({super.key, required this.player, required this.index});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
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
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.pause),
            iconSize: 40.0,
            onPressed: player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 40.0,
            onPressed: () => player.seek(Duration.zero),
          );
        }
      },
    );
  }
}
