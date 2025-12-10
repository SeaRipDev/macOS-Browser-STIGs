#!/bin/bash

################################################################################
# Browser STIG Compliance Verification Script
#
# Purpose: Verifies STIG compliance for Chrome, Firefox, and Edge browsers
# Created for: macOS 26
# STIGs: Chrome V2R11, Firefox V6R6, Edge V2R3
#
# Usage: sudo ./verify_browser_stig_compliance.sh
################################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
CHROME_PASS=0
CHROME_FAIL=0
FIREFOX_PASS=0
FIREFOX_FAIL=0
EDGE_PASS=0
EDGE_FAIL=0

echo ""
echo "=========================================================================="
echo "           Browser STIG Compliance Verification Script"
echo "=========================================================================="
echo ""
echo "Checking STIG compliance for Chrome V2R11, Firefox V6R6, and Edge V2R3"
echo "Date: $(date)"
echo ""

################################################################################
# Function to check preference value
################################################################################
check_pref() {
    local domain=$1
    local key=$2
    local expected=$3
    local description=$4
    local browser=$5

    # Read the preference - check managed preferences first (MDM/profiles), then user defaults
    actual=$(defaults read "/Library/Managed Preferences/$domain" "$key" 2>/dev/null)
    exit_code=$?

    # If not in managed preferences, check user defaults
    if [ $exit_code -ne 0 ]; then
        actual=$(defaults read "$domain" "$key" 2>/dev/null)
        exit_code=$?
    fi

    if [ $exit_code -eq 0 ]; then
        if [ "$actual" == "$expected" ]; then
            echo -e "${GREEN}[PASS]${NC} $description"
            case $browser in
                chrome) ((CHROME_PASS++));;
                firefox) ((FIREFOX_PASS++));;
                edge) ((EDGE_PASS++));;
            esac
        else
            echo -e "${RED}[FAIL]${NC} $description"
            echo "       Expected: $expected | Actual: $actual"
            case $browser in
                chrome) ((CHROME_FAIL++));;
                firefox) ((FIREFOX_FAIL++));;
                edge) ((EDGE_FAIL++));;
            esac
        fi
    else
        echo -e "${RED}[FAIL]${NC} $description"
        echo "       Key not found or not set"
        case $browser in
            chrome) ((CHROME_FAIL++));;
            firefox) ((FIREFOX_FAIL++));;
            edge) ((EDGE_FAIL++));;
        esac
    fi
}

################################################################################
# Google Chrome STIG V2R11 Checks
################################################################################
echo "=========================================================================="
echo "                     GOOGLE CHROME STIG V2R11"
echo "=========================================================================="
echo ""

CHROME_DOMAIN="com.google.Chrome"

echo "Checking Chrome STIG requirements..."
echo ""

check_pref "$CHROME_DOMAIN" "RemoteAccessHostFirewallTraversal" "0" "DTBC-0001: Firewall traversal disabled" "chrome"
check_pref "$CHROME_DOMAIN" "DefaultGeolocationSetting" "2" "DTBC-0002: Geolocation tracking disabled" "chrome"
check_pref "$CHROME_DOMAIN" "DefaultPopupsSetting" "2" "DTBC-0004: Pop-ups disabled" "chrome"
check_pref "$CHROME_DOMAIN" "PasswordManagerEnabled" "0" "DTBC-0011: Password Manager disabled" "chrome"
check_pref "$CHROME_DOMAIN" "BackgroundModeEnabled" "0" "DTBC-0017: Background processing disabled" "chrome"
check_pref "$CHROME_DOMAIN" "SyncDisabled" "1" "DTBC-0020: Google Sync disabled" "chrome"
check_pref "$CHROME_DOMAIN" "CloudPrintProxyEnabled" "0" "DTBC-0023: Cloud print disabled" "chrome"
check_pref "$CHROME_DOMAIN" "NetworkPredictionOptions" "2" "DTBC-0025: Network prediction disabled" "chrome"
check_pref "$CHROME_DOMAIN" "MetricsReportingEnabled" "0" "DTBC-0026: Metrics reporting disabled" "chrome"
check_pref "$CHROME_DOMAIN" "SearchSuggestEnabled" "0" "DTBC-0027: Search suggestions disabled" "chrome"
check_pref "$CHROME_DOMAIN" "ImportSavedPasswords" "0" "DTBC-0029: Importing passwords disabled" "chrome"
check_pref "$CHROME_DOMAIN" "IncognitoModeAvailability" "1" "DTBC-0030: Incognito mode disabled" "chrome"
check_pref "$CHROME_DOMAIN" "EnableOnlineRevocationChecks" "1" "DTBC-0037: Online revocation checks enabled" "chrome"
check_pref "$CHROME_DOMAIN" "SafeBrowsingProtectionLevel" "1" "DTBC-0038: Safe Browsing enabled" "chrome"
check_pref "$CHROME_DOMAIN" "SavingBrowserHistoryDisabled" "0" "DTBC-0039: Browser history saved" "chrome"
check_pref "$CHROME_DOMAIN" "AllowDeletingBrowserHistory" "0" "DTBC-0052: Deletion of history disabled" "chrome"
check_pref "$CHROME_DOMAIN" "PromptForDownloadLocation" "1" "DTBC-0053: Download prompt enabled" "chrome"
check_pref "$CHROME_DOMAIN" "DownloadRestrictions" "1" "DTBC-0055: Download restrictions configured" "chrome"
check_pref "$CHROME_DOMAIN" "SafeBrowsingExtendedReportingEnabled" "0" "DTBC-0057: Extended reporting disabled" "chrome"
check_pref "$CHROME_DOMAIN" "DefaultWebUsbGuardSetting" "2" "DTBC-0058: WebUSB disabled" "chrome"
check_pref "$CHROME_DOMAIN" "EnableMediaRouter" "0" "DTBC-0063: Google Cast disabled" "chrome"
check_pref "$CHROME_DOMAIN" "AutoplayAllowed" "0" "DTBC-0064: Autoplay disabled" "chrome"
check_pref "$CHROME_DOMAIN" "UrlKeyedAnonymizedDataCollectionEnabled" "0" "DTBC-0066: Data collection disabled" "chrome"
check_pref "$CHROME_DOMAIN" "WebRtcEventLogCollectionAllowed" "0" "DTBC-0067: WebRTC logs disabled" "chrome"
check_pref "$CHROME_DOMAIN" "DeveloperToolsAvailability" "2" "DTBC-0068: Developer tools disabled" "chrome"
check_pref "$CHROME_DOMAIN" "BrowserGuestModeEnabled" "0" "DTBC-0069: Guest mode disabled" "chrome"
check_pref "$CHROME_DOMAIN" "AutofillCreditCardEnabled" "0" "DTBC-0070: Credit card autofill disabled" "chrome"
check_pref "$CHROME_DOMAIN" "AutofillAddressEnabled" "0" "DTBC-0071: Address autofill disabled" "chrome"
check_pref "$CHROME_DOMAIN" "ImportAutofillFormData" "0" "DTBC-0072: Import autofill disabled" "chrome"
check_pref "$CHROME_DOMAIN" "DefaultWebBluetoothGuardSetting" "2" "DTBC-0073: Web Bluetooth disabled" "chrome"
check_pref "$CHROME_DOMAIN" "QuicAllowed" "0" "DTBC-0074: QUIC protocol disabled" "chrome"
check_pref "$CHROME_DOMAIN" "DefaultCookiesSetting" "4" "DTBC-0045: Session-only cookies enabled" "chrome"
check_pref "$CHROME_DOMAIN" "CreateThemesSettings" "2" "DTBC-0075: AI theme creation disabled" "chrome"
check_pref "$CHROME_DOMAIN" "DevToolsGenAiSettings" "2" "DTBC-0076: DevTools AI disabled" "chrome"
check_pref "$CHROME_DOMAIN" "GenAILocalFoundationalModelSettings" "1" "DTBC-0077: Local AI model disabled" "chrome"
check_pref "$CHROME_DOMAIN" "HelpMeWriteSettings" "2" "DTBC-0078: Help Me Write disabled" "chrome"
check_pref "$CHROME_DOMAIN" "HistorySearchSettings" "2" "DTBC-0079: AI History Search disabled" "chrome"
check_pref "$CHROME_DOMAIN" "TabCompareSettings" "2" "DTBC-0080: Tab Compare disabled" "chrome"

echo ""
echo -e "Chrome STIG Summary: ${GREEN}$CHROME_PASS PASS${NC} | ${RED}$CHROME_FAIL FAIL${NC}"
echo ""

################################################################################
# Mozilla Firefox STIG V6R6 Checks
################################################################################
echo "=========================================================================="
echo "                    MOZILLA FIREFOX STIG V6R6"
echo "=========================================================================="
echo ""

FIREFOX_DOMAIN="org.mozilla.firefox"

echo "Checking Firefox STIG requirements..."
echo ""

check_pref "$FIREFOX_DOMAIN" "SSLVersionMin" "tls1.2" "V-251546: TLS 1.2 minimum" "firefox"
check_pref "$FIREFOX_DOMAIN" "ExtensionUpdate" "0" "V-251549: Extension auto-update disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisableFormHistory" "1" "V-251551: Form fill disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "PasswordManagerEnabled" "0" "V-251552: Password manager disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisableTelemetry" "1" "V-251558: Telemetry disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisableDeveloperTools" "1" "V-251559: Developer tools disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisableForgetButton" "1" "V-251562: Forget button disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisablePrivateBrowsing" "1" "V-251563: Private browsing disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "SearchSuggestEnabled" "0" "V-251564: Search suggestions disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "NetworkPrediction" "0" "V-251566: Network prediction disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisableFirefoxAccounts" "1" "V-251578: Firefox accounts disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisableFeedbackCommands" "1" "V-251580: Feedback disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisablePocket" "1" "V-252908: Pocket disabled" "firefox"
check_pref "$FIREFOX_DOMAIN" "DisableFirefoxStudies" "1" "V-252909: Firefox Studies disabled" "firefox"

echo ""
echo -e "Firefox STIG Summary: ${GREEN}$FIREFOX_PASS PASS${NC} | ${RED}$FIREFOX_FAIL FAIL${NC}"
echo ""

################################################################################
# Microsoft Edge STIG V2R3 Checks
################################################################################
echo "=========================================================================="
echo "                    MICROSOFT EDGE STIG V2R3"
echo "=========================================================================="
echo ""

EDGE_DOMAIN="com.microsoft.Edge"

echo "Checking Edge STIG requirements..."
echo ""

check_pref "$EDGE_DOMAIN" "PreventSmartScreenPromptOverride" "1" "V-235720: SmartScreen override blocked" "edge"
check_pref "$EDGE_DOMAIN" "PreventSmartScreenPromptOverrideForFiles" "1" "V-235721: SmartScreen file override blocked" "edge"
check_pref "$EDGE_DOMAIN" "InPrivateModeAvailability" "1" "V-235723: InPrivate mode disabled" "edge"
check_pref "$EDGE_DOMAIN" "BackgroundModeEnabled" "0" "V-235724: Background processing disabled" "edge"
check_pref "$EDGE_DOMAIN" "DefaultPopupsSetting" "2" "V-235725: Pop-ups disabled" "edge"
check_pref "$EDGE_DOMAIN" "SyncDisabled" "1" "V-235727: Sync disabled" "edge"
check_pref "$EDGE_DOMAIN" "NetworkPredictionOptions" "2" "V-235728: Network prediction disabled" "edge"
check_pref "$EDGE_DOMAIN" "SearchSuggestEnabled" "0" "V-235729: Search suggestions disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportAutofillFormData" "0" "V-235730: Import autofill disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportBrowserSettings" "0" "V-235731: Import settings disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportCookies" "0" "V-235732: Import cookies disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportExtensions" "0" "V-235733: Import extensions disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportHistory" "0" "V-235734: Import history disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportHomepage" "0" "V-235735: Import homepage disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportOpenTabs" "0" "V-235736: Import tabs disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportPaymentInfo" "0" "V-235737: Import payment info disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportSavedPasswords" "0" "V-235738: Import passwords disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportSearchEngine" "0" "V-235739: Import search engine disabled" "edge"
check_pref "$EDGE_DOMAIN" "ImportShortcuts" "0" "V-235740: Import shortcuts disabled" "edge"
check_pref "$EDGE_DOMAIN" "AutoplayAllowed" "0" "V-235741: Autoplay disabled" "edge"
check_pref "$EDGE_DOMAIN" "DefaultWebUsbGuardSetting" "2" "V-235742: WebUSB disabled" "edge"
check_pref "$EDGE_DOMAIN" "EnableMediaRouter" "0" "V-235743: Google Cast disabled" "edge"
check_pref "$EDGE_DOMAIN" "DefaultWebBluetoothGuardSetting" "2" "V-235744: Web Bluetooth disabled" "edge"
check_pref "$EDGE_DOMAIN" "AutofillCreditCardEnabled" "0" "V-235745: Credit card autofill disabled" "edge"
check_pref "$EDGE_DOMAIN" "AutofillAddressEnabled" "0" "V-235746: Address autofill disabled" "edge"
check_pref "$EDGE_DOMAIN" "EnableOnlineRevocationChecks" "1" "V-235747: Online revocation checks enabled" "edge"
check_pref "$EDGE_DOMAIN" "PersonalizationReportingEnabled" "0" "V-235748: Personalization disabled" "edge"
check_pref "$EDGE_DOMAIN" "DefaultGeolocationSetting" "2" "V-235749: Geolocation disabled" "edge"
check_pref "$EDGE_DOMAIN" "AllowDeletingBrowserHistory" "0" "V-235750: History deletion disabled" "edge"
check_pref "$EDGE_DOMAIN" "DeveloperToolsAvailability" "2" "V-235751: Developer tools disabled" "edge"
check_pref "$EDGE_DOMAIN" "DownloadRestrictions" "1" "V-235752: Download restrictions configured" "edge"
check_pref "$EDGE_DOMAIN" "PasswordManagerEnabled" "0" "V-235756: Password manager disabled" "edge"
check_pref "$EDGE_DOMAIN" "SitePerProcess" "1" "V-235760: Site isolation enabled" "edge"
check_pref "$EDGE_DOMAIN" "AuthSchemes" "ntlm,negotiate" "V-235761: Auth schemes configured" "edge"
check_pref "$EDGE_DOMAIN" "SmartScreenEnabled" "1" "V-235763: SmartScreen enabled" "edge"
check_pref "$EDGE_DOMAIN" "SmartScreenPuaEnabled" "1" "V-235764: SmartScreen PUA enabled" "edge"
check_pref "$EDGE_DOMAIN" "PromptForDownloadLocation" "1" "V-235765: Download prompt enabled" "edge"
check_pref "$EDGE_DOMAIN" "TrackingPrevention" "3" "V-235766: Tracking prevention configured" "edge"
check_pref "$EDGE_DOMAIN" "PaymentMethodQueryEnabled" "0" "V-235767: Payment query disabled" "edge"
check_pref "$EDGE_DOMAIN" "AlternateErrorPagesEnabled" "0" "V-235768: Alternate error pages disabled" "edge"
check_pref "$EDGE_DOMAIN" "UserFeedbackAllowed" "0" "V-235769: User feedback disabled" "edge"
check_pref "$EDGE_DOMAIN" "EdgeCollectionsEnabled" "0" "V-235770: Collections disabled" "edge"
check_pref "$EDGE_DOMAIN" "ConfigureShare" "1" "V-235771: Share experience disabled" "edge"
check_pref "$EDGE_DOMAIN" "BrowserGuestModeEnabled" "0" "V-235772: Guest mode disabled" "edge"
check_pref "$EDGE_DOMAIN" "RelaunchNotification" "2" "V-235773: Relaunch notification required" "edge"
check_pref "$EDGE_DOMAIN" "BuiltInDnsClientEnabled" "0" "V-235774: Built-in DNS disabled" "edge"
check_pref "$EDGE_DOMAIN" "QuicAllowed" "0" "V-246736: QUIC protocol disabled" "edge"
check_pref "$EDGE_DOMAIN" "VisualSearchEnabled" "0" "V-260465: Visual Search disabled" "edge"
check_pref "$EDGE_DOMAIN" "HubsSidebarEnabled" "0" "V-260466: Copilot disabled" "edge"
check_pref "$EDGE_DOMAIN" "DefaultCookiesSetting" "4" "V-260467: Session-only cookies enabled" "edge"
check_pref "$EDGE_DOMAIN" "ConfigureDefaultPasteFormatForUrls" "1" "V-266981: Friendly URLs disabled" "edge"

echo ""
echo -e "Edge STIG Summary: ${GREEN}$EDGE_PASS PASS${NC} | ${RED}$EDGE_FAIL FAIL${NC}"
echo ""

################################################################################
# Overall Summary
################################################################################
echo "=========================================================================="
echo "                        OVERALL SUMMARY"
echo "=========================================================================="
echo ""
echo -e "Chrome:  ${GREEN}$CHROME_PASS PASS${NC} | ${RED}$CHROME_FAIL FAIL${NC}"
echo -e "Firefox: ${GREEN}$FIREFOX_PASS PASS${NC} | ${RED}$FIREFOX_FAIL FAIL${NC}"
echo -e "Edge:    ${GREEN}$EDGE_PASS PASS${NC} | ${RED}$EDGE_FAIL FAIL${NC}"
echo ""

TOTAL_PASS=$((CHROME_PASS + FIREFOX_PASS + EDGE_PASS))
TOTAL_FAIL=$((CHROME_FAIL + FIREFOX_FAIL + EDGE_FAIL))
TOTAL_CHECKS=$((TOTAL_PASS + TOTAL_FAIL))

if [ $TOTAL_CHECKS -gt 0 ]; then
    COMPLIANCE_PERCENT=$(( (TOTAL_PASS * 100) / TOTAL_CHECKS ))
    echo -e "Total:   ${GREEN}$TOTAL_PASS PASS${NC} | ${RED}$TOTAL_FAIL FAIL${NC} ($TOTAL_CHECKS checks)"
    echo "Compliance: $COMPLIANCE_PERCENT%"
else
    echo "No checks performed."
fi

echo ""
echo "=========================================================================="
echo ""

# Exit with appropriate code
if [ $TOTAL_FAIL -eq 0 ]; then
    exit 0
else
    exit 1
fi
