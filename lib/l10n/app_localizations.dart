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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PMDAP'**
  String get appName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection and try again.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @throttled.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get throttled;

  /// No description provided for @validationFailed.
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted fields.'**
  String get validationFailed;

  /// No description provided for @unknownStatus.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownStatus;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access your medical archive'**
  String get loginSubtitle;

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

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in.'**
  String get signInFailed;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get invalidCredentials;

  /// No description provided for @accountUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This account is not available. Contact support if this is unexpected.'**
  String get accountUnavailable;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'No account yet?'**
  String get noAccountYet;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register to start your medical archive'**
  String get registerSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @sex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sex;

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

  /// No description provided for @unspecified.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get unspecified;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality (2-letter code)'**
  String get nationality;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood group'**
  String get bloodGroup;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created. Please sign in.'**
  String get registrationSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the account.'**
  String get registrationFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out of PMDAP?'**
  String get logoutConfirm;

  /// No description provided for @loggedOut.
  ///
  /// In en, this message translates to:
  /// **'Signed out.'**
  String get loggedOut;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @minors.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get minors;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @accountClaim.
  ///
  /// In en, this message translates to:
  /// **'Claim an account'**
  String get accountClaim;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @digitalId.
  ///
  /// In en, this message translates to:
  /// **'Digital ID'**
  String get digitalId;

  /// No description provided for @identityState.
  ///
  /// In en, this message translates to:
  /// **'Identity status'**
  String get identityState;

  /// No description provided for @needsDateConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Documents needing date confirmation'**
  String get needsDateConfirmation;

  /// No description provided for @recentDocuments.
  ///
  /// In en, this message translates to:
  /// **'Recent documents'**
  String get recentDocuments;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @identityVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get identityVerified;

  /// No description provided for @identityUnverified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get identityUnverified;

  /// No description provided for @identityPending.
  ///
  /// In en, this message translates to:
  /// **'Pending verification'**
  String get identityPending;

  /// No description provided for @identityRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get identityRejected;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @identityTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity documents'**
  String get identityTitle;

  /// No description provided for @addIdentityDocument.
  ///
  /// In en, this message translates to:
  /// **'Add identity document'**
  String get addIdentityDocument;

  /// No description provided for @replaceIdentityDocument.
  ///
  /// In en, this message translates to:
  /// **'Replace document'**
  String get replaceIdentityDocument;

  /// No description provided for @chooseExistingImage.
  ///
  /// In en, this message translates to:
  /// **'Choose existing image'**
  String get chooseExistingImage;

  /// No description provided for @documentNumber.
  ///
  /// In en, this message translates to:
  /// **'Document number'**
  String get documentNumber;

  /// No description provided for @nationalNumber.
  ///
  /// In en, this message translates to:
  /// **'National number'**
  String get nationalNumber;

  /// No description provided for @familyNumber.
  ///
  /// In en, this message translates to:
  /// **'Family number'**
  String get familyNumber;

  /// No description provided for @issuingCountry.
  ///
  /// In en, this message translates to:
  /// **'Issuing country'**
  String get issuingCountry;

  /// No description provided for @issueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get issueDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get expiryDate;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get documentType;

  /// No description provided for @docTypeNationalCard.
  ///
  /// In en, this message translates to:
  /// **'National Card'**
  String get docTypeNationalCard;

  /// No description provided for @docTypePassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get docTypePassport;

  /// No description provided for @docTypeBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth document'**
  String get docTypeBirth;

  /// No description provided for @docTypeOtherGov.
  ///
  /// In en, this message translates to:
  /// **'Other government ID'**
  String get docTypeOtherGov;

  /// No description provided for @frontImage.
  ///
  /// In en, this message translates to:
  /// **'Front image'**
  String get frontImage;

  /// No description provided for @backImage.
  ///
  /// In en, this message translates to:
  /// **'Back image'**
  String get backImage;

  /// No description provided for @submitIdentity.
  ///
  /// In en, this message translates to:
  /// **'Submit document'**
  String get submitIdentity;

  /// No description provided for @identitySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Identity document submitted for review.'**
  String get identitySubmitted;

  /// No description provided for @verificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationStatus;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get statusVerified;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @viewImage.
  ///
  /// In en, this message translates to:
  /// **'View image'**
  String get viewImage;

  /// No description provided for @noIdentityDocuments.
  ///
  /// In en, this message translates to:
  /// **'No identity documents yet.'**
  String get noIdentityDocuments;

  /// No description provided for @replacementInfo.
  ///
  /// In en, this message translates to:
  /// **'Replacing a verified document may trigger a new verification review.'**
  String get replacementInfo;

  /// No description provided for @selectImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a front image.'**
  String get selectImageRequired;

  /// No description provided for @minorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get minorsTitle;

  /// No description provided for @addMinor.
  ///
  /// In en, this message translates to:
  /// **'Add child'**
  String get addMinor;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @father.
  ///
  /// In en, this message translates to:
  /// **'Father'**
  String get father;

  /// No description provided for @mother.
  ///
  /// In en, this message translates to:
  /// **'Mother'**
  String get mother;

  /// No description provided for @legalGuardian.
  ///
  /// In en, this message translates to:
  /// **'Legal guardian'**
  String get legalGuardian;

  /// No description provided for @minorCreated.
  ///
  /// In en, this message translates to:
  /// **'Child added. Their identity document is under review.'**
  String get minorCreated;

  /// No description provided for @minorCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add the child.'**
  String get minorCreateFailed;

  /// No description provided for @noMinors.
  ///
  /// In en, this message translates to:
  /// **'No children linked to your account.'**
  String get noMinors;

  /// No description provided for @evidenceFile.
  ///
  /// In en, this message translates to:
  /// **'Guardianship evidence file'**
  String get evidenceFile;

  /// No description provided for @evidenceType.
  ///
  /// In en, this message translates to:
  /// **'Evidence type'**
  String get evidenceType;

  /// No description provided for @guardianEvidence.
  ///
  /// In en, this message translates to:
  /// **'Guardianship evidence'**
  String get guardianEvidence;

  /// No description provided for @courtDocument.
  ///
  /// In en, this message translates to:
  /// **'Court document'**
  String get courtDocument;

  /// No description provided for @otherOfficialEvidence.
  ///
  /// In en, this message translates to:
  /// **'Other official evidence'**
  String get otherOfficialEvidence;

  /// No description provided for @minorDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get minorDocuments;

  /// No description provided for @minorArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get minorArchive;

  /// No description provided for @minorSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get minorSearch;

  /// No description provided for @guardianAccessRemoved.
  ///
  /// In en, this message translates to:
  /// **'Guardian access is no longer available for this child.'**
  String get guardianAccessRemoved;

  /// No description provided for @minorAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get minorAge;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical documents'**
  String get documentsTitle;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get uploadDocument;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose existing file'**
  String get chooseFile;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get uploading;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded.'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload the document.'**
  String get uploadFailed;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @facility.
  ///
  /// In en, this message translates to:
  /// **'Facility'**
  String get facility;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @physician.
  ///
  /// In en, this message translates to:
  /// **'Physician'**
  String get physician;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @reportDate.
  ///
  /// In en, this message translates to:
  /// **'Report date'**
  String get reportDate;

  /// No description provided for @dateVerifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Date verified'**
  String get dateVerifiedLabel;

  /// No description provided for @dateUnconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Date not confirmed'**
  String get dateUnconfirmed;

  /// No description provided for @processingStatus.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processingStatus;

  /// No description provided for @statusUploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get statusUploaded;

  /// No description provided for @statusQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get statusQueued;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @statusTextExtracted.
  ///
  /// In en, this message translates to:
  /// **'Text extracted'**
  String get statusTextExtracted;

  /// No description provided for @statusOcrRequired.
  ///
  /// In en, this message translates to:
  /// **'OCR required'**
  String get statusOcrRequired;

  /// No description provided for @statusOcrProcessing.
  ///
  /// In en, this message translates to:
  /// **'OCR processing'**
  String get statusOcrProcessing;

  /// No description provided for @statusDateProcessing.
  ///
  /// In en, this message translates to:
  /// **'Reading date'**
  String get statusDateProcessing;

  /// No description provided for @statusDateDetected.
  ///
  /// In en, this message translates to:
  /// **'Date detected'**
  String get statusDateDetected;

  /// No description provided for @statusDateNotFound.
  ///
  /// In en, this message translates to:
  /// **'Date not found'**
  String get statusDateNotFound;

  /// No description provided for @statusAwaitingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Awaiting confirmation'**
  String get statusAwaitingConfirmation;

  /// No description provided for @statusDateConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Date confirmed'**
  String get statusDateConfirmed;

  /// No description provided for @statusIndexed.
  ///
  /// In en, this message translates to:
  /// **'Indexed'**
  String get statusIndexed;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @viewFile.
  ///
  /// In en, this message translates to:
  /// **'View file'**
  String get viewFile;

  /// No description provided for @deleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get deleteDocument;

  /// No description provided for @deleteDocumentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this document from your archive?'**
  String get deleteDocumentConfirm;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Document deleted.'**
  String get deleted;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No medical documents yet.'**
  String get noDocuments;

  /// No description provided for @openFileFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the file.'**
  String get openFileFailed;

  /// No description provided for @dateCandidates.
  ///
  /// In en, this message translates to:
  /// **'Suggested dates'**
  String get dateCandidates;

  /// No description provided for @suggestedDate.
  ///
  /// In en, this message translates to:
  /// **'Suggested date'**
  String get suggestedDate;

  /// No description provided for @confirmDate.
  ///
  /// In en, this message translates to:
  /// **'Confirm date'**
  String get confirmDate;

  /// No description provided for @manualDate.
  ///
  /// In en, this message translates to:
  /// **'Enter date manually'**
  String get manualDate;

  /// No description provided for @chooseCandidate.
  ///
  /// In en, this message translates to:
  /// **'Select a suggested date'**
  String get chooseCandidate;

  /// No description provided for @dateConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Date confirmed.'**
  String get dateConfirmed;

  /// No description provided for @confirmFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not confirm the date.'**
  String get confirmFailed;

  /// No description provided for @candidateScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get candidateScore;

  /// No description provided for @pageNumber.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get pageNumber;

  /// No description provided for @ambiguousDate.
  ///
  /// In en, this message translates to:
  /// **'Ambiguous'**
  String get ambiguousDate;

  /// No description provided for @facilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilitiesTitle;

  /// No description provided for @selectFacility.
  ///
  /// In en, this message translates to:
  /// **'Select facility'**
  String get selectFacility;

  /// No description provided for @searchFacility.
  ///
  /// In en, this message translates to:
  /// **'Search facilities'**
  String get searchFacility;

  /// No description provided for @noFacilities.
  ///
  /// In en, this message translates to:
  /// **'No facilities found.'**
  String get noFacilities;

  /// No description provided for @facilityType.
  ///
  /// In en, this message translates to:
  /// **'Facility type'**
  String get facilityType;

  /// No description provided for @noneSelected.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneSelected;

  /// No description provided for @archiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveTitle;

  /// No description provided for @archiveSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get archiveSummary;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @allYears.
  ///
  /// In en, this message translates to:
  /// **'All years'**
  String get allYears;

  /// No description provided for @allMonths.
  ///
  /// In en, this message translates to:
  /// **'All months'**
  String get allMonths;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @allFacilities.
  ///
  /// In en, this message translates to:
  /// **'All facilities'**
  String get allFacilities;

  /// No description provided for @allDates.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get allDates;

  /// No description provided for @unconfirmedSection.
  ///
  /// In en, this message translates to:
  /// **'Needs date confirmation'**
  String get unconfirmedSection;

  /// No description provided for @noArchive.
  ///
  /// In en, this message translates to:
  /// **'No documents in the archive.'**
  String get noArchive;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @unconfirmedDates.
  ///
  /// In en, this message translates to:
  /// **'Unconfirmed dates'**
  String get unconfirmedDates;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search documents…'**
  String get searchHint;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get searchResults;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResults;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by document content'**
  String get searchPlaceholder;

  /// No description provided for @claimTitle.
  ///
  /// In en, this message translates to:
  /// **'Claim an account'**
  String get claimTitle;

  /// No description provided for @claimSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If you already have medical records, claim them with your Digital ID.'**
  String get claimSubtitle;

  /// No description provided for @claimDigitalId.
  ///
  /// In en, this message translates to:
  /// **'Digital ID (17 digits)'**
  String get claimDigitalId;

  /// No description provided for @claimEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get claimEmail;

  /// No description provided for @claimPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get claimPhone;

  /// No description provided for @claimFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get claimFullName;

  /// No description provided for @claimDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get claimDob;

  /// No description provided for @claimIdType.
  ///
  /// In en, this message translates to:
  /// **'Identity document type'**
  String get claimIdType;

  /// No description provided for @claimIdNumber.
  ///
  /// In en, this message translates to:
  /// **'Identity document number'**
  String get claimIdNumber;

  /// No description provided for @claimSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit claim'**
  String get claimSubmit;

  /// No description provided for @claimSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your claim was submitted. It will be reviewed.'**
  String get claimSubmitted;

  /// No description provided for @claimFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not submit the claim.'**
  String get claimFailed;

  /// No description provided for @claimPending.
  ///
  /// In en, this message translates to:
  /// **'Claim pending review'**
  String get claimPending;

  /// No description provided for @healthCheck.
  ///
  /// In en, this message translates to:
  /// **'Connectivity check'**
  String get healthCheck;

  /// No description provided for @healthReachable.
  ///
  /// In en, this message translates to:
  /// **'Server reachable'**
  String get healthReachable;

  /// No description provided for @healthUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Server unreachable'**
  String get healthUnreachable;

  /// No description provided for @apiBaseHost.
  ///
  /// In en, this message translates to:
  /// **'API host'**
  String get apiBaseHost;

  /// No description provided for @httpStatus.
  ///
  /// In en, this message translates to:
  /// **'HTTP status'**
  String get httpStatus;

  /// No description provided for @apiBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'API base URL'**
  String get apiBaseUrl;
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
    'that was used.',
  );
}
