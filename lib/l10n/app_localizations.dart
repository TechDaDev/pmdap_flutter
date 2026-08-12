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

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found.'**
  String get notFound;

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
  /// **'Nationality'**
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
  /// **'Needs date confirmation'**
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

  /// No description provided for @guardianEligibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity before managing a child\'s record.'**
  String get guardianEligibilityTitle;

  /// No description provided for @guardianEligibilityBody.
  ///
  /// In en, this message translates to:
  /// **'A verified Unified National Card is required before you can create or manage a child record.'**
  String get guardianEligibilityBody;

  /// No description provided for @verifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify identity'**
  String get verifyIdentity;

  /// No description provided for @relationshipPending.
  ///
  /// In en, this message translates to:
  /// **'Relationship pending verification'**
  String get relationshipPending;

  /// No description provided for @documentIssuingCountry.
  ///
  /// In en, this message translates to:
  /// **'Issuing country'**
  String get documentIssuingCountry;

  /// No description provided for @frontImageRequired.
  ///
  /// In en, this message translates to:
  /// **'A front image is required.'**
  String get frontImageRequired;

  /// No description provided for @backImageRequired.
  ///
  /// In en, this message translates to:
  /// **'A back image is required.'**
  String get backImageRequired;

  /// No description provided for @nationalNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'National number is required.'**
  String get nationalNumberRequired;

  /// No description provided for @dobUnder18.
  ///
  /// In en, this message translates to:
  /// **'Child must be under 18 years old.'**
  String get dobUnder18;

  /// No description provided for @dobNotFuture.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future.'**
  String get dobNotFuture;

  /// No description provided for @unsupportedImageFormat.
  ///
  /// In en, this message translates to:
  /// **'This image format is not supported. Use JPEG or PNG.'**
  String get unsupportedImageFormat;

  /// No description provided for @legalGuardianEvidenceRequired.
  ///
  /// In en, this message translates to:
  /// **'Official evidence is required for a legal guardian.'**
  String get legalGuardianEvidenceRequired;

  /// No description provided for @verifiedFieldsLocked.
  ///
  /// In en, this message translates to:
  /// **'Verified identity fields cannot be edited directly.'**
  String get verifiedFieldsLocked;

  /// No description provided for @claimSubmittedReview.
  ///
  /// In en, this message translates to:
  /// **'Your claim has been submitted for review.'**
  String get claimSubmittedReview;

  /// No description provided for @accountActivationTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate your account'**
  String get accountActivationTitle;

  /// No description provided for @activationToken.
  ///
  /// In en, this message translates to:
  /// **'Activation token'**
  String get activationToken;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @accountActivated.
  ///
  /// In en, this message translates to:
  /// **'Account activated. You can now sign in.'**
  String get accountActivated;

  /// No description provided for @activationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not activate the account.'**
  String get activationFailed;

  /// No description provided for @claimTypeNationalCard.
  ///
  /// In en, this message translates to:
  /// **'Unified National Card'**
  String get claimTypeNationalCard;

  /// No description provided for @claimBackImageRequired.
  ///
  /// In en, this message translates to:
  /// **'A back image is required for your claim.'**
  String get claimBackImageRequired;

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

  /// No description provided for @legalGuardianshipDocument.
  ///
  /// In en, this message translates to:
  /// **'Legal guardianship document'**
  String get legalGuardianshipDocument;

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

  /// No description provided for @typeLaboratory.
  ///
  /// In en, this message translates to:
  /// **'Laboratory'**
  String get typeLaboratory;

  /// No description provided for @typeRadiology.
  ///
  /// In en, this message translates to:
  /// **'Radiology'**
  String get typeRadiology;

  /// No description provided for @typePrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get typePrescription;

  /// No description provided for @typeConsultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get typeConsultation;

  /// No description provided for @typeMedicalReport.
  ///
  /// In en, this message translates to:
  /// **'Medical report'**
  String get typeMedicalReport;

  /// No description provided for @typeHospitalAdmission.
  ///
  /// In en, this message translates to:
  /// **'Hospital admission'**
  String get typeHospitalAdmission;

  /// No description provided for @typeDischargeSummary.
  ///
  /// In en, this message translates to:
  /// **'Discharge summary'**
  String get typeDischargeSummary;

  /// No description provided for @typeSurgeryProcedure.
  ///
  /// In en, this message translates to:
  /// **'Surgery procedure'**
  String get typeSurgeryProcedure;

  /// No description provided for @typePathology.
  ///
  /// In en, this message translates to:
  /// **'Pathology'**
  String get typePathology;

  /// No description provided for @typeVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get typeVaccination;

  /// No description provided for @typeVitalSigns.
  ///
  /// In en, this message translates to:
  /// **'Vital signs'**
  String get typeVitalSigns;

  /// No description provided for @typeOther.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get typeOther;

  /// No description provided for @lifecycleCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get lifecycleCurrent;

  /// No description provided for @lifecycleExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get lifecycleExpired;

  /// No description provided for @lifecycleReplaced.
  ///
  /// In en, this message translates to:
  /// **'Replaced'**
  String get lifecycleReplaced;

  /// No description provided for @lifecycleRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get lifecycleRevoked;

  /// No description provided for @lifecycleStatus.
  ///
  /// In en, this message translates to:
  /// **'Lifecycle status'**
  String get lifecycleStatus;

  /// No description provided for @identityStatus.
  ///
  /// In en, this message translates to:
  /// **'Identity status'**
  String get identityStatus;

  /// No description provided for @relationshipStatus.
  ///
  /// In en, this message translates to:
  /// **'Relationship status'**
  String get relationshipStatus;

  /// No description provided for @facilityHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get facilityHospital;

  /// No description provided for @facilityClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get facilityClinic;

  /// No description provided for @facilityLaboratory.
  ///
  /// In en, this message translates to:
  /// **'Laboratory'**
  String get facilityLaboratory;

  /// No description provided for @facilityRadiologyCenter.
  ///
  /// In en, this message translates to:
  /// **'Radiology center'**
  String get facilityRadiologyCenter;

  /// No description provided for @facilityPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get facilityPharmacy;

  /// No description provided for @facilityPrimaryCareCenter.
  ///
  /// In en, this message translates to:
  /// **'Primary care center'**
  String get facilityPrimaryCareCenter;

  /// No description provided for @facilitySpecializedCenter.
  ///
  /// In en, this message translates to:
  /// **'Specialized center'**
  String get facilitySpecializedCenter;

  /// No description provided for @facilityUniversityHospital.
  ///
  /// In en, this message translates to:
  /// **'University hospital'**
  String get facilityUniversityHospital;

  /// No description provided for @facilityOther.
  ///
  /// In en, this message translates to:
  /// **'Other facility'**
  String get facilityOther;

  /// No description provided for @dateConfirmedState.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get dateConfirmedState;

  /// No description provided for @dateNotDetected.
  ///
  /// In en, this message translates to:
  /// **'No date detected'**
  String get dateNotDetected;

  /// No description provided for @processingDate.
  ///
  /// In en, this message translates to:
  /// **'Processing date'**
  String get processingDate;

  /// No description provided for @fileInfo.
  ///
  /// In en, this message translates to:
  /// **'File information'**
  String get fileInfo;

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get fileName;

  /// No description provided for @fileType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fileType;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fileSize;

  /// No description provided for @filePages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get filePages;

  /// No description provided for @integrityCorrupted.
  ///
  /// In en, this message translates to:
  /// **'File appears damaged'**
  String get integrityCorrupted;

  /// No description provided for @integrityQuarantined.
  ///
  /// In en, this message translates to:
  /// **'File unavailable'**
  String get integrityQuarantined;

  /// No description provided for @integrityMissing.
  ///
  /// In en, this message translates to:
  /// **'File missing'**
  String get integrityMissing;

  /// No description provided for @integrityPending.
  ///
  /// In en, this message translates to:
  /// **'File check pending'**
  String get integrityPending;

  /// No description provided for @viewFront.
  ///
  /// In en, this message translates to:
  /// **'View front'**
  String get viewFront;

  /// No description provided for @viewBack.
  ///
  /// In en, this message translates to:
  /// **'View back'**
  String get viewBack;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @permanentPatientId.
  ///
  /// In en, this message translates to:
  /// **'Permanent patient identifier'**
  String get permanentPatientId;

  /// No description provided for @noUnconfirmedDocuments.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noUnconfirmedDocuments;

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

  /// No description provided for @archiveEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a medical document to start your archive.'**
  String get archiveEmptySubtitle;

  /// No description provided for @noUnconfirmedArchive.
  ///
  /// In en, this message translates to:
  /// **'No documents need date confirmation.'**
  String get noUnconfirmedArchive;

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

  /// No description provided for @searchEmptyQuery.
  ///
  /// In en, this message translates to:
  /// **'Search your medical records'**
  String get searchEmptyQuery;

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
  /// **'Digital ID'**
  String get claimDigitalId;

  /// No description provided for @claimDigitalIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. PT-XXXX-XXXX-XXXX'**
  String get claimDigitalIdHint;

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

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @environmentOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get environmentOnline;

  /// No description provided for @environmentLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get environmentLocal;

  /// No description provided for @appFullName.
  ///
  /// In en, this message translates to:
  /// **'PMDAP Records'**
  String get appFullName;

  /// No description provided for @logoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your medical records, organized and secure.'**
  String get logoSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitleSecure.
  ///
  /// In en, this message translates to:
  /// **'Access your medical records securely.'**
  String get loginSubtitleSecure;

  /// No description provided for @secureFooter.
  ///
  /// In en, this message translates to:
  /// **'Secure access to your records'**
  String get secureFooter;

  /// No description provided for @claimExistingAccount.
  ///
  /// In en, this message translates to:
  /// **'Claim an existing patient account'**
  String get claimExistingAccount;

  /// No description provided for @activateClaimedAccount.
  ///
  /// In en, this message translates to:
  /// **'Activate a claimed account'**
  String get activateClaimedAccount;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get hello;

  /// No description provided for @medicalRecordOverview.
  ///
  /// In en, this message translates to:
  /// **'Here is your medical record overview.'**
  String get medicalRecordOverview;

  /// No description provided for @patientDigitalId.
  ///
  /// In en, this message translates to:
  /// **'Patient Digital ID'**
  String get patientDigitalId;

  /// No description provided for @permanentIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Permanent patient identifier'**
  String get permanentIdentifier;

  /// No description provided for @identityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity verification'**
  String get identityVerification;

  /// No description provided for @manageIdentity.
  ///
  /// In en, this message translates to:
  /// **'Manage identity'**
  String get manageIdentity;

  /// No description provided for @uploadDocumentShortcut.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get uploadDocumentShortcut;

  /// No description provided for @needsConfirmationShortcut.
  ///
  /// In en, this message translates to:
  /// **'Confirm dates'**
  String get needsConfirmationShortcut;

  /// No description provided for @myChildrenShortcut.
  ///
  /// In en, this message translates to:
  /// **'My children'**
  String get myChildrenShortcut;

  /// No description provided for @identityShortcut.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identityShortcut;

  /// No description provided for @confirmReportDate.
  ///
  /// In en, this message translates to:
  /// **'Confirm report date'**
  String get confirmReportDate;

  /// No description provided for @dateConfirmationBanner.
  ///
  /// In en, this message translates to:
  /// **'Please confirm the date shown on the medical report.'**
  String get dateConfirmationBanner;

  /// No description provided for @confirmSelectedDate.
  ///
  /// In en, this message translates to:
  /// **'Confirm selected date'**
  String get confirmSelectedDate;

  /// No description provided for @chooseExistingFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a PDF or image'**
  String get chooseExistingFile;

  /// No description provided for @chooseExistingFileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'PDF, JPG or PNG'**
  String get chooseExistingFileSubtitle;

  /// No description provided for @chooseFileButton.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFileButton;

  /// No description provided for @uploadDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload medical document'**
  String get uploadDocumentTitle;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetails;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalDetails;

  /// No description provided for @identityDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity documents'**
  String get identityDocumentsTitle;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account security'**
  String get accountSecurity;

  /// No description provided for @aboutPMDAP.
  ///
  /// In en, this message translates to:
  /// **'About PMDAP'**
  String get aboutPMDAP;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @recordsOrganized.
  ///
  /// In en, this message translates to:
  /// **'Your records are organized and protected.'**
  String get recordsOrganized;

  /// No description provided for @noRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No medical documents yet'**
  String get noRecordsYet;

  /// No description provided for @noRecordsYetDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload your first report to start your archive.'**
  String get noRecordsYetDescription;

  /// No description provided for @noConfirmedRecords.
  ///
  /// In en, this message translates to:
  /// **'No confirmed records yet'**
  String get noConfirmedRecords;

  /// No description provided for @noManagedChildren.
  ///
  /// In en, this message translates to:
  /// **'No managed child records'**
  String get noManagedChildren;

  /// No description provided for @tryAnotherSearch.
  ///
  /// In en, this message translates to:
  /// **'Try another word or adjust your filters.'**
  String get tryAnotherSearch;

  /// No description provided for @unableToReachPMDAP.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach PMDAP'**
  String get unableToReachPMDAP;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get checkConnection;

  /// No description provided for @removeThisDocument.
  ///
  /// In en, this message translates to:
  /// **'Remove this document?'**
  String get removeThisDocument;

  /// No description provided for @removeThisDocumentDescription.
  ///
  /// In en, this message translates to:
  /// **'It will no longer appear in your archive or search results.'**
  String get removeThisDocumentDescription;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of PMDAP Records?'**
  String get logoutTitle;

  /// No description provided for @documentsAndActions.
  ///
  /// In en, this message translates to:
  /// **'Documents & Actions'**
  String get documentsAndActions;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get appSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @useDeviceSettings.
  ///
  /// In en, this message translates to:
  /// **'Use device settings'**
  String get useDeviceSettings;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get profilePhoto;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get choosePhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get changeProfilePhoto;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get photoUpdated;

  /// No description provided for @photoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Photo removed'**
  String get photoRemoved;

  /// No description provided for @unableToUpdatePhoto.
  ///
  /// In en, this message translates to:
  /// **'Unable to update photo'**
  String get unableToUpdatePhoto;

  /// No description provided for @removePhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove profile photo?'**
  String get removePhotoConfirm;

  /// No description provided for @removePhotoExplain.
  ///
  /// In en, this message translates to:
  /// **'Your initials will be shown instead.'**
  String get removePhotoExplain;

  /// No description provided for @addMedicalDocument.
  ///
  /// In en, this message translates to:
  /// **'Add medical document'**
  String get addMedicalDocument;

  /// No description provided for @scanDocument.
  ///
  /// In en, this message translates to:
  /// **'Scan document'**
  String get scanDocument;

  /// No description provided for @scanDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your camera to scan one or more pages.'**
  String get scanDocumentSubtitle;

  /// No description provided for @selectDocumentType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectDocumentType;

  /// No description provided for @advancedDetails.
  ///
  /// In en, this message translates to:
  /// **'Advanced details'**
  String get advancedDetails;

  /// No description provided for @advancedDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — you can add or edit these later.'**
  String get advancedDetailsSubtitle;

  /// No description provided for @scannedDocument.
  ///
  /// In en, this message translates to:
  /// **'Scanned document'**
  String get scannedDocument;

  /// No description provided for @pagesLabel.
  ///
  /// In en, this message translates to:
  /// **'pages'**
  String get pagesLabel;

  /// No description provided for @rescan.
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get rescan;

  /// No description provided for @scannerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Document scanning is not available on this device.'**
  String get scannerUnavailable;

  /// No description provided for @scanCancelled.
  ///
  /// In en, this message translates to:
  /// **'Scan cancelled'**
  String get scanCancelled;

  /// No description provided for @startingScanner.
  ///
  /// In en, this message translates to:
  /// **'Starting scanner…'**
  String get startingScanner;

  /// No description provided for @chooseAnother.
  ///
  /// In en, this message translates to:
  /// **'Choose another'**
  String get chooseAnother;

  /// No description provided for @scanFront.
  ///
  /// In en, this message translates to:
  /// **'Scan front'**
  String get scanFront;

  /// No description provided for @scanBack.
  ///
  /// In en, this message translates to:
  /// **'Scan back'**
  String get scanBack;

  /// No description provided for @scanPassport.
  ///
  /// In en, this message translates to:
  /// **'Scan passport'**
  String get scanPassport;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get chooseImage;

  /// No description provided for @replaceImage.
  ///
  /// In en, this message translates to:
  /// **'Replace image'**
  String get replaceImage;

  /// No description provided for @readDocument.
  ///
  /// In en, this message translates to:
  /// **'Read document'**
  String get readDocument;

  /// No description provided for @readingDocument.
  ///
  /// In en, this message translates to:
  /// **'Reading document…'**
  String get readingDocument;

  /// No description provided for @documentReadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Document reading failed. Please try again.'**
  String get documentReadingFailed;

  /// No description provided for @documentNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'The document could not be recognized. Please scan it again.'**
  String get documentNotRecognized;

  /// No description provided for @reviewDocumentInformation.
  ///
  /// In en, this message translates to:
  /// **'Review document information'**
  String get reviewDocumentInformation;

  /// No description provided for @reviewDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please check the detected information before submitting.'**
  String get reviewDocumentSubtitle;

  /// No description provided for @confidenceDetected.
  ///
  /// In en, this message translates to:
  /// **'Detected'**
  String get confidenceDetected;

  /// No description provided for @confidencePleaseCheck.
  ///
  /// In en, this message translates to:
  /// **'Please check'**
  String get confidencePleaseCheck;

  /// No description provided for @confidenceNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get confidenceNeedsReview;

  /// No description provided for @couldNotReadThisField.
  ///
  /// In en, this message translates to:
  /// **'Could not read this field'**
  String get couldNotReadThisField;

  /// No description provided for @mrzVerified.
  ///
  /// In en, this message translates to:
  /// **'MRZ verified'**
  String get mrzVerified;

  /// No description provided for @submitForVerification.
  ///
  /// In en, this message translates to:
  /// **'Submit for verification'**
  String get submitForVerification;

  /// No description provided for @passportNumber.
  ///
  /// In en, this message translates to:
  /// **'Passport number'**
  String get passportNumber;

  /// No description provided for @identityExtractionAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Extraction is a suggestion only — please verify all values before submitting.'**
  String get identityExtractionAdvisory;

  /// No description provided for @identityImagesJpegOrPng.
  ///
  /// In en, this message translates to:
  /// **'Identity images must be JPEG or PNG.'**
  String get identityImagesJpegOrPng;

  /// No description provided for @uploadingIdentityDocument.
  ///
  /// In en, this message translates to:
  /// **'Uploading identity document…'**
  String get uploadingIdentityDocument;

  /// No description provided for @uploadingIdentityDocumentProgress.
  ///
  /// In en, this message translates to:
  /// **'Uploading identity document… {percent}%'**
  String uploadingIdentityDocumentProgress(Object percent);

  /// No description provided for @submittingIdentityDocument.
  ///
  /// In en, this message translates to:
  /// **'Submitting identity document…'**
  String get submittingIdentityDocument;

  /// No description provided for @identityExtractionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Document reading is temporarily unavailable.'**
  String get identityExtractionUnavailable;

  /// No description provided for @documentReadingMayTakeLonger.
  ///
  /// In en, this message translates to:
  /// **'Document reading may take a little longer. You can keep this screen open.'**
  String get documentReadingMayTakeLonger;

  /// No description provided for @identityConflictPending.
  ///
  /// In en, this message translates to:
  /// **'An identity document of this type is already awaiting verification.'**
  String get identityConflictPending;

  /// No description provided for @identityConflictVerified.
  ///
  /// In en, this message translates to:
  /// **'Use Replace document to submit a new copy.'**
  String get identityConflictVerified;

  /// No description provided for @viewIdentityDocuments.
  ///
  /// In en, this message translates to:
  /// **'View identity documents'**
  String get viewIdentityDocuments;

  /// No description provided for @identityConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity document already exists'**
  String get identityConflictTitle;
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
