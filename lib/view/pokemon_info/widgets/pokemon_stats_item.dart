import 'package:flutter/material.dart';
import 'package:pokedex/core/num.dart';
import 'package:pokedex/core/string.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class PokemonStatItem extends StatefulWidget {
  final PokemonStat stat;
  const PokemonStatItem(this.stat, {Key? key}) : super(key: key);

  @override
  State<PokemonStatItem> createState() => _PokemonStatItemState();
}

class _PokemonStatItemState extends State<PokemonStatItem>
    with SingleTickerProviderStateMixin<PokemonStatItem> {
  late AnimationController controller;
  late Animation<double> animation;
  late PokemonStat stat;
  late double value;

  @override
  void initState() {
    super.initState();
    stat = widget.stat;
    value = stat.baseStat.interpolate(0, 100, upperBound: 1);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() {
        setState(() {});
      })
      ..forward();
    animation = Tween<double>(begin: 0, end: value).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                stat.stat.name.replaceAll("-", " ").capitalize(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                stat.baseStat.toString(),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          StepProgressIndicator(
            totalSteps: 10,
            currentStep: (animation.value * 10).round(),
            unselectedColor: Colors.black,
            selectedColor: getColor(animation.value),
          ),
        ],
      ),
    );
  }
}

Color getColor(double value) {
  if (value > 0.7) {
    return Colors.green;
  } else if (value > 0.3) {
    return const Color(0xffEEC218);
  } else {
    return const Color(0xffCD2873);
  }
}
