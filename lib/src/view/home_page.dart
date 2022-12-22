import 'package:animation_coin/src/util/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController animationCoinBounce;
  late Animation<double>   animationCoinBounceValue;


  late AnimationController animationIconHigh;
  late Animation<double>   animationIconHighValue;

  int  selectedFace =Random().nextInt(2);

  @override
  void initState() {

    super.initState();
    animationCoinBounce = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600)
    );
    animationCoinBounceValue = Tween<double>(
        begin: 0,
        end: 32
    ).animate(animationCoinBounce);

    animationIconHigh = AnimationController(
        vsync: this,
        duration:const Duration(milliseconds: 300)
    );

    animationIconHighValue = Tween<double>(
        begin: 0,
       end: -250
     ).animate(animationIconHigh);

    _onListenAnimation();
  }

  void _onListenAnimation(){
    animationIconHigh.addStatusListener((status) {
       if (status ==AnimationStatus.completed){
         animationIconHigh.reverse();
       }

       if (status == AnimationStatus.dismissed){
          animationIconHigh.reset();
       }
    });

    animationCoinBounce.addStatusListener((status) {

      if (status ==AnimationStatus.completed){
        animationCoinBounce.reverse();
      }

      if (status == AnimationStatus.dismissed){
        animationCoinBounce.reset();
        setState(() {
           selectedFace = Random().nextInt(2);
        });
      }
    });
  }

  void dispose(){
    animationCoinBounce.dispose();
    animationIconHigh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
            child: Stack(children: [
              AnimatedBuilder(
                animation: animationIconHigh,
                builder: (context, child) {
                  return  Transform.translate(
                    offset: Offset(0 ,animationIconHighValue.value),
                    child: child,
                  );
                },
                child: AnimatedBuilder(
                  animation: animationCoinBounceValue,
                  builder: (context,child){
                    return Transform(
                      transform: Matrix4.identity()
                        ..rotateZ((pi * animationCoinBounceValue.value) / 4)
                        ..rotateY((pi * animationCoinBounceValue.value) / 4)
                        ..rotateX((pi * animationCoinBounceValue.value) / 4)
                        ..setEntry(3, 2, 0.002),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: _containerCoin(),
                ),
              ),
            ])),
      ),
      bottomNavigationBar: MaterialButton(
        onPressed: () {
          animationIconHigh.forward();
          animationCoinBounce.forward();
        },
        minWidth: 210,
        height: 80,
        color: Colors.black,
        child: const Text("Start" ,style: TextStyle(
          fontSize: 20,
          color:Colors.white,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }

  Widget _containerCoin() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.black),
          child: Image.asset(listImagesIcon[selectedFace],fit: BoxFit.cover),
    );
  }
}
