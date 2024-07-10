import 'package:animated_introduction/src/constants/constants.dart';
import 'package:animated_introduction/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedIntroduction extends StatefulWidget {
//  PageController get controller => this.createState()._controller;

  @override
  AnimatedIntroductionState createState() => AnimatedIntroductionState();

  ///sets the indicator type for your slides
  ///[IndicatorType]
  final IndicatorType? indicatorType;

  ///sets the next widget, the one used to move to the next screen
  ///[Widget]
  final Widget? nextWidget;

  ///sets the next text, the one used to move to the next screen
  ///[String]
  final String nextText;

  ///sets the done widget, the one used to end the slides
  ///[Widget]
  final Widget? doneWidget;

  ///set the radius of the footer part of your slides
  ///[double]
  final double footerRadius;

  ///sets the viewport fraction of your controller
  ///[double]
  final double viewPortFraction;

  ///sets your slides
  ///[List<IntroScreen>]
  final List<SingleIntroScreen> slides;

  ///sets the skip widget text
  ///[String]
  final String skipText;

  /// sets the done text
  /// [String]
  final String doneText;

  ///defines what to do when the skip button is tapped
  ///[Function]
  final Function? onSkip;

  ///defines what to do when the last slide is reached
  ///[Function]
  final Function onDone;

  ///defines what to do when the last slide is reached
  ///[Function]
  final Function onRegister;

  /// set the color of the active indicator
  ///[Color]
  final Color activeDotColor;

  ///set the color of an inactive indicator
  ///[Color]
  final Color? inactiveDotColor;

  ///sets the padding of the footer part of your slides
  ///[EdgeInsets]
  final EdgeInsets footerPadding;

  ///sets the background color of the footer part of your slides
  ///[Color]
  final Color footerBgColor;

  ///sets the text color of your slides
  ///[Color]
  final Color textColor;

  ///sets the colors of the gradient for the footer widget of your slides
  ///[List<Color>]
  final List<Color> footerGradients;

  ///[ScrollPhysics]
  ///sets the physics for the page view
  final ScrollPhysics physics;

  ///[Color]
  ///sets the wrapper container's background color, defaults to white
  final Color containerBg;

  ///[Color]
  ///sets the wrapper container's background color, defaults to white
  final Color containerBorderColor;

  ///[double]
  ///sets the height of the footer widget
  final double? topHeightForFooter;

  ///[bool]
  ///is the screen full screen with systemNavigationBarColor
  final bool isFullScreen;

  const AnimatedIntroduction({
    super.key,
    required this.slides,
    this.footerRadius = 26.0,
    this.footerGradients = const [],
    this.containerBg = Colors.white,
    this.containerBorderColor = Colors.white,
    required this.onDone,
    required this.onRegister,
    this.indicatorType = IndicatorType.circle,
    this.physics = const BouncingScrollPhysics(),
    this.onSkip,
    this.nextWidget,
    this.doneWidget,
    this.activeDotColor = Colors.white,
    this.inactiveDotColor,
    this.skipText = 'Pomiń',
    this.nextText = 'Dalej',
    this.doneText = 'Zaloguj się',
    this.viewPortFraction = 1.0,
    this.textColor = const Color.fromARGB(255, 37, 37, 37),
    this.footerPadding = const EdgeInsets.all(24),
    this.footerBgColor = const Color(0xff51adf6),
    this.topHeightForFooter,
    this.isFullScreen = false,
  }) : assert(slides.length > 0);
}

class AnimatedIntroductionState extends State<AnimatedIntroduction>
    with TickerProviderStateMixin {
  PageController? _controller;
  double? pageOffset = 0;
  int currentPage = 0;
  bool lastPage = false;
  late AnimationController animationController;
  SingleIntroScreen? currentScreen;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: widget.viewPortFraction,
    )..addListener(() {
        pageOffset = _controller!.page;
      });

    currentScreen = widget.slides[0];
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
  }

  get onSkip => widget.onSkip ?? defaultOnSkip;

  defaultOnSkip() => _controller?.animateToPage(
        widget.slides.length - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );

  TextStyle get textStyle =>
      currentScreen!.textStyle ??
      Theme.of(context).textTheme.bodyLarge ??
      const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
      );

  Widget get next => Container(
        width: 160,
        child: widget.nextWidget ??
            Text(
              textAlign: TextAlign.center,
              widget.nextText,
              style: textStyle.apply(
                color: widget.textColor,
                fontSizeFactor: .9,
                fontWeightDelta: 1,
              ),
            ),
      );

  Widget get done => Container(
        width: 160,
        child: widget.doneWidget ??
            Text(
              textAlign: TextAlign.center,
              widget.doneText,
              style: textStyle.apply(
                color: widget.textColor,
                fontSizeFactor: .9,
                fontWeightDelta: 1,
              ),
            ),
      );

  @override
  void dispose() {
    _controller!.dispose();
    animationController.dispose();
    super.dispose();
  }

  bool get existGradientColors =>
      widget.footerGradients.isNotEmpty && widget.footerGradients.length > 1;

  LinearGradient get gradients => existGradientColors
      ? LinearGradient(
          colors: widget.footerGradients,
          begin: Alignment.topLeft,
          end: Alignment.topRight)
      : LinearGradient(
          colors: [
            widget.footerBgColor,
            widget.footerBgColor,
          ],
        );

  int getCurrentPage() => _controller!.page!.floor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: currentScreen?.headerBgColor?.withOpacity(.8) ??
              Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor:
              widget.isFullScreen ? gradients.colors.first : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            PageView.builder(
              itemCount: widget.slides.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  currentScreen = widget.slides[currentPage];
                  if (currentPage == widget.slides.length - 1) {
                    lastPage = true;
                    animationController.forward();
                  } else {
                    lastPage = false;
                    animationController.reverse();
                  }
                });
              },
              controller: _controller,
              physics: widget.physics,
              itemBuilder: (context, index) {
                if (index == pageOffset!.floor()) {
                  return AnimatedBuilder(
                      animation: _controller!,
                      builder: (context, _) {
                        return buildPage(
                          index: index,
                          angle: pageOffset! - index,
                        );
                      });
                } else if (index == pageOffset!.floor() + 1) {
                  return AnimatedBuilder(
                    animation: _controller!,
                    builder: (context, _) {
                      return buildPage(
                        index: index,
                        angle: pageOffset! - index,
                      );
                    },
                  );
                }
                return buildPage(index: index);
              },
            ),
            //footer widget

            //controls widget

            Positioned.fill(
              bottom: 30,
              right: MediaQuery.sizeOf(context).width * 0.06,
              left: MediaQuery.sizeOf(context).width * 0.06,
              top: widget.topHeightForFooter ??
                  MediaQuery.sizeOf(context).height * .62,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: widget.containerBg,
                        border: Border.all(
                          color: widget.containerBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        gradient: gradients,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 241, 241, 241),
                            blurRadius: 8,
                            spreadRadius: 7,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                currentScreen!.title!,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textStyle.apply(
                                  fontFamily: 'BioRhyme',
                                  color: widget.textColor,
                                  fontWeightDelta: 5,
                                  fontSizeDelta: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                currentScreen!.description!,
                                softWrap: true,
                                style: textStyle.apply(
                                  color: widget.textColor,
                                  fontSizeFactor: .9,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Material(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      type: MaterialType.transparency,
                                      child: lastPage
                                          ? OutlinedButton(
                                              onPressed: widget.onDone as void
                                                  Function()?,
                                              child: done)
                                          : OutlinedButton(
                                              onPressed: () =>
                                                  _controller!.nextPage(
                                                    duration: const Duration(
                                                        milliseconds: 800),
                                                    curve: Curves.fastOutSlowIn,
                                                  ),
                                              child: next),
                                    ),
                                    Material(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      type: MaterialType.transparency,
                                      child: lastPage
                                          ? OutlinedButton(
                                              onPressed: widget.onRegister
                                                  as void Function()?,
                                              style: ButtonStyle(
                                                side: MaterialStateProperty.all(
                                                    BorderSide.none),
                                              ),
                                              child: Text(
                                                'Zarejestruj się',
                                                style: textStyle.apply(
                                                  color: widget.textColor,
                                                  fontSizeFactor: .9,
                                                  fontWeightDelta: 1,
                                                ),
                                              ))
                                          : OutlinedButton(
                                              onPressed: onSkip,
                                              style: ButtonStyle(
                                                side: MaterialStateProperty.all(
                                                    BorderSide.none),
                                              ),
                                              child: Text(
                                                'Pomiń',
                                                style: textStyle.apply(
                                                  color: widget.textColor,
                                                  fontSizeFactor: .9,
                                                  fontWeightDelta: 0,
                                                ),
                                              )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //controls widget
          ],
        ),
      ),
    );
  }

  Widget buildPage(
          {required int index, double angle = 0.0, double scale = 1.0}) =>
      // print(pageOffset - index);
      Container(
        color: Colors.transparent,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, .001)
            ..rotateY(angle),
          child: widget.slides[index],
        ),
      );
}
