import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int value1 = 0;
  int value2 = 0;
  int correctValue = 0;

  int maxValue = 200;

  bool showDiff = false;
  bool isGreenCoundown = false;

  final textController = TextEditingController();
  final maxValueController = TextEditingController();

  final blueController = TextEditingController();
  final redController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    maxValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final whoWins = (value1 <= 0 || value2 <= 0);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 30,
            ),
            child: SizedBox(
              width: 1280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (whoWins && textController.text.isNotEmpty) ...[
                    Text(
                      (value1 == value2)
                          ? 'НИЧЬЯ'
                          : value1 <= 0
                              ? 'КРАСНЫЕ ПОБЕЖДАЮТ'
                              : 'СИНИЕ ПОБЕЖДАЮТ',
                      style: TextStyle(
                        color: (value1 == value2)
                            ? Colors.grey
                            : value1 <= 0
                                ? Colors.red
                                : Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Играем на столько баллов:',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        width: 400,
                        child: TextField(
                          controller: maxValueController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                maxValue =
                                    int.tryParse(maxValueController.text) ??
                                        200;
                              });
                            },
                            child: const Icon(
                              Icons.done,
                              color: Colors.green,
                            )),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              value1 = maxValue;
                            });
                          },
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              value2 = maxValue;
                            });
                          },
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  const Text(
                    'Команда Синих',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  _TeamBar(
                    value1,
                    maxValue,
                    Colors.blue.shade200,
                    width: 1280,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: TextField(
                          controller: blueController,
                        ),
                      ),
                      const Spacer(),
                      Text('Сейчас $value1 / $maxValue'),
                      if (correctValue != -1 && showDiff)
                        _ThatMinus(
                          maybe: int.tryParse(blueController.text) ?? 0,
                          answer: int.tryParse(textController.text) ?? 0,
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Команда Красных',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  _TeamBar(
                    value2,
                    maxValue,
                    Colors.red.shade200,
                    width: 1280,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: TextField(
                          controller: redController,
                        ),
                      ),
                      const Spacer(),
                      Text('Сейчас $value2 / $maxValue'),
                      if (correctValue != -1 && showDiff)
                        _ThatMinus(
                          maybe: int.tryParse(redController.text) ?? 0,
                          answer: int.tryParse(textController.text) ?? 0,
                        ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: TextField(
                          controller: textController,
                          obscureText: false,
                          cursorColor: Colors.transparent,
                          style: const TextStyle(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                          key: GlobalKey(debugLabel: 'question'),
                          onPressed: () {
                            _guestAnimation(
                                secretValue:
                                    int.tryParse(textController.text) ?? 0);
                          },
                          child: const Icon(
                            Icons.question_mark,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                          key: GlobalKey(debugLabel: 'calculate'),
                          onPressed: () {
                            _modifyValues(
                              int.tryParse(blueController.text) ?? 0,
                              int.tryParse(redController.text) ?? 0,
                            );
                          },
                          child: const Icon(
                            Icons.calculate_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                          key: GlobalKey(debugLabel: 'refresh'),
                          onPressed: () {
                            setState(() {
                              correctValue = -1;
                              blueController.text = '';
                              redController.text = '';
                              textController.text = '';
                              isGreenCoundown = false;
                            });
                          },
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _TeamBar(
                    correctValue,
                    100,
                    Colors.grey,
                    width: 1280,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        correctValue != -1
                            ? Text(
                                correctValue.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: isGreenCoundown == true
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isGreenCoundown == true
                                      ? Colors.green.shade700
                                      : Colors.black,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _modifyValues(int maybeBlue, int maybeRed) async {
    final correctAnswer = int.tryParse(textController.text) ?? 0;
    final targetBlue = (maybeBlue - correctAnswer) < 0
        ? value1 - (maybeBlue - correctAnswer) * -1
        : value1 - (maybeBlue - correctAnswer);
    final targetRed = (maybeRed - correctAnswer) < 0
        ? value2 - (maybeRed - correctAnswer) * -1
        : value2 - (maybeRed - correctAnswer);
    while (value1 != targetBlue || value2 != targetRed) {
      if (value1 == 0 || value2 == 0) return;
      if (value1 != targetBlue) {
        setState(() {
          value1--;
        });
      }
      if (value2 != targetRed) {
        setState(() {
          value2--;
        });
      }
      final summ = (value1 - targetBlue) + (value2 - targetRed);
      if (summ >= 31) {
        await Future.delayed(
          const Duration(milliseconds: 150),
        );
      }

      if (summ < 31) {
        if (summ < 11) {
          if (summ < 6) {
            if (summ < 3) {
              if (summ == 0) {
                setState(() {
                  showDiff = true;
                  correctValue = correctAnswer;
                });
                continue;
              }
              await Future.delayed(
                const Duration(milliseconds: 2000),
              );
              continue;
            }

            await Future.delayed(
              const Duration(milliseconds: 800),
            );
            continue;
          }
          await Future.delayed(
            const Duration(milliseconds: 360),
          );
          continue;
        }
        await Future.delayed(
          const Duration(milliseconds: 250),
        );
        continue;
      }
    }
  }

  void _guestAnimation({required int secretValue}) async {
    int value = 100;
    bool flag = false;

    setState(() {
      correctValue = value;
      showDiff = false;
    });

    while (flag == false) {
      value--;
      setState(() {
        correctValue--;
      });
      if (value >= 31) {
        await Future.delayed(
          const Duration(milliseconds: 25),
        );
      }

      if (value < 31) {
        if (value < 11) {
          if (value < 4) {
            if (value == 0) {
              flag = true;
              continue;
            }
            await Future.delayed(
              const Duration(milliseconds: 80),
            );
            continue;
          }
          await Future.delayed(
            const Duration(milliseconds: 55),
          );
          continue;
        }
        await Future.delayed(
          const Duration(milliseconds: 40),
        );
        continue;
      }
    }

    while (flag == true && value != secretValue) {
      if (value == 0) {
        await Future.delayed(
          const Duration(seconds: 2),
        );
      }

      value++;
      setState(() {
        correctValue++;
      });

      final diff = (value - secretValue) < 0
          ? (value - secretValue) * -1
          : (value - secretValue);
      if (diff >= 31) {
        await Future.delayed(
          const Duration(milliseconds: 30),
        );
      }
      if (diff < 31) {
        if (diff < 11) {
          if (diff < 6) {
            if (diff < 4) {
              if (diff < 2) {
                if (diff == 0) {
                  setState(() {
                    isGreenCoundown = true;
                  });
                }
                await Future.delayed(
                  const Duration(milliseconds: 2000),
                );
                continue;
              }
              await Future.delayed(
                const Duration(milliseconds: 600),
              );
              continue;
            }
            await Future.delayed(
              const Duration(milliseconds: 240),
            );
            continue;
          }
          await Future.delayed(
            const Duration(milliseconds: 160),
          );
          continue;
        }
        await Future.delayed(
          const Duration(milliseconds: 80),
        );
      }
    }
  }
}

class _ThatMinus extends StatelessWidget {
  final int maybe;
  final int answer;

  const _ThatMinus({
    required this.maybe,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final thatMinus =
        (maybe - answer) < 0 ? (maybe - answer) * -1 : (maybe - answer);

    return thatMinus == 0
        ? const Text(
            ' ЗОЛОТАЯ ЧУЙКА!',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w600,
              fontSize: 40,
            ),
          )
        : Text(
            ' - ${thatMinus}',
            style: TextStyle(
              color: Colors.red.shade900,
            ),
          );
  }
}

class _TeamBar extends StatelessWidget {
  const _TeamBar(
    this.value,
    this.maxValue,
    this.color, {
    required this.width,
  });

  final int value;
  final int maxValue;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        children: List.generate(
          maxValue,
          (index) {
            Color cellColor = index < value ? color : Colors.grey.shade300;

            BorderRadius borderRadius;
            if (index == 0) {
              borderRadius = const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              );
            } else if (index == maxValue - 1) {
              borderRadius = const BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              );
            } else {
              borderRadius = BorderRadius.zero;
            }

            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: borderRadius,
                ),
                margin: const EdgeInsets.all(0.5),
              ),
            );
          },
        ),
      ),
    );
  }
}
