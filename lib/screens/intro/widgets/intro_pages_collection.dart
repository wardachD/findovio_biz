import 'package:animated_introduction/animated_introduction.dart';

final List<SingleIntroScreen> pages = [
  const SingleIntroScreen(
    imageWithBubble: false,
    imageAsset: 'assets/images/gifs/Beauty salon.png',
    imageHeightMultiple: 0.3,
    title: 'Stwórz salon',
    description:
        'Zarejestruj się i otwórz drzwi do wyjątkowych ofert, zniżek i bonusów.',
  ),
  const SingleIntroScreen(
    imageWithBubble: false,
    imageAsset: 'assets/images/gifs/Business Plan.png',
    imageHeightMultiple: 0.3,
    title: 'Zarządzaj nim',
    description:
        'Zarejestruj się i otwórz drzwi do wyjątkowych ofert, zniżek i bonusów.',
  ),
  const SingleIntroScreen(
    imageAsset: 'assets/images/gifs/App monetization.png',
    imageHeightMultiple: 0.3,
    imageWithBubble: false,
    title: 'Zwiększ zyski',
    description:
        'Zarejestruj się i otwórz drzwi do wyjątkowych ofert, zniżek i bonusów.',
  ),
];
