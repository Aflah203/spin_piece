import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import 'package:provider/provider.dart';
import 'package:spin_piece/providers/wheel_data_provider.dart';
import 'package:spin_piece/widgets/go_back.dart';
import 'package:spin_piece/widgets/next_go_pop.dart';

class WheelPage extends StatefulWidget {
  final VoidCallback onReset;
  const WheelPage({super.key, required this.onReset});

  @override
  State<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WheelDataProvider>(context, listen: true);
    final StreamController<int> controller = provider.controller;
    final List<String> chicken = provider.chicken;
    final List<String> names = provider.names;
    final int itertotor = provider.iterator;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          // Dialog appears when user tries to pop
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => GoBack(
              message: 'Are you sure to reset the wheel?',
              onReset: widget.onReset,
            ),
          );
        }
      },

      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,

          centerTitle: true,

          title: Text(
            'Spin Wheel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return GoBack(
                    onReset: widget.onReset,
                    message: 'Are you sure to reset the wheel?',
                  );
                },
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (provider.showWheel && provider.chicken.length > 1)
              Column(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      width: 300,
                      height: 300,
                      child: FortuneWheel(
                        animateFirst: false,
                        selected: controller.stream,
                        items: [
                          for (var piece in chicken)
                            FortuneItem(
                              child: Text(
                                piece,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                        onAnimationEnd: () async {
                          final index = provider.lastSelectedIndex;
                          if (index != null && index < chicken.length) {
                            var result = chicken[index];
                            final currentIterator =
                                provider.iterator; // capture it here

                            provider.addWinner(
                              provider.names[currentIterator],
                              result,
                            );

                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => NextGoPop(
                                name: provider.names[currentIterator],
                                message: 'take $result',
                              ),
                            );

                            provider.removeOne(index);
                            provider.incrementi();
                          }
                          if (provider.chicken.length == 1) {
                            provider.addWinner(
                              provider.names[provider.iterator],
                              provider.chicken.first,
                            );
                            var result = provider.chicken.first;
                            if (context.mounted) {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return NextGoPop(
                                    message: 'takes $result',
                                    name: provider.names[provider.iterator],
                                  );
                                },
                              );
                            }

                            provider.hideWheel();
                          }
                          if (chicken.every((item) => item == 'Chest Piece') &&
                              chicken.length > 1) {
                            var nameIndex = provider.iterator;
                            for (int i = 0; i < chicken.length; i++) {
                              if (nameIndex < names.length) {
                                provider.addWinner(
                                  names[nameIndex],
                                  chicken[i],
                                );
                                nameIndex++;
                              }
                            }
                            if (context.mounted) {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const NextGoPop(
                                  message: 'Rest of you take Chest Piece',
                                ),
                              );
                            }

                            provider.hideWheel();
                          }

                          if (chicken.every((item) => item == 'Leg Piece') &&
                              chicken.length > 1) {
                            var nameIndex = provider.iterator;
                            for (int i = 0; i < chicken.length; i++) {
                              if (nameIndex < names.length) {
                                provider.addWinner(
                                  names[nameIndex],
                                  chicken[i],
                                );
                                nameIndex++;
                              }
                            }
                            if (context.mounted) {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const NextGoPop(
                                  message: 'Rest of you take Leg Piece',
                                ),
                              );
                            }

                            provider.hideWheel();
                          }
                          provider.setSpinning(false);
                        },
                      ),
                    ),
                  ),
                  Text(
                    'spinning for:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      names[itertotor],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  OutlinedButton(
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
                          width: 2.0,
                        ),
                      ),
                    ),
                    onPressed: provider.isSpinning
                        ? null
                        : () {
                            provider.spinWheel();
                          },
                    child: const Text(
                      'SPIN',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4, top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Result:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: provider.winList.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),

                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 160,
                            child: Text(
                              provider.winList.keys.elementAt(index),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          provider.winList.values.elementAt(index),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const Spacer(),

                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onSecondary,
                              width: 0,
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                provider.winList.values.elementAt(index) ==
                                        'Chest Piece'
                                    ? 'assets/images/chestpiece.png'
                                    : 'assets/images/legpiece.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
