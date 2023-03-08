import 'package:flutter/material.dart';
import 'package:music/theme.dart';

//elemento grafico di una GridView
//* sarà reso disponibile in una prossima versione
class GridItem extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? leadingTitle;
  final String? topRightTxt;
  final Widget leadingIcon;
  final void Function()? onTap;

  const GridItem({
    Key? key,
    required this.title,
    this.subTitle,
    required this.leadingIcon,
    this.leadingTitle,
    this.topRightTxt,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      elevation: 3.0,
      color: MainColor.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          width: 4.0,
          color: MainColor.secondaryColor.withOpacity(0.8),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, cons) => Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              child: Container(
                height: cons.maxHeight * 0.4,
                width: cons.maxWidth * 0.6,
                decoration: BoxDecoration(
                  color: MainColor.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(15.0),
                    topLeft: Radius.circular(25.0),
                  ),
                  border:
                      Border.all(width: 4.0, color: MainColor.secondaryColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(children: [
                    leadingIcon,
                    if (leadingTitle != null) Text(leadingTitle!),
                  ]),
                ),
              ),
            ),
            if (topRightTxt != null)
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                child: Text(topRightTxt!),
              ),
            Positioned(
              left: 10,
              top: cons.maxHeight * 0.4 + 10,
              bottom: cons.maxHeight * 0.15,
              right: 0.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Text(title)),
                    if (subTitle != null) Text(subTitle!),
                  ]),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              top: cons.maxHeight * 0.80,
              left: cons.maxWidth * 0.70,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25.0),
                          topLeft: Radius.circular(15.0)),
                      color: MainColor.secondaryColor),
                  child: const Center(child: Icon(Icons.send_outlined)),
                ),
              ),
            ),
          ],
        ),
      ));
}
