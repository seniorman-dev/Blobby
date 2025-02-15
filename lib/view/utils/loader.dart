import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';





class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(  //threeArchedCircle( 
        color: Colors.white, 
        size: 35.r,
      ),
    );
  }
}


class LoaderDark extends StatelessWidget {
  const LoaderDark({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle( 
        color: Colors.black,  
        size: 35.r,
      ),
    );
  }
}