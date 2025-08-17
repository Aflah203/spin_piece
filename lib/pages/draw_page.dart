import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:spin_piece/providers/wheel_data_provider.dart';
import 'package:spin_piece/widgets/are_you_sure.dart';
import 'package:spin_piece/widgets/popup_error_widget.dart';

class DrawPage extends StatefulWidget {
  final VoidCallback onReset;

  const DrawPage({super.key, required this.onReset});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int chestpieceNos = Provider.of<WheelDataProvider>(context).chestpieceNos;
    int legpieceNos = Provider.of<WheelDataProvider>(context).legpieceNos;
    final List<String> names = Provider.of<WheelDataProvider>(context).names;
    final int innames = names.length;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Spin App',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: Text(
                        'Names appears in the box below.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  NameAppearArea(
                    names: names,
                    legpiece: legpieceNos,
                    chestpiece: chestpieceNos,
                  ),

                  EnterNames(controller: _controller, names: names),
                  Chestpiece(
                    chestpieceNos: chestpieceNos,
                    len: innames,
                    legpieceNos: legpieceNos,
                  ),
                  Legpiece(
                    legpieceNos: legpieceNos,
                    len: innames,
                    chestpieceNos: chestpieceNos,
                  ),
                  const SizedBox(height: 65),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: OutlinedButton(
                          onPressed: () {
                            if (chestpieceNos == 0 ||
                                legpieceNos == 0 ||
                                innames != (chestpieceNos + legpieceNos)) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return const PopUpErrorWidget(
                                    message: 'Chicken piece?',
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AreYouSure(
                                    onReset: widget.onReset,
                                    message: 'Ready for spin wheel',
                                    chestpieceNos: chestpieceNos,
                                    legpieceNos: legpieceNos,
                                  );
                                },
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.secondary,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.onSecondary,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            side: WidgetStateProperty.all(
                              BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 0,
                              ),
                            ),
                          ),
                          child: Text(
                            'Go Spin',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),

                      SizedBox(
                        height: 50,
                        width: 100,
                        child: OutlinedButton(
                          onPressed: () {
                            final value = _controller.text.trim();
                            if (value.isNotEmpty && !names.contains(value)) {
                              Provider.of<WheelDataProvider>(
                                context,
                                listen: false,
                              ).addName(value);
                              _controller.clear();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.secondary,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.onSecondary,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            side: WidgetStateProperty.all(
                              BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 0,
                              ),
                            ),
                          ),
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Chestpiece extends StatelessWidget {
  const Chestpiece({
    super.key,
    required this.chestpieceNos,
    required this.len,
    required this.legpieceNos,
  });

  final int chestpieceNos;
  final int len;
  final int legpieceNos;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 0,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/chestpiece.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Chest Piece',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: IconButton(
                  highlightColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    if (chestpieceNos > 0) {
                      Provider.of<WheelDataProvider>(
                        context,
                        listen: false,
                      ).decrementChestpiece();
                    }
                  },
                  icon: Icon(
                    Icons.remove,
                    size: 25,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  border: Border.all(
                    width: 0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: NumberPicker(
                    itemCount: 1,
                    minValue: 0,
                    maxValue: len - legpieceNos,
                    value: chestpieceNos,
                    onChanged: (value) {
                      Provider.of<WheelDataProvider>(
                        context,
                        listen: false,
                      ).setChestpiece(value);
                    },
                    selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: IconButton(
                  highlightColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    if (chestpieceNos < len - legpieceNos) {
                      Provider.of<WheelDataProvider>(
                        context,
                        listen: false,
                      ).incrementChestpiece();
                    }
                    if (len == 0) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return const PopUpErrorWidget(message: 'Names?');
                        },
                      );
                    }
                  },
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Legpiece extends StatelessWidget {
  const Legpiece({
    super.key,
    required this.legpieceNos,
    required this.len,
    required this.chestpieceNos,
  });

  final int legpieceNos;
  final int len;
  final int chestpieceNos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 0,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/legpiece.png'),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Leg Piece',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: IconButton(
                  highlightColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    if (legpieceNos > 0) {
                      Provider.of<WheelDataProvider>(
                        context,
                        listen: false,
                      ).decrementLegpiece();
                    }
                  },
                  icon: Icon(
                    Icons.remove,
                    size: 25,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  border: Border.all(
                    width: 0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: NumberPicker(
                    itemCount: 1,
                    minValue: 0,
                    maxValue: len - chestpieceNos,
                    value: legpieceNos,
                    onChanged: (value) {
                      Provider.of<WheelDataProvider>(
                        context,
                        listen: false,
                      ).setLegpiece(value);
                    },
                    selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: IconButton(
                  highlightColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    if (len == 0) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return const PopUpErrorWidget(message: 'Names?');
                        },
                      );
                    }
                    if (legpieceNos < len - chestpieceNos) {
                      Provider.of<WheelDataProvider>(
                        context,
                        listen: false,
                      ).incrementLegpiece();
                    }
                  },
                  icon: Icon(
                    Icons.add,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EnterNames extends StatefulWidget {
  const EnterNames({
    super.key,
    required TextEditingController controller,
    required this.names,
  }) : _controller = controller;

  final TextEditingController _controller;
  final List<String> names;

  @override
  State<EnterNames> createState() => _EnterNamesState();
}

class _EnterNamesState extends State<EnterNames> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      width: double.infinity,
      child: TextField(
        controller: widget._controller,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 0,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 0,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          hintText: 'Names',
          filled: true,
          fillColor: Theme.of(context).colorScheme.onSecondary,
          hintStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onSubmitted: (String text) {
          final value = text.trim();

          if (value.isNotEmpty && !widget.names.contains(value)) {
            Provider.of<WheelDataProvider>(
              context,
              listen: false,
            ).addName(value);
            widget._controller.clear();
          }
        },
      ),
    );
  }
}

class NameAppearArea extends StatelessWidget {
  const NameAppearArea({
    super.key,
    required this.legpiece,
    required this.chestpiece,
    required this.names,
  });
  final int legpiece;
  final int chestpiece;
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 125),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 0,
        ),

        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 4,
          runSpacing: 0,
          children: [
            ...names.map(
              (chip) => InputChip(
                deleteIconColor: Theme.of(context).colorScheme.primary,
                labelStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 0,
                ),
                backgroundColor: Theme.of(context).colorScheme.onSecondary,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),

                label: Text(
                  chip,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onDeleted: () {
                  if (chestpiece > 0) {
                    Provider.of<WheelDataProvider>(
                      context,
                      listen: false,
                    ).decrementChestpiece();
                  } else if (legpiece > 0) {
                    Provider.of<WheelDataProvider>(
                      context,
                      listen: false,
                    ).decrementLegpiece();
                  }
                  Provider.of<WheelDataProvider>(
                    context,
                    listen: false,
                  ).removeName(chip);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
