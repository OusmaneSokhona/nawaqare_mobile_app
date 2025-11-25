import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardWidget extends StatelessWidget {
  final Color baseColor;
  final Color textColor;
  final Color waveColor;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cardLogo;

  const CreditCardWidget({
    super.key,
    required this.baseColor,
    required this.textColor,
    required this.waveColor,
    required this.cardLogo,
    this.cardNumber = '5282 3456 7890',
    this.cardHolder = 'Roronoa Zoro',
    this.expiryDate = '09/25',
  });

  @override
  Widget build(BuildContext context) {

    // The standard aspect ratio for credit cards is 1.586
    return AspectRatio(
      aspectRatio: 1.586,
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: CardWavePainter(waveColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row: Chip and Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/images/sim.png",height: 30.h,width: 60.w,),
                        Image.asset(cardLogo,height: 40.h,width: 60.w,),
                      ],
                    ),

                    // Card Number
                    Text(
                      cardNumber,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                    ),

                    // Bottom Row: Holder and Expiry
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARD HOLDER',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cardHolder,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          expiryDate,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CardWavePainter extends CustomPainter {
  final Color lighterShade;

  CardWavePainter(this.lighterShade);

  @override
  void paint(Canvas canvas, Size size) {
    final lighterPaint = Paint()
      ..color = lighterShade.withOpacity(0.1) // Opacity 40%
      ..style = PaintingStyle.fill;

    final veryLightPaint = Paint()
      ..color = lighterShade.withOpacity(0.1) // Opacity 20%
      ..style = PaintingStyle.fill;

    // --- Large Wave Path (Simulating the C70 30 70 70 100 100 Z path from React) ---
    final largePath = Path();
    largePath.moveTo(0, 0);
    largePath.lineTo(size.width, 0);
    // Control points for a large curve
    largePath.cubicTo(size.width * 0.7, size.height * 0.3, size.width * 0.7,
        size.height * 0.7, size.width, size.height);
    largePath.lineTo(0, size.height);
    largePath.close();

    canvas.drawPath(largePath, lighterPaint);

    // --- Smaller Wave Path (Simulating the C40 20 50 60 0 100 Z path from React) ---
    final smallPath = Path();
    smallPath.moveTo(0, 0);
    // Control points for a smaller, inner curve
    smallPath.cubicTo(size.width * 0.4, size.height * 0.2, size.width * 0.5,
        size.height * 0.6, 0, size.height);
    smallPath.close();

    canvas.drawPath(smallPath, veryLightPaint);
  }

  @override
  bool shouldRepaint(covariant CardWavePainter oldDelegate) =>
      oldDelegate.lighterShade != lighterShade;
}