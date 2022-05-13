# Specific error handling for the Bing Ads API.


module BingAdsApi
  module Errors

    # This class encapsulates base class for API exceptions. More specific
    # exceptions are generated based on Service WSDL.
    class ApiException < AdsCommonForBingAds::Errors::ApiException
      attr_reader :array_fields

      def initialize(exception_fault)
        @array_fields ||= []
        exception_fault.each { |key, value| set_field(key, value) }
      end

      private

      # Sets instance's property to a value if it is defined
      def set_field(field, value)
        if respond_to?(field)
          value = arrayize(value) if is_array_field(field)
          instance_variable_set("@#{field}", value)
        end
      end

      # Makes sure object is an array
      def arrayize(object)
        return [] if object.nil?
        return object.is_a?(Array) ? object : [object]
      end

      # Should a field be forced to be an array
      def is_array_field(field)
        return @array_fields.include?(field.to_s)
      end
    end

    # Error for invalid credentials sush as malformed ID.
    class BadCredentialsError < AdsCommonForBingAds::Errors::ApiException
    end

    # Error for malformed report definition.
    class InvalidReportDefinitionError < AdsCommonForBingAds::Errors::ApiException
    end

    # Error for server-side report error.
    class ReportError < AdsCommonForBingAds::Errors::ApiException
      attr_reader :http_code

      def initialize(http_code, message)
        super(message)
        @http_code = http_code
      end
    end

    CODES = {
      # Common Error Codes
      # http://msdn.microsoft.com/en-us/library/bb672016.aspx
      "0" => "InternalError",
      "100" => "NullRequest",
      "105" => "InvalidCredentials",
      "106" => "UserIsNotAuthorized",
      "107" => "QuotaNotAvailable",
      "113" => "InvalidDateObject",
      "116" => "RequestMissingHeaders",
      "201" => "ApiInputValidationError",
      "202" => "ApiExecutionError",
      "203" => "NullParameter",
      "204" => "OperationNotSupported",
      "205" => "InvalidVersion",
      "206" => "NullArrayArgument",
      "207" => "ConcurrentRequestOverLimit",
      "208" => "InvalidAccount",
      "209" => "TimestampNotMatch",
      "210" => "EntityNotExistent",
      "211" => "NameTooLong",
      "512" => "FilterListOverLimit",
      # Campaign Management Error Codes
      # http://msdn.microsoft.com/en-us/library/bb671735.aspx
      "1001" => "CampaignServiceCannotChangeStatusOnUpdate",
      "1003" => "CampaignServiceCannotSpecifyStatusOnAdd",
      "1004" => "CampaignServiceIdShouldBeNullOnAdd",
      "1005" => "CampaignServiceInvalidNegativeKeyword",
      "1006" => "CampaignServiceNegativeKeywordsTotalLengthExceeded",
      "1007" => "CampaignServiceNegativeKeywordMatchesKeyword",
      "1008" => "CampaignServiceInvalidAccountStatus",
      "1009" => "CampaignServiceAccountIdMissingInRequestHeader",
      "1010" => "CampaignServiceSystemInReadOnlyMode",
      "1011" => "CampaignServiceFutureFeatureCode",
      "1012" => "CampaignServiceInvalidNegativeSiteURL",
      "1013" => "CampaignServiceNegativeSiteURLExceededMaxCount",
      "1014" => "CampaignServiceTimeZoneValueInvalid",
      "1015" => "CampaignServiceCurrencyValueInvalid",
      "1016" => "CampaignServiceInvalidEntityState",
      "1017" => "CampaignServiceInvalidSearchBids",
      "1018" => "CampaignServiceInvalidContentBid",
      "1019" => "CampaignServiceCashbackAllowedOnlyForSearchMedium",
      "1020" => "CampaignServiceCashbackNotAllowedForAdgroupsDistributionChannel",
      "1021" => "CampaignServiceAccountNotEligbleForKeywordLevelCashback",
      "1022" => "CampaignServiceCampaignCashbackNeedToBeEnabledBeforeEnablingAdgroup",
      "1023" => "CampaignServiceAccountNotEligibleToModifyCashBack",
      "1024" => "CampaignServiceAccountNotEligibleToSetCashbackAmount",
      "1025" => "CampaignServiceInvalidCashbackAmount",
      "1026" => "CampaignServiceCashbackTextTooLong",
      "1027" => "CampaignServiceCashBackStatusRequired",
      "1028" => "CampaignServiceCashbackInfoShouldBeNullForBackwardCompatability",
      "1029" => "CampaignServiceCustomerIdHasToBeSpecified",
      "1030" => "CampaignServiceAccountIdHasToBeSpecified",
      "1031" => "CampaignServiceCannotPerformCurrentOperation",
      "2928" => "CampaignServiceCustomerDataBeingMigrated",
      "1032" => "CampaignServiceNegativeKeywordsLimitExceeded",
      "1033" => "CampaignServiceNegativeKeywordsEntityLimitExceeded",
      "1034" => "CampaignServiceNegativeKeywordsNotPassed",
      "1100" => "CampaignServiceInvalidCampaignId",
      "1101" => "CampaignServiceInvalidCampaignName",
      "1102" => "CampaignServiceInvalidAccountId",
      "1103" => "CampaignServiceNullCampaign",
      "1104" => "CampaignServiceInvalidCampaignDescription",
      "1105" => "CampaignServiceInvalidMonthlyBudget",
      "1106" => "CampaignServiceInvalidDailyBudget",
      "1107" => "CampaignServiceDuplicateCampaignIds",
      "1108" => "CampaignServiceInvalidConversionTrackingEnabled",
      "1109" => "CampaignServiceTimeZoneNotEnabled",
      "1110" => "CampaignServiceDaylightSavingNotEnabled",
      "1111" => "CampaignServiceInvalidConversionTrackingScriptSet",
      "1113" => "CampaignServiceCampaignsArrayShouldNotBeNullOrEmpty",
      "1114" => "CampaignServiceCampaignsArrayExceedsLimit",
      "1115" => "CampaignServiceCannotCreateDuplicateCampaign",
      "1117" => "CampaignServiceMaximumCampaignsReached",
      "1118" => "CampaignServiceCampaignIdsArrayShouldNotBeNullOrEmpty",
      "1119" => "CampaignServiceCampaignIdsArrayExceedsLimit",
      "1120" => "CampaignServiceInvalidCampaignStatus",
      "1121" => "CampaignServiceInvalidBudgetType",
      "1122" => "CampaignServiceCampaignNotEligibleForCashBack",
      "1123" => "CampaignServiceCampaignBudgetAmountIsLessThanSpendAmount",
      "1129" => "CampaignServiceCampaignAlreadyExists",
      "1130" => "CampaignServiceNullCampaignNegativeKeywords",
      "1200" => "CampaignServiceNullAdGroup",
      "1201" => "CampaignServiceInvalidAdGroupId",
      "1202" => "CampaignServiceInvalidAdGroupName",
      "1203" => "CampaignServiceDuplicateInAdGroupIds",
      "1204" => "CampaignServiceAdGroupEndDateShouldBeAfterStartDate",
      "1205" => "CampaignServiceCannotUpdateLanguageAndRegion",
      "1208" => "CampaignServiceCampaignBudgetLessThanAdGroupBudget",
      "1209" => "CampaignServiceAdGroupsArrayShouldNotBeNullOrEmpty",
      "1210" => "CampaignServiceAdGroupsArrayExceedsLimit",
      "1211" => "CampaignServiceAdGroupUserNotAllowedContentMedium",
      "1212" => "CampaignServiceAdGroupStartDateLessThanCurrentDate",
      "1213" => "CampaignServiceMaximumAdGroupsReached",
      "1214" => "CampaignServiceCannotCreateDuplicateAdGroup",
      "1215" => "CampaignServiceCannotUpdateAdGroupInExpiredState",
      "1216" => "CampaignServiceCannotUpdateAdGroupInSubmittedState",
      "1217" => "CampaignServiceCannotOperateOnAdGroupInCurrentState",
      "1218" => "CampaignServiceAdGroupIdsArrayShouldNotBeNullOrEmpty",
      "1219" => "CampaignServiceAdGroupIdsArrayExceedsLimit",
      "1220" => "CampaignServiceMissingDistributionChannel",
      "1221" => "CampaignServiceAdGroupInvalidDistributionChannel",
      "1222" => "CampaignServiceAdGroupInvalidMedium",
      "1223" => "CampaignServiceAdGroupMediumNotAllowedForDistributionChannel",
      "1224" => "CampaignServiceAdGroupMissingAdMedium",
      "1225" => "CampaignServiceUserNotAuthorizedForDistributionChannel",
      "1226" => "CampaignServiceNeedAtleastOneAdAndOneKeywordToSubmit",
      "1227" => "CampaignServiceAdGroupStartDateCannotBeEarlierThanSubmitDate",
      "1228" => "CampaignServiceCannotSetPricingModelOnAdGroup",
      "1229" => "CampaignServiceCannotSetSearchBidOnAdGroup",
      "1230" => "CampaignServiceCannotSetContentBidOnAdGroup",
      "1231" => "CampaignServiceAdGroupExpired",
      "1232" => "CampaignServiceAdGroupInvalidStartDate",
      "1233" => "CampaignServiceAdGroupInvalidEndDate",
      "1234" => "CampaignServiceAdGroupPricingModelCpmRequiresContentMedium",
      "1235" => "CampaignServiceAdGroupInvalidMediumForCustomer",
      "1236" => "CampaignServiceAdGroupPricingModelCpmIsNotEnabledForCustomer",
      "1237" => "CampaignServiceAdGroupPricingModelIsNull",
      "1239" => "CampaignServiceTypeCanBeBehavioralBidOnlyForContentAdGroups",
      "1240" => "CampaignServiceTypeCanBeSitePlacementOnlyForContentAdGroups",
      "1241" => "CampaignServiceCannotUpdateBiddingModel",
      "1242" => "CampaignServiceCannotUpdateAdDistributionForThisType",
      "1243" => "CampaignServiceTooManyAdGroupsInAccount",
      "1244" => "AdGroupServiceNullAdGroupNegativeKeywords",
      "1245" => "AdGroupServiceNegativeSiteUrlsNotPassed",
      "1300" => "CampaignServiceNullAd",
      "1301" => "CampaignServiceInvalidAdTitle",
      "1302" => "CampaignServiceInvalidAdDestinationUrl",
      "1303" => "CampaignServiceAdIdIsNull",
      "1304" => "CampaignServiceAdIdIsNonNull",
      "1305" => "CampaignServiceAdTypeIsNonNull",
      "1306" => "CampaignServiceInvalidAdText",
      "1307" => "CampaignServiceInvalidAdDisplayUrl",
      "1308" => "CampaignServiceInvalidAdId",
      "1309" => "CampaignServiceDuplicateInAdIds",
      "1310" => "CampaignServiceAdsArrayShouldNotBeNullOrEmpty",
      "1311" => "CampaignServiceAdsArrayExceedsLimit",
      "1312" => "CampaignServiceMaxAdsReached",
      "1313" => "CampaignServiceDuplicateAd",
      "1314" => "CampaignServiceDefaultAdExists",
      "1315" => "CampaignServiceSyntaxErrorInAdTitle",
      "1316" => "CampaignServiceSyntaxErrorInAdText",
      "1317" => "CampaignServiceSyntaxErrorInAdDisplayUrl",
      "1318" => "CampaignServiceForbiddenTextInAdTitle",
      "1319" => "CampaignServiceForbiddenTextInAdText",
      "1320" => "CampaignServiceForbiddenTextInAdDisplayUrl",
      "1321" => "CampaignServiceIncorrectAdFormatInTitle",
      "1322" => "CampaignServiceIncorrectAdFormatInText",
      "1323" => "CampaignServiceIncorrectAdFormatInDisplayUrl",
      "1324" => "CampaignServiceTooMuchAdTextInTitle",
      "1325" => "CampaignServiceTooMuchAdTextInText",
      "1326" => "CampaignServiceTooMuchAdTextInDisplayUrl",
      "1327" => "CampaignServiceTooMuchAdTextInDestinationUrl",
      "1328" => "CampaignServiceNotEnoughAdText",
      "1329" => "CampaignServiceExclusiveWordInAdTitle",
      "1330" => "CampaignServiceExclusiveWordInAdText",
      "1331" => "CampaignServiceExclusiveWordInAdDisplayUrl",
      "1332" => "CampaignServiceInvalidAdDisplayUrlFormat",
      "1333" => "CampaignServiceDefaultAdSyntaxErrorInTitle",
      "1334" => "CampaignServiceDefaultAdSyntaxErrorInText",
      "1335" => "CampaignServiceDefaultAdSyntaxErrorInDisplayUrl",
      "1336" => "CampaignServiceDefaultAdForbiddenWordInTitle",
      "1337" => "CampaignServiceDefaultAdForbiddenWordInText",
      "1338" => "CampaignServiceDefaultAdForbiddenWordInDisplayUrl",
      "1339" => "CampaignServiceDefaultAdIncorrectAdFormatInTitle",
      "1340" => "CampaignServiceDefaultAdIncorrectAdFormatInText",
      "1341" => "CampaignServiceDefaultAdIncorrectAdFormatInDisplayUrl",
      "1342" => "CampaignServiceDefaultAdTooMuchTextInTitle",
      "1343" => "CampaignServiceDefaultAdTooMuchTextInText",
      "1344" => "CampaignServiceDefaultAdTooMuchTextInDisplayUrl",
      "1345" => "CampaignServiceDefaultAdTooMuchTextInDestinationUrl",
      "1346" => "CampaignServiceDefaultAdNotEnoughAdText",
      "1347" => "CampaignServiceDefaultAdExclusiveWordInTitle",
      "1348" => "CampaignServiceDefaultAdExclusiveWordInText",
      "1349" => "CampaignServiceDefaultAdExclusiveWordInDisplayUrl",
      "1350" => "CampaignServiceDefaultAdInvalidDisplayUrlFormat",
      "1351" => "CampaignServiceAdIdsArrayShouldNotBeNullOrEmpty",
      "1352" => "CampaignServiceAdIdsArrayExceedsLimit",
      "1353" => "CampaignServiceTooMuchTextInTitleAcrossAllAssociations",
      "1354" => "CampaignServiceTooMuchTextInTextAcrossAllAssociations",
      "1355" => "CampaignServiceTooMuchTextInDisplayUrlAcrossAllAssociations",
      "1356" => "CampaignServiceNothingToUpdateInAdRequest",
      "1357" => "CampaignServiceCannotOperateOnAdInCurrentState",
      "1358" => "CampaignServiceDefaultAdInvalidDestinationUrlFormat",
      "1359" => "CampaignServiceInvalidAdDestinationUrlFormat",
      "1360" => "CampaignServiceAdTypeDoesNotMatch",
      "1361" => "CampaignServiceInvalidBusinessName",
      "1362" => "CampaignServiceInvalidPhoneNumber",
      "1363" => "CampaignServiceMobileAdRequiredDataMissing",
      "1364" => "CampaignServiceMobileAdSupportedForSearchOnlyAdGroups",
      "1365" => "CampaignServiceMobileAdNotSupportedForThisMarket",
      "1366" => "CampaignServiceAdTypeInvalidForCustomer",
      "1367" => "CampaignServiceTooMuchAdTextInBusinessName",
      "1368" => "CampaignServiceTooMuchAdTextInPhoneNumber",
      "1370" => "CampaignServicePhoneNumberNotAllowedForCountry",
      "1371" => "CampaignServiceBlockedPhoneNumber",
      "1372" => "CampaignServicePhoneNumberNotAllowedInAdTitle",
      "1373" => "CampaignServicePhoneNumberNotAllowedInAdText",
      "1374" => "CampaignServicePhoneNumberNotAllowedInAdDisplayUrl",
      "1375" => "CampaignServicePhoneNumberNotAllowedInAdBusinessName",
      "1376" => "CampaignServiceEditorialErrorInAdTitle",
      "1377" => "CampaignServiceEditorialErrorInAdText",
      "1378" => "CampaignServiceEditorialErrorInAdDisplayUrl",
      "1379" => "CampaignServiceEditorialErrorInAdDestinationUrl",
      "1380" => "CampaignServiceEditorialErrorInAdBusinessName",
      "1381" => "CampaignServiceEditorialErrorInAdPhoneNumber",
      "1382" => "CampaignServiceInvalidAdStatus",
      "1383" => "CampaignServiceInvalidAdEditorialStatus",
      "1384" => "CampaignServiceCannotSetExemptionRequestOnAd",
      "1385" => "CampaignServiceUpdateAdEmpty",
      "1386" => "CampaignServiceAdTypeDoesNotMatchExistingValue",
      "1387" => "CampaignServiceEditorialAdTitleBlankAcrossAllAssociations",
      "1388" => "CampaignServiceEditorialAdTitleBlank",
      "1389" => "CampaignServiceEditorialAdTextBlankAcrossAllAssociations",
      "1390" => "CampaignServiceEditorialAdTextBlank",
      "1391" => "CampaignServiceEditorialAdDisplayUrlBlankAcrossAllAssociations",
      "1392" => "CampaignServiceEditorialAdDisplayUrlBlank",
      "1393" => "CampaignServiceEditorialAdDestinationUrlBlank",
      "1394" => "CampaignServiceAdDeleted",
      "1395" => "CampaignServiceAdInInvalidStatus",
      "1396" => "CampaignServiceDefaultAdTooMuchTextInBusniessName",
      "1397" => "CampaignServiceEditorialGenericError",
      "2802" => "CampaignServiceCannotChangeImageUrlOnUpdate",
      "2803" => "CampaignServiceDefaultAdTooMuchTextInAltText",
      "1400" => "CampaignServiceNullTarget",
      "1401" => "CampaignServiceInvalidTargetId",
      "1402" => "CampaignServiceNoBidsInTarget",
      "1403" => "CampaignServiceInvalidDayTarget",
      "1404" => "CampaignServiceInvalidHourTarget",
      "1405" => "CampaignServiceInvalidLocationTarget",
      "1406" => "CampaignServiceInvalidGenderTarget",
      "1407" => "CampaignServiceInvalidAgeTarget",
      "1408" => "CampaignServiceDuplicateDayTarget",
      "1409" => "CampaignServiceDuplicateHourTarget",
      "1410" => "CampaignServiceDuplicateMetroAreaLocationTarget",
      "1411" => "CampaignServiceDuplicateCountryLocationTarget",
      "1412" => "CampaignServiceDuplicateGenderTarget",
      "1413" => "CampaignServiceDuplicateAgeTarget",
      "1414" => "CampaignServiceCountryAndMetroAreaTargetsExclusive",
      "1415" => "CampaignServiceMetroTargetsFromMultipleCountries",
      "1416" => "CampaignServiceIncrementalBudgetAmountRequiredForDayTarget",
      "1417" => "CampaignServiceGeoTargetsInAdGroupExceedsLimit",
      "1418" => "CampaignServiceDuplicateInTargetIds",
      "1419" => "CampaignServiceTargetGroupAssignedEntitiesPermissionMismatch",
      "1420" => "CampaignServiceTargetsNotPassed",
      "1421" => "CampaignServiceTargetAlreadyExists",
      "1422" => "CampaignServiceTargetsLimitReached",
      "1423" => "CampaignServiceInvalidGeoLocationLevel",
      "1424" => "CampaignServiceAdGroupMediumInvalidWithBusinessTargets",
      "1425" => "CampaignServiceTargetsArrayExceedsLimit",
      "1426" => "CampaignServiceTargetNotAssociatedWithEntity",
      "1427" => "CampaignServiceTargetAlreadyAssociatedWithEntity",
      "1428" => "CampaignServiceTargetHasActiveAssociations",
      "1429" => "CampaignServiceInvalidTarget",
      "1430" => "CampaignServiceBTTargettingNotEnabledForPilot",
      "1431" => "CampaignServiceInvalidBehaviorTarget",
      "1432" => "CampaignServiceDuplicateBehaviorTarget",
      "1433" => "CampaignServiceInvalidSegmentTarget",
      "1434" => "CampaignServiceDuplicateSegmentTarget",
      "1435" => "CampaignServiceNegativeBiddingNotAllowedForThisTargetType",
      "1436" => "CampaignServiceInvalidCashbackTextinSegmentTarget",
      "1437" => "CampaignServiceInvalidParam1inSegmentTarget",
      "1438" => "CampaignServiceInvalidParam2inSegmentTarget",
      "1439" => "CampaignServiceInvalidParam3inSegmentTarget",
      "1440" => "CampaignServiceInvalidSegmentParam1inSegmentTarget",
      "1441" => "CampaignServiceInvalidSegmentParam2inSegmentTarget",
      "1442" => "CampaignServiceCannotSpecifySegmentTargetsWithAnyOtherTarget",
      "1443" => "CampaignServiceBusinessLocationsNotPassed",
      "1444" => "CampaignServiceInvalidBusinessLocationHours",
      "1445" => "CampaignServiceInvalidAddress",
      "1446" => "CampaignServiceBusinessLocationTargetsLimitReachedForCustomer",
      "1447" => "CampaignServiceBusinessLocationTargetsLimitReachedForAdGroup",
      "1448" => "CampaignServiceBusinessLocationTargetsLimitReachedForCampaign",
      "1449" => "CampaignServiceTargetsAgeBidsBatchLimitExceeded",
      "1450" => "CampaignServiceTargetsDayBidsBatchLimitExceeded",
      "1451" => "CampaignServiceTargetsHourBidsBatchLimitExceeded",
      "1452" => "CampaignServiceTargetsGenderBidsBatchLimitExceeded",
      "1453" => "CampaignServiceTargetsLocationBidsBatchLimitExceeded",
      "1454" => "CampaignServiceTargetsSegmentBidsBatchLimitExceeded",
      "1455" => "CampaignServiceTargetsBehaviorBidsBatchLimitExceeded",
      "1456" => "CampaignServiceInvalidBusinessLocationId",
      "1457" => "CampaignServiceInvalidTargetRadius",
      "1458" => "CampaignServiceInvalidLatitude",
      "1459" => "CampaignServiceInvalidLongitude",
      "1460" => "CampaignServiceDuplicateSubGeographyTarget",
      "1461" => "CampaignServiceDuplicateCityTarget",
      "1462" => "CampaignServiceDuplicateBusinessLocationTarget",
      "1463" => "CampaignServiceDuplicateCustomLocationTarget",
      "1464" => "CampaignServiceInvalidLocationId",
      "1465" => "CampaignServiceGeoLocationOptionsRequired",
      "1466" => "CampaignServiceUnsupportedCombinationOfLocationIdAndOptions",
      "1467" => "CampaignServiceInvalidGeographicalLocationSearchString",
      "1468" => "CampaignServiceGeoTargetsAndBusinessTargetsMutuallyExclusive",
      "1469" => "CampaignServiceBusinessLocationNotSet",
      "1470" => "CampaignServiceBusinessNameRequired",
      "1471" => "CampaignServiceLattitudeLongitudeRequired",
      "1472" => "CampaignServiceBusinessNameTooLong",
      "1473" => "CampaignServiceDomainNameAlreadyTaken",
      "1474" => "CampaignServiceBusinessDescriptionTooLong",
      "1475" => "CampaignServiceInvalidBusinessTypeId",
      "1476" => "CampaignServiceInvalidPaymentTypeId",
      "1477" => "CampaignServiceInvalidBusinessHoursEntry",
      "1478" => "CampaignServiceAddressRequired",
      "1479" => "CampaignServiceAddressTooLong",
      "1480" => "CampaignServiceCityNameRequired",
      "1481" => "CampaignServiceCityNameTooLong",
      "1482" => "CampaignServiceCountryCodeRequired",
      "1483" => "CampaignServiceCountryCodeTooLong",
      "1484" => "CampaignServiceStateOrProvinceRequired",
      "1485" => "CampaignServiceStateOrProvinceTooLong",
      "1486" => "CampaignServiceLocationIsNotSpecified",
      "1487" => "CampaignServiceOpen24HoursAndBusinessHoursMutuallyExclusive",
      "1488" => "CampaignServiceBusinessNameAndAddressAlreadyExists",
      "1489" => "CampaignServiceBusinessLocationListTooLong",
      "1490" => "CampaignServiceInvalidCustomerId",
      "1491" => "InvalidDomainName",
      "1492" => "CampaignServiceBusinessDomainNameNotSet",
      "1493" => "CampaignServiceBusinessDomainTimestampMismatch",
      "1494" => "CampaignServiceTimestampRequiredForBusinessDomainNameModification",
      "1495" => "CampaignServiceBusinessDomainAlreadySet",
      "1496" => "CampaignServiceDomainNameUnknown",
      "1497" => "CampaignServiceOnlyOneBusinessLocationPerCustomerIsAllowed",
      "1498" => "CampaignServiceBiddingOtherThanZeroNotAllowedForThisTargetType",
      "1499" => "CampaignServiceTargetingShouldBeExclusiveForThisTargetType",
      "2900" => "CampaignServiceInvalidCashbackAmountInSegmentTarget",
      "2902" => "CampaignServiceInvalidTargetName",
      "2904" => "CampaignServiceTargetInvalidForCustomer",
      "2909" => "CampaignServiceIsLibraryTargetNotNull",
      "2918" => "CampaignServiceBusinessAndRadiusTargetsAllowedOnlyForSearchMedium",
      "2919" => "CampaignServiceAssociatingNonLibraryTargetNotAllowed",
      "1500" => "CampaignServiceNullKeyword",
      "1501" => "CampaignServiceInvalidKeywordId",
      "1502" => "CampaignServiceDuplicateInKeywordIds",
      "1503" => "CampaignServiceInvalidKeywordText",
      "1504" => "CampaignServiceCannotChangeTextOnUpdate",
      "1505" => "CampaignServiceKeywordsArrayShouldNotBeNullOrEmpty",
      "1506" => "CampaignServiceKeywordsArrayExceedsLimit",
      "1507" => "CampaignServiceInvalidBidAmounts",
      "1508" => "CampaignServiceInvalidBidAmountForSearchAdGroup",
      "1509" => "CampaignServiceInvalidBidAmountForContentAdGroup",
      "1510" => "CampaignServiceInvalidBidAmountForHybridAdGroup",
      "1511" => "CampaignServiceInvalidParam1",
      "1512" => "CampaignServiceInvalidParam2",
      "1513" => "CampaignServiceInvalidParam3",
      "1514" => "CampaignServiceNegativeKeywordRequiresPartialMatchBid",
      "1515" => "CampaignServiceBidAmountsLessThanFloorPrice",
      "1516" => "CampaignServiceBidAmountsGreaterThanCeilingPrice",
      "1517" => "CampaignServiceDuplicateKeyword",
      "1518" => "CampaignServiceMaxKeywordsReachedForAccount",
      "1519" => "CampaignServiceMaxKeywordsReachedForAdGroup",
      "1520" => "CampaignServiceForbiddenWordInKeywordText",
      "1521" => "CampaignServiceForbiddenWordInParam1",
      "1522" => "CampaignServiceForbiddenWordInParam2",
      "1523" => "CampaignServiceForbiddenWordInParam3",
      "1524" => "CampaignServiceExclusiveWordInKeywordText",
      "1525" => "CampaignServiceExclusiveWordInParam1",
      "1526" => "CampaignServiceExclusiveWordInParam2",
      "1527" => "CampaignServiceExclusiveWordInParam3",
      "1528" => "CampaignServiceKeywordDoesNotBelongToAdGroupId",
      "1529" => "CampaignServiceKeywordIdsArrayShouldNotBeNullOrEmpty",
      "1530" => "CampaignServiceKeywordIdsArrayExceedsLimit",
      "1531" => "CampaignServiceInvalidKeywordStatus",
      "1532" => "CampaignServiceInvalidKeywordEditorialStatus",
      "1533" => "CampaignServiceCannotSetExemptionRequestOnKeyword",
      "1534" => "CampaignServiceUpdateKeywordEmpty",
      "1535" => "CampaignServiceKeywordQualityScoreOperationNotEnabledForCustomer",
      "1536" => "CampaignServiceDuplicateKeywordIdInRequest",
      "1537" => "CampaignServiceCCannotAddKeywordToSpecifiedAdGroup",
      "1700" => "CampaignServiceNullKeywordBid",
      "1701" => "CampaignServiceKeywordBidsArrayShouldNotBeNullOrEmpty",
      "1702" => "CampaignServiceKeywordBidsArrayExceedsLimit",
      "1703" => "CampaignServiceKeywordBidsInvalidKeyword",
      "1704" => "CampaignServiceAtleastOneKeywordBidShouldBeSpecified",
      "1705" => "CampaignServiceInvalidLanguageAndRegionValue",
      "1900" => "CampaignServiceNullSegment",
      "1901" => "CampaignServiceInvalidSegmentId",
      "1902" => "CampaignServiceDuplicateInSegmentIds",
      "1903" => "CampaignServiceInvalidSegmentName",
      "1904" => "CampaignServiceInvalidUserHash",
      "1905" => "CampaignServiceSegmentsArrayShouldNotBeNullOrEmpty",
      "1906" => "CampaignServiceSegmentsArrayExceedsLimit",
      "1907" => "CampaignServiceDuplicateSegmentName",
      "1908" => "CampaignServiceSegmentOperationNotAllowedForPilot",
      "1909" => "CampaignServiceUserHashArrayShouldNotBeNullOrEmpty",
      "1910" => "CampaignServiceUserHashArrayExceedsLimit",
      "1911" => "CampaignServiceSegmentIdsArrayShouldNotBeNullOrEmpty",
      "1912" => "CampaignServiceSegmentIdsArrayExceedsLimit",
      "1913" => "CampaignServiceMaxSegmentsForCustomerHasBeenReached",
      "1914" => "CampaignServiceSegmentNotAllowedForDistributionChannel",
      "2500" => "CampaignServiceNullBusiness",
      "2501" => "CampaignServiceInvalidBusinessId",
      "2502" => "CampaignServiceDuplicateInBusinessIds",
      "2503" => "CampaignServiceBusinessesArrayShouldNotBeNullOrEmpty",
      "2504" => "CampaignServiceBusinessesArrayExceedsLimit",
      "2505" => "CampaignServiceBusinessIdsArrayShouldNotBeNullOrEmpty",
      "2506" => "CampaignServiceBusinessIdsArrayExceedsLimit",
      "2507" => "CampaignServiceInvalidBusinessStatus",
      "2508" => "CampaignServiceInvalidBusinessGeoCodeStatus",
      "2509" => "CampaignServiceInvalidBusinessLatitude",
      "2510" => "CampaignServiceInvalidBusinessLongitude",
      "2511" => "CampaignServiceInvalidCustomIconAssetId",
      "2901" => "CampaignServiceBusinessLocationBeginAndEndHoursMismatch",
      "2903" => "CampaignServiceDuplicatePaymentTypes",
      "2905" => "CampaignServiceInvalidEmail",
      "2906" => "CampaignServiceEmailTooLong",
      "2907" => "CampaignServiceBusinessPhoneNumberInvalid",
      "2908" => "CampaignServicePhoneNumberTooLong",
      "2910" => "CampaignServiceInvalidLatitudeLongitudeForBusinessLocation",
      "2914" => "CampaignServiceZipOrPostalCodeTooLong",
      "2915" => "CampaignServiceBusinessDescriptionRequired",
      "2916" => "CampaignServiceDuplicateBusinessHours",
      "2917" => "CampaignServiceAddressInvalid",
      "2920" => "CampaignServiceBusinessAddressShouldBeValidForUpdate",
      "2921" => "CampaignServiceBusinessHasActiveAssociations",
      "2600" => "CampaignServiceNullSitePlacement",
      "2601" => "CampaignServiceInvalidSitePlacementId",
      "2602" => "CampaignServiceDuplicateInSitePlacementIds",
      "2603" => "CampaignServiceSitePlacementsArrayShouldNotBeNullOrEmpty",
      "2604" => "CampaignServiceSitePlacementsArrayExceedsLimit",
      "2605" => "CampaignServiceSitePlacementOperationNotAllowedForPilot",
      "2606" => "CampaignServiceSitePlacementIdsArrayShouldNotBeNullOrEmpty",
      "2607" => "CampaignServiceSitePlacementIdsArrayExceedsLimit",
      "2608" => "CampaignServiceUrlsArrayShouldNotBeNullOrEmpty",
      "2609" => "CampaignServiceUrlsArrayExceedsLimit",
      "2610" => "CampaignServiceNullUrl",
      "2611" => "CampaignServiceInvalidUrl",
      "2612" => "CampaignServiceInvalidPlacementId",
      "2613" => "CampaignServiceCannotChangeUrlOnUpdate",
      "2614" => "CampaignServiceCannotChangePlacementIdOnUpdate",
      "2615" => "CampaignServiceNothingToUpdateInSitePlacementRequest",
      "2616" => "CampaignServiceCannotAddSitePlacementToSpecifiedAdGroup",
      "2617" => "CampaignServiceInvalidSitePlacementStatus",
      "2618" => "CampaignServiceDuplicateSitePlacement",
      "2700" => "CampaignServiceNullBehavioralBid",
      "2701" => "CampaignServiceInvalidBehavioralBidId",
      "2702" => "CampaignServiceDuplicateInBehavioralBidIds",
      "2703" => "CampaignServiceBehavioralBidsArrayShouldNotBeNullOrEmpty",
      "2704" => "CampaignServiceBehavioralBidsArrayExceedsLimit",
      "2705" => "CampaignServiceBehavioralBidOperationNotAllowedForPilot",
      "2706" => "CampaignServiceBehavioralBidIdsArrayShouldNotBeNullOrEmpty",
      "2707" => "CampaignServiceBehavioralBidIdsArrayExceedsLimit",
      "2708" => "CampaignServiceInvalidBehavioralBidName",
      "2709" => "CampaignServiceCannotChangeBehavioralName",
      "2710" => "CampaignServiceNothingToUpdateInBehavioralBidRequest",
      "2711" => "CampaignServiceCannotAddBehavioralBidToSpecifiedAdGroup",
      "2712" => "CampaignServiceBTBiddingNotEnabledForPilot",
      "2713" => "CampaignServiceDuplicateBehavioralBid",
      "2714" => "CampaignServiceInvalidBehavioralBidStatus",
      "2715" => "CampaignServiceInvalidMediumAndBiddingStrategyCombination",
      # Reporting API Error Codes
      # http://msdn.microsoft.com/en-US/library/bb672083(v=msads.70)
      "2001" => "ReportingServiceNullReportRequest",
      "2002" => "ReportingServiceUnknownReportType",
      "2003" => "ReportingServiceAccountNotAuthorized",
      "2004" => "ReportingServiceNoCompleteDataAvaliable",
      "2005" => "ReportingServiceInvalidDataAvailabilityAndTimePeriodCombination",
      "2006" => "ReportingServiceInvalidReportName",
      "2007" => "ReportingServiceInvalidReportAggregation",
      "2008" => "ReportingServiceInvalidReportTimeSelection",
      "2009" => "ReportingServiceInvalidCustomDateRangeStart",
      "2010" => "ReportingServiceInvalidCustomDateRangeEnd",
      "2011" => "ReportingServiceEndDateBeforeStartDate",
      "2012" => "ReportingServiceEmptyCustomDates",
      "2013" => "ReportingServiceCustomDatesOverlimit",
      "2014" => "ReportingServiceNullColumns",
      "2015" => "ReportingServiceRequiredColumnsNotSelected",
      "2016" => "ReportingServiceDuplicateColumns",
      "2017" => "ReportingServiceNoMeasureSelected",
      "2018" => "ReportingServiceInvalidAccountIdInCampaignReportScope",
      "2019" => "ReportingServiceInvalidCampaignIdInCampaignReportScope",
      "2020" => "ReportingServiceInvalidAccountIdInAdGroupReportScope",
      "2021" => "ReportingServiceInvalidCampaignIdInAdGroupReportScope",
      "2022" => "ReportingServiceInvalidAdGroupIdInAdGroupReportScope",
      "2023" => "ReportingServiceInvalidAccountIdInAccountReportScope",
      "2024" => "ReportingServiceNullCampaignReportScope",
      "2025" => "ReportingServiceNullAdGroupReportScope",
      "2026" => "ReportingServiceInvalidAccountReportScope",
      "2027" => "ReportingServiceInvalidAccountThruCampaignReportScope",
      "2028" => "ReportingServiceInvalidAccountThruAdGroupReportScope",
      "2029" => "ReportingServiceAccountsOverLimit",
      "2030" => "ReportingServiceMaximumCampaignsLimitReached",
      "2031" => "ReportingServiceAdGroupsOverLimit",
      "2032" => "ReportingServiceCrossSiteScriptNotAllowed",
      "2033" => "ReportingServiceInvalidKeywordFilterValue",
      "2034" => "ReportingServiceInvalidTimePeriodColumnForSummaryReport",
      "2035" => "ReportingServiceInvalidAccountIds",
      "2036" => "ReportingServiceBehavioralIdMaxArraySizeReached",
      "2037" => "ReportingServiceInvalidBehavioralIdValue",
      "2038" => "ReportingServiceSiteIdMaxArraySizeReached",
      "2039" => "ReportingServiceInvalidSiteIdValue",
      "2040" => "ReportingServiceInvalidCustomDateRange",
      "2041" => "ReportingServiceInvalidFutureStartDate",
      "2042" => "ReportingServiceInvalidSearchQueryFilterValue",
      "2043" => "ReportingServiceSearchQueryFilterValueLengthExceeded",
      "2044" => "ReportingServiceSearchQueryOverLimit",
      "2045" => "ReportingServiceKeywordFilterValueLengthExceeded",
      "2046" => "ReportingServiceKeywordOverLimit",
      "2100" => "ReportingServiceInvalidReportId",
      "2101" => "ReportingServiceReportNotFound",
    }
    CODES.each do |_, constant|
      unless const_defined?(constant)
        const_set(constant,Class.new(AdsCommonForBingAds::Errors::ApiException))
      end
    end

  end
end