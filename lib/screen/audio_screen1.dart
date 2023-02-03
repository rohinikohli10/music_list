import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_list_app/widgets/common.dart';
import 'package:music_list_app/widgets/list_tile.dart';
import '../widgets/audio_list_tile.dart';

const List audioExamples = [
  {
    'title': 'Salt & Pepper',
    'singer': 'Dope Lemon',
    'img': 'https://m.media-amazon.com/images/I/91vBpel766L._SS500_.jpg',
    'song': 'https://dl.espressif.com/dl/audio/gs-16b-2c-44100hz.mp3',
    'isplayed': false
  },
  {
    'title': 'Losing It',
    'singer': 'FISHER',
    'img': 'https://m.media-amazon.com/images/I/9135KRo8Q7L._SS500_.jpg',
    'song': 'https://www.kozco.com/tech/piano2-Audacity1.2.5.mp3',
    'isplayed': false
  },
  {
    'title': 'American Kids',
    'singer': 'Kenny Chesney',
    'img':
        'https://cdn.playbuzz.com/cdn/7ce5041b-f9e8-4058-8886-134d05e33bd7/5c553d94-4aa2-485c-8a3f-9f496e4e4619.jpg',
    'song': 'https://www.kozco.com/tech/organfinale.mp3',
    'isplayed': false
  },
  {
    'title': 'Wake Me Up',
    'singer': 'Avicii',
    'img':
        'https://upload.wikimedia.org/wikipedia/en/d/da/Avicii_Wake_Me_Up_Official_Single_Cover.png',
    'song': 'https://www.kozco.com/tech/32.mp3',
    'isplayed': false
  },
  {
    'title': 'Missing You',
    'singer': 'Mesto',
    'img':
        'https://img.discogs.com/EcqkrmOCbBguE3ns-HrzNmZP4eM=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-12539198-1537229070-5497.jpeg.jpg',
    'song': 'https://www.kozco.com/tech/LRMonoPhase4.mp3',
    'isplayed': false
  },
  {
    'title': 'My heart goes on',
    'singer': 'Tash Sultana',
    'img': 'https://m.media-amazon.com/images/I/91vBpel766L._SS500_.jpg',
    'song': 'https://www.kozco.com/tech/LRMonoPhase4.wav',
    'isplayed': false
  },
  {
    'title': 'Ego Death',
    'singer': 'Ty Dolla \$ign, Kanye West, FKA Twigs, Skrillex',
    'img':
        'https://static.stereogum.com/uploads/2020/06/Ego-Death-1593566496.jpg',
    'song': 'https://www.kozco.com/tech/c304-2.wav',
    'isplayed': false
  },
];

class AudioUi1 extends StatefulWidget {
  final String title;
  const AudioUi1({Key? key, required this.title}) : super(key: key);

  @override
  State<AudioUi1> createState() => _AudioUi1State();
}

class _AudioUi1State extends State<AudioUi1> with WidgetsBindingObserver {
  // late int selectedPlayerIdx;
  // List<AudioPlayer> audioPlayers = List.generate(
  //   audioExamples.length,
  //   (index) => AudioPlayer(),
  // );
//  late AudioPlayer player;

  final _player = AudioPlayer();

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
      _player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                title: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 6, top: 15),
                      child: Text(
                        'Your Library:',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: audioExamples.length,
                      itemBuilder: (context, index) {
                        // player = audioPlayers[index];
                        return ListTileWidget(
                          img: audioExamples[index]['img'],
                          title: audioExamples[index]['title'],
                          singer: audioExamples[index]['singer'],
                          player: _player,
                          onPlay: () {
                            _player.play();
                            try {
                              _player.setAudioSource(AudioSource.uri(
                                  Uri.parse(audioExamples[index]['song'])));
                            } catch (e) {
                              print("Error loading audio source: $e");
                            }
                          },
                          onPause: _player.pause,
                          onReplay: () => _player.seek(Duration.zero),
                        );
                        // AudioListTile(
                        //   player: player,
                        //   audioExamples: audioExamples,
                        //   index: index,
                        // );
                      },
                    ),
                    Container(
                      height: 50,
                    )
                    //for (AudioObject a in audioExamples)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
