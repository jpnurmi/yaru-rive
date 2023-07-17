import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <({
      IconData Function(bool) icon,
      String label,
      String asset,
      List<String> animations,
    })>[
      (
        icon: (s) => s ? YaruIcons.meter_0_filled : YaruIcons.meter_0,
        label: 'Wroooom',
        asset: 'assets/338-662-car-interface.riv',
        animations: [],
      ),
      (
        icon: (s) => s ? YaruIcons.dialpad_filled : YaruIcons.dialpad,
        label: 'Chaotic Queens',
        asset: 'assets/4066-8427-chaotic-queens.riv',
        animations: [],
      ),
      (
        icon: (s) => s ? YaruIcons.sun_filled : YaruIcons.sun,
        label: 'Noon Nap',
        asset: 'assets/4357-8952-noon-nap.riv',
        animations: ['Idle'],
      ),
    ];

    return YaruTheme(
      builder: (context, yaru, child) => MaterialApp(
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: YaruWindowTitleBar(
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(YaruIcons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          extendBodyBehindAppBar: true,
          body: YaruNavigationPage(
            leading: const SizedBox(height: kYaruTitleBarHeight),
            length: pages.length,
            itemBuilder: (context, index, selected) => YaruNavigationRailItem(
              icon: Icon(pages[index].icon(selected)),
              label: Text(pages[index].label),
              style: YaruNavigationRailStyle.labelled,
            ),
            pageBuilder: (context, index) => MyPage(
              asset: pages[index].asset,
              animations: pages[index].animations,
            ),
          ),
        ),
      ),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({
    super.key,
    required this.asset,
    required this.animations,
  });

  final String asset;
  final List<String> animations;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 12),
          sliver: SliverAppBar(
            pinned: true,
            collapsedHeight: 0,
            toolbarHeight: 0,
            expandedHeight: 520,
            shape: const Border.fromBorderSide(BorderSide.none),
            flexibleSpace: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Opacity(
                opacity: 1 - (_controller.offset / 520).clamp(0, 1).toDouble(),
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: RiveAnimation.asset(
                    widget.asset,
                    animations: widget.animations,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        for (var i = 0; i < 3; ++i) ...[
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: kYaruPagePadding * 2)
                    .copyWith(bottom: 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Lorem ipsum',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: kYaruPagePadding)
                .copyWith(bottom: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 200,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => YaruBanner.tile(
                  title: const Text('Foo'),
                  subtitle: const Text('Bar'),
                  onTap: () {},
                ),
                childCount: 1,
              ),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: kYaruPagePadding * 2)
                    .copyWith(bottom: 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Dolor sit amet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: kYaruPagePadding)
                .copyWith(bottom: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 100,
                maxCrossAxisExtent: 550,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => YaruBanner.tile(
                  title: const Text('Foo'),
                  subtitle: const Text('Bar'),
                  onTap: () {},
                ),
                childCount: 10,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: kYaruPagePadding)
                .copyWith(bottom: 12),
          ),
        ],
      ],
    );
  }
}
