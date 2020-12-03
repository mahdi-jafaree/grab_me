import 'dart:convert';

// import 'package:cleverchildren/AppBar/appbar2.dart';
import 'package:video_player/video_player.dart';

import './Modelvideo.dart';
import 'package:flutter/material.dart';
import 'package:grab_me/Modelvideo.dart';
import 'package:http/http.dart';

class Video extends StatefulWidget {
  final int itemId;

  const Video({
    Key key,
    @required this.itemId,
    // @required this.type,
  }) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  List<ModelVideo> items = [];
  List<ModelVideo> itemss = [];
  ModelVideo model;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFutuer;

  @override
  void initState() {
    // fetchItems(widget.itemId).then((value) {
    //   if (value.video1 != null) {
    //     _controller = VideoPlayerController.network(model.video1)
    //       ..initialize().then((_) {
    //         setState(() {});
    //       });
    //     _controller.setLooping(true);
    //     _controller.setVolume(1.0);
    //   }
    // });

    super.initState();
  }

  // @override
  // void didChangeDependencies() async {
  //   await fetchItems(widget.itemId);
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.maxFinite,
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: fetchItems(widget.itemId),
                  builder: (context, snap) {
                    if (snap.hasData && snap.data != null) {
                      _controller =
                          VideoPlayerController.network(snap.data.video1);
                      _controller.addListener(() {
                        setState(() {});
                      });
                      _controller.setLooping(true);
                      _controller.initialize().then((value) {
                        setState(() {});
                      });
                      _controller.setVolume(1.0);
                      _controller.play();
                      return Column(
                        children: [
                          AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                          // Icon(_controller.value.initialized &&
                          //         _controller.value.isPlaying
                          //     ? Icons.pause
                          //     : Icons.play_arrow),
                        ],
                      );
                    } else if (snap.hasError)
                      return Text("This error occoured :${snap.error}");
                    else
                      return CircularProgressIndicator();
                  })

              // return Center(
              //   child:
              // );
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
      ),
    );
  }

  Future<ModelVideo> fetchItems(int itemId) async {
    var url = "http://clever-app.ir/children/wp-json/wp/v2/sarfasl/$itemId";
    print("=> 1");
    Response response = await get(url);
    print(" response : ${response.body}");
    var productJson = json.decode(response.body);

    print('=> 2');
    itemss.clear();
    //print(response);
    // productJson.forEach((eachProduct) {
    var video1 = productJson['acf']['video-1']['url'];
    print("Video1 : $video1");
    model = ModelVideo(video1);

    print('=> 3');
    print("Pitem : ${model.video1}");

    return model;
  }
}
