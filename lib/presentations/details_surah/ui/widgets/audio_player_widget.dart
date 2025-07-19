import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transcosmos_test/presentations/surah_detail/controllers/surah_detail_controller.dart';

class MeasuredAudioPlayerWidget extends StatefulWidget {
  const MeasuredAudioPlayerWidget({super.key});

  @override
  State<MeasuredAudioPlayerWidget> createState() =>
      _MeasuredAudioPlayerWidgetState();
}

class _MeasuredAudioPlayerWidgetState extends State<MeasuredAudioPlayerWidget> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Schedule a post-frame callback to measure the widget height
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureHeight();
    });
  }

  void _measureHeight() {
    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final height = renderBox.size.height;
      final controller = Get.find<SurahDetailController>();
      controller.updateAudioPlayerHeight(height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: const AudioPlayerWidget());
  }
}

class AudioPlayerWidget extends GetView<SurahDetailController> {
  const AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress Bar
            Obx(
              () => Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Colors.grey[300],
                      thumbColor: Theme.of(context).colorScheme.primary,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        disabledThumbRadius: 8,
                        elevation: 4,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 20,
                      ),
                      trackHeight: 4,
                      valueIndicatorShape:
                          const PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor:
                          Theme.of(context).colorScheme.primary,
                      valueIndicatorTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Slider(
                      value: controller.audioProgress.clamp(0.0, 1.0),
                      min: 0.0,
                      max: 1.0,
                      divisions: null, // Allow smooth sliding
                      label: controller.formatDuration(
                        Duration(
                          milliseconds:
                              (controller.audioProgress *
                                      controller.totalDuration.inMilliseconds)
                                  .round(),
                        ),
                      ),
                      onChanged: (value) {
                        // Update progress immediately
                        controller.seekAudioByProgress(value);
                      },
                      onChangeStart: (value) {
                        // Pause audio while seeking
                        if (controller.isPlaying) {
                          controller.pauseAudio();
                        }
                      },
                    ),
                  ),

                  // Time Display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.formatDuration(controller.currentPosition),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          controller.formatDuration(controller.totalDuration),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Previous Surah Button
                Obx(
                  () => IconButton(
                    onPressed:
                        controller.surahDetail?.suratSebelumnya != null
                            ? controller.navigateToPreviousSurah
                            : null,
                    icon: Icon(
                      Icons.skip_previous,
                      color:
                          controller.surahDetail?.suratSebelumnya != null
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                    ),
                    iconSize: 32,
                  ),
                ),

                // Play/Pause Button
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed:
                          controller.isLoadingAudio
                              ? null
                              : () {
                                if (controller.isPlaying) {
                                  controller.pauseAudio();
                                } else {
                                  controller.playAudio();
                                }
                              },
                      icon:
                          controller.isLoadingAudio
                              ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              )
                              : Icon(
                                controller.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                      iconSize: 32,
                    ),
                  ),
                ),

                // Stop Button
                IconButton(
                  onPressed: controller.stopAudio,
                  icon: Icon(
                    Icons.stop,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  iconSize: 32,
                ),

                // Next Surah Button
                Obx(
                  () => IconButton(
                    onPressed:
                        controller.surahDetail?.suratSelanjutnya != null
                            ? controller.navigateToNextSurah
                            : null,
                    icon: Icon(
                      Icons.skip_next,
                      color:
                          controller.surahDetail?.suratSelanjutnya != null
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                    ),
                    iconSize: 32,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Audio Status with enhanced styling
            Obx(
              () => Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        controller.isPlaying
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1)
                            : controller.isSeeking
                            ? Colors.orange.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.isSeeking)
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orange,
                            ),
                          ),
                        ),
                      if (controller.isSeeking) const SizedBox(width: 8),
                      Text(
                        controller.isLoadingAudio
                            ? 'Loading audio...'
                            : controller.isSeeking
                            ? 'Seeking...'
                            : controller.isPlaying
                            ? 'Playing'
                            : 'Paused',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              controller.isPlaying
                                  ? Theme.of(context).colorScheme.primary
                                  : controller.isSeeking
                                  ? Colors.orange
                                  : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
