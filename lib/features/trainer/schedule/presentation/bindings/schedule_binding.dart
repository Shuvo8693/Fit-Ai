import 'package:get/get.dart';
import 'package:pler_to_pler_app/features/trainer/schedule/data/data_sources/schedule_local_data_source.dart';
import 'package:pler_to_pler_app/features/trainer/schedule/data/data_sources/schedule_local_data_source_impl.dart';
import 'package:pler_to_pler_app/features/trainer/schedule/data/data_sources/schedule_remote_data_source.dart';
import 'package:pler_to_pler_app/features/trainer/schedule/data/data_sources/schedule_remote_data_source_impl.dart';
import 'package:pler_to_pler_app/features/trainer/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:pler_to_pler_app/features/trainer/schedule/domain/repositories/schedule_repository.dart';
import 'package:pler_to_pler_app/features/trainer/schedule/presentation/controllers/schedule_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dependency Injection Binding for Schedule Feature
/// Registers all dependencies with GetX
class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    // Local Data Source
    Get.lazyPut<ScheduleLocalDataSource>(
      () => ScheduleLocalDataSourceImpl(Get.find<SharedPreferences>()),
    );

    // Remote Data Source
    Get.lazyPut<ScheduleRemoteDataSource>(
      () => ScheduleRemoteDataSourceImpl(),
    );

    // Repository
    Get.lazyPut<ScheduleRepository>(
      () => ScheduleRepositoryImpl(
        remoteDataSource: Get.find<ScheduleRemoteDataSource>(),
        localDataSource: Get.find<ScheduleLocalDataSource>(),
      ),
    );

    // Controller
    Get.lazyPut<ScheduleController>(
      () => ScheduleController(
        repository: Get.find<ScheduleRepository>(),
      ),
    );
  }
}
