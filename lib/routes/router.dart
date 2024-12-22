import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:spooky/routes/utils/animated_page_route.dart';
import 'package:spooky/views/home/home_view.dart';
import 'package:spooky/views/stories/changes/changes_story_view.dart';
import 'package:spooky/views/stories/edit/edit_story_view.dart';
import 'package:spooky/views/stories/show/show_story_view.dart';

final GoRouter $router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return const HomeView().getRoute(context: context, state: state);
      },
    ),
    GoRoute(
      path: '/stories/new',
      pageBuilder: (context, state) {
        return EditStoryView(
          id: null,
          initialYear: int.tryParse(state.uri.queryParameters['initialYear'] ?? ''),
        ).getRoute(context: context, state: state);
      },
    ),
    GoRoute(
      path: '/stories/:id',
      pageBuilder: (context, state) {
        return ShowStoryView(
          id: int.parse(state.pathParameters['id']!),
        ).getRoute(context: context, state: state);
      },
    ),
    GoRoute(
      path: '/stories/:id/edit',
      pageBuilder: (context, state) => EditStoryView(
        id: int.tryParse(state.pathParameters['id']!)!,
        initialPageIndex: int.tryParse(state.uri.queryParameters['initialPageIndex'] ?? '') ?? 0,
        quillControllers: state.extra is Map<int, QuillController> ? state.extra as Map<int, QuillController> : null,
      ).getRoute(context: context, state: state),
    ),
    GoRoute(
      path: '/stories/:id/changes',
      pageBuilder: (context, state) => ChangesStoryView(
        id: int.tryParse(state.pathParameters['id']!)!,
      ).getRoute(context: context, state: state),
    ),
  ],
);

extension _PageRoute on Widget {
  CustomTransitionPage getRoute({
    required BuildContext context,
    required GoRouterState state,
    Color? fillColor,
    SharedAxisTransitionType type = SharedAxisTransitionType.vertical,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          fillColor: fillColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
          child: child,
        );
      },
    );
  }
}
