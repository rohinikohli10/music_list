import 'package:flutter/material.dart';
import '../widgets/audio_list_tile.dart';

const List audioExamples = [
  {
    'title': 'Salt & Pepper',
    'singer': 'Dope Lemon',
    'img': 'https://m.media-amazon.com/images/I/81UYWMG47EL._SS500_.jpg',
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

class AudioUi extends StatefulWidget {
  final String title;
  const AudioUi({Key? key, required this.title}) : super(key: key);

  @override
  State<AudioUi> createState() => _AudioUiState();
}

class _AudioUiState extends State<AudioUi> {
  bool isSelected = false;

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
                        return AudioListTile(
                          audioExamples: audioExamples,
                          index: index,
                        );
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
