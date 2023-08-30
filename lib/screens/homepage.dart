import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joke_a_minute/providers/jokes.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    context.read<JokeProvider>().startTimer();
    context.read<JokeProvider>().fetchOrientationState();
    super.initState();
  }

  @override
  void dispose() {
    context.read<JokeProvider>().timer?.cancel();
    super.dispose();
  }

  final primaryGreen = const Color(0xFFc9f73a);
  final fontStyle = GoogleFonts.poppins().copyWith(
      color: Colors.black87, fontSize: 22.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () =>
                context.read<JokeProvider>().rotateScrollOrientation(),
            backgroundColor: Colors.black,
            child:
                const Icon(Icons.view_carousel_outlined, color: Colors.white)),
        body: context.watch<JokeProvider>().jokes.isEmpty
            ? const CircularProgressIndicator()
            : SafeArea(
                child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/background.png"),
                            fit: BoxFit.cover)),
                    child: Center(
                        child: context.watch<JokeProvider>().isHorizontalView
                            ? FlutterCarousel(
                                options: CarouselOptions(
                                    height: mq.height - mq.height * .2,
                                    showIndicator: true,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    viewportFraction: 0.7),
                                items: context
                                    .watch<JokeProvider>()
                                    .jokes
                                    .map((e) => _cardDesignHorizontal(mq, e))
                                    .toList())
                            : Column(children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: _timerIndicator()),
                                Expanded(
                                    child: AnimatedList(
                                        key: context
                                            .read<JokeProvider>()
                                            .listKey,
                                        shrinkWrap: true,
                                        initialItemCount: context
                                            .watch<JokeProvider>()
                                            .jokes
                                            .length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder:
                                            (context, index, animation) {
                                          return SlideTransition(
                                              position: Tween<Offset>(
                                                      begin:
                                                          const Offset(-1, 0),
                                                      end: const Offset(0, 0))
                                                  .animate(CurvedAnimation(
                                                      parent: animation,
                                                      curve: Curves.linear,
                                                      reverseCurve:
                                                          Curves.linear)),
                                              child:
                                                  _cardDesignVertical(index));
                                        }))
                              ])))));
  }

  Widget _cardDesignHorizontal(Size mq, String joke) {
    return Card(
        color: primaryGreen.withOpacity(0.85),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 36.0),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 36.0),
                  child: SizedBox(
                      width: mq.width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Text(
                                    (context
                                                .watch<JokeProvider>()
                                                .jokes
                                                .indexOf(joke) +
                                            1)
                                        .toString(),
                                    style: fontStyle.copyWith(
                                        color: Colors.white))),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: _timerIndicator())))
                          ]))),
              Expanded(
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(36.0),
                          child: Text(joke, style: fontStyle))))
            ]));
  }

  Widget _cardDesignVertical(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
      child: Card(
        elevation: 4.0,
        color: primaryGreen.withOpacity(0.7),
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.black,
                child: Text((index + 1).toString(),
                    style: fontStyle.copyWith(color: Colors.white))),
            title: Text(context.watch<JokeProvider>().jokes[index].toString(),
                style: fontStyle.copyWith(fontSize: 16.0))),
      ),
    );
  }

  Widget _timerIndicator() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(
            context.watch<JokeProvider>().isHorizontalView ? 8 : 0),
        child: LinearProgressIndicator(
            value: context.watch<JokeProvider>().timerIndicator,
            minHeight: 8.0,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black87),
            backgroundColor: Colors.grey));
  }

  Widget transition(Animation<double> animation) {
    return SlideTransition(
        position:
            Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.linear,
                    reverseCurve: Curves.linear)),
        child: _cardDesignVertical(0));
  }
}
