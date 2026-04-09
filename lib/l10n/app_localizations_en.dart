// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rahal';

  @override
  String get homeGreeting => 'Ready for takeoff?';

  @override
  String homeGreetingWithName(String name) {
    return 'Ready for takeoff, $name?';
  }

  @override
  String get homeHeroTitle => 'Plan your next adventure';

  @override
  String get homeHeroSubtitle =>
      'Search inspiring places, compare ideas, and open a destination guide without leaving the home screen.';

  @override
  String get homeDestinationsTitle => 'Explore destinations';

  @override
  String get homeDestinationsSubtitle =>
      'Browse a curated set of destinations and open a quick guide for the place that matches your next trip.';

  @override
  String get homeSearchHint => 'Search destinations, countries, or keywords';

  @override
  String get homeExploreDestination => 'Open guide';

  @override
  String get homeBackToDestinations => 'Back to destinations';

  @override
  String get homeNoDestinationsTitle => 'No destinations found';

  @override
  String get homeNoDestinationsSubtitle =>
      'Try a different search term to explore more places.';

  @override
  String get homeOfficialWebsite => 'Official website';

  @override
  String get homeOfficialWebsiteHint =>
      'Use this source when you want the destination\'s official travel page.';

  @override
  String get homeOfficialSource => 'Official source';

  @override
  String get homeTravelerGuide => 'Traveler guide';

  @override
  String get homeSearchReady => 'Search-ready';

  @override
  String get seeAll => 'See all';

  @override
  String get allDestinationsTitle => 'All Destinations';

  @override
  String get popularDestinations => 'Popular';

  @override
  String get allDestinationsTab => 'All';

  @override
  String get noDestinationResults => 'No results found';

  @override
  String get destinationBestTimeTitle => 'Best Time to Visit';

  @override
  String destinationBestTimeBody(String name) {
    return 'The ideal time to explore $name is during the milder seasons when sightseeing and outdoor activities feel most comfortable.';
  }

  @override
  String get destinationCuisineTitle => 'Local Cuisine';

  @override
  String destinationCuisineBody(String name) {
    return 'Experience local flavors in $name and explore signature dishes, neighborhood favorites, and food markets.';
  }

  @override
  String get destinationStayTitle => 'Where to Stay';

  @override
  String get destinationStayBody =>
      'Choose an area close to the attractions you care about most, with good transport access and comfortable surroundings.';

  @override
  String get destinationAttractionsTitle => 'Top Attractions';

  @override
  String destinationAttractionsBody(String name) {
    return 'Start with the best-known places in $name, then leave room for local neighborhoods and hidden gems.';
  }

  @override
  String get devMenu => 'Dev Menu';

  @override
  String get mainScreens => 'Main Screens';

  @override
  String get auth => 'Auth';

  @override
  String get hotels => 'Hotels';

  @override
  String get flights => 'Flights';

  @override
  String get carRent => 'Car Rent';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get next => 'Add';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboarding1Title => 'Plan Your Trip';

  @override
  String get onboarding1Body =>
      'Create your dream trip with ease. Choose a destination, find the perfect place to stay, and build an itinerary that suits you.';

  @override
  String get onboarding2Title => 'Get the Best Deal';

  @override
  String get onboarding2Body =>
      'Save time and money by finding the best travel deals. Exclusive promotions and discounts to make your trip more affordable.';

  @override
  String get onboarding3Title => 'Explore Local Attractions';

  @override
  String get onboarding3Body =>
      'Discover the beauty of local places you may never have visited. Experience authentic local life in every destination.';

  @override
  String get signInTitle => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to continue';

  @override
  String get signUpTitle => 'Create account';

  @override
  String get signUpSubtitle => 'Join us and start exploring';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get age => 'Age';

  @override
  String get gender => 'Gender';

  @override
  String get phone => 'Phone Number';

  @override
  String get nationalId => 'National ID';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get passwordHint => 'Min 8 chars, upper, lower, number, special';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a reset link';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent =>
      'Reset link sent! Check your inbox.\nRedirecting to sign in...';

  @override
  String get errorFillFields => 'Please fill in all fields';

  @override
  String get errorValidEmail => 'Enter a valid email';

  @override
  String get errorPasswordLength => 'Password must be at least 8 characters';

  @override
  String get errorLettersOnly => 'Letters only';

  @override
  String get errorMustBe18 => 'Must be 18+';

  @override
  String get errorRequired => 'Required';

  @override
  String get errorValidPhone => 'Enter a valid phone number (7-15 digits)';

  @override
  String get errorPasswordUppercase => 'At least 1 uppercase letter';

  @override
  String get errorPasswordLowercase => 'At least 1 lowercase letter';

  @override
  String get errorPasswordNumber => 'At least 1 number';

  @override
  String get errorPasswordSpecial => 'At least 1 special character';

  @override
  String get errorPasswordMinLength => 'At least 8 characters';

  @override
  String get carRentTitle => 'Car Rent';

  @override
  String get carRentSubtitle => 'Rent a car at the best rates';

  @override
  String get carRentHint =>
      'Tap a car to select it, then fill in the details below';

  @override
  String get selected => 'Selected';

  @override
  String get showMore => 'Show more';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get selectCarFirst => '↑ Select a car from the list above';

  @override
  String get pickupLocation => 'Pickup location';

  @override
  String get dropoffLocation => 'Dropoff location';

  @override
  String get selectLocation => 'Select location';

  @override
  String get pickupDateTime => 'Pickup date & time';

  @override
  String get dropoffDateTime => 'Dropoff date & time';

  @override
  String get selectDateTime => 'Select date & time';

  @override
  String totalDays(int days) {
    return 'Total: $days day(s)';
  }

  @override
  String get privateDriver => 'Private driver';

  @override
  String get privateDriverExtra => 'Extra ﷼100/day';

  @override
  String carRentalDays(int days) {
    return 'Car rental ($days days)';
  }

  @override
  String get total => 'Total';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get bookingConfirmed => 'Booking confirmed! 🎉';

  @override
  String get bookingFailed => 'Booking failed';

  @override
  String get selectCarError => 'Please select a car first';

  @override
  String get selectLocationsError =>
      'Please select pickup and dropoff locations';

  @override
  String get selectDatesError => 'Please select pickup and dropoff date & time';

  @override
  String get dropoffBeforePickup => 'Dropoff must be after pickup';

  @override
  String get signInFirst => 'Please sign in first';

  @override
  String get perDay => 'Per day';

  @override
  String get perWeek => 'Per week';

  @override
  String get vatIncluded => '*The prices are inclusive of VAT';

  @override
  String get noCarAvailable => 'No cars available';

  @override
  String get seats => 'Seats';

  @override
  String get bags => 'Bags';

  @override
  String get unableToConnect => 'Unable to connect';

  @override
  String get checkConnectionRetry =>
      'Please check your connection and try again';

  @override
  String get retry => 'Retry';

  @override
  String get searchStays => 'Search Stays';

  @override
  String get overOneMillion => 'Over 1M properties worldwide';

  @override
  String get destination => 'Destination';

  @override
  String get entireCountry => 'Entire country';

  @override
  String get cityOnly => 'City only';

  @override
  String get whereToQuestion => 'Where to?';

  @override
  String get dates => 'Dates';

  @override
  String get checkIn => 'Check in';

  @override
  String get checkOut => 'Check out';

  @override
  String get guests => 'Guests';

  @override
  String get searchProperties => 'Search Properties';

  @override
  String nights(int count) {
    return '$count night(s)';
  }

  @override
  String get room => 'Room';

  @override
  String get adults => 'Adults';

  @override
  String get children => 'Children';

  @override
  String get addAnotherRoom => 'Add another room';

  @override
  String get done => 'Done';

  @override
  String get remove => 'Remove';

  @override
  String get maxGuestsPerRoom =>
      'The maximum number of guests allowed per room is 8.';

  @override
  String propertiesFound(int count, String destination) {
    return '$count properties found in $destination';
  }

  @override
  String get sortBy => 'Sort by';

  @override
  String get filter => 'Filter';

  @override
  String get propertyRating => 'Property Rating';

  @override
  String get view => 'View';

  @override
  String get clearAll => 'Clear all';

  @override
  String get apply => 'Apply';

  @override
  String get noPropertiesMatch => 'No properties match your filters';

  @override
  String get searchByHotelName => 'Search by hotel name';

  @override
  String get priceLowToHigh => 'Price: Low to High';

  @override
  String get priceHighToLow => 'Price: High to Low';

  @override
  String get rating => 'Rating';

  @override
  String get totalPriceOneNight => 'Total price for 1 night (including taxes)';

  @override
  String get yourStay => 'Your Stay';

  @override
  String get views => 'Views';

  @override
  String get rooms => 'Rooms';

  @override
  String get roomsAndGuests => 'Rooms & Guests';

  @override
  String get numberOfRooms => 'Number of rooms';

  @override
  String get bookNow => 'Book Now';

  @override
  String get perNight => '/ night';

  @override
  String totalNightsRooms(int total, int nights, int rooms) {
    return 'SAR $total total ($nights nights, $rooms room(s))';
  }

  @override
  String get guestDetails => 'Guest details';

  @override
  String get guest => 'Guest';

  @override
  String get you => 'You';

  @override
  String get fullName => 'Full name';

  @override
  String get address => 'Address';

  @override
  String saveGuest(int number) {
    return 'Save Guest $number';
  }

  @override
  String get fillGuestDetails =>
      'Please fill in details for all remaining guests';

  @override
  String get hotelBookedSuccess => 'Hotel booked successfully! 🏨';

  @override
  String get hotelSeeReviews => 'See reviews';

  @override
  String get hotelRatingExceptional => 'Exceptional';

  @override
  String get hotelRatingExcellent => 'Excellent';

  @override
  String get hotelRatingVeryGood => 'Very Good';

  @override
  String get hotelRatingGood => 'Good';

  @override
  String get hotelRatingStandard => 'Standard';

  @override
  String get hotelViewSea => 'Sea view';

  @override
  String get hotelViewPool => 'Pool view';

  @override
  String get hotelViewGarden => 'Garden view';

  @override
  String get hotelViewCity => 'City view';

  @override
  String get hotelViewMountain => 'Mountain view';

  @override
  String get hotelViewRiver => 'River view';

  @override
  String get hotelViewLake => 'Lake view';

  @override
  String get hotelViewHarbor => 'Harbor view';

  @override
  String get viewSummary => 'View summary';

  @override
  String get hideSummary => 'Hide summary';

  @override
  String get checkInLabel => 'Check-in';

  @override
  String get checkOutLabel => 'Check-out';

  @override
  String get nightsLabel => 'Nights';

  @override
  String get roomsLabel => 'Rooms';

  @override
  String get guestsLabel => 'Guests';

  @override
  String get pricePerNight => 'Price per night';

  @override
  String get searchFlights => 'Search Flights';

  @override
  String get oneWay => 'One-way';

  @override
  String get roundTrip => 'Round trip';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get departure => 'Departure';

  @override
  String get returnDate => 'Return';

  @override
  String get passengersAndClass => 'Passengers & Class';

  @override
  String get passengers => 'Passengers';

  @override
  String get age12Plus => 'Age 12+';

  @override
  String get age211 => 'Age 2-11';

  @override
  String get underTwo => 'Under 2';

  @override
  String get infants => 'Infants';

  @override
  String get cabinClass => 'Cabin Class';

  @override
  String get selectDepartureCity => 'Select Departure City';

  @override
  String get selectArrivalCity => 'Select Arrival City';

  @override
  String get passenger => 'Passenger';

  @override
  String get travellerDetails => 'Traveller details';

  @override
  String get nationality => 'Nationality';

  @override
  String get passportNumber => 'Passport number';

  @override
  String get passportExpiry => 'Passport expiry date';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get travelDocument => 'Travel document';

  @override
  String get contactDetails => 'Contact details';

  @override
  String savePassenger(int number) {
    return 'Save Passenger $number';
  }

  @override
  String confirmBookings(int count) {
    return 'Confirm $count Bookings';
  }

  @override
  String get fillPassengerDetails =>
      'Please fill in details for all remaining passengers';

  @override
  String get flightBookedSuccess => 'Flight booked successfully! ✈️';

  @override
  String get someBookingsFailed => 'Some bookings failed. Please try again.';

  @override
  String get reviewTrip => 'Review your trip';

  @override
  String get flightDetails => 'Flight Details';

  @override
  String get priceSummary => 'Price Summary';

  @override
  String get baseFare => 'Base fare';

  @override
  String get taxesAndFees => 'Taxes & fees';

  @override
  String get included => 'Included';

  @override
  String get checkedBaggage => 'Checked Baggage';

  @override
  String get checkedBaggageIncluded =>
      'This flight includes checked baggage at no extra cost.';

  @override
  String get noBaggageIncluded =>
      'This flight does not include checked baggage. Additional fees may apply.';

  @override
  String get continue_ => 'Continue';

  @override
  String get totalPrice => 'Total price';

  @override
  String get class_ => 'Class';

  @override
  String get tripType => 'Trip Type';

  @override
  String get airline => 'Airline';

  @override
  String get duration => 'Duration';

  @override
  String get stops => 'Stops';

  @override
  String get pricePerPerson => 'Price per person';

  @override
  String get outboundFlight => 'Outbound Flight';

  @override
  String get returnFlight => 'Return Flight';

  @override
  String get noFlightsFound => 'No flights found';

  @override
  String get tryDifferentDates => 'Try different dates or cities';

  @override
  String get selectCitiesError => 'Please select departure and arrival cities';

  @override
  String get selectReturnDate => 'Please select a return date';

  @override
  String get errorPassport => '6-9 letters/numbers only';

  @override
  String get errorPhone => '7-15 digits only';

  @override
  String get pleaseFixErrors => 'Please fix the errors above';

  @override
  String get selectDate => 'Select date';

  @override
  String get viewSummaryFlight => 'View summary';

  @override
  String get hideSummaryFlight => 'Hide summary';
}
