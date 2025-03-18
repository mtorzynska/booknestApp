import 'package:booknest/models/goal.dart';
import 'package:booknest/providers/goal_provider.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/widgets/appbar_widget.dart';
import 'package:booknest/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  Future<void> showAddGoalDialog() async {
    final TextEditingController textController = TextEditingController();
    final goalsService = ref.watch(goalServiceProvider);
    TextEditingController deadlinePicker = TextEditingController();
    DateTime? deadlineDate;
    TimeOfDay? deadlineTime;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final uid = ref.read(currentUserProvider);
        return AlertDialog(
          title: const Text(
            'Enter your goal here',
            style: TextStyle(
                fontSize: 23, color: Color.fromARGB(255, 255, 159, 178)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInputWidget(
                  controller: textController,
                  labelText: "I want to achieve..."),
              const SizedBox(height: 10),
              TextInputWidget(
                controller: deadlinePicker,
                readOnly: true,
                labelText: "Deadline (optional)",
                onTap: () async {
                  final DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2099),
                      initialDate: DateTime.now());
                  final TimeOfDay? time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (date != null && time != null) {
                    setState(() {
                      deadlineDate = date;
                      deadlineTime = time;
                      deadlinePicker.text =
                          '${DateFormat('dd-MM-yyyy').format(deadlineDate!)} at ${deadlineTime!.format(context)}';
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 17, color: Color.fromARGB(255, 255, 159, 178)),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (deadlineTime == null &&
                    deadlineDate == null &&
                    textController.text.isNotEmpty) {
                  goalsService.createGoal(
                      uid!, Goal(goalName: textController.text));
                  Navigator.pop(context);
                } else if (textController.text.isNotEmpty) {
                  DateTime deadline = DateTime(
                      deadlineDate!.year,
                      deadlineDate!.month,
                      deadlineDate!.day,
                      deadlineTime!.hour,
                      deadlineTime!.minute);
                  await goalsService.createGoalWithDeadline(uid!,
                      Goal(goalName: textController.text, deadline: deadline));
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Add goal',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 159, 178), fontSize: 17),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalsData = ref.watch(userGoalsProvider);
    final goalsService = ref.watch(goalServiceProvider);
    final uid = ref.read(currentUserProvider);

    return Scaffold(
      appBar: const AppBarWidget(title: "My goals"),
      backgroundColor: Color.fromARGB(255, 255, 246, 220),
      body: goalsData.when(
          data: (goals) {
            if (goals.isEmpty) {
              return const Center(
                  child: Text(
                "No goals here...",
                style: TextStyle(
                    fontSize: 17, color: Color.fromARGB(255, 255, 165, 143)),
              ));
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final Goal goal = goals[index];
                      var date;
                      if (goal.deadline != null) {
                        date = DateFormat('dd-MM-yyyy HH:mm')
                            .format(goal.deadline!);
                      }
                      return ListTile(
                        title: Text(goal.goalName,
                            style: TextStyle(
                              color: (index % 2 == 0)
                                  ? Color.fromARGB(255, 255, 165, 143)
                                  : Color.fromARGB(255, 202, 153, 205),
                              fontSize: 20,
                            )),
                        subtitle: date != null
                            ? Text(date,
                                style: TextStyle(
                                  color: (index % 2 == 0)
                                      ? Color.fromARGB(255, 255, 165, 143)
                                      : Color.fromARGB(255, 202, 153, 205),
                                ))
                            : null,
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.check_circle_sharp,
                            color: Color.fromARGB(255, 193, 219, 179),
                            size: 32,
                          ),
                          onPressed: () {
                            goalsService.deleteGoal(uid!, goal.goalName);
                          },
                        ),
                      );
                    }),
              );
            }
          },
          error: ((error, stackTrace) => Center(child: Text("Error: $error"))),
          loading: () => const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 193, 219, 179)))),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 255, 159, 178),
          shape: CircleBorder(),
          onPressed: showAddGoalDialog,
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 255, 246, 220),
            size: 35,
          ),
        ),
      ),
    );
  }
}
