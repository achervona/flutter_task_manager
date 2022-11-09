import 'package:flutter/material.dart';

class AppToggleButtons extends StatefulWidget {
  const AppToggleButtons({
    required this.options,
    this.selectedIndex = 0,
    this.onChange,
    Key? key,
  }) : super(key: key);

  final List<String> options;
  final int selectedIndex;
  final void Function(int selectedIndex)? onChange;

  @override
  State<AppToggleButtons> createState() => AppToggleButtonsState();
}

class AppToggleButtonsState extends State<AppToggleButtons> {
  late final List<bool> _selectionState;

  @override
  void initState() {
    super.initState();
    final int selectedIndex = widget.selectedIndex >= 0 
      && widget.selectedIndex < widget.options.length 
      ? widget.selectedIndex : 0;
    
    _selectionState = List<bool>.generate(
      widget.options.length,
      (index) => index == selectedIndex
    );
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: _onChange,
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      borderColor: Colors.grey.shade400,
      selectedColor: Colors.blueAccent,
      selectedBorderColor: Colors.blueAccent,
      fillColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 16.0,
        color: Colors.black
      ),
      isSelected: _selectionState,
      children: List<Widget>.generate(
        widget.options.length,
        (index) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(widget.options[index])
        ) 
      )
    );
  }

  void _onChange(int index) {
    setState(() {
      for (int i = 0; i < _selectionState.length; i++) {
        _selectionState[i] = i == index;
      }
    });
    if (widget.onChange != null) {
      widget.onChange!(index);
    }
  }
}
