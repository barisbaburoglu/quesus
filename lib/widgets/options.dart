import 'package:flutter/material.dart';
import 'package:quesus/constants/colors.dart';
import 'package:quesus/widgets/question_view.dart';

class Options extends StatefulWidget {
  final List optionList;
  final OptionSelectedCallback onOptionsSelected;
  final int selectedPosition;
  final int index;

  Options({
    required this.optionList,
    required this.onOptionsSelected,
    required this.selectedPosition,
    required this.index,
  });

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  int selectedIndex = 99;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.optionList[widget.index].length,
          itemBuilder: (context, position) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 3),
              child: CheckboxListTile(
                controlAffinity: ListTileControlAffinity.platform,
                checkColor:
                    widget.optionList[widget.index].elementAt(position).score ==
                            1
                        ? colorGreenLight
                        : colorRed,
                activeColor: Colors.lightGreen[100],
                selectedTileColor:
                    widget.optionList[widget.index].elementAt(position).score ==
                            1
                        ? colorGreenLight
                        : colorRed,
                selected: selectedIndex == position,
                title: Text(
                    '${widget.optionList[widget.index].elementAt(position).choice}'),
                value: selectedIndex == position,
                onChanged: (bool? newValue) {
                  widget.onOptionsSelected(
                      widget.optionList[widget.index].elementAt(position));
                  setState(
                    () {
                      selectedIndex = position;
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
