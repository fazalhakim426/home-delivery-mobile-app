// lib/widgets/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:home_delivery_br/app/app_colors.dart';
import 'custom_drawer.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final String title;
  final bool showDrawer;
  final VoidCallback? onScrollUp; // Optional callback for scroll detection

  const AppScaffold({
    super.key,
    required this.body,
    this.title = 'HomeDelivery Br',
    this.showDrawer = true,
    this.onScrollUp,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse &&
        _scrollController.offset > _lastScrollOffset) {
      widget.onScrollUp?.call();
    }
    _lastScrollOffset = _scrollController.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white, // Or any static color (e.g., AppColors.primary)
        title: Text(widget.title),
        foregroundColor: AppColors.primary,
        leading: widget.showDrawer
            ? IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        )
            : null,
      ),
      drawer: widget.showDrawer ? const CustomDrawer() : null,
      body: PrimaryScrollController(
        controller: _scrollController,
        child: widget.body,
      ),
    );
  }
}