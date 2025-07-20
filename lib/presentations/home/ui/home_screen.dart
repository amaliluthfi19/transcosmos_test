import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transcosmos_test/core/constants/app_constants.dart';
import 'package:transcosmos_test/core/constants/route_constans.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/presentations/home/controllers/home_controller.dart';
import 'package:transcosmos_test/presentations/home/ui/widgets/search_bar_widget.dart';
import 'widgets/surah_card.dart';
import 'package:transcosmos_test/presentations/shared/widgets/loading_widget.dart';
import 'package:transcosmos_test/presentations/shared/widgets/error_widget.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black38,
        actions: [
          IconButton(
            icon: Obx(
              () => Icon(controller.showSearchBar ? Icons.close : Icons.search),
            ),
            onPressed: controller.toggleSearchBar,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.refreshSurahs(),
        child: Column(
          children: [
            // Collapsible Search Bar
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: controller.showSearchBar ? 80 : 0,
                child:
                    controller.showSearchBar
                        ? SearchBarWidget(controller: controller)
                        : const SizedBox.shrink(),
              ),
            ),
            // Surah list
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const LoadingWidget();
                }

                if (controller.errorMessage.isNotEmpty) {
                  return CustomErrorWidget(
                    message: controller.errorMessage,
                    onRetry: () => controller.refreshSurahs(),
                  );
                }

                final surahs = controller.filteredSurahs;

                if (surahs.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildSurahList(surahs);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahList(List<Surah> surahs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: surahs.length,
      itemBuilder: (context, index) {
        final surah = surahs[index];
        return SurahCard(
          surah: surah,
          onTap: () {
            Get.toNamed(RouteConstants.surahDetail, arguments: surah.nomor);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            controller.searchKeyword.isEmpty
                ? Icons.menu_book
                : Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            controller.searchKeyword.isEmpty
                ? 'Tidak ada surah tersedia'
                : 'Tidak ada surah yang ditemukan',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          if (controller.searchKeyword.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Coba kata kunci lain',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }
}
