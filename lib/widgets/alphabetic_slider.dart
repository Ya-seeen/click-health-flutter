import 'package:flutter/material.dart';

class AlphabeticSlider extends StatefulWidget {
  final ValueChanged<String> onAlphabetChanged;
  final double top, bottom;

  AlphabeticSlider({@required this.onAlphabetChanged, this.top, this.bottom});

  @override
  _AlphabeticSliderState createState() => _AlphabeticSliderState();
}

class _AlphabeticSliderState extends State<AlphabeticSlider> {
  double _offsetContainer;
  var _sizeheightcontainer;
  var _heightscroller;
  var posSelected = 0;
  var diff = 0.0;
  var height = 0.0;

  void initState() {
    _offsetContainer = 0.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return LayoutBuilder(builder: (context, contrainsts) {
      diff = height - contrainsts.biggest.height;
      _heightscroller = (contrainsts.biggest.height) / _alphabet.length;
      _sizeheightcontainer = (contrainsts.biggest.height);
      return GestureDetector(
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragStart: _onVerticalDragStart,
        child: Container(
          margin: EdgeInsets.only(right: 3, top: widget.top, bottom: widget.bottom),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[600]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: []..addAll(
                  new List.generate(
                      _alphabet.length, (index) => _getAlphabetItem(index)),
                ),
            ),
          ),
        ),
      );
    });
  }

  final List _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if ((_offsetContainer + details.delta.dy) >= 0 &&
          (_offsetContainer + details.delta.dy) <=
              (_sizeheightcontainer - _heightscroller)) {
        _offsetContainer += details.delta.dy;
        posSelected =
            ((_offsetContainer / _heightscroller) % _alphabet.length).round();

        widget.onAlphabetChanged(_alphabet[posSelected]);
      }
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _offsetContainer = details.globalPosition.dy - diff;
  }

  _getAlphabetItem(int index) {
    return Expanded(
      child: Container(
        width: 25,
        alignment: Alignment.center,
        child: Text(
          _alphabet[index],
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  /*_getAlphabetItem(int index) {
    return Expanded(
      child: Container(
        width: 25,
        color: (index == posSelected) ? Colors.black : Colors.white,
        alignment: Alignment.center,
        child: Text(
          _alphabet[index],
          style: (index == posSelected)
              ? TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                )
              : TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
        ),
      ),
    );
  }*/
}
