// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'PMDAP';

  @override
  String get ok => 'حسناً';

  @override
  String get cancel => 'إلغاء';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get save => 'حفظ';

  @override
  String get submit => 'إرسال';

  @override
  String get delete => 'حذف';

  @override
  String get close => 'إغلاق';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get errorGeneric => 'حدث خطأ. حاول مرة أخرى.';

  @override
  String get errorEmailExists =>
      'هذا البريد الإلكتروني مسجّل مسبقاً. سجّل الدخول بدلاً من ذلك.';

  @override
  String get errorCardAlreadyRegistered => 'هذه البطاقة الوطنية مسجّلة مسبقاً.';

  @override
  String get errorRegistrationExpired =>
      'انتهت صلاحية جلسة التسجيل. يرجى مسح بطاقتك مرة أخرى.';

  @override
  String get errorRegistrationAlreadyCompleted =>
      'اكتمل هذا التسجيل مسبقاً. يرجى تسجيل الدخول بدلاً من ذلك.';

  @override
  String get errorRegistrationSessionInvalid =>
      'جلسة التسجيل لم تعد صالحة. يرجى مسح بطاقتك مرة أخرى.';

  @override
  String get networkError => 'خطأ في الشبكة. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get serverError => 'خطأ في الخادم. حاول لاحقاً.';

  @override
  String get sessionExpired => 'انتهت الجلسة. سجّل الدخول مرة أخرى.';

  @override
  String get throttled => 'محاولات كثيرة. انتظر قليلاً ثم حاول.';

  @override
  String get validationFailed => 'يرجى مراجعة الحقول المميزة.';

  @override
  String get unknownStatus => 'غير معروف';

  @override
  String get notFound => 'العنصر المطلوب غير موجود.';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'الوصول إلى أرشيفك الطبي';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get phone => 'الهاتف';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInFailed => 'تعذر تسجيل الدخول.';

  @override
  String get signInPrompt => 'هل لديك حساب؟ سجّل الدخول';

  @override
  String get invalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get accountUnavailable =>
      'الحساب غير متاح. تواصل مع الدعم إذا كان ذلك غير متوقع.';

  @override
  String get noAccountYet => 'لا تملك حساباً؟';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'سجّل لبدء أرشيفك الطبي';

  @override
  String get accountStepTitle => 'إنشاء حساب';

  @override
  String get scanStepTitle => 'تحقق من معلوماتك';

  @override
  String get reviewStepTitle => 'راجع معلوماتك';

  @override
  String get continueAction => 'متابعة';

  @override
  String get scanFirstExplanation =>
      'يقرأ PMDAP بطاقة الهوية العراقية لملء ملفك. القيم مجرد اقتراحات — راجعها وصحّحها قبل إنشاء حسابك.';

  @override
  String get nationalCard => 'بطاقة الهوية العراقية';

  @override
  String get governorate => 'المحافظة';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get confirmCardMatches =>
      'أؤكد أن المعلومات أعلاه مطابقة لبطاقة هويتي.';

  @override
  String uploadingCardProgress(int percent) {
    return 'جاري رفع البطاقة… $percent%';
  }

  @override
  String get governorateAlAnbar => 'الأنبار';

  @override
  String get governorateAlQadisiyyah => 'القادسية';

  @override
  String get governorateBabil => 'بابل';

  @override
  String get governorateBaghdad => 'بغداد';

  @override
  String get governorateBasra => 'البصرة';

  @override
  String get governorateDhiQar => 'ذي قار';

  @override
  String get governorateDiyala => 'ديالى';

  @override
  String get governorateDuhok => 'دهوك';

  @override
  String get governorateErbil => 'أربيل';

  @override
  String get governorateHalabja => 'حلبجة';

  @override
  String get governorateKarbala => 'كربلاء';

  @override
  String get governorateKirkuk => 'كركوك';

  @override
  String get governorateMaysan => 'ميسان';

  @override
  String get governorateMuthanna => 'المثنى';

  @override
  String get governorateNajaf => 'النجف';

  @override
  String get governorateNineveh => 'نينوى';

  @override
  String get governorateSaladin => 'صلاح الدين';

  @override
  String get governorateSulaymaniyah => 'السليمانية';

  @override
  String get governorateWasit => 'واسط';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get sex => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get unspecified => 'غير محدد';

  @override
  String get nationality => 'الجنسية';

  @override
  String get bloodGroup => 'فصيلة الدم';

  @override
  String get name => 'الاسم';

  @override
  String get fathersName => 'اسم الأب';

  @override
  String get grandfathersName => 'اسم الجد';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get cardInformation => 'معلومات البطاقة';

  @override
  String get registrationSuccess => 'تم إنشاء الحساب. سجّل الدخول.';

  @override
  String get registrationFailed => 'تعذر إنشاء الحساب.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'هل تريد تسجيل الخروج من PMDAP؟';

  @override
  String get loggedOut => 'تم تسجيل الخروج.';

  @override
  String get home => 'الرئيسية';

  @override
  String get archive => 'الأرشيف';

  @override
  String get search => 'البحث';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get identity => 'الهوية';

  @override
  String get minors => 'الأطفال';

  @override
  String get documents => 'المستندات';

  @override
  String get accountClaim => 'المطالبة بحساب';

  @override
  String get welcome => 'مرحباً';

  @override
  String get digitalId => 'المعرف الرقمي';

  @override
  String get identityState => 'حالة الهوية';

  @override
  String get needsDateConfirmation => 'بحاجة لتأكيد التاريخ';

  @override
  String get recentDocuments => 'أحدث المستندات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get identityVerified => 'موثّق';

  @override
  String get identityUnverified => 'غير موثّق';

  @override
  String get identityPending => 'قيد التحقق';

  @override
  String get identityRejected => 'مرفوض';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get age => 'العمر';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get identityTitle => 'وثائق الهوية';

  @override
  String get addIdentityDocument => 'إضافة وثيقة هوية';

  @override
  String get replaceIdentityDocument => 'استبدال الوثيقة';

  @override
  String get chooseExistingImage => 'اختيار صورة موجودة';

  @override
  String get documentNumber => 'رقم الوثيقة';

  @override
  String get nationalNumber => 'الرقم الوطني';

  @override
  String get nationalCardNumber => 'الرقم الوطني / رقم البطاقة';

  @override
  String get familyNumber => 'رقم العائلة';

  @override
  String get issuingCountry => 'دولة الإصدار';

  @override
  String get uniqueCardBodyNumber => 'الرقم الفريد لجسم البطاقة';

  @override
  String get issueDate => 'تاريخ الإصدار';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get documentType => 'نوع الوثيقة';

  @override
  String get docTypeNationalCard => 'البطاقة الوطنية';

  @override
  String get docTypePassport => 'جواز السفر';

  @override
  String get docTypeBirth => 'وثيقة ميلاد';

  @override
  String get docTypeOtherGov => 'هوية حكومية أخرى';

  @override
  String get frontImage => 'الصورة الأمامية';

  @override
  String get backImage => 'الصورة الخلفية';

  @override
  String get submitIdentity => 'إرسال الوثيقة';

  @override
  String get identitySubmitted => 'تم إرسال وثيقة الهوية للمراجعة.';

  @override
  String get verificationStatus => 'التحقق';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusVerified => 'موثّق';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get viewImage => 'عرض الصورة';

  @override
  String get noIdentityDocuments => 'لا توجد وثائق هوية بعد.';

  @override
  String get replacementInfo =>
      'قد يؤدي استبدال وثيقة موثّقة إلى مراجعة جديدة.';

  @override
  String get selectImageRequired => 'يرجى اختيار صورة أمامية.';

  @override
  String get minorsTitle => 'الأطفال';

  @override
  String get addMinor => 'إضافة طفل';

  @override
  String get relationship => 'العلاقة';

  @override
  String get father => 'أب';

  @override
  String get mother => 'أم';

  @override
  String get legalGuardian => 'وصي قانوني';

  @override
  String get minorCreated => 'تمت إضافة الطفل. وثيقة هويته قيد المراجعة.';

  @override
  String get minorCreateFailed => 'تعذر إضافة الطفل.';

  @override
  String get noMinors => 'لا يوجد أطفال مرتبطون بحسابك.';

  @override
  String get guardianEligibilityTitle => 'تحقق من هويتك قبل إدارة سجل الطفل.';

  @override
  String get guardianEligibilityBody =>
      'البطاقة الوطنية الموحدة الموثقة مطلوبة قبل أن تتمكن من إنشاء أو إدارة سجل طفل.';

  @override
  String get verifyIdentity => 'تحقق من الهوية';

  @override
  String get relationshipPending => 'العلاقة قيد التحقق';

  @override
  String get documentIssuingCountry => 'دولة الإصدار';

  @override
  String get frontImageRequired => 'الصورة الأمامية مطلوبة.';

  @override
  String get backImageRequired => 'الصورة الخلفية مطلوبة.';

  @override
  String get nationalNumberRequired => 'الرقم الوطني مطلوب.';

  @override
  String get dobUnder18 => 'يجب أن يكون الطفل أقل من 18 عامًا.';

  @override
  String get dobNotFuture => 'لا يمكن أن يكون تاريخ الميلاد في المستقبل.';

  @override
  String get requiredField => 'هذا الحقل مطلوب.';

  @override
  String get selectSex => 'يرجى اختيار الجنس.';

  @override
  String get confirmRequired =>
      'يرجى تأكيد أن المعلومات أعلاه مطابقة لبطاقتك الوطنية.';

  @override
  String get verifyIdentityTitle => 'تحقق من هويتك';

  @override
  String get verifyIdentityDescription =>
      'استخدم بطاقتك الوطنية العراقية للتحقق من معلوماتك.';

  @override
  String get identityAlreadyRead => 'تمت قراءة البطاقة الوطنية';

  @override
  String get continueToReview => 'متابعة إلى المراجعة';

  @override
  String get editAccountDetails => 'تعديل بيانات الحساب';

  @override
  String get identityNotSubmitted => 'لم يتم تقديمها';

  @override
  String get needsAttention => 'يحتاج إلى انتباه';

  @override
  String get resubmitIdentity => 'إعادة تقديم الهوية';

  @override
  String get addIdentity => 'إضافة هوية';

  @override
  String get identityPendingReview => 'بطاقتك الوطنية قيد المراجعة.';

  @override
  String get identityVerifiedNote => 'تم التحقق من هويتك.';

  @override
  String get identityRejectedNote => 'لم يتم قبول بطاقتك الوطنية.';

  @override
  String get stillReading =>
      'لا تزال القراءة جارية — قد يستغرق هذا وقتًا أطول قليلاً...';

  @override
  String get unsupportedImageFormat =>
      'صيغة الصورة غير مدعومة. استخدم JPEG أو PNG.';

  @override
  String get legalGuardianEvidenceRequired =>
      'الدليل الرسمي مطلوب للوصي القانوني.';

  @override
  String get verifiedFieldsLocked =>
      'لا يمكن تعديل حقول الهوية الموثقة مباشرة.';

  @override
  String get claimSubmittedReview => 'تم إرسال مطالبتك للمراجعة.';

  @override
  String get accountActivationTitle => 'تفعيل حسابك';

  @override
  String get activationToken => 'رمز التفعيل';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get scan => 'مسح';

  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get accountActivated => 'تم تفعيل الحساب. يمكنك الآن تسجيل الدخول.';

  @override
  String get activationFailed => 'تعذر تفعيل الحساب.';

  @override
  String get claimTypeNationalCard => 'البطاقة الوطنية الموحدة';

  @override
  String get claimBackImageRequired => 'الصورة الخلفية مطلوبة للمطالبة.';

  @override
  String get evidenceFile => 'ملف إثبات الوصاية';

  @override
  String get evidenceType => 'نوع الإثبات';

  @override
  String get guardianEvidence => 'إثبات الوصاية';

  @override
  String get courtDocument => 'وثيقة محكمة';

  @override
  String get legalGuardianshipDocument => 'وثيقة الوصاية القانونية';

  @override
  String get otherOfficialEvidence => 'إثبات رسمي آخر';

  @override
  String get minorDocuments => 'المستندات';

  @override
  String get minorArchive => 'الأرشيف';

  @override
  String get minorSearch => 'البحث';

  @override
  String get guardianAccessRemoved => 'لم يعد وصول الوصي متاحاً لهذا الطفل.';

  @override
  String get minorAge => 'العمر';

  @override
  String get documentsTitle => 'المستندات الطبية';

  @override
  String get uploadDocument => 'رفع مستند';

  @override
  String get chooseFile => 'اختيار ملف موجود';

  @override
  String get upload => 'رفع';

  @override
  String get uploading => 'جارٍ الرفع…';

  @override
  String get uploadSuccess => 'تم رفع المستند.';

  @override
  String get uploadFailed => 'تعذر رفع المستند.';

  @override
  String get uploadFileTypeUnsupported =>
      'نوع الملف غير مدعوم. استخدم PDF أو JPG أو PNG.';

  @override
  String get uploadFileTooLarge => 'هذا الملف كبير جدًا.';

  @override
  String get uploadImageTooLarge =>
      'هذه الصورة كبيرة جدًا. جرب صورة أصغر أو استخدم الماسح الضوئي.';

  @override
  String get uploadImageCorrupt =>
      'تعذرت قراءة هذه الصورة. حاول مسحها ضوئيًا أو تحديدها مرة أخرى.';

  @override
  String get uploadInvalidDocumentType => 'يرجى اختيار نوع المستند.';

  @override
  String get preparingDocument => 'جارٍ تجهيز المستند…';

  @override
  String get documentStillProcessing =>
      'لا يزال مستندك قيد المعالجة. يمكنك مغادرة هذه الشاشة والتحقق لاحقًا.';

  @override
  String uploadingProgress(int percent) {
    return 'جارٍ الرفع… $percent%';
  }

  @override
  String get preparingDocumentFailed =>
      'تعذّر تجهيز هذه الصورة. حاول تحديدها مرة أخرى.';

  @override
  String get imageTooLargeToPrepare =>
      'هذه الصورة كبيرة جدًا ولا يمكن تجهيزها. جرّب مسح المستند ضوئيًا بدلاً من ذلك.';

  @override
  String originalPreparedSize(String original, String prepared) {
    return 'الأصلي $original · المجهّز $prepared';
  }

  @override
  String get title => 'العنوان';

  @override
  String get description => 'الوصف';

  @override
  String get facility => 'المنشأة';

  @override
  String get department => 'القسم';

  @override
  String get physician => 'الطبيب';

  @override
  String get location => 'الموقع';

  @override
  String get reportDate => 'تاريخ التقرير';

  @override
  String get dateVerifiedLabel => 'التاريخ موثّق';

  @override
  String get dateUnconfirmed => 'التاريخ غير مؤكد';

  @override
  String get processingStatus => 'المعالجة';

  @override
  String get statusUploaded => 'تم الرفع';

  @override
  String get statusQueued => 'في الانتظار';

  @override
  String get statusProcessing => 'قيد المعالجة';

  @override
  String get statusTextExtracted => 'تم استخراج النص';

  @override
  String get statusOcrRequired => 'مطلوب OCR';

  @override
  String get statusOcrProcessing => 'جارٍ OCR';

  @override
  String get statusDateProcessing => 'جارٍ قراءة التاريخ';

  @override
  String get statusDateDetected => 'تم اكتشاف التاريخ';

  @override
  String get statusDateNotFound => 'التاريخ غير موجود';

  @override
  String get statusAwaitingConfirmation => 'بانتظار التأكيد';

  @override
  String get statusDateConfirmed => 'تم تأكيد التاريخ';

  @override
  String get statusIndexed => 'مفهرس';

  @override
  String get statusFailed => 'فشل';

  @override
  String get typeLaboratory => 'مخبري';

  @override
  String get typeRadiology => 'أشعة';

  @override
  String get typePrescription => 'وصفة طبية';

  @override
  String get typeConsultation => 'استشارة';

  @override
  String get typeMedicalReport => 'تقرير طبي';

  @override
  String get typeHospitalAdmission => 'تنويم مستشفى';

  @override
  String get typeDischargeSummary => 'ملخص الخروج';

  @override
  String get typeSurgeryProcedure => 'إجراء جراحي';

  @override
  String get typePathology => 'علم الأمراض';

  @override
  String get typeVaccination => 'تطعيم';

  @override
  String get typeVitalSigns => 'علامات حيوية';

  @override
  String get typeOther => 'مستند';

  @override
  String get lifecycleCurrent => 'حالي';

  @override
  String get lifecycleExpired => 'منتهي';

  @override
  String get lifecycleReplaced => 'مستبدل';

  @override
  String get lifecycleRevoked => 'ملغي';

  @override
  String get lifecycleStatus => 'حالة دورة الحياة';

  @override
  String get identityStatus => 'حالة الهوية';

  @override
  String get relationshipStatus => 'حالة العلاقة';

  @override
  String get facilityHospital => 'مستشفى';

  @override
  String get facilityClinic => 'عيادة';

  @override
  String get facilityLaboratory => 'مخبر';

  @override
  String get facilityRadiologyCenter => 'مركز أشعة';

  @override
  String get facilityPharmacy => 'صيدلية';

  @override
  String get facilityPrimaryCareCenter => 'مركز رعاية أولية';

  @override
  String get facilitySpecializedCenter => 'مركز تخصصي';

  @override
  String get facilityUniversityHospital => 'مستشفى جامعي';

  @override
  String get facilityOther => 'منشأة أخرى';

  @override
  String get dateConfirmedState => 'مؤكد';

  @override
  String get dateNotDetected => 'لم يتم العثور على تاريخ';

  @override
  String get detectedDateLabel => 'التاريخ المكتشف';

  @override
  String get dateStatusLabel => 'حالة التاريخ';

  @override
  String get notDetected => 'غير مكتشف';

  @override
  String get needsConfirmation => 'بحاجة للتأكيد';

  @override
  String possibleDatesDetected(int count) {
    return '$count تواريخ محتملة تم اكتشافها';
  }

  @override
  String get processingDate => 'تاريخ قيد المعالجة';

  @override
  String get fileInfo => 'معلومات الملف';

  @override
  String get fileName => 'اسم الملف';

  @override
  String get fileType => 'النوع';

  @override
  String get fileSize => 'الحجم';

  @override
  String get filePages => 'الصفحات';

  @override
  String get integrityCorrupted => 'يبدو الملف تالفًا';

  @override
  String get integrityQuarantined => 'الملف غير متاح';

  @override
  String get integrityMissing => 'الملف مفقود';

  @override
  String get integrityPending => 'فحص الملف قيد الانتظار';

  @override
  String get viewFront => 'عرض الوجه الأمامي';

  @override
  String get viewBack => 'عرض الوجه الخلفي';

  @override
  String get notProvided => 'غير مقدم';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get permanentPatientId => 'معرّف المريض الدائم';

  @override
  String get noUnconfirmedDocuments => 'لا يوجد';

  @override
  String get viewFile => 'عرض الملف';

  @override
  String get deleteDocument => 'حذف المستند';

  @override
  String get deleteDocumentConfirm => 'حذف هذا المستند من أرشيفك؟';

  @override
  String get deleted => 'تم حذف المستند.';

  @override
  String get noDocuments => 'لا توجد مستندات طبية بعد.';

  @override
  String get openFileFailed => 'تعذر فتح الملف.';

  @override
  String get dateCandidates => 'التواريخ المقترحة';

  @override
  String get suggestedDate => 'التاريخ المقترح';

  @override
  String get confirmDate => 'تأكيد التاريخ';

  @override
  String get confirmDatesTitle => 'تأكيد التواريخ';

  @override
  String get noDocumentsNeedConfirmation =>
      'لا توجد مستندات تتطلب تأكيد التاريخ.';

  @override
  String get noDateDetected => 'لم يتم اكتشاف أي تاريخ.';

  @override
  String get enterReportDate => 'يرجى إدخال تاريخ التقرير.';

  @override
  String get manualDate => 'إدخال التاريخ يدوياً';

  @override
  String get chooseCandidate => 'اختر تاريخاً مقترحاً';

  @override
  String get dateConfirmed => 'تم تأكيد التاريخ.';

  @override
  String get confirmFailed => 'تعذر تأكيد التاريخ.';

  @override
  String get candidateScore => 'الدرجة';

  @override
  String get pageNumber => 'الصفحة';

  @override
  String get ambiguousDate => 'غامض';

  @override
  String get facilitiesTitle => 'المنشآت';

  @override
  String get selectFacility => 'اختيار منشأة';

  @override
  String get searchFacility => 'البحث في المنشآت';

  @override
  String get noFacilities => 'لا توجد منشآت.';

  @override
  String get facilityType => 'نوع المنشأة';

  @override
  String get noneSelected => 'لا شيء';

  @override
  String get archiveTitle => 'الأرشيف';

  @override
  String get archiveSummary => 'الملخص';

  @override
  String get year => 'السنة';

  @override
  String get month => 'الشهر';

  @override
  String get allYears => 'كل السنوات';

  @override
  String get allMonths => 'كل الشهور';

  @override
  String get allTypes => 'كل الأنواع';

  @override
  String get allFacilities => 'كل المنشآت';

  @override
  String get allDates => 'كل التواريخ';

  @override
  String get unconfirmedSection => 'بحاجة لتأكيد التاريخ';

  @override
  String get noArchive => 'لا توجد مستندات في الأرشيف.';

  @override
  String get archiveEmptySubtitle => 'ارفع مستنداً طبياً لبدء أرشيفك.';

  @override
  String get noUnconfirmedArchive => 'لا توجد مستندات بحاجة لتأكيد التاريخ.';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get unconfirmedDates => 'تواريخ غير مؤكدة';

  @override
  String get searchTitle => 'البحث';

  @override
  String get searchHint => 'ابحث في المستندات…';

  @override
  String get searchEmptyQuery => 'ابحث في سجلاتك الطبية';

  @override
  String get searchResults => 'النتائج';

  @override
  String get noResults => 'لا توجد نتائج.';

  @override
  String get searchPlaceholder => 'ابحث حسب محتوى المستند';

  @override
  String get claimTitle => 'المطالبة بحساب';

  @override
  String get claimSubtitle =>
      'إذا كانت لديك سجلات طبية، يمكنك المطالبة بها باستخدام المعرف الرقمي.';

  @override
  String get claimDigitalId => 'المعرف الرقمي';

  @override
  String get claimDigitalIdHint => 'مثال: PT-XXXX-XXXX-XXXX';

  @override
  String get claimEmail => 'البريد الإلكتروني';

  @override
  String get claimPhone => 'الهاتف';

  @override
  String get claimFullName => 'الاسم الكامل';

  @override
  String get claimDob => 'تاريخ الميلاد';

  @override
  String get claimIdType => 'نوع وثيقة الهوية';

  @override
  String get claimIdNumber => 'رقم وثيقة الهوية';

  @override
  String get claimSubmit => 'إرسال المطالبة';

  @override
  String get claimSubmitted => 'تم إرسال مطالبتك. ستتم مراجعتها.';

  @override
  String get claimFailed => 'تعذر إرسال المطالبة.';

  @override
  String get claimPending => 'المطالبة قيد المراجعة';

  @override
  String get healthCheck => 'فحص الاتصال';

  @override
  String get healthReachable => 'الخادم متاح';

  @override
  String get healthUnreachable => 'الخادم غير متاح';

  @override
  String get apiBaseHost => 'مضيف API';

  @override
  String get httpStatus => 'حالة HTTP';

  @override
  String get apiBaseUrl => 'عنوان API الأساسي';

  @override
  String get environment => 'البيئة';

  @override
  String get environmentOnline => 'متصل';

  @override
  String get environmentLocal => 'محلي';

  @override
  String get appFullName => 'PMDAP Records';

  @override
  String get logoSubtitle => 'سجلاتك الطبية، منظمة وآمنة.';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get loginSubtitleSecure => 'الوصول إلى سجلاتك الطبية بأمان.';

  @override
  String get secureFooter => 'وصول آمن إلى سجلاتك';

  @override
  String get claimExistingAccount => 'المطالبة بحساب مريض موجود';

  @override
  String get activateClaimedAccount => 'تفعيل حساب مُطالب به';

  @override
  String get hello => 'مرحباً،';

  @override
  String get medicalRecordOverview => 'هذه لمحة عن سجلك الطبي.';

  @override
  String get patientDigitalId => 'المعرف الرقمي للمريض';

  @override
  String get permanentIdentifier => 'معرف مريض دائم';

  @override
  String get identityVerification => 'التحقق من الهوية';

  @override
  String get manageIdentity => 'إدارة الهوية';

  @override
  String get uploadDocumentShortcut => 'رفع مستند';

  @override
  String get needsConfirmationShortcut => 'تأكيد التواريخ';

  @override
  String get myChildrenShortcut => 'أطفالي';

  @override
  String get identityShortcut => 'الهوية';

  @override
  String get confirmReportDate => 'تأكيد تاريخ التقرير';

  @override
  String get dateConfirmationBanner =>
      'يرجى تأكيد التاريخ الظاهر على التقرير الطبي.';

  @override
  String get confirmSelectedDate => 'تأكيد التاريخ المحدد';

  @override
  String get chooseExistingFile => 'اختر ملف PDF أو صورة';

  @override
  String get chooseExistingFileSubtitle => 'PDF أو JPG أو PNG';

  @override
  String get chooseFileButton => 'اختيار ملف';

  @override
  String get uploadDocumentTitle => 'رفع مستند طبي';

  @override
  String get editDetails => 'تعديل التفاصيل';

  @override
  String get personalDetails => 'معلومات شخصية';

  @override
  String get identityDocumentsTitle => 'وثائق الهوية';

  @override
  String get children => 'الأطفال';

  @override
  String get accountSecurity => 'أمان الحساب';

  @override
  String get aboutPMDAP => 'حول PMDAP';

  @override
  String get help => 'المساعدة';

  @override
  String get recordsOrganized => 'سجلاتك منظمة ومحمية.';

  @override
  String get noRecordsYet => 'لا توجد مستندات طبية بعد';

  @override
  String get noRecordsYetDescription => 'ارفع تقريرك الأول لبدء أرشيفك.';

  @override
  String get noConfirmedRecords => 'لا توجد سجلات مؤكدة بعد';

  @override
  String get noManagedChildren => 'لا يوجد أطفال مدارون';

  @override
  String get tryAnotherSearch => 'جرّب كلمة أخرى أو عدّل الفلاتر.';

  @override
  String get unableToReachPMDAP => 'تعذر الوصول إلى PMDAP';

  @override
  String get checkConnection => 'تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get removeThisDocument => 'إزالة هذا المستند؟';

  @override
  String get removeThisDocumentDescription =>
      'لن يظهر بعد الآن في أرشيفك أو نتائج البحث.';

  @override
  String get remove => 'إزالة';

  @override
  String get logoutTitle => 'تسجيل الخروج من PMDAP Records؟';

  @override
  String get documentsAndActions => 'المستندات والإجراءات';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get language => 'اللغة';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get systemDefault => 'إعداد النظام';

  @override
  String get useDeviceSettings => 'استخدام إعدادات الجهاز';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get profilePhoto => 'صورة الملف الشخصي';

  @override
  String get choosePhoto => 'اختيار صورة';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get removePhoto => 'إزالة الصورة';

  @override
  String get changeProfilePhoto => 'تغيير صورة الملف الشخصي';

  @override
  String get photoUpdated => 'تم تحديث الصورة';

  @override
  String get photoRemoved => 'تمت إزالة الصورة';

  @override
  String get unableToUpdatePhoto => 'تعذر تحديث الصورة';

  @override
  String get removePhotoConfirm => 'إزالة صورة الملف الشخصي؟';

  @override
  String get removePhotoExplain => 'ستظهر الأحرف الأولى من اسمك بدلاً منها.';

  @override
  String get addMedicalDocument => 'إضافة مستند طبي';

  @override
  String get scanDocument => 'مسح المستند';

  @override
  String get scanDocumentSubtitle => 'استخدم كاميرتك لمسح صفحة أو أكثر.';

  @override
  String get selectDocumentType => 'اختر النوع';

  @override
  String get advancedDetails => 'التفاصيل المتقدمة';

  @override
  String get advancedDetailsSubtitle =>
      'اختياري — يمكنك الإضافة أو التعديل لاحقاً.';

  @override
  String get scannedDocument => 'المستند الممسوح';

  @override
  String get pagesLabel => 'صفحات';

  @override
  String get rescan => 'إعادة المسح';

  @override
  String get scannerUnavailable => 'مسح المستندات غير متاح على هذا الجهاز.';

  @override
  String get scanCancelled => 'تم إلغاء المسح';

  @override
  String get startingScanner => 'جارٍ تشغيل الماسح…';

  @override
  String get chooseAnother => 'اختيار آخر';

  @override
  String get scanFront => 'مسح الوجه الأمامي';

  @override
  String get scanBack => 'مسح الوجه الخلفي';

  @override
  String get scanPassport => 'مسح جواز السفر';

  @override
  String get chooseImage => 'اختيار صورة';

  @override
  String get replaceImage => 'استبدال الصورة';

  @override
  String get readDocument => 'قراءة المستند';

  @override
  String get readingDocument => 'جارٍ قراءة المستند…';

  @override
  String get documentReadingFailed => 'فشلت قراءة المستند. حاول مرة أخرى.';

  @override
  String get documentNotRecognized =>
      'تعذر التعرف على المستند. يرجى مسحه مرة أخرى.';

  @override
  String get reviewDocumentInformation => 'مراجعة معلومات المستند';

  @override
  String get reviewDocumentSubtitle =>
      'يرجى التحقق من المعلومات المكتشفة قبل الإرسال.';

  @override
  String get confidenceDetected => 'تم اكتشافه';

  @override
  String get confidencePleaseCheck => 'يرجى التحقق';

  @override
  String get confidenceNeedsReview => 'يحتاج إلى مراجعة';

  @override
  String get couldNotReadThisField => 'تعذر قراءة هذا الحقل';

  @override
  String get mrzVerified => 'تم التحقق من MRZ';

  @override
  String get submitForVerification => 'إرسال للتحقق';

  @override
  String get passportNumber => 'رقم جواز السفر';

  @override
  String get identityExtractionAdvisory =>
      'الاستخراج مجرد اقتراح — يرجى التحقق من جميع القيم قبل الإرسال.';

  @override
  String get identityImagesJpegOrPng =>
      'يجب أن تكون صور الهوية بصيغة JPEG أو PNG.';

  @override
  String get uploadingIdentityDocument => 'جارٍ رفع وثيقة الهوية…';

  @override
  String uploadingIdentityDocumentProgress(Object percent) {
    return 'جارٍ رفع وثيقة الهوية… $percent%';
  }

  @override
  String get submittingIdentityDocument => 'جارٍ إرسال وثيقة الهوية…';

  @override
  String get identityExtractionUnavailable => 'قراءة الوثيقة غير متاحة مؤقتًا.';

  @override
  String get documentReadingMayTakeLonger =>
      'قد تستغرق قراءة الوثيقة وقتًا أطول قليلاً. يمكنك إبقاء هذه الشاشة مفتوحة.';

  @override
  String get identityConflictPending =>
      'توجد بالفعل وثيقة هوية من هذا النوع بانتظار التحقق.';

  @override
  String get identityConflictVerified =>
      'استخدم استبدال الوثيقة لإرسال نسخة جديدة.';

  @override
  String get viewIdentityDocuments => 'عرض وثائق الهوية';

  @override
  String get identityConflictTitle => 'وثيقة الهوية موجودة بالفعل';
}
