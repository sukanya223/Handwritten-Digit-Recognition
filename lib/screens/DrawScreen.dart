import 'package:flutter/material.dart';
import '../models/DrawingArea.dart';
import '../models/Prediction.dart';
import '../screens/DrawingPainter.dart';
import '../screens/PredictionWidget.dart';
import '../services/Recognizer.dart';
import '../utils/Constants.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({required Key key}) : super(key: key);

  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<DrawingArea> _points = [];
  final _recognizer = Recognizer();
  List<Prediction> _prediction = [];
  final GlobalKey canvasKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    Constants().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handwritten Digit Recognition'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _points.clear();
                _prediction = [];
              });
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: Constants.screenHeight * 0.02),
          RepaintBoundary(
            key: canvasKey,
            child: _drawCanvasWidget(),
          ),
          SizedBox(height: Constants.screenHeight * 0.02),
          Expanded(
            // Allow PredictionWidget to take remaining space
            child: PredictionWidget(
              predictions: _prediction,
              key: const Key("prediction"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: Constants.blockSizeHorizontal,
      height: Constants.blockSizeVertical,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: Constants.borderSize),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset localPosition = details.localPosition;
          if (localPosition.dx >= 0 &&
              localPosition.dx <= Constants.blockSizeHorizontal &&
              localPosition.dy >= 0 &&
              localPosition.dy <= Constants.blockSizeVertical) {
            setState(() {
              _points.add(
                DrawingArea(
                  point: localPosition,
                  areaPaint: Paint()
                    ..strokeCap = StrokeCap.round
                    ..isAntiAlias = true
                    ..color = Colors.redAccent
                    ..strokeWidth = Constants.strokeWidth,
                ),
              );
            });
          }
        },
        onPanEnd: (DragEndDetails details) {
          _recognize();
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  Future<void> _initModel() async {
    await _recognizer.loadModel();
  }

  Future<void> _recognize() async {
    List<dynamic> predictions = await _recognizer.recognize(context, _points);
    print('Raw predictions: $predictions');
    setState(() {
      _prediction = predictions
          .where((json) => json != null)
          .map((json) => Prediction.fromJson(json))
          .toList();
    });
    if (_prediction.isNotEmpty) {
      print('First prediction label: ${_prediction.first.label}');
    } else {
      print('No valid predictions');
    }
  }
}
