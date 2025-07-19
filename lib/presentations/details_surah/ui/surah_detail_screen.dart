import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:transcosmos_test/domain/entities/surah_detail.dart';
import 'package:transcosmos_test/presentations/details_surah/ui/widgets/audio_player_widget.dart';
import 'package:transcosmos_test/presentations/shared/widgets/loading_widget.dart';
import 'package:transcosmos_test/presentations/shared/widgets/error_widget.dart';
import 'package:transcosmos_test/presentations/surah_detail/controllers/surah_detail_controller.dart';
import 'package:transcosmos_test/presentations/surah_detail/ui/widgets/ayat_card_widget.dart';

class DetailsSurahScreen extends GetView<SurahDetailController> {
  const DetailsSurahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get surah number from arguments
    final int surahNumber = Get.arguments as int;

    // Load surah detail when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSurahDetail(surahNumber);
    });

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.surahDetail?.namaLatin ?? 'Memuat...',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomSheet: const MeasuredAudioPlayerWidget(),
      body: RefreshIndicator(
        onRefresh: () async => controller.getSurahDetail(surahNumber),
        child: Obx(() {
          if (controller.isLoading) {
            return const LoadingWidget();
          }

          if (controller.errorMessage.isNotEmpty) {
            return CustomErrorWidget(
              message: controller.errorMessage,
              onRetry: () => controller.getSurahDetail(surahNumber),
            );
          }

          final surahDetail = controller.surahDetail;
          if (surahDetail == null) {
            return const Center(child: Text('Tidak ada detail surah'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom:
                    controller.audioPlayerHeight > 0
                        ? controller.audioPlayerHeight
                        : kBottomNavigationBarHeight,
              ),
              child: Column(
                children: [
                  // Surah Header
                  _buildHeader(surahDetail, context),
                  const SizedBox(height: 8),
                  // Surah Description
                  _buildDescription(context, surahDetail),
                  const SizedBox(height: 32),
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  // Ayats List
                  _buildAyatList(surahDetail),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  ListView _buildAyatList(SurahDetail surahDetail) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surahDetail.ayats.length,
      itemBuilder: (context, index) {
        final ayat = surahDetail.ayats[index];
        final isLast = index == surahDetail.ayats.length - 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AyatCardWidget(ayat: ayat, isLast: isLast),
        );
      },
    );
  }

  Container _buildDescription(BuildContext context, SurahDetail surahDetail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Deskripsi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Html(
            data: surahDetail.deskripsi,
            style: {
              'body': Style(
                textAlign: TextAlign.justify,
                padding: HtmlPaddings.zero,
                color: Theme.of(context).colorScheme.primary,
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(SurahDetail surahDetail, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Text(
            surahDetail.nama,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            surahDetail.arti,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                context,
                '${surahDetail.jumlahAyat} Ayat',
                Icons.menu_book,
              ),
              _buildInfoChip(
                context,
                surahDetail.tempatTurun.capitalize!,
                Icons.location_on,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
