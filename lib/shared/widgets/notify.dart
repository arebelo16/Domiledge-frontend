import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum NotifyType { success, info, warning, error }

class Notify {
  static OverlayEntry? _entry;

  static void show(
    BuildContext context,
    String message, {
    NotifyType type = NotifyType.info,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _entry?.remove();
    final overlay = Overlay.of(context, rootOverlay: true);

    _entry = OverlayEntry(
      builder: (_) => _Toast(
        message: message,
        title: title,
        type: type,
        duration: duration,
        onClosed: () {
          _entry?.remove();
          _entry = null;
        },
      ),
    );
    overlay.insert(_entry!);
  }

  static void close() {
    _entry?.remove();
    _entry = null;
  }
}

class _Toast extends StatefulWidget {
  final String message;
  final String? title;
  final NotifyType type;
  final Duration duration;
  final VoidCallback onClosed;

  const _Toast({
    required this.message,
    required this.type,
    required this.duration,
    required this.onClosed,
    this.title,
  });

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with TickerProviderStateMixin {
  static const double _radius = 12.0;
  static const double _borderWidth = 1.0;
  static const double _barHeight = 2.75;

  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  /// 0 -> 1
  late final AnimationController _progress;

  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _paused = false;

  Color get _accent {
    switch (widget.type) {
      case NotifyType.success:
        return const Color(0xFF22c55e);
      case NotifyType.info:
        return const Color(0xFF3b82f6);
      case NotifyType.warning:
        return const Color(0xFFf59e0b);
      case NotifyType.error:
        return const Color(0xFFef4444);
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case NotifyType.success:
        return Icons.check_circle_rounded;
      case NotifyType.info:
        return Icons.info_rounded;
      case NotifyType.warning:
        return Icons.warning_rounded;
      case NotifyType.error:
        return Icons.error_rounded;
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.18, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _progress = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0,
      upperBound: 1,
    );

    _ctrl.forward();
    _progress.forward();
    _remaining = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(_remaining, _close);
  }

  void _pause() {
    if (_paused) return;
    _paused = true;
    _progress.stop();
    _remaining = widget.duration * (1 - _progress.value);
    _timer?.cancel();
  }

  void _resume() {
    if (!_paused) return;
    _paused = false;
    _progress.animateTo(1, duration: _remaining, curve: Curves.linear);
    _startTimer();
  }

  Future<void> _close() async {
    await _ctrl.reverse();
    widget.onClosed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: MouseRegion(
        onEnter: kIsWeb ? (_) => _pause() : null,
        onExit: kIsWeb ? (_) => _resume() : null,
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Material(
                color: Colors.white,
                elevation: 0,
                borderRadius: BorderRadius.circular(_radius),
                clipBehavior: Clip.hardEdge,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_radius),
                    border: Border.all(
                      color: _accent.withOpacity(.18),
                      width: _borderWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // --------- Content ---------
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(_icon, color: _accent, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.title != null)
                                    Text(
                                      widget.title!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  Text(
                                    widget.message,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: _close,
                              borderRadius: BorderRadius.circular(6),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.close, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --------- Progress Bar ---------
                      Positioned(
                        left: _borderWidth,
                        right: _borderWidth,
                        bottom: _borderWidth,
                        height: _barHeight,
                        child: AnimatedBuilder(
                          animation: _progress,
                          builder: (_, __) {
                            final v = _progress.value.clamp(0.0, 1.0);
                            return ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(_radius - _borderWidth),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Opacity(
                                    opacity: .12,
                                    child: Container(color: _accent),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: v,
                                      child: Container(
                                        height: double.infinity,
                                        color: _accent.withOpacity(.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
