import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('pl'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CleanPath'**
  String get appTitle;

  /// No description provided for @drawerOptions.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get drawerOptions;

  /// No description provided for @drawerStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get drawerStatistics;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerForum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get drawerForum;

  /// No description provided for @drawerAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get drawerAchievements;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @appLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguageTitle;

  /// No description provided for @appLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get appLanguageSubtitle;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(Object message);

  /// No description provided for @selectedLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Currently selected'**
  String get selectedLanguageLabel;

  /// No description provided for @achievement1Title.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started!'**
  String get achievement1Title;

  /// No description provided for @achievement1Description.
  ///
  /// In en, this message translates to:
  /// **'Begin any fight with an addiction.'**
  String get achievement1Description;

  /// No description provided for @achievement2Title.
  ///
  /// In en, this message translates to:
  /// **'First day of the journey'**
  String get achievement2Title;

  /// No description provided for @achievement2Description.
  ///
  /// In en, this message translates to:
  /// **'The first 24 hours are behind you. Every step counts!'**
  String get achievement2Description;

  /// No description provided for @achievement3Title.
  ///
  /// In en, this message translates to:
  /// **'3 days of freedom'**
  String get achievement3Title;

  /// No description provided for @achievement3Description.
  ///
  /// In en, this message translates to:
  /// **'Three days of perseverance! You\'re building your new future.'**
  String get achievement3Description;

  /// No description provided for @achievement4Title.
  ///
  /// In en, this message translates to:
  /// **'7 days clean'**
  String get achievement4Title;

  /// No description provided for @achievement4Description.
  ///
  /// In en, this message translates to:
  /// **'The first week is behind you. You\'re stronger than you think!'**
  String get achievement4Description;

  /// No description provided for @achievement5Title.
  ///
  /// In en, this message translates to:
  /// **'Two weeks of perseverance'**
  String get achievement5Title;

  /// No description provided for @achievement5Description.
  ///
  /// In en, this message translates to:
  /// **'Two weeks on the new path already. You can be proud!'**
  String get achievement5Description;

  /// No description provided for @achievement6Title.
  ///
  /// In en, this message translates to:
  /// **'A month of new life'**
  String get achievement6Title;

  /// No description provided for @achievement6Description.
  ///
  /// In en, this message translates to:
  /// **'30 days of change! Your determination makes a difference.'**
  String get achievement6Description;

  /// No description provided for @achievement7Title.
  ///
  /// In en, this message translates to:
  /// **'60 days of strength'**
  String get achievement7Title;

  /// No description provided for @achievement7Description.
  ///
  /// In en, this message translates to:
  /// **'Two months already. Your consistency deserves recognition!'**
  String get achievement7Description;

  /// No description provided for @achievement8Title.
  ///
  /// In en, this message translates to:
  /// **'100 days of victory'**
  String get achievement8Title;

  /// No description provided for @achievement8Description.
  ///
  /// In en, this message translates to:
  /// **'Over three months now. Perseverance is becoming your strength!'**
  String get achievement8Description;

  /// No description provided for @achievement9Title.
  ///
  /// In en, this message translates to:
  /// **'Year of freedom'**
  String get achievement9Title;

  /// No description provided for @achievement9Description.
  ///
  /// In en, this message translates to:
  /// **'365 days of struggle, growth, and transformation. You\'re an example of strength and determination!'**
  String get achievement9Description;

  /// No description provided for @achievement10Title.
  ///
  /// In en, this message translates to:
  /// **'One minute passed'**
  String get achievement10Title;

  /// No description provided for @achievement10Description.
  ///
  /// In en, this message translates to:
  /// **'Test achievement for verification.'**
  String get achievement10Description;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @noAchievements.
  ///
  /// In en, this message translates to:
  /// **'No achievements'**
  String get noAchievements;

  /// No description provided for @noRecordsForDay.
  ///
  /// In en, this message translates to:
  /// **'No records for this day'**
  String get noRecordsForDay;

  /// No description provided for @motivationPopupDescription.
  ///
  /// In en, this message translates to:
  /// **'You can always begin again.\\nDon\'t lose faith in yourself'**
  String get motivationPopupDescription;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @commentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentLabel;

  /// No description provided for @failDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Fail date'**
  String get failDateLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No Records'**
  String get noRecords;

  /// No description provided for @mainTagline.
  ///
  /// In en, this message translates to:
  /// **'Get rid of addictions with us today!'**
  String get mainTagline;

  /// No description provided for @addictionPornography.
  ///
  /// In en, this message translates to:
  /// **'Pornography'**
  String get addictionPornography;

  /// No description provided for @addictionSmoking.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get addictionSmoking;

  /// No description provided for @addictionDrinking.
  ///
  /// In en, this message translates to:
  /// **'Drinking'**
  String get addictionDrinking;

  /// No description provided for @addictionSweets.
  ///
  /// In en, this message translates to:
  /// **'Sweets'**
  String get addictionSweets;

  /// No description provided for @editRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Record'**
  String get editRecordTitle;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Write comment...'**
  String get commentHint;

  /// No description provided for @dateHint.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get dateHint;

  /// No description provided for @motivationMessage1.
  ///
  /// In en, this message translates to:
  /// **'One day at a time — that\'s enough.'**
  String get motivationMessage1;

  /// No description provided for @motivationMessage2.
  ///
  /// In en, this message translates to:
  /// **'You don’t have to be perfect, just persistent.'**
  String get motivationMessage2;

  /// No description provided for @motivationMessage3.
  ///
  /// In en, this message translates to:
  /// **'Every no is a step toward freedom.'**
  String get motivationMessage3;

  /// No description provided for @motivationMessage4.
  ///
  /// In en, this message translates to:
  /// **'Your strength is built in silence — keep going.'**
  String get motivationMessage4;

  /// No description provided for @motivationMessage5.
  ///
  /// In en, this message translates to:
  /// **'A setback doesn’t erase your progress. Getting back up proves your power.'**
  String get motivationMessage5;

  /// No description provided for @motivationMessage6.
  ///
  /// In en, this message translates to:
  /// **'You are not alone. What you feel matters.'**
  String get motivationMessage6;

  /// No description provided for @motivationMessage7.
  ///
  /// In en, this message translates to:
  /// **'Your tomorrow depends on the choices you make today.'**
  String get motivationMessage7;

  /// No description provided for @motivationMessage8.
  ///
  /// In en, this message translates to:
  /// **'Recovery isn’t weakness. It’s a sign of courage.'**
  String get motivationMessage8;

  /// No description provided for @motivationMessage9.
  ///
  /// In en, this message translates to:
  /// **'Peace in your mind is possible — and it’s worth the fight.'**
  String get motivationMessage9;

  /// No description provided for @motivationMessage10.
  ///
  /// In en, this message translates to:
  /// **'Every day clean is a victory no one can take from you.'**
  String get motivationMessage10;

  /// No description provided for @totalAttempts.
  ///
  /// In en, this message translates to:
  /// **'Total attempts'**
  String get totalAttempts;

  /// No description provided for @averageAttemptTime.
  ///
  /// In en, this message translates to:
  /// **'Average attempt time'**
  String get averageAttemptTime;

  /// No description provided for @noFapStatus.
  ///
  /// In en, this message translates to:
  /// **'No Fap Status'**
  String get noFapStatus;

  /// No description provided for @noSmokingStatus.
  ///
  /// In en, this message translates to:
  /// **'No Smoking Status'**
  String get noSmokingStatus;

  /// No description provided for @noAlcoholStatus.
  ///
  /// In en, this message translates to:
  /// **'No Alcohol Status'**
  String get noAlcoholStatus;

  /// No description provided for @noSweetStatus.
  ///
  /// In en, this message translates to:
  /// **'No Sweet Status'**
  String get noSweetStatus;

  /// No description provided for @timesOfTrials.
  ///
  /// In en, this message translates to:
  /// **'Times of trials'**
  String get timesOfTrials;

  /// No description provided for @totalNumberOfAttempts.
  ///
  /// In en, this message translates to:
  /// **'Total number of attempts'**
  String get totalNumberOfAttempts;

  /// No description provided for @longestAttemptTime.
  ///
  /// In en, this message translates to:
  /// **'Longest attempt time'**
  String get longestAttemptTime;

  /// No description provided for @isAttemptActive.
  ///
  /// In en, this message translates to:
  /// **'Is attempt active?'**
  String get isAttemptActive;

  /// No description provided for @currentDuration.
  ///
  /// In en, this message translates to:
  /// **'Current duration'**
  String get currentDuration;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get statusActive;

  /// No description provided for @statusNotActive.
  ///
  /// In en, this message translates to:
  /// **'not active'**
  String get statusNotActive;

  /// No description provided for @drawerDailyChallenges.
  ///
  /// In en, this message translates to:
  /// **'Daily challenges'**
  String get drawerDailyChallenges;

  /// No description provided for @dailyTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily tasks'**
  String get dailyTaskTitle;

  /// No description provided for @dailyTaskStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Current daily task status'**
  String get dailyTaskStatusTitle;

  /// No description provided for @dailyTaskListTab.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get dailyTaskListTab;

  /// No description provided for @dailyTaskTaskTab.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get dailyTaskTaskTab;

  /// No description provided for @dailyTaskCalendarTab.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get dailyTaskCalendarTab;

  /// No description provided for @dailyTaskHydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get dailyTaskHydration;

  /// No description provided for @dailyTaskWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get dailyTaskWorkout;

  /// No description provided for @dailyTaskMeditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get dailyTaskMeditation;

  /// No description provided for @dailyTaskLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get dailyTaskLearning;

  /// No description provided for @dailyTaskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get dailyTaskCompleted;

  /// No description provided for @dailyTaskNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Not completed'**
  String get dailyTaskNotCompleted;

  /// No description provided for @dailyTaskTotalCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks'**
  String get dailyTaskTotalCompleted;

  /// No description provided for @dailyTaskCompletedForCategory.
  ///
  /// In en, this message translates to:
  /// **'Completed in {category}'**
  String dailyTaskCompletedForCategory(Object category);

  /// No description provided for @accountDefaultUsername.
  ///
  /// In en, this message translates to:
  /// **'Clean Path user'**
  String get accountDefaultUsername;

  /// No description provided for @accountNoEmail.
  ///
  /// In en, this message translates to:
  /// **'No email address'**
  String get accountNoEmail;

  /// No description provided for @accountLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get accountLevelLabel;

  /// No description provided for @accountXpLabel.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get accountXpLabel;

  /// No description provided for @accountStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get accountStreakLabel;

  /// No description provided for @accountStreakValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String accountStreakValue(Object days);

  /// No description provided for @accountStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Account status'**
  String get accountStatusTitle;

  /// No description provided for @accountStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get accountStatusActive;

  /// No description provided for @accountStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get accountStatusInactive;

  /// No description provided for @accountJoinedTitle.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get accountJoinedTitle;

  /// No description provided for @accountEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get accountEditProfile;

  /// No description provided for @accountClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get accountClose;

  /// No description provided for @accountLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get accountLoading;

  /// No description provided for @accountNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get accountNoData;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
