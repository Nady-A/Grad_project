import 'package:flutter/material.dart';

class PostMedia extends StatefulWidget {
  final List<String> urls;
  final String category;
  PostMedia(this.urls, this.category);

  @override
  _PostMediaState createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: _h / 2.25,
      color: Color.fromRGBO(233, 235, 238, 1),
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
            onHorizontalDragEnd: (d) {
              print(d.primaryVelocity);
              if (d.primaryVelocity > 0) {
                if (_selectedIndex > 0) {
                  setState(() {
                    _selectedIndex--;
                  });
                }
              }
              if (d.primaryVelocity < 0) {
                if (_selectedIndex + 1 < widget.urls.length) {
                  print('incrementing index');
                  setState(() {
                    _selectedIndex++;
                  });
                }
              }
            },
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/loading.gif',
              image: widget.urls[_selectedIndex],
              //fit: BoxFit.fitHeight,
              height: double.infinity,
            ),
          ),
          Positioned(
            child: _selectedIndex > 0
                ? Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  )
                : Container(),
            left: 15,
          ),
          Positioned(
            child: _selectedIndex < widget.urls.length - 1
                ? Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  )
                : Container(),
            right: 15,
          ),
        ],
      ),
    );
  }
}
