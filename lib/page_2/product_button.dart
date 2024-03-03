import 'package:flutter/material.dart';

class ProductButton extends StatelessWidget {
  const ProductButton({
    super.key,
    required this.text,
    required this.color,
    this.height = 50,
    this.width,
    this.borderRadius = 15,
    this.isOutlined = false,
    this.icon,
  });

  final String text;
  final Color color;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool isOutlined;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(right: 16),
      child: isOutlined
          ? OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(color),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox(),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xffB1B0B0),
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            )
          : FilledButton(
              onPressed: () {},
              style: ButtonStyle(
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 12),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(color),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox(),
                  Text(
                    text,
                    style: TextStyle(
                      color: color == Colors.white ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
