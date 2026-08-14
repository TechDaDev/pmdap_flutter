// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PMDAP';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get save => 'Save';

  @override
  String get submit => 'Submit';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get loading => 'Loading…';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get networkError =>
      'Network error. Check your connection and try again.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get sessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get throttled =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get validationFailed => 'Please check the highlighted fields.';

  @override
  String get unknownStatus => 'Unknown';

  @override
  String get notFound => 'The requested item was not found.';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Access your medical archive';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get phone => 'Phone';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInFailed => 'Could not sign in.';

  @override
  String get invalidCredentials => 'Incorrect email or password.';

  @override
  String get accountUnavailable =>
      'This account is not available. Contact support if this is unexpected.';

  @override
  String get noAccountYet => 'No account yet?';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Register to start your medical archive';

  @override
  String get accountStepTitle => 'Create account';

  @override
  String get scanStepTitle => 'Verify your information';

  @override
  String get reviewStepTitle => 'Review your information';

  @override
  String get continueAction => 'Continue';

  @override
  String get scanFirstExplanation =>
      'PMDAP reads your Iraqi National Card to fill your profile. The values are suggestions — review and correct them before creating your account.';

  @override
  String get nationalCard => 'Iraqi National Card';

  @override
  String get governorate => 'Governorate';

  @override
  String get accountInformation => 'Account information';

  @override
  String get confirmCardMatches =>
      'I confirm that the information above matches my National Card.';

  @override
  String uploadingCardProgress(int percent) {
    return 'Uploading card… $percent%';
  }

  @override
  String get governorateAlAnbar => 'Al Anbar';

  @override
  String get governorateAlQadisiyyah => 'Al-Qadisiyyah';

  @override
  String get governorateBabil => 'Babil';

  @override
  String get governorateBaghdad => 'Baghdad';

  @override
  String get governorateBasra => 'Basra';

  @override
  String get governorateDhiQar => 'Dhi Qar';

  @override
  String get governorateDiyala => 'Diyala';

  @override
  String get governorateDuhok => 'Duhok';

  @override
  String get governorateErbil => 'Erbil';

  @override
  String get governorateHalabja => 'Halabja';

  @override
  String get governorateKarbala => 'Karbala';

  @override
  String get governorateKirkuk => 'Kirkuk';

  @override
  String get governorateMaysan => 'Maysan';

  @override
  String get governorateMuthanna => 'Muthanna';

  @override
  String get governorateNajaf => 'Najaf';

  @override
  String get governorateNineveh => 'Nineveh';

  @override
  String get governorateSaladin => 'Saladin';

  @override
  String get governorateSulaymaniyah => 'Sulaymaniyah';

  @override
  String get governorateWasit => 'Wasit';

  @override
  String get fullName => 'Full name';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get sex => 'Sex';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get unspecified => 'Unspecified';

  @override
  String get nationality => 'Nationality';

  @override
  String get bloodGroup => 'Blood group';

  @override
  String get name => 'Name';

  @override
  String get fathersName => 'Father\'s name';

  @override
  String get grandfathersName => 'Grandfather\'s name';

  @override
  String get personalInformation => 'Personal information';

  @override
  String get cardInformation => 'Card information';

  @override
  String get registrationSuccess => 'Account created. Please sign in.';

  @override
  String get registrationFailed => 'Could not create the account.';

  @override
  String get logout => 'Sign out';

  @override
  String get logoutConfirm => 'Sign out of PMDAP?';

  @override
  String get loggedOut => 'Signed out.';

  @override
  String get home => 'Home';

  @override
  String get archive => 'Archive';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';

  @override
  String get identity => 'Identity';

  @override
  String get minors => 'Children';

  @override
  String get documents => 'Documents';

  @override
  String get accountClaim => 'Claim an account';

  @override
  String get welcome => 'Welcome';

  @override
  String get digitalId => 'Digital ID';

  @override
  String get identityState => 'Identity status';

  @override
  String get needsDateConfirmation => 'Needs date confirmation';

  @override
  String get recentDocuments => 'Recent documents';

  @override
  String get viewAll => 'View all';

  @override
  String get identityVerified => 'Verified';

  @override
  String get identityUnverified => 'Not verified';

  @override
  String get identityPending => 'Pending verification';

  @override
  String get identityRejected => 'Rejected';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get age => 'Age';

  @override
  String get noData => 'No data';

  @override
  String get identityTitle => 'Identity documents';

  @override
  String get addIdentityDocument => 'Add identity document';

  @override
  String get replaceIdentityDocument => 'Replace document';

  @override
  String get chooseExistingImage => 'Choose existing image';

  @override
  String get documentNumber => 'Document number';

  @override
  String get nationalNumber => 'National number';

  @override
  String get nationalCardNumber => 'National/Card number';

  @override
  String get familyNumber => 'Family number';

  @override
  String get issuingCountry => 'Issuing country';

  @override
  String get uniqueCardBodyNumber => 'Unique card body number';

  @override
  String get issueDate => 'Issue date';

  @override
  String get expiryDate => 'Expiry date';

  @override
  String get documentType => 'Document type';

  @override
  String get docTypeNationalCard => 'National Card';

  @override
  String get docTypePassport => 'Passport';

  @override
  String get docTypeBirth => 'Birth document';

  @override
  String get docTypeOtherGov => 'Other government ID';

  @override
  String get frontImage => 'Front image';

  @override
  String get backImage => 'Back image';

  @override
  String get submitIdentity => 'Submit document';

  @override
  String get identitySubmitted => 'Identity document submitted for review.';

  @override
  String get verificationStatus => 'Verification';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusVerified => 'Verified';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get viewImage => 'View image';

  @override
  String get noIdentityDocuments => 'No identity documents yet.';

  @override
  String get replacementInfo =>
      'Replacing a verified document may trigger a new verification review.';

  @override
  String get selectImageRequired => 'Please choose a front image.';

  @override
  String get minorsTitle => 'Children';

  @override
  String get addMinor => 'Add child';

  @override
  String get relationship => 'Relationship';

  @override
  String get father => 'Father';

  @override
  String get mother => 'Mother';

  @override
  String get legalGuardian => 'Legal guardian';

  @override
  String get minorCreated =>
      'Child added. Their identity document is under review.';

  @override
  String get minorCreateFailed => 'Could not add the child.';

  @override
  String get noMinors => 'No children linked to your account.';

  @override
  String get guardianEligibilityTitle =>
      'Verify your identity before managing a child\'s record.';

  @override
  String get guardianEligibilityBody =>
      'A verified Unified National Card is required before you can create or manage a child record.';

  @override
  String get verifyIdentity => 'Verify identity';

  @override
  String get relationshipPending => 'Relationship pending verification';

  @override
  String get documentIssuingCountry => 'Issuing country';

  @override
  String get frontImageRequired => 'A front image is required.';

  @override
  String get backImageRequired => 'A back image is required.';

  @override
  String get nationalNumberRequired => 'National number is required.';

  @override
  String get dobUnder18 => 'Child must be under 18 years old.';

  @override
  String get dobNotFuture => 'Date of birth cannot be in the future.';

  @override
  String get unsupportedImageFormat =>
      'This image format is not supported. Use JPEG or PNG.';

  @override
  String get legalGuardianEvidenceRequired =>
      'Official evidence is required for a legal guardian.';

  @override
  String get verifiedFieldsLocked =>
      'Verified identity fields cannot be edited directly.';

  @override
  String get claimSubmittedReview =>
      'Your claim has been submitted for review.';

  @override
  String get accountActivationTitle => 'Activate your account';

  @override
  String get activationToken => 'Activation token';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordMismatch => 'Passwords do not match.';

  @override
  String get scan => 'Scan';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get accountActivated => 'Account activated. You can now sign in.';

  @override
  String get activationFailed => 'Could not activate the account.';

  @override
  String get claimTypeNationalCard => 'Unified National Card';

  @override
  String get claimBackImageRequired =>
      'A back image is required for your claim.';

  @override
  String get evidenceFile => 'Guardianship evidence file';

  @override
  String get evidenceType => 'Evidence type';

  @override
  String get guardianEvidence => 'Guardianship evidence';

  @override
  String get courtDocument => 'Court document';

  @override
  String get legalGuardianshipDocument => 'Legal guardianship document';

  @override
  String get otherOfficialEvidence => 'Other official evidence';

  @override
  String get minorDocuments => 'Documents';

  @override
  String get minorArchive => 'Archive';

  @override
  String get minorSearch => 'Search';

  @override
  String get guardianAccessRemoved =>
      'Guardian access is no longer available for this child.';

  @override
  String get minorAge => 'Age';

  @override
  String get documentsTitle => 'Medical documents';

  @override
  String get uploadDocument => 'Upload document';

  @override
  String get chooseFile => 'Choose existing file';

  @override
  String get upload => 'Upload';

  @override
  String get uploading => 'Uploading…';

  @override
  String get uploadSuccess => 'Document uploaded.';

  @override
  String get uploadFailed => 'Could not upload the document.';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get facility => 'Facility';

  @override
  String get department => 'Department';

  @override
  String get physician => 'Physician';

  @override
  String get location => 'Location';

  @override
  String get reportDate => 'Report date';

  @override
  String get dateVerifiedLabel => 'Date verified';

  @override
  String get dateUnconfirmed => 'Date not confirmed';

  @override
  String get processingStatus => 'Processing';

  @override
  String get statusUploaded => 'Uploaded';

  @override
  String get statusQueued => 'Queued';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusTextExtracted => 'Text extracted';

  @override
  String get statusOcrRequired => 'OCR required';

  @override
  String get statusOcrProcessing => 'OCR processing';

  @override
  String get statusDateProcessing => 'Reading date';

  @override
  String get statusDateDetected => 'Date detected';

  @override
  String get statusDateNotFound => 'Date not found';

  @override
  String get statusAwaitingConfirmation => 'Awaiting confirmation';

  @override
  String get statusDateConfirmed => 'Date confirmed';

  @override
  String get statusIndexed => 'Indexed';

  @override
  String get statusFailed => 'Failed';

  @override
  String get typeLaboratory => 'Laboratory';

  @override
  String get typeRadiology => 'Radiology';

  @override
  String get typePrescription => 'Prescription';

  @override
  String get typeConsultation => 'Consultation';

  @override
  String get typeMedicalReport => 'Medical report';

  @override
  String get typeHospitalAdmission => 'Hospital admission';

  @override
  String get typeDischargeSummary => 'Discharge summary';

  @override
  String get typeSurgeryProcedure => 'Surgery procedure';

  @override
  String get typePathology => 'Pathology';

  @override
  String get typeVaccination => 'Vaccination';

  @override
  String get typeVitalSigns => 'Vital signs';

  @override
  String get typeOther => 'Document';

  @override
  String get lifecycleCurrent => 'Current';

  @override
  String get lifecycleExpired => 'Expired';

  @override
  String get lifecycleReplaced => 'Replaced';

  @override
  String get lifecycleRevoked => 'Revoked';

  @override
  String get lifecycleStatus => 'Lifecycle status';

  @override
  String get identityStatus => 'Identity status';

  @override
  String get relationshipStatus => 'Relationship status';

  @override
  String get facilityHospital => 'Hospital';

  @override
  String get facilityClinic => 'Clinic';

  @override
  String get facilityLaboratory => 'Laboratory';

  @override
  String get facilityRadiologyCenter => 'Radiology center';

  @override
  String get facilityPharmacy => 'Pharmacy';

  @override
  String get facilityPrimaryCareCenter => 'Primary care center';

  @override
  String get facilitySpecializedCenter => 'Specialized center';

  @override
  String get facilityUniversityHospital => 'University hospital';

  @override
  String get facilityOther => 'Other facility';

  @override
  String get dateConfirmedState => 'Confirmed';

  @override
  String get dateNotDetected => 'No date detected';

  @override
  String get processingDate => 'Processing date';

  @override
  String get fileInfo => 'File information';

  @override
  String get fileName => 'File name';

  @override
  String get fileType => 'Type';

  @override
  String get fileSize => 'Size';

  @override
  String get filePages => 'Pages';

  @override
  String get integrityCorrupted => 'File appears damaged';

  @override
  String get integrityQuarantined => 'File unavailable';

  @override
  String get integrityMissing => 'File missing';

  @override
  String get integrityPending => 'File check pending';

  @override
  String get viewFront => 'View front';

  @override
  String get viewBack => 'View back';

  @override
  String get notProvided => 'Not provided';

  @override
  String get notAvailable => 'Not available';

  @override
  String get permanentPatientId => 'Permanent patient identifier';

  @override
  String get noUnconfirmedDocuments => 'None';

  @override
  String get viewFile => 'View file';

  @override
  String get deleteDocument => 'Delete document';

  @override
  String get deleteDocumentConfirm => 'Delete this document from your archive?';

  @override
  String get deleted => 'Document deleted.';

  @override
  String get noDocuments => 'No medical documents yet.';

  @override
  String get openFileFailed => 'Could not open the file.';

  @override
  String get dateCandidates => 'Suggested dates';

  @override
  String get suggestedDate => 'Suggested date';

  @override
  String get confirmDate => 'Confirm date';

  @override
  String get manualDate => 'Enter date manually';

  @override
  String get chooseCandidate => 'Select a suggested date';

  @override
  String get dateConfirmed => 'Date confirmed.';

  @override
  String get confirmFailed => 'Could not confirm the date.';

  @override
  String get candidateScore => 'Score';

  @override
  String get pageNumber => 'Page';

  @override
  String get ambiguousDate => 'Ambiguous';

  @override
  String get facilitiesTitle => 'Facilities';

  @override
  String get selectFacility => 'Select facility';

  @override
  String get searchFacility => 'Search facilities';

  @override
  String get noFacilities => 'No facilities found.';

  @override
  String get facilityType => 'Facility type';

  @override
  String get noneSelected => 'None';

  @override
  String get archiveTitle => 'Archive';

  @override
  String get archiveSummary => 'Summary';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';

  @override
  String get allYears => 'All years';

  @override
  String get allMonths => 'All months';

  @override
  String get allTypes => 'All types';

  @override
  String get allFacilities => 'All facilities';

  @override
  String get allDates => 'All dates';

  @override
  String get unconfirmedSection => 'Needs date confirmation';

  @override
  String get noArchive => 'No documents in the archive.';

  @override
  String get archiveEmptySubtitle =>
      'Upload a medical document to start your archive.';

  @override
  String get noUnconfirmedArchive => 'No documents need date confirmation.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get unconfirmedDates => 'Unconfirmed dates';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search documents…';

  @override
  String get searchEmptyQuery => 'Search your medical records';

  @override
  String get searchResults => 'Results';

  @override
  String get noResults => 'No results found.';

  @override
  String get searchPlaceholder => 'Search by document content';

  @override
  String get claimTitle => 'Claim an account';

  @override
  String get claimSubtitle =>
      'If you already have medical records, claim them with your Digital ID.';

  @override
  String get claimDigitalId => 'Digital ID';

  @override
  String get claimDigitalIdHint => 'e.g. PT-XXXX-XXXX-XXXX';

  @override
  String get claimEmail => 'Email';

  @override
  String get claimPhone => 'Phone';

  @override
  String get claimFullName => 'Full name';

  @override
  String get claimDob => 'Date of birth';

  @override
  String get claimIdType => 'Identity document type';

  @override
  String get claimIdNumber => 'Identity document number';

  @override
  String get claimSubmit => 'Submit claim';

  @override
  String get claimSubmitted => 'Your claim was submitted. It will be reviewed.';

  @override
  String get claimFailed => 'Could not submit the claim.';

  @override
  String get claimPending => 'Claim pending review';

  @override
  String get healthCheck => 'Connectivity check';

  @override
  String get healthReachable => 'Server reachable';

  @override
  String get healthUnreachable => 'Server unreachable';

  @override
  String get apiBaseHost => 'API host';

  @override
  String get httpStatus => 'HTTP status';

  @override
  String get apiBaseUrl => 'API base URL';

  @override
  String get environment => 'Environment';

  @override
  String get environmentOnline => 'Online';

  @override
  String get environmentLocal => 'Local';

  @override
  String get appFullName => 'PMDAP Records';

  @override
  String get logoSubtitle => 'Your medical records, organized and secure.';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginSubtitleSecure => 'Access your medical records securely.';

  @override
  String get secureFooter => 'Secure access to your records';

  @override
  String get claimExistingAccount => 'Claim an existing patient account';

  @override
  String get activateClaimedAccount => 'Activate a claimed account';

  @override
  String get hello => 'Hello,';

  @override
  String get medicalRecordOverview => 'Here is your medical record overview.';

  @override
  String get patientDigitalId => 'Patient Digital ID';

  @override
  String get permanentIdentifier => 'Permanent patient identifier';

  @override
  String get identityVerification => 'Identity verification';

  @override
  String get manageIdentity => 'Manage identity';

  @override
  String get uploadDocumentShortcut => 'Upload document';

  @override
  String get needsConfirmationShortcut => 'Confirm dates';

  @override
  String get myChildrenShortcut => 'My children';

  @override
  String get identityShortcut => 'Identity';

  @override
  String get confirmReportDate => 'Confirm report date';

  @override
  String get dateConfirmationBanner =>
      'Please confirm the date shown on the medical report.';

  @override
  String get confirmSelectedDate => 'Confirm selected date';

  @override
  String get chooseExistingFile => 'Choose a PDF or image';

  @override
  String get chooseExistingFileSubtitle => 'PDF, JPG or PNG';

  @override
  String get chooseFileButton => 'Choose file';

  @override
  String get uploadDocumentTitle => 'Upload medical document';

  @override
  String get editDetails => 'Edit details';

  @override
  String get personalDetails => 'Personal information';

  @override
  String get identityDocumentsTitle => 'Identity documents';

  @override
  String get children => 'Children';

  @override
  String get accountSecurity => 'Account security';

  @override
  String get aboutPMDAP => 'About PMDAP';

  @override
  String get help => 'Help';

  @override
  String get recordsOrganized => 'Your records are organized and protected.';

  @override
  String get noRecordsYet => 'No medical documents yet';

  @override
  String get noRecordsYetDescription =>
      'Upload your first report to start your archive.';

  @override
  String get noConfirmedRecords => 'No confirmed records yet';

  @override
  String get noManagedChildren => 'No managed child records';

  @override
  String get tryAnotherSearch => 'Try another word or adjust your filters.';

  @override
  String get unableToReachPMDAP => 'Unable to reach PMDAP';

  @override
  String get checkConnection => 'Check your connection and try again.';

  @override
  String get removeThisDocument => 'Remove this document?';

  @override
  String get removeThisDocumentDescription =>
      'It will no longer appear in your archive or search results.';

  @override
  String get remove => 'Remove';

  @override
  String get logoutTitle => 'Log out of PMDAP Records?';

  @override
  String get documentsAndActions => 'Documents & Actions';

  @override
  String get appSettings => 'App settings';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get systemDefault => 'System default';

  @override
  String get useDeviceSettings => 'Use device settings';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get profilePhoto => 'Profile photo';

  @override
  String get choosePhoto => 'Choose photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get changeProfilePhoto => 'Change profile photo';

  @override
  String get photoUpdated => 'Photo updated';

  @override
  String get photoRemoved => 'Photo removed';

  @override
  String get unableToUpdatePhoto => 'Unable to update photo';

  @override
  String get removePhotoConfirm => 'Remove profile photo?';

  @override
  String get removePhotoExplain => 'Your initials will be shown instead.';

  @override
  String get addMedicalDocument => 'Add medical document';

  @override
  String get scanDocument => 'Scan document';

  @override
  String get scanDocumentSubtitle =>
      'Use your camera to scan one or more pages.';

  @override
  String get selectDocumentType => 'Select type';

  @override
  String get advancedDetails => 'Advanced details';

  @override
  String get advancedDetailsSubtitle =>
      'Optional — you can add or edit these later.';

  @override
  String get scannedDocument => 'Scanned document';

  @override
  String get pagesLabel => 'pages';

  @override
  String get rescan => 'Rescan';

  @override
  String get scannerUnavailable =>
      'Document scanning is not available on this device.';

  @override
  String get scanCancelled => 'Scan cancelled';

  @override
  String get startingScanner => 'Starting scanner…';

  @override
  String get chooseAnother => 'Choose another';

  @override
  String get scanFront => 'Scan front';

  @override
  String get scanBack => 'Scan back';

  @override
  String get scanPassport => 'Scan passport';

  @override
  String get chooseImage => 'Choose image';

  @override
  String get replaceImage => 'Replace image';

  @override
  String get readDocument => 'Read document';

  @override
  String get readingDocument => 'Reading document…';

  @override
  String get documentReadingFailed =>
      'Document reading failed. Please try again.';

  @override
  String get documentNotRecognized =>
      'The document could not be recognized. Please scan it again.';

  @override
  String get reviewDocumentInformation => 'Review document information';

  @override
  String get reviewDocumentSubtitle =>
      'Please check the detected information before submitting.';

  @override
  String get confidenceDetected => 'Detected';

  @override
  String get confidencePleaseCheck => 'Please check';

  @override
  String get confidenceNeedsReview => 'Needs review';

  @override
  String get couldNotReadThisField => 'Could not read this field';

  @override
  String get mrzVerified => 'MRZ verified';

  @override
  String get submitForVerification => 'Submit for verification';

  @override
  String get passportNumber => 'Passport number';

  @override
  String get identityExtractionAdvisory =>
      'Extraction is a suggestion only — please verify all values before submitting.';

  @override
  String get identityImagesJpegOrPng => 'Identity images must be JPEG or PNG.';

  @override
  String get uploadingIdentityDocument => 'Uploading identity document…';

  @override
  String uploadingIdentityDocumentProgress(Object percent) {
    return 'Uploading identity document… $percent%';
  }

  @override
  String get submittingIdentityDocument => 'Submitting identity document…';

  @override
  String get identityExtractionUnavailable =>
      'Document reading is temporarily unavailable.';

  @override
  String get documentReadingMayTakeLonger =>
      'Document reading may take a little longer. You can keep this screen open.';

  @override
  String get identityConflictPending =>
      'An identity document of this type is already awaiting verification.';

  @override
  String get identityConflictVerified =>
      'Use Replace document to submit a new copy.';

  @override
  String get viewIdentityDocuments => 'View identity documents';

  @override
  String get identityConflictTitle => 'Identity document already exists';
}
