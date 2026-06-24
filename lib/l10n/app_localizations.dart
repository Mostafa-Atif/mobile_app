import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Rahal'**
  String get appTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Ready for takeoff?'**
  String get homeGreeting;

  /// No description provided for @homeGreetingWithName.
  ///
  /// In en, this message translates to:
  /// **'Ready for takeoff, {name}?'**
  String homeGreetingWithName(String name);

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan your next adventure'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search inspiring places, compare ideas, and open a destination guide without leaving the home screen.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeDestinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore destinations'**
  String get homeDestinationsTitle;

  /// No description provided for @homeDestinationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse a curated set of destinations and open a quick guide for the place that matches your next trip.'**
  String get homeDestinationsSubtitle;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search destinations, countries, or keywords'**
  String get homeSearchHint;

  /// No description provided for @homeExploreDestination.
  ///
  /// In en, this message translates to:
  /// **'Open guide'**
  String get homeExploreDestination;

  /// No description provided for @homeBackToDestinations.
  ///
  /// In en, this message translates to:
  /// **'Back to destinations'**
  String get homeBackToDestinations;

  /// No description provided for @homeNoDestinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No destinations found'**
  String get homeNoDestinationsTitle;

  /// No description provided for @homeNoDestinationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term to explore more places.'**
  String get homeNoDestinationsSubtitle;

  /// No description provided for @homeOfficialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get homeOfficialWebsite;

  /// No description provided for @homeOfficialWebsiteHint.
  ///
  /// In en, this message translates to:
  /// **'Use this source when you want the destination\'s official travel page.'**
  String get homeOfficialWebsiteHint;

  /// No description provided for @homeOfficialSource.
  ///
  /// In en, this message translates to:
  /// **'Official source'**
  String get homeOfficialSource;

  /// No description provided for @homeTravelerGuide.
  ///
  /// In en, this message translates to:
  /// **'Traveler guide'**
  String get homeTravelerGuide;

  /// No description provided for @homeSearchReady.
  ///
  /// In en, this message translates to:
  /// **'Search-ready'**
  String get homeSearchReady;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @allDestinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'All Destinations'**
  String get allDestinationsTitle;

  /// No description provided for @popularDestinations.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularDestinations;

  /// No description provided for @allDestinationsTab.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allDestinationsTab;

  /// No description provided for @noDestinationResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noDestinationResults;

  /// No description provided for @destinationBestTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Best Time to Visit'**
  String get destinationBestTimeTitle;

  /// No description provided for @destinationBestTimeBody.
  ///
  /// In en, this message translates to:
  /// **'The ideal time to explore {name} is during the milder seasons when sightseeing and outdoor activities feel most comfortable.'**
  String destinationBestTimeBody(String name);

  /// No description provided for @destinationCuisineTitle.
  ///
  /// In en, this message translates to:
  /// **'Local Cuisine'**
  String get destinationCuisineTitle;

  /// No description provided for @destinationCuisineBody.
  ///
  /// In en, this message translates to:
  /// **'Experience local flavors in {name} and explore signature dishes, neighborhood favorites, and food markets.'**
  String destinationCuisineBody(String name);

  /// No description provided for @destinationStayTitle.
  ///
  /// In en, this message translates to:
  /// **'Where to Stay'**
  String get destinationStayTitle;

  /// No description provided for @destinationStayBody.
  ///
  /// In en, this message translates to:
  /// **'Choose an area close to the attractions you care about most, with good transport access and comfortable surroundings.'**
  String get destinationStayBody;

  /// No description provided for @destinationAttractionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Attractions'**
  String get destinationAttractionsTitle;

  /// No description provided for @destinationAttractionsBody.
  ///
  /// In en, this message translates to:
  /// **'Start with the best-known places in {name}, then leave room for local neighborhoods and hidden gems.'**
  String destinationAttractionsBody(String name);

  /// No description provided for @devMenu.
  ///
  /// In en, this message translates to:
  /// **'Dev Menu'**
  String get devMenu;

  /// No description provided for @mainScreens.
  ///
  /// In en, this message translates to:
  /// **'Main Screens'**
  String get mainScreens;

  /// No description provided for @auth.
  ///
  /// In en, this message translates to:
  /// **'Auth'**
  String get auth;

  /// No description provided for @hotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get hotels;

  /// No description provided for @flights.
  ///
  /// In en, this message translates to:
  /// **'Flights'**
  String get flights;

  /// No description provided for @carRent.
  ///
  /// In en, this message translates to:
  /// **'Car Rent'**
  String get carRent;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Trip'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Create your dream trip with ease. Choose a destination, find the perfect place to stay, and build an itinerary that suits you.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Get the Best Deal'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Save time and money by finding the best travel deals. Exclusive promotions and discounts to make your trip more affordable.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Explore Local Attractions'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Discover the beauty of local places you may never have visited. Experience authentic local life in every destination.'**
  String get onboarding3Body;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInSubtitle;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us and start exploring'**
  String get signUpSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Min 8 chars, upper, lower, number, special'**
  String get passwordHint;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent! Check your inbox.\nRedirecting to sign in...'**
  String get resetLinkSent;

  /// No description provided for @errorFillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get errorFillFields;

  /// No description provided for @errorValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get errorValidEmail;

  /// No description provided for @errorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get errorPasswordLength;

  /// No description provided for @errorLettersOnly.
  ///
  /// In en, this message translates to:
  /// **'Letters only'**
  String get errorLettersOnly;

  /// No description provided for @errorMustBe18.
  ///
  /// In en, this message translates to:
  /// **'Must be 18+'**
  String get errorMustBe18;

  /// No description provided for @errorRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get errorRequired;

  /// No description provided for @errorValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number (7-15 digits)'**
  String get errorValidPhone;

  /// No description provided for @errorPasswordUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least 1 uppercase letter'**
  String get errorPasswordUppercase;

  /// No description provided for @errorPasswordLowercase.
  ///
  /// In en, this message translates to:
  /// **'At least 1 lowercase letter'**
  String get errorPasswordLowercase;

  /// No description provided for @errorPasswordNumber.
  ///
  /// In en, this message translates to:
  /// **'At least 1 number'**
  String get errorPasswordNumber;

  /// No description provided for @errorPasswordSpecial.
  ///
  /// In en, this message translates to:
  /// **'At least 1 special character'**
  String get errorPasswordSpecial;

  /// No description provided for @errorPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get errorPasswordMinLength;

  /// No description provided for @carRentTitle.
  ///
  /// In en, this message translates to:
  /// **'Car Rent'**
  String get carRentTitle;

  /// No description provided for @carRentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rent a car at the best rates'**
  String get carRentSubtitle;

  /// No description provided for @carRentHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a car to select it, then fill in the details below'**
  String get carRentHint;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @selectCarFirst.
  ///
  /// In en, this message translates to:
  /// **'↑ Select a car from the list above'**
  String get selectCarFirst;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup location'**
  String get pickupLocation;

  /// No description provided for @dropoffLocation.
  ///
  /// In en, this message translates to:
  /// **'Dropoff location'**
  String get dropoffLocation;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get selectLocation;

  /// No description provided for @pickupDateTime.
  ///
  /// In en, this message translates to:
  /// **'Pickup date & time'**
  String get pickupDateTime;

  /// No description provided for @dropoffDateTime.
  ///
  /// In en, this message translates to:
  /// **'Dropoff date & time'**
  String get dropoffDateTime;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get selectDateTime;

  /// No description provided for @totalDays.
  ///
  /// In en, this message translates to:
  /// **'Total: {days} day(s)'**
  String totalDays(int days);

  /// No description provided for @privateDriver.
  ///
  /// In en, this message translates to:
  /// **'Private driver'**
  String get privateDriver;

  /// No description provided for @privateDriverExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra ﷼100/day'**
  String get privateDriverExtra;

  /// No description provided for @carRentalDays.
  ///
  /// In en, this message translates to:
  /// **'Car rental ({days} days)'**
  String carRentalDays(int days);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @proceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed To Payment'**
  String get proceedToPayment;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed! 🎉'**
  String get bookingConfirmed;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed'**
  String get bookingFailed;

  /// No description provided for @selectCarError.
  ///
  /// In en, this message translates to:
  /// **'Please select a car first'**
  String get selectCarError;

  /// No description provided for @selectLocationsError.
  ///
  /// In en, this message translates to:
  /// **'Please select pickup and dropoff locations'**
  String get selectLocationsError;

  /// No description provided for @selectDatesError.
  ///
  /// In en, this message translates to:
  /// **'Please select pickup and dropoff date & time'**
  String get selectDatesError;

  /// No description provided for @dropoffBeforePickup.
  ///
  /// In en, this message translates to:
  /// **'Dropoff must be after pickup'**
  String get dropoffBeforePickup;

  /// No description provided for @signInFirst.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first'**
  String get signInFirst;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'Per day'**
  String get perDay;

  /// No description provided for @perWeek.
  ///
  /// In en, this message translates to:
  /// **'Per week'**
  String get perWeek;

  /// No description provided for @vatIncluded.
  ///
  /// In en, this message translates to:
  /// **'*The prices are inclusive of VAT'**
  String get vatIncluded;

  /// No description provided for @noCarAvailable.
  ///
  /// In en, this message translates to:
  /// **'No cars available'**
  String get noCarAvailable;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seats;

  /// No description provided for @bags.
  ///
  /// In en, this message translates to:
  /// **'Bags'**
  String get bags;

  /// No description provided for @unableToConnect.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect'**
  String get unableToConnect;

  /// No description provided for @checkConnectionRetry.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again'**
  String get checkConnectionRetry;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dateTimeAt.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String dateTimeAt(String date, String time);

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @searchStays.
  ///
  /// In en, this message translates to:
  /// **'Search Stays'**
  String get searchStays;

  /// No description provided for @overOneMillion.
  ///
  /// In en, this message translates to:
  /// **'Over 1M properties worldwide'**
  String get overOneMillion;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @entireCountry.
  ///
  /// In en, this message translates to:
  /// **'Entire country'**
  String get entireCountry;

  /// No description provided for @cityOnly.
  ///
  /// In en, this message translates to:
  /// **'City only'**
  String get cityOnly;

  /// No description provided for @whereToQuestion.
  ///
  /// In en, this message translates to:
  /// **'Where to?'**
  String get whereToQuestion;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check out'**
  String get checkOut;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @searchProperties.
  ///
  /// In en, this message translates to:
  /// **'Search Properties'**
  String get searchProperties;

  /// No description provided for @nights.
  ///
  /// In en, this message translates to:
  /// **'{count} night(s)'**
  String nights(int count);

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @adults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get adults;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @addAnotherRoom.
  ///
  /// In en, this message translates to:
  /// **'Add another room'**
  String get addAnotherRoom;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @maxGuestsPerRoom.
  ///
  /// In en, this message translates to:
  /// **'The maximum number of guests allowed per room is 4.'**
  String get maxGuestsPerRoom;

  /// No description provided for @propertiesFound.
  ///
  /// In en, this message translates to:
  /// **'{count} properties found in {destination}'**
  String propertiesFound(int count, String destination);

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @propertyRating.
  ///
  /// In en, this message translates to:
  /// **'Property Rating'**
  String get propertyRating;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @noPropertiesMatch.
  ///
  /// In en, this message translates to:
  /// **'No properties match your filters'**
  String get noPropertiesMatch;

  /// No description provided for @searchByHotelName.
  ///
  /// In en, this message translates to:
  /// **'Search by hotel name'**
  String get searchByHotelName;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @totalPriceOneNight.
  ///
  /// In en, this message translates to:
  /// **'Total price for 1 night (including taxes)'**
  String get totalPriceOneNight;

  /// No description provided for @yourStay.
  ///
  /// In en, this message translates to:
  /// **'Your Stay'**
  String get yourStay;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @roomsAndGuests.
  ///
  /// In en, this message translates to:
  /// **'Rooms & Guests'**
  String get roomsAndGuests;

  /// No description provided for @numberOfRooms.
  ///
  /// In en, this message translates to:
  /// **'Number of rooms'**
  String get numberOfRooms;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @perNight.
  ///
  /// In en, this message translates to:
  /// **'/ night'**
  String get perNight;

  /// No description provided for @totalNightsRooms.
  ///
  /// In en, this message translates to:
  /// **'SAR {total} total ({nights} nights, {rooms} room(s))'**
  String totalNightsRooms(int total, int nights, int rooms);

  /// No description provided for @guestDetails.
  ///
  /// In en, this message translates to:
  /// **'Guest details'**
  String get guestDetails;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @saveGuest.
  ///
  /// In en, this message translates to:
  /// **'Save Guest {number}'**
  String saveGuest(int number);

  /// No description provided for @fillGuestDetails.
  ///
  /// In en, this message translates to:
  /// **'Please fill in details for all remaining guests'**
  String get fillGuestDetails;

  /// No description provided for @hotelBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Hotel booked successfully! 🏨'**
  String get hotelBookedSuccess;

  /// No description provided for @hotelSeeReviews.
  ///
  /// In en, this message translates to:
  /// **'See reviews'**
  String get hotelSeeReviews;

  /// No description provided for @hotelRatingExceptional.
  ///
  /// In en, this message translates to:
  /// **'Exceptional'**
  String get hotelRatingExceptional;

  /// No description provided for @hotelRatingExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get hotelRatingExcellent;

  /// No description provided for @hotelRatingVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get hotelRatingVeryGood;

  /// No description provided for @hotelRatingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get hotelRatingGood;

  /// No description provided for @hotelRatingStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get hotelRatingStandard;

  /// No description provided for @hotelViewSea.
  ///
  /// In en, this message translates to:
  /// **'Sea view'**
  String get hotelViewSea;

  /// No description provided for @hotelViewPool.
  ///
  /// In en, this message translates to:
  /// **'Pool view'**
  String get hotelViewPool;

  /// No description provided for @hotelViewGarden.
  ///
  /// In en, this message translates to:
  /// **'Garden view'**
  String get hotelViewGarden;

  /// No description provided for @hotelViewCity.
  ///
  /// In en, this message translates to:
  /// **'City view'**
  String get hotelViewCity;

  /// No description provided for @hotelViewMountain.
  ///
  /// In en, this message translates to:
  /// **'Mountain view'**
  String get hotelViewMountain;

  /// No description provided for @hotelViewRiver.
  ///
  /// In en, this message translates to:
  /// **'River view'**
  String get hotelViewRiver;

  /// No description provided for @hotelViewLake.
  ///
  /// In en, this message translates to:
  /// **'Lake view'**
  String get hotelViewLake;

  /// No description provided for @hotelViewHarbor.
  ///
  /// In en, this message translates to:
  /// **'Harbor view'**
  String get hotelViewHarbor;

  /// No description provided for @viewSummary.
  ///
  /// In en, this message translates to:
  /// **'View summary'**
  String get viewSummary;

  /// No description provided for @hideSummary.
  ///
  /// In en, this message translates to:
  /// **'Hide summary'**
  String get hideSummary;

  /// No description provided for @checkInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkInLabel;

  /// No description provided for @checkOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOutLabel;

  /// No description provided for @nightsLabel.
  ///
  /// In en, this message translates to:
  /// **'Nights'**
  String get nightsLabel;

  /// No description provided for @roomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get roomsLabel;

  /// No description provided for @guestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guestsLabel;

  /// No description provided for @pricePerNight.
  ///
  /// In en, this message translates to:
  /// **'Price per night'**
  String get pricePerNight;

  /// No description provided for @searchFlights.
  ///
  /// In en, this message translates to:
  /// **'Search Flights'**
  String get searchFlights;

  /// No description provided for @oneWay.
  ///
  /// In en, this message translates to:
  /// **'One-way'**
  String get oneWay;

  /// No description provided for @roundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round trip'**
  String get roundTrip;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @returnDate.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnDate;

  /// No description provided for @passengersAndClass.
  ///
  /// In en, this message translates to:
  /// **'Passengers & Class'**
  String get passengersAndClass;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @age12Plus.
  ///
  /// In en, this message translates to:
  /// **'Age 12+'**
  String get age12Plus;

  /// No description provided for @age211.
  ///
  /// In en, this message translates to:
  /// **'Age 2-11'**
  String get age211;

  /// No description provided for @underTwo.
  ///
  /// In en, this message translates to:
  /// **'Under 2'**
  String get underTwo;

  /// No description provided for @infants.
  ///
  /// In en, this message translates to:
  /// **'Infants'**
  String get infants;

  /// No description provided for @cabinClass.
  ///
  /// In en, this message translates to:
  /// **'Cabin Class'**
  String get cabinClass;

  /// No description provided for @selectDepartureCity.
  ///
  /// In en, this message translates to:
  /// **'Select Departure City'**
  String get selectDepartureCity;

  /// No description provided for @selectArrivalCity.
  ///
  /// In en, this message translates to:
  /// **'Select Arrival City'**
  String get selectArrivalCity;

  /// No description provided for @passenger.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get passenger;

  /// No description provided for @travellerDetails.
  ///
  /// In en, this message translates to:
  /// **'Traveller details'**
  String get travellerDetails;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @passportNumber.
  ///
  /// In en, this message translates to:
  /// **'Passport number'**
  String get passportNumber;

  /// No description provided for @passportExpiry.
  ///
  /// In en, this message translates to:
  /// **'Passport expiry date'**
  String get passportExpiry;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @travelDocument.
  ///
  /// In en, this message translates to:
  /// **'Travel document'**
  String get travelDocument;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get contactDetails;

  /// No description provided for @savePassenger.
  ///
  /// In en, this message translates to:
  /// **'Save Passenger {number}'**
  String savePassenger(int number);

  /// No description provided for @confirmBookings.
  ///
  /// In en, this message translates to:
  /// **'Confirm {count} Bookings'**
  String confirmBookings(int count);

  /// No description provided for @fillPassengerDetails.
  ///
  /// In en, this message translates to:
  /// **'Please fill in details for all remaining passengers'**
  String get fillPassengerDetails;

  /// No description provided for @flightBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Flight booked successfully! ✈️'**
  String get flightBookedSuccess;

  /// No description provided for @someBookingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Some bookings failed. Please try again.'**
  String get someBookingsFailed;

  /// No description provided for @reviewTrip.
  ///
  /// In en, this message translates to:
  /// **'Review your trip'**
  String get reviewTrip;

  /// No description provided for @flightDetails.
  ///
  /// In en, this message translates to:
  /// **'Flight Details'**
  String get flightDetails;

  /// No description provided for @priceSummary.
  ///
  /// In en, this message translates to:
  /// **'Price Summary'**
  String get priceSummary;

  /// No description provided for @baseFare.
  ///
  /// In en, this message translates to:
  /// **'Base fare'**
  String get baseFare;

  /// No description provided for @taxesAndFees.
  ///
  /// In en, this message translates to:
  /// **'Taxes & fees'**
  String get taxesAndFees;

  /// No description provided for @included.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get included;

  /// No description provided for @checkedBaggage.
  ///
  /// In en, this message translates to:
  /// **'Checked Baggage'**
  String get checkedBaggage;

  /// No description provided for @checkedBaggageIncluded.
  ///
  /// In en, this message translates to:
  /// **'This flight includes checked baggage at no extra cost.'**
  String get checkedBaggageIncluded;

  /// No description provided for @noBaggageIncluded.
  ///
  /// In en, this message translates to:
  /// **'This flight does not include checked baggage. Additional fees may apply.'**
  String get noBaggageIncluded;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total price'**
  String get totalPrice;

  /// No description provided for @class_.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get class_;

  /// No description provided for @tripType.
  ///
  /// In en, this message translates to:
  /// **'Trip Type'**
  String get tripType;

  /// No description provided for @airline.
  ///
  /// In en, this message translates to:
  /// **'Airline'**
  String get airline;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @pricePerPerson.
  ///
  /// In en, this message translates to:
  /// **'Price per person'**
  String get pricePerPerson;

  /// No description provided for @outboundFlight.
  ///
  /// In en, this message translates to:
  /// **'Outbound Flight'**
  String get outboundFlight;

  /// No description provided for @returnFlight.
  ///
  /// In en, this message translates to:
  /// **'Return Flight'**
  String get returnFlight;

  /// No description provided for @noFlightsFound.
  ///
  /// In en, this message translates to:
  /// **'No flights found'**
  String get noFlightsFound;

  /// No description provided for @tryDifferentDates.
  ///
  /// In en, this message translates to:
  /// **'Try different dates or cities'**
  String get tryDifferentDates;

  /// No description provided for @selectCitiesError.
  ///
  /// In en, this message translates to:
  /// **'Please select departure and arrival cities'**
  String get selectCitiesError;

  /// No description provided for @selectReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a return date'**
  String get selectReturnDate;

  /// No description provided for @errorPassport.
  ///
  /// In en, this message translates to:
  /// **'6-9 letters/numbers only'**
  String get errorPassport;

  /// No description provided for @errorPhone.
  ///
  /// In en, this message translates to:
  /// **'7-15 digits only'**
  String get errorPhone;

  /// No description provided for @pleaseFixErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors above'**
  String get pleaseFixErrors;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @viewSummaryFlight.
  ///
  /// In en, this message translates to:
  /// **'View summary'**
  String get viewSummaryFlight;

  /// No description provided for @hideSummaryFlight.
  ///
  /// In en, this message translates to:
  /// **'Hide summary'**
  String get hideSummaryFlight;

  /// No description provided for @promoCode.
  ///
  /// In en, this message translates to:
  /// **'Promo Code'**
  String get promoCode;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discountWithCode.
  ///
  /// In en, this message translates to:
  /// **'Discount ({code})'**
  String discountWithCode(String code);

  /// No description provided for @invalidPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid promo code'**
  String get invalidPromoCode;

  /// No description provided for @promoValidateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not validate code. Try again.'**
  String get promoValidateFailed;

  /// No description provided for @userDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get userDashboardTitle;

  /// No description provided for @userDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All your travel bookings in one place'**
  String get userDashboardSubtitle;

  /// No description provided for @userDashboardTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get userDashboardTotal;

  /// No description provided for @userDashboardConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get userDashboardConfirmed;

  /// No description provided for @userDashboardCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get userDashboardCompleted;

  /// No description provided for @userDashboardPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get userDashboardPending;

  /// No description provided for @userDashboardAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get userDashboardAll;

  /// No description provided for @userDashboardFlights.
  ///
  /// In en, this message translates to:
  /// **'Flights'**
  String get userDashboardFlights;

  /// No description provided for @userDashboardHotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get userDashboardHotels;

  /// No description provided for @userDashboardCars.
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get userDashboardCars;

  /// No description provided for @userDashboardFlight.
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get userDashboardFlight;

  /// No description provided for @userDashboardHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get userDashboardHotel;

  /// No description provided for @userDashboardCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get userDashboardCar;

  /// No description provided for @userDashboardCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get userDashboardCheckIn;

  /// No description provided for @userDashboardCheckOut.
  ///
  /// In en, this message translates to:
  /// **'Check out'**
  String get userDashboardCheckOut;

  /// No description provided for @userDashboardRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get userDashboardRooms;

  /// No description provided for @userDashboardGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get userDashboardGuest;

  /// No description provided for @userDashboardPickUp.
  ///
  /// In en, this message translates to:
  /// **'Pick up'**
  String get userDashboardPickUp;

  /// No description provided for @userDashboardDropOff.
  ///
  /// In en, this message translates to:
  /// **'Drop off'**
  String get userDashboardDropOff;

  /// No description provided for @userDashboardRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get userDashboardRoute;

  /// No description provided for @userDashboardDepartureDate.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get userDashboardDepartureDate;

  /// No description provided for @userDashboardReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get userDashboardReturnDate;

  /// No description provided for @userDashboardPassenger.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get userDashboardPassenger;

  /// No description provided for @userDashboardTripType.
  ///
  /// In en, this message translates to:
  /// **'Trip type'**
  String get userDashboardTripType;

  /// No description provided for @userDashboardNoBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get userDashboardNoBookings;

  /// No description provided for @userDashboardNoBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your bookings will appear here once you create one.'**
  String get userDashboardNoBookingsSubtitle;

  /// No description provided for @userDashboardLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load bookings'**
  String get userDashboardLoadError;

  /// No description provided for @adminCarBookings.
  ///
  /// In en, this message translates to:
  /// **'Car Bookings'**
  String get adminCarBookings;

  /// No description provided for @adminHotelBookings.
  ///
  /// In en, this message translates to:
  /// **'Hotel Bookings'**
  String get adminHotelBookings;

  /// No description provided for @adminFlightBookings.
  ///
  /// In en, this message translates to:
  /// **'Flight Bookings'**
  String get adminFlightBookings;

  /// No description provided for @adminCarBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and review all car rental bookings'**
  String get adminCarBookingsSubtitle;

  /// No description provided for @adminHotelBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and review all hotel bookings'**
  String get adminHotelBookingsSubtitle;

  /// No description provided for @adminFlightBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and review all flight bookings'**
  String get adminFlightBookingsSubtitle;

  /// No description provided for @adminDashboardLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load admin dashboard'**
  String get adminDashboardLoadError;

  /// No description provided for @adminNoBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings here yet'**
  String get adminNoBookings;

  /// No description provided for @adminNoBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New bookings for this section will appear here.'**
  String get adminNoBookingsSubtitle;

  /// No description provided for @adminBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get adminBookingConfirmed;

  /// No description provided for @adminBookingDeleted.
  ///
  /// In en, this message translates to:
  /// **'Booking deleted'**
  String get adminBookingDeleted;

  /// No description provided for @adminActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Action failed'**
  String get adminActionFailed;

  /// No description provided for @adminConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get adminConfirm;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutTitle;

  /// No description provided for @aboutMissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get aboutMissionLabel;

  /// No description provided for @aboutMissionBody.
  ///
  /// In en, this message translates to:
  /// **'Rahal is your companion on every journey. We believe travel should be simple, enjoyable, and accessible to everyone. That\'s why we\'ve brought everything you need into one place - from flights and hotels to car rentals - at competitive prices with an unmatched experience.'**
  String get aboutMissionBody;

  /// No description provided for @aboutOfferLabel.
  ///
  /// In en, this message translates to:
  /// **'What We Offer'**
  String get aboutOfferLabel;

  /// No description provided for @aboutContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Get In Touch'**
  String get aboutContactLabel;

  /// No description provided for @aboutHeadquarters.
  ///
  /// In en, this message translates to:
  /// **'Headquarters'**
  String get aboutHeadquarters;

  /// No description provided for @aboutHeadquartersValue.
  ///
  /// In en, this message translates to:
  /// **'Riyadh, Saudi Arabia'**
  String get aboutHeadquartersValue;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get aboutVersion;

  /// No description provided for @aboutStatsHotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get aboutStatsHotels;

  /// No description provided for @aboutStatsDestinations.
  ///
  /// In en, this message translates to:
  /// **'Destinations'**
  String get aboutStatsDestinations;

  /// No description provided for @aboutStatsTravelers.
  ///
  /// In en, this message translates to:
  /// **'Happy Travelers'**
  String get aboutStatsTravelers;

  /// No description provided for @aboutFeatureFlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flight Booking'**
  String get aboutFeatureFlightsTitle;

  /// No description provided for @aboutFeatureFlightsDesc.
  ///
  /// In en, this message translates to:
  /// **'Search and book the best flights from hundreds of airlines worldwide.'**
  String get aboutFeatureFlightsDesc;

  /// No description provided for @aboutFeatureHotelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hotel Stays'**
  String get aboutFeatureHotelsTitle;

  /// No description provided for @aboutFeatureHotelsDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose from over 1M+ hotels and apartments across the globe.'**
  String get aboutFeatureHotelsDesc;

  /// No description provided for @aboutFeatureCarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Car Rentals'**
  String get aboutFeatureCarsTitle;

  /// No description provided for @aboutFeatureCarsDesc.
  ///
  /// In en, this message translates to:
  /// **'Rent your preferred car at the best rates with an optional private driver.'**
  String get aboutFeatureCarsDesc;

  /// No description provided for @aboutFeatureSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get aboutFeatureSupportTitle;

  /// No description provided for @aboutFeatureSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Our support team is always available to assist you throughout your journey.'**
  String get aboutFeatureSupportDesc;

  /// No description provided for @menuDashboard.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get menuDashboard;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get menuAboutUs;

  /// No description provided for @menuProfileFallback.
  ///
  /// In en, this message translates to:
  /// **'Rahal User'**
  String get menuProfileFallback;

  /// No description provided for @menuNoEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get menuNoEmail;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsAppearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app mode'**
  String get settingsAppearanceSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsLight;

  /// No description provided for @settingsDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsDark;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// No description provided for @errorName.
  ///
  /// In en, this message translates to:
  /// **'Must be 2–50 letters'**
  String get errorName;

  /// No description provided for @errorAge.
  ///
  /// In en, this message translates to:
  /// **'Must be between 18 and 120'**
  String get errorAge;

  /// No description provided for @errorNationalId.
  ///
  /// In en, this message translates to:
  /// **'Must be 8–20 alphanumeric characters'**
  String get errorNationalId;

  /// No description provided for @upcomingTrip.
  ///
  /// In en, this message translates to:
  /// **'Upcoming trip'**
  String get upcomingTrip;

  /// No description provided for @specialOffers.
  ///
  /// In en, this message translates to:
  /// **'Special offers'**
  String get specialOffers;

  /// No description provided for @specialOffer.
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get specialOffer;

  /// No description provided for @offerBadge.
  ///
  /// In en, this message translates to:
  /// **'APP EXCLUSIVE'**
  String get offerBadge;

  /// No description provided for @offerWelcomeGift.
  ///
  /// In en, this message translates to:
  /// **'Your welcome gift.'**
  String get offerWelcomeGift;

  /// No description provided for @offerDiscount.
  ///
  /// In en, this message translates to:
  /// **'20% off everything.'**
  String get offerDiscount;

  /// No description provided for @offerCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get offerCodeLabel;

  /// No description provided for @offerCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied: RAHAL20'**
  String get offerCodeCopied;

  /// No description provided for @offerCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get offerCopyCode;

  /// No description provided for @paymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentTitle;

  /// No description provided for @paymentCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get paymentCreditCard;

  /// No description provided for @paymentDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit card'**
  String get paymentDebitCard;

  /// No description provided for @paymentCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get paymentCardNumber;

  /// No description provided for @paymentCardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder name'**
  String get paymentCardholderName;

  /// No description provided for @paymentCardholderHint.
  ///
  /// In en, this message translates to:
  /// **'Name on card'**
  String get paymentCardholderHint;

  /// No description provided for @paymentExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get paymentExpiry;

  /// No description provided for @paymentCvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get paymentCvv;

  /// No description provided for @paymentSaveCard.
  ///
  /// In en, this message translates to:
  /// **'Save card'**
  String get paymentSaveCard;

  /// No description provided for @paymentSaveCardSub.
  ///
  /// In en, this message translates to:
  /// **'For faster checkout next time'**
  String get paymentSaveCardSub;

  /// No description provided for @paymentSecureNote.
  ///
  /// In en, this message translates to:
  /// **'Your payment is secured'**
  String get paymentSecureNote;

  /// No description provided for @paymentErrorCardNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your card number'**
  String get paymentErrorCardNumberRequired;

  /// No description provided for @paymentErrorCardNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid card number'**
  String get paymentErrorCardNumberInvalid;

  /// No description provided for @paymentErrorCardholderRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the cardholder name'**
  String get paymentErrorCardholderRequired;

  /// No description provided for @paymentErrorCardholderInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name'**
  String get paymentErrorCardholderInvalid;

  /// No description provided for @paymentErrorExpiryRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the expiry date'**
  String get paymentErrorExpiryRequired;

  /// No description provided for @paymentErrorExpiryInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid expiry date'**
  String get paymentErrorExpiryInvalid;

  /// No description provided for @paymentErrorExpiryExpired.
  ///
  /// In en, this message translates to:
  /// **'This card has expired'**
  String get paymentErrorExpiryExpired;

  /// No description provided for @paymentErrorCvvRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the CVV'**
  String get paymentErrorCvvRequired;

  /// No description provided for @paymentErrorCvvInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid CVV'**
  String get paymentErrorCvvInvalid;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @airport.
  ///
  /// In en, this message translates to:
  /// **'Airport'**
  String get airport;

  /// No description provided for @downtown.
  ///
  /// In en, this message translates to:
  /// **'Downtown'**
  String get downtown;

  /// No description provided for @trainStation.
  ///
  /// In en, this message translates to:
  /// **'Train Station'**
  String get trainStation;

  /// No description provided for @hotelDistrict.
  ///
  /// In en, this message translates to:
  /// **'Hotel District'**
  String get hotelDistrict;

  /// No description provided for @shoppingDistrict.
  ///
  /// In en, this message translates to:
  /// **'Shopping District'**
  String get shoppingDistrict;

  /// No description provided for @industrialZone.
  ///
  /// In en, this message translates to:
  /// **'Industrial Zone'**
  String get industrialZone;

  /// No description provided for @airportRoad.
  ///
  /// In en, this message translates to:
  /// **'Airport Road'**
  String get airportRoad;

  /// No description provided for @dubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get dubai;

  /// No description provided for @abuDhabi.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi'**
  String get abuDhabi;

  /// No description provided for @sharjah.
  ///
  /// In en, this message translates to:
  /// **'Sharjah'**
  String get sharjah;

  /// No description provided for @riyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get riyadh;

  /// No description provided for @jeddah.
  ///
  /// In en, this message translates to:
  /// **'Jeddah'**
  String get jeddah;

  /// No description provided for @cairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cairo;

  /// No description provided for @alexandria.
  ///
  /// In en, this message translates to:
  /// **'Alexandria'**
  String get alexandria;

  /// No description provided for @giza.
  ///
  /// In en, this message translates to:
  /// **'Giza'**
  String get giza;

  /// No description provided for @aswan.
  ///
  /// In en, this message translates to:
  /// **'Aswan'**
  String get aswan;

  /// No description provided for @doha.
  ///
  /// In en, this message translates to:
  /// **'Doha'**
  String get doha;

  /// No description provided for @alRayyan.
  ///
  /// In en, this message translates to:
  /// **'Al Rayyan'**
  String get alRayyan;

  /// No description provided for @manama.
  ///
  /// In en, this message translates to:
  /// **'Manama'**
  String get manama;

  /// No description provided for @muharraq.
  ///
  /// In en, this message translates to:
  /// **'Muharraq'**
  String get muharraq;

  /// No description provided for @muscat.
  ///
  /// In en, this message translates to:
  /// **'Muscat'**
  String get muscat;

  /// No description provided for @salalah.
  ///
  /// In en, this message translates to:
  /// **'Salalah'**
  String get salalah;

  /// No description provided for @kuwaitCity.
  ///
  /// In en, this message translates to:
  /// **'Kuwait City'**
  String get kuwaitCity;

  /// No description provided for @salmiya.
  ///
  /// In en, this message translates to:
  /// **'Salmiya'**
  String get salmiya;

  /// No description provided for @amman.
  ///
  /// In en, this message translates to:
  /// **'Amman'**
  String get amman;

  /// No description provided for @zarqa.
  ///
  /// In en, this message translates to:
  /// **'Zarqa'**
  String get zarqa;

  /// No description provided for @beirut.
  ///
  /// In en, this message translates to:
  /// **'Beirut'**
  String get beirut;

  /// No description provided for @tripoli.
  ///
  /// In en, this message translates to:
  /// **'Tripoli'**
  String get tripoli;

  /// No description provided for @istanbul.
  ///
  /// In en, this message translates to:
  /// **'Istanbul'**
  String get istanbul;

  /// No description provided for @ankara.
  ///
  /// In en, this message translates to:
  /// **'Ankara'**
  String get ankara;

  /// No description provided for @izmir.
  ///
  /// In en, this message translates to:
  /// **'Izmir'**
  String get izmir;

  /// No description provided for @london.
  ///
  /// In en, this message translates to:
  /// **'London'**
  String get london;

  /// No description provided for @manchester.
  ///
  /// In en, this message translates to:
  /// **'Manchester'**
  String get manchester;

  /// No description provided for @birmingham.
  ///
  /// In en, this message translates to:
  /// **'Birmingham'**
  String get birmingham;

  /// No description provided for @paris.
  ///
  /// In en, this message translates to:
  /// **'Paris'**
  String get paris;

  /// No description provided for @lyon.
  ///
  /// In en, this message translates to:
  /// **'Lyon'**
  String get lyon;

  /// No description provided for @marseille.
  ///
  /// In en, this message translates to:
  /// **'Marseille'**
  String get marseille;

  /// No description provided for @madrid.
  ///
  /// In en, this message translates to:
  /// **'Madrid'**
  String get madrid;

  /// No description provided for @barcelona.
  ///
  /// In en, this message translates to:
  /// **'Barcelona'**
  String get barcelona;

  /// No description provided for @seville.
  ///
  /// In en, this message translates to:
  /// **'Seville'**
  String get seville;

  /// No description provided for @rome.
  ///
  /// In en, this message translates to:
  /// **'Rome'**
  String get rome;

  /// No description provided for @milan.
  ///
  /// In en, this message translates to:
  /// **'Milan'**
  String get milan;

  /// No description provided for @venice.
  ///
  /// In en, this message translates to:
  /// **'Venice'**
  String get venice;

  /// No description provided for @berlin.
  ///
  /// In en, this message translates to:
  /// **'Berlin'**
  String get berlin;

  /// No description provided for @munich.
  ///
  /// In en, this message translates to:
  /// **'Munich'**
  String get munich;

  /// No description provided for @hamburg.
  ///
  /// In en, this message translates to:
  /// **'Hamburg'**
  String get hamburg;

  /// No description provided for @tokyo.
  ///
  /// In en, this message translates to:
  /// **'Tokyo'**
  String get tokyo;

  /// No description provided for @osaka.
  ///
  /// In en, this message translates to:
  /// **'Osaka'**
  String get osaka;

  /// No description provided for @kyoto.
  ///
  /// In en, this message translates to:
  /// **'Kyoto'**
  String get kyoto;

  /// No description provided for @singapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get singapore;

  /// No description provided for @bangkok.
  ///
  /// In en, this message translates to:
  /// **'Bangkok'**
  String get bangkok;

  /// No description provided for @phuket.
  ///
  /// In en, this message translates to:
  /// **'Phuket'**
  String get phuket;

  /// No description provided for @chiangMai.
  ///
  /// In en, this message translates to:
  /// **'Chiang Mai'**
  String get chiangMai;

  /// No description provided for @delhi.
  ///
  /// In en, this message translates to:
  /// **'Delhi'**
  String get delhi;

  /// No description provided for @mumbai.
  ///
  /// In en, this message translates to:
  /// **'Mumbai'**
  String get mumbai;

  /// No description provided for @bangalore.
  ///
  /// In en, this message translates to:
  /// **'Bangalore'**
  String get bangalore;

  /// No description provided for @seoul.
  ///
  /// In en, this message translates to:
  /// **'Seoul'**
  String get seoul;

  /// No description provided for @busan.
  ///
  /// In en, this message translates to:
  /// **'Busan'**
  String get busan;

  /// No description provided for @incheon.
  ///
  /// In en, this message translates to:
  /// **'Incheon'**
  String get incheon;

  /// No description provided for @newYork.
  ///
  /// In en, this message translates to:
  /// **'New York'**
  String get newYork;

  /// No description provided for @losAngeles.
  ///
  /// In en, this message translates to:
  /// **'Los Angeles'**
  String get losAngeles;

  /// No description provided for @chicago.
  ///
  /// In en, this message translates to:
  /// **'Chicago'**
  String get chicago;

  /// No description provided for @miami.
  ///
  /// In en, this message translates to:
  /// **'Miami'**
  String get miami;

  /// No description provided for @lasVegas.
  ///
  /// In en, this message translates to:
  /// **'Las Vegas'**
  String get lasVegas;

  /// No description provided for @toronto.
  ///
  /// In en, this message translates to:
  /// **'Toronto'**
  String get toronto;

  /// No description provided for @vancouver.
  ///
  /// In en, this message translates to:
  /// **'Vancouver'**
  String get vancouver;

  /// No description provided for @montreal.
  ///
  /// In en, this message translates to:
  /// **'Montreal'**
  String get montreal;

  /// No description provided for @mexicoCity.
  ///
  /// In en, this message translates to:
  /// **'Mexico City'**
  String get mexicoCity;

  /// No description provided for @cancun.
  ///
  /// In en, this message translates to:
  /// **'Cancun'**
  String get cancun;

  /// No description provided for @playaDelCarmen.
  ///
  /// In en, this message translates to:
  /// **'Playa del Carmen'**
  String get playaDelCarmen;

  /// No description provided for @saoPaulo.
  ///
  /// In en, this message translates to:
  /// **'São Paulo'**
  String get saoPaulo;

  /// No description provided for @rioDeJaneiro.
  ///
  /// In en, this message translates to:
  /// **'Rio de Janeiro'**
  String get rioDeJaneiro;

  /// No description provided for @salvador.
  ///
  /// In en, this message translates to:
  /// **'Salvador'**
  String get salvador;

  /// No description provided for @sydney.
  ///
  /// In en, this message translates to:
  /// **'Sydney'**
  String get sydney;

  /// No description provided for @melbourne.
  ///
  /// In en, this message translates to:
  /// **'Melbourne'**
  String get melbourne;

  /// No description provided for @brisbane.
  ///
  /// In en, this message translates to:
  /// **'Brisbane'**
  String get brisbane;

  /// No description provided for @uae.
  ///
  /// In en, this message translates to:
  /// **'UAE'**
  String get uae;

  /// No description provided for @saudiArabia.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get saudiArabia;

  /// No description provided for @egypt.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get egypt;

  /// No description provided for @qatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get qatar;

  /// No description provided for @bahrain.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get bahrain;

  /// No description provided for @oman.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get oman;

  /// No description provided for @kuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get kuwait;

  /// No description provided for @jordan.
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get jordan;

  /// No description provided for @lebanon.
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get lebanon;

  /// No description provided for @turkey.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get turkey;

  /// No description provided for @unitedKingdom.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get unitedKingdom;

  /// No description provided for @france.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get france;

  /// No description provided for @spain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get spain;

  /// No description provided for @italy.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get italy;

  /// No description provided for @germany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get germany;

  /// No description provided for @japan.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get japan;

  /// No description provided for @thailand.
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get thailand;

  /// No description provided for @india.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get india;

  /// No description provided for @southKorea.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get southKorea;

  /// No description provided for @unitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get unitedStates;

  /// No description provided for @canada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get canada;

  /// No description provided for @mexico.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get mexico;

  /// No description provided for @brazil.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get brazil;

  /// No description provided for @australia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get australia;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @selectPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get selectPickupLocation;

  /// No description provided for @selectDropoffLocation.
  ///
  /// In en, this message translates to:
  /// **'Dropoff Location'**
  String get selectDropoffLocation;

  /// No description provided for @sameCityAsPickup.
  ///
  /// In en, this message translates to:
  /// **'Same city as pickup'**
  String get sameCityAsPickup;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 4'**
  String stepOf(int step);

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @yourInformation.
  ///
  /// In en, this message translates to:
  /// **'Your Information'**
  String get yourInformation;

  /// No description provided for @reviewAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review & Confirm'**
  String get reviewAndConfirm;

  /// No description provided for @pickupAndDropoff.
  ///
  /// In en, this message translates to:
  /// **'Pickup & Drop-off'**
  String get pickupAndDropoff;

  /// No description provided for @airportNotice.
  ///
  /// In en, this message translates to:
  /// **'Pickup and drop-off are always at the city airport'**
  String get airportNotice;

  /// No description provided for @pricePerDayFilter.
  ///
  /// In en, this message translates to:
  /// **'Price/day'**
  String get pricePerDayFilter;

  /// No description provided for @noCarsMatch.
  ///
  /// In en, this message translates to:
  /// **'No cars match your filters'**
  String get noCarsMatch;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get until;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @trip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get trip;

  /// No description provided for @priceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Price Breakdown'**
  String get priceBreakdown;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @total2.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get total2;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'saved'**
  String get saved;

  /// No description provided for @sortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceLow;

  /// No description provided for @sortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceHigh;

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name: A to Z'**
  String get sortNameAZ;

  /// No description provided for @sortSeatsLow.
  ///
  /// In en, this message translates to:
  /// **'Seats: Fewest First'**
  String get sortSeatsLow;

  /// No description provided for @sortSeatsHigh.
  ///
  /// In en, this message translates to:
  /// **'Seats: Most First'**
  String get sortSeatsHigh;

  /// No description provided for @cashOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Payment Only'**
  String get cashOnlyTitle;

  /// No description provided for @cashOnlyBody.
  ///
  /// In en, this message translates to:
  /// **'We currently don\'t support online payments. Please prepare to pay in cash upon receiving the car.'**
  String get cashOnlyBody;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get searchCountry;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search cities...'**
  String get searchCity;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price ↑'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price ↓'**
  String get sortPriceDesc;

  /// No description provided for @sortNameAz.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get sortNameAz;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Your Info'**
  String get info;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @bookingConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get bookingConfirmedTitle;

  /// No description provided for @bookingConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your booking is confirmed. Our team will be ready at the airport when you arrive.'**
  String get bookingConfirmedMessage;

  /// No description provided for @cashPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay at Pickup — No Card Needed'**
  String get cashPaymentTitle;

  /// No description provided for @cashPaymentBody.
  ///
  /// In en, this message translates to:
  /// **'Pay in cash when you collect your car — no online forms, no hidden fees, no hassle.'**
  String get cashPaymentBody;

  /// No description provided for @dubaiInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Dubai International Airport'**
  String get dubaiInternationalAirport;

  /// No description provided for @abuDhabiInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi International Airport'**
  String get abuDhabiInternationalAirport;

  /// No description provided for @sharjahInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Sharjah International Airport'**
  String get sharjahInternationalAirport;

  /// No description provided for @kingKhalidInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'King Khalid International Airport'**
  String get kingKhalidInternationalAirport;

  /// No description provided for @kingAbdulazizInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'King Abdulaziz International Airport'**
  String get kingAbdulazizInternationalAirport;

  /// No description provided for @cairoInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Cairo International Airport'**
  String get cairoInternationalAirport;

  /// No description provided for @elNouzhaAirport.
  ///
  /// In en, this message translates to:
  /// **'El Nouzha Airport'**
  String get elNouzhaAirport;

  /// No description provided for @hamadInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Hamad International Airport'**
  String get hamadInternationalAirport;

  /// No description provided for @bahrainInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Bahrain International Airport'**
  String get bahrainInternationalAirport;

  /// No description provided for @muscatInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Muscat International Airport'**
  String get muscatInternationalAirport;

  /// No description provided for @kuwaitInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Kuwait International Airport'**
  String get kuwaitInternationalAirport;

  /// No description provided for @queenAliaInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Queen Alia International Airport'**
  String get queenAliaInternationalAirport;

  /// No description provided for @beirutRaficHaririInternational.
  ///
  /// In en, this message translates to:
  /// **'Beirut–Rafic Hariri International'**
  String get beirutRaficHaririInternational;

  /// No description provided for @istanbulAirport.
  ///
  /// In en, this message translates to:
  /// **'Istanbul Airport'**
  String get istanbulAirport;

  /// No description provided for @sabihaCokcentInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Sabiha Gökçen International Airport'**
  String get sabihaCokcentInternationalAirport;

  /// No description provided for @adnanMenderesAirport.
  ///
  /// In en, this message translates to:
  /// **'Adnan Menderes Airport'**
  String get adnanMenderesAirport;

  /// No description provided for @ankaraEsenbogaAirport.
  ///
  /// In en, this message translates to:
  /// **'Ankara Esenboğa Airport'**
  String get ankaraEsenbogaAirport;

  /// No description provided for @heathrowAirport.
  ///
  /// In en, this message translates to:
  /// **'Heathrow Airport'**
  String get heathrowAirport;

  /// No description provided for @gatwickAirport.
  ///
  /// In en, this message translates to:
  /// **'Gatwick Airport'**
  String get gatwickAirport;

  /// No description provided for @manchesterAirport.
  ///
  /// In en, this message translates to:
  /// **'Manchester Airport'**
  String get manchesterAirport;

  /// No description provided for @charlesDeGaulleAirport.
  ///
  /// In en, this message translates to:
  /// **'Charles de Gaulle Airport'**
  String get charlesDeGaulleAirport;

  /// No description provided for @parisOrlyAirport.
  ///
  /// In en, this message translates to:
  /// **'Paris-Orly Airport'**
  String get parisOrlyAirport;

  /// No description provided for @adolfoSuarezMadridBarajasAirport.
  ///
  /// In en, this message translates to:
  /// **'Adolfo Suárez Madrid–Barajas Airport'**
  String get adolfoSuarezMadridBarajasAirport;

  /// No description provided for @barcelonaElPratAirport.
  ///
  /// In en, this message translates to:
  /// **'Barcelona–El Prat Airport'**
  String get barcelonaElPratAirport;

  /// No description provided for @leonardoDaVinciFiumicinoAirport.
  ///
  /// In en, this message translates to:
  /// **'Leonardo da Vinci–Fiumicino Airport'**
  String get leonardoDaVinciFiumicinoAirport;

  /// No description provided for @milanMalpensaAirport.
  ///
  /// In en, this message translates to:
  /// **'Milan Malpensa Airport'**
  String get milanMalpensaAirport;

  /// No description provided for @berlinBrandenburgAirport.
  ///
  /// In en, this message translates to:
  /// **'Berlin Brandenburg Airport'**
  String get berlinBrandenburgAirport;

  /// No description provided for @munichAirport.
  ///
  /// In en, this message translates to:
  /// **'Munich Airport'**
  String get munichAirport;

  /// No description provided for @hamburgAirport.
  ///
  /// In en, this message translates to:
  /// **'Hamburg Airport'**
  String get hamburgAirport;

  /// No description provided for @tokyoHanedaAirport.
  ///
  /// In en, this message translates to:
  /// **'Tokyo Haneda Airport'**
  String get tokyoHanedaAirport;

  /// No description provided for @naritaInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Narita International Airport'**
  String get naritaInternationalAirport;

  /// No description provided for @kansaiInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Kansai International Airport'**
  String get kansaiInternationalAirport;

  /// No description provided for @singaporeChangiAirport.
  ///
  /// In en, this message translates to:
  /// **'Singapore Changi Airport'**
  String get singaporeChangiAirport;

  /// No description provided for @suvarnabhumiAirport.
  ///
  /// In en, this message translates to:
  /// **'Suvarnabhumi Airport'**
  String get suvarnabhumiAirport;

  /// No description provided for @phuketInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Phuket International Airport'**
  String get phuketInternationalAirport;

  /// No description provided for @indiraGandhiInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Indira Gandhi International Airport'**
  String get indiraGandhiInternationalAirport;

  /// No description provided for @chhatrapatiShivajiInternational.
  ///
  /// In en, this message translates to:
  /// **'Chhatrapati Shivaji International'**
  String get chhatrapatiShivajiInternational;

  /// No description provided for @incheonInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Incheon International Airport'**
  String get incheonInternationalAirport;

  /// No description provided for @gimpoInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Gimpo International Airport'**
  String get gimpoInternationalAirport;

  /// No description provided for @johnFKennedyInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'John F. Kennedy International Airport'**
  String get johnFKennedyInternationalAirport;

  /// No description provided for @laGuardiaAirport.
  ///
  /// In en, this message translates to:
  /// **'LaGuardia Airport'**
  String get laGuardiaAirport;

  /// No description provided for @losAngelesInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Los Angeles International Airport'**
  String get losAngelesInternationalAirport;

  /// No description provided for @ohareInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'O\'Hare International Airport'**
  String get ohareInternationalAirport;

  /// No description provided for @miamiInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Miami International Airport'**
  String get miamiInternationalAirport;

  /// No description provided for @harryReidInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Harry Reid International Airport'**
  String get harryReidInternationalAirport;

  /// No description provided for @torontoPearsonInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Toronto Pearson International Airport'**
  String get torontoPearsonInternationalAirport;

  /// No description provided for @vancouverInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Vancouver International Airport'**
  String get vancouverInternationalAirport;

  /// No description provided for @mexicoCityInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Mexico City International Airport'**
  String get mexicoCityInternationalAirport;

  /// No description provided for @cancunInternationalAirport.
  ///
  /// In en, this message translates to:
  /// **'Cancún International Airport'**
  String get cancunInternationalAirport;

  /// No description provided for @saoPauloGuarulhosInternational.
  ///
  /// In en, this message translates to:
  /// **'São Paulo–Guarulhos International'**
  String get saoPauloGuarulhosInternational;

  /// No description provided for @rioDeJaneiroGaleaoInternational.
  ///
  /// In en, this message translates to:
  /// **'Rio de Janeiro–Galeão International'**
  String get rioDeJaneiroGaleaoInternational;

  /// No description provided for @sydneyKingsfordSmithAirport.
  ///
  /// In en, this message translates to:
  /// **'Sydney Kingsford Smith Airport'**
  String get sydneyKingsfordSmithAirport;

  /// No description provided for @melbourneAirport.
  ///
  /// In en, this message translates to:
  /// **'Melbourne Airport'**
  String get melbourneAirport;

  /// No description provided for @brisbaneAirport.
  ///
  /// In en, this message translates to:
  /// **'Brisbane Airport'**
  String get brisbaneAirport;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get all;

  /// No description provided for @economy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get economy;

  /// No description provided for @premiumEconomy.
  ///
  /// In en, this message translates to:
  /// **'Premium Economy'**
  String get premiumEconomy;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @firstClass.
  ///
  /// In en, this message translates to:
  /// **'First Class'**
  String get firstClass;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
