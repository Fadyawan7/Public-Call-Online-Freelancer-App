import 'package:dio/dio.dart';
import 'package:flutter_restaurant/common/providers/data_sync_provider.dart';
import 'package:flutter_restaurant/common/reposotories/data_sync_repo.dart';


import 'package:flutter_restaurant/features/auth/domain/reposotories/auth_repo.dart';
import 'package:flutter_restaurant/features/category/domain/reposotories/category_repo.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';

import 'package:flutter_restaurant/features/booking/domain/reposotories/booking_repo.dart';

import 'package:flutter_restaurant/features/address/domain/reposotories/location_repo.dart';
import 'package:flutter_restaurant/features/chat/domain/reposotories/chat_repo.dart';
import 'package:flutter_restaurant/features/chat/providers/chat_provider.dart';
import 'package:flutter_restaurant/features/freelancer/domain/reposotories/freelancer_repo.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/features/freelancer_booking/domain/reposotories/freelancer_booking_repo.dart';
import 'package:flutter_restaurant/features/freelancer_booking/providers/freelancer_booking_provider.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/domain/reposotories/freelancer_portfolio_repo.dart';
import 'package:flutter_restaurant/features/freelancer_portfolio/providers/freelancer_portfolio_provider.dart';
import 'package:flutter_restaurant/features/notification/domain/reposotories/notification_repo.dart';
import 'package:flutter_restaurant/features/language/domain/reposotories/language_repo.dart';
import 'package:flutter_restaurant/features/onboarding/domain/reposotories/onboarding_repo.dart';
import 'package:flutter_restaurant/features/profile/domain/reposotories/profile_repo.dart';
import 'package:flutter_restaurant/features/rating_reviews/providers/review_provider.dart';
import 'package:flutter_restaurant/features/splash/domain/reposotories/splash_repo.dart';

import 'package:flutter_restaurant/features/auth/providers/auth_provider.dart';
import 'package:flutter_restaurant/features/booking/providers/booking_provider.dart';

import 'package:flutter_restaurant/features/language/providers/localization_provider.dart';
import 'package:flutter_restaurant/features/notification/providers/notification_provider.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/language/providers/language_provider.dart';
import 'package:flutter_restaurant/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_restaurant/features/profile/providers/profile_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/common/providers/theme_provider.dart';

import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => DataSyncRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => BookingRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl(), sharedPreferences: sl()));

  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => FreelancerRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => FreelancerBookingRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => FreelancerPortfolioRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl(), sharedPreferences: sl()));


  // Provider
  sl.registerLazySingleton(() => DataSyncProvider());
  sl.registerLazySingleton(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashProvider(splashRepo: sl()));
  sl.registerLazySingleton(() => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => LanguageProvider(languageRepo: sl()));
  sl.registerLazySingleton(() => OnBoardingProvider(onboardingRepo: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => BookingProvider(bookingRepo: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => FreelancerBookingProvider(freelancerBookingRepo: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => FreelancerPortfolioProvider(freelancerPortfolioRepo: sl(), sharedPreferences: sl()));

  sl.registerLazySingleton(() => AuthProvider(authRepo: sl()));
  sl.registerLazySingleton(() => LocationProvider(sharedPreferences: sl(), locationRepo: sl()));
  sl.registerLazySingleton(() => ProfileProvider(profileRepo: sl()));
  sl.registerLazySingleton(() => NotificationProvider(notificationRepo: sl()));
  sl.registerLazySingleton(() => CategoryProvider(categoryRepo: sl()));

  sl.registerLazySingleton(() => FreelancerProvider(sharedPreferences: sl(),freelancerRepo: sl()));

  sl.registerLazySingleton(() => ChatProvider(chatRepo: sl(), notificationRepo: sl()));
  sl.registerLazySingleton(() => ReviewProvider(bookingRepo: sl()));



  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
