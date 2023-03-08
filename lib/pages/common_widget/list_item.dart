import 'package:flutter/material.dart';
import 'package:music/theme.dart';

//elemento grafico di una listaView
class ListItem extends StatelessWidget {
  final String title;
  final String? leadingSubTitle;
  final String? leadingTitle;
  final String? subTitle;
  final String? thirdLine;
  final Widget leadingIcon;
  final double height;
  final void Function()? onTap;

  const ListItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.leadingSubTitle,
    this.leadingTitle,
    this.subTitle,
    this.thirdLine,
    required this.leadingIcon,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //da passare come parametro
      height: height,
      margin: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: MainColor.primaryColor,
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(20.0),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, cons) => Stack(
          clipBehavior: Clip.none,
          children: [
            //tipo di Form
            Positioned(
              top: -15.0,
              bottom: -15.0,
              left: -15,
              child: Container(
                width: cons.maxWidth * 0.3,
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: MainColor.primaryColor,
                  border: Border.all(
                    width: 5.0,
                    color: MainColor.secondaryColor,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    leadingIcon,
                    if (leadingTitle != null)
                      Text(
                        leadingTitle!,
                        textScaleFactor: 0.8,
                        textAlign: TextAlign.center,
                      ),
                    if (leadingSubTitle != null) Text(leadingSubTitle!),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              bottom: 0.0,
              left: cons.maxWidth * 0.30 - 16,
              right: cons.maxWidth * 0.15,
              child: Container(
                decoration: const BoxDecoration(
                  color: MainColor.primaryColor,
                  border: Border.symmetric(
                    horizontal:
                        BorderSide(color: MainColor.secondaryColor, width: 2.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        const Spacer(),
                        if (subTitle != null)
                          Text(
                            subTitle!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (thirdLine != null) Text(thirdLine!),
                      ]),
                ),
              ),
            ),
            Positioned(
              top: 0.0,
              bottom: 0.0,
              right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: cons.maxWidth * 0.15,
                  decoration: const BoxDecoration(
                      color: MainColor.secondaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )),
                  child: const Icon(Icons.send_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
