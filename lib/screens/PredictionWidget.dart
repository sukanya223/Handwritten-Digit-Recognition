import 'package:flutter/material.dart';
import '../models/Prediction.dart';
import '../utils/Constants.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;

  const PredictionWidget({required Key key, required this.predictions})
      : super(key: key);

  Widget _numberWidget(int num, Prediction? prediction) {
    return Column(
      children: <Widget>[
        Text(
          '$num',
          style: TextStyle(
            fontSize: Constants.screenHeight * 0.05,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withValues(
                    alpha: (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
        Text(
          prediction == null ? '' : prediction.confidence.toStringAsFixed(3),
          style: TextStyle(fontSize: Constants.screenHeight * 0.015),
        ),
      ],
    );
  }

  Widget _labelAndConfidence(String text, Prediction prediction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$text: ',
          style: TextStyle(
            fontSize: Constants.screenHeight * 0.04,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          text == "Score"
              ? '${(prediction.confidence * 100).toStringAsFixed(1)}%'
              : prediction.label,
          style: TextStyle(
            fontSize: Constants.screenHeight * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  List<Prediction?> getPredictionStyles(List<Prediction> predictions) {
    List<Prediction?> data = List.filled(10, null);
    for (var prediction in predictions) {
      int index = int.tryParse(prediction.label) ?? -1;
      if (index >= 0 && index < 10) {
        data[index] = prediction;
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'No predictions yet. Draw something!',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    var styles = getPredictionStyles(predictions);
    Prediction maxPrediction =
        predictions.reduce((a, b) => a.confidence > b.confidence ? a : b);

    return SizedBox(
      height: Constants.screenHeight * 0.3, // Fixed height
      child: SingleChildScrollView(
        // Allow scrolling if content overflows
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < 5; i++) _numberWidget(i, styles[i])
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 5; i < 10; i++) _numberWidget(i, styles[i])
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _labelAndConfidence("Result", maxPrediction),
                _labelAndConfidence("Score", maxPrediction),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
