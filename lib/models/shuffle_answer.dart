import '../pages/question_page.dart';

class ShuffleOptions {
  final List result;
  final Randomise shuffler;
  final List optionList = [];

  ShuffleOptions({required this.result, required this.shuffler}) {
    optionList.addAll(result.map((e) => []));
    for (int i = 0; i < result.length; i++) {
      List answers = result.elementAt(i).options;
      optionList[i] = answers;
      optionList[i].shuffle();
    }
    shuffler(optionList);
  }
}
