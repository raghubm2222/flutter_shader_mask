import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Shader Mask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('Shader Mask'),
        actions: [
          TextButton.icon(
            onPressed: () {
              CustomNavigator.to(context: context, route: DynamicGridView());
            },
            icon: Icon(
              Icons.grid_on,
              color: Colors.white,
            ),
            label: Text(
              'Dynamic Grid',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 15.0),
          TextButton.icon(
            onPressed: () {
              CustomNavigator.to(context: context, route: ListViewShaderMask());
            },
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            label: Text(
              'List View',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 15.0),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (rect) => LinearGradient(colors: [
                Colors.yellow,
                Colors.red,
                Colors.yellow,
                Colors.red,
              ]).createShader(rect),
              child: Text(
                'Flutter Fire',
                style: TextStyle(
                    fontSize: size > 600 ? 100.0 : 50, color: Colors.white),
              ),
            ),
            ShaderMaskWidget(
              beginColor: Colors.green,
              endColor: Colors.black,
              child: Text(
                'Animated Flutter',
                style: TextStyle(
                    fontSize: size > 600 ? 120.0 : 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ShaderMaskWidget(
              beginColor: Colors.blue.shade300,
              endColor: Colors.purple.shade300,
              child: Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1593642634402-b0eb5e2eebc9?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicGridView extends StatelessWidget {
  const DynamicGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    int crossAxisCount = size ~/ 250;
    return Scaffold(
      appBar: AppBar(
        title: Text('DynamicGridView'),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: GridView.builder(
            itemCount: 100,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 2,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              return ShaderMaskWidget(
                beginColor: Colors.white,
                endColor: Colors.blueGrey,
              );
            }),
      ),
    );
  }
}

class ListViewShaderMask extends StatelessWidget {
  const ListViewShaderMask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return ShaderMaskWidget();
        },
      ),
    );
  }
}

class ShaderMaskWidget extends StatefulWidget {
  final Color? beginColor;
  final Color? endColor;
  final Widget? child;
  const ShaderMaskWidget({
    Key? key,
    this.beginColor = Colors.white,
    this.endColor = Colors.grey,
    this.child,
  }) : super(key: key);

  @override
  _ShaderMaskWidgetState createState() => _ShaderMaskWidgetState();
}

class _ShaderMaskWidgetState extends State<ShaderMaskWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Color?>? forwardAnimation;
  Animation<Color?>? backwardAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    forwardAnimation =
        ColorTween(begin: widget.beginColor, end: widget.endColor)
            .animate(_controller!);
    backwardAnimation =
        ColorTween(begin: widget.endColor, end: widget.beginColor)
            .animate(_controller!);
    _controller!.forward();
    _controller!.addListener(() {
      if (_controller!.status == AnimationStatus.completed) {
        _controller!.reverse();
      } else if (_controller!.status == AnimationStatus.dismissed) {
        _controller!.forward();
      }
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    _controller!.stop();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        colors: [forwardAnimation!.value!, backwardAnimation!.value!],
      ).createShader(rect),
      child: widget.child ?? LoadingWidget(),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            color: Colors.white,
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12.0,
                  width: double.infinity,
                  color: Colors.white,
                ),
                Container(
                  height: 8.0,
                  width: 30.0,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                ),
                Container(
                  height: 8.0,
                  width: 150.0,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                ),
                Container(
                  height: 8.0,
                  width: 180.0,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                      height: 15.0,
                      width: 50.0,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      height: 15.0,
                      width: 50.0,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomNavigator {
  static void to({required BuildContext context, required Widget route}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0, 0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(microseconds: 100),
      ),
    );
  }
}
