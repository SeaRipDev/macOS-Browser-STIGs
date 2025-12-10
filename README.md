# Browser STIG Configuration for Jamf Pro

This directory contains DISA STIG-compliant configuration profiles for Chrome, Firefox, and Edge browsers, designed for deployment via Jamf Pro on macOS 26.

## Contents

### Configuration Profiles
- **Chrome_STIG_V2R11.mobileconfig** - Google Chrome STIG V2 Release 11 (46 requirements)
- **Firefox_STIG_V6R6.mobileconfig** - Mozilla Firefox STIG V6 Release 6 (34 requirements)
- **Edge_STIG_V2R3.mobileconfig** - Microsoft Edge STIG V2 Release 3 (59 requirements)

### Verification Script
- **verify_browser_stig_compliance.sh** - Automated compliance verification script

---

## STIG Versions and Requirements

### Google Chrome STIG V2R11
- **Total Requirements**: 46
- **CAT I (High)**: 0
- **CAT II (Medium)**: 44
- **CAT III (Low)**: 2
- **Key Controls**:
  - Disables password manager, sync, and telemetry
  - Blocks all extensions by default (must allowlist approved ones)
  - Disables incognito mode and guest mode
  - Enforces session-only cookies
  - Disables all AI features (themes, DevTools AI, Help Me Write, etc.)
  - Blocks WebUSB, Web Bluetooth, and QUIC protocol
  - Requires encrypted search provider

### Mozilla Firefox STIG V6R6
- **Total Requirements**: 34
- **CAT I (High)**: 2
- **CAT II (Medium)**: 30
- **CAT III (Low)**: 2
- **Key Controls**:
  - Enforces TLS 1.2 minimum
  - Disables password manager, telemetry, and form history
  - Blocks extensions installation
  - Disables private browsing
  - Enables strict tracking protection
  - Prevents data deletion on shutdown
  - Requires DOD root certificates

### Microsoft Edge STIG V2R3
- **Total Requirements**: 59
- **CAT I (High)**: 1
- **CAT II (Medium)**: 48
- **CAT III (Low)**: 10
- **Key Controls**:
  - Disables password manager, sync, and InPrivate mode
  - Blocks all extensions by default
  - Enforces SmartScreen with PUA blocking
  - Disables Copilot and Visual Search
  - Enables site isolation for security
  - Blocks import from other browsers
  - Requires NTLM/Negotiate authentication only

---

## Deployment Instructions

### Option 1: Upload via Jamf Pro Web Interface

1. **Log in to Jamf Pro**
2. **Navigate to**: Computers → Configuration Profiles
3. **Click**: "+ New"
4. **Click**: "Upload" in the bottom right
5. **Select** one of the .mobileconfig files
6. **Configure scope**:
   - Add target computers or computer groups
   - Set deployment schedule
7. **Save** and the profile will deploy automatically

### Option 2: Manual Installation for Testing

Test on a single machine before deploying to production:

```bash
# Install Chrome profile
sudo profiles install -path="/path/to/Chrome_STIG_V2R11.mobileconfig"

# Install Firefox profile
sudo profiles install -path="/path/to/Firefox_STIG_V6R6.mobileconfig"

# Install Edge profile
sudo profiles install -path="/path/to/Edge_STIG_V2R3.mobileconfig"

# Verify installed profiles
sudo profiles list

# Remove a profile if needed
sudo profiles remove -identifier "com.organization.chrome.stig.v2r11"
```

---

## Configuration Profile Details

### Chrome Configuration Profile
- **Preference Domain**: `com.google.Chrome`
- **Identifier**: `com.organization.chrome.stig.v2r11`
- **Scope**: System (Computer-level)
- **Removal**: Disallowed

### Firefox Configuration Profile
- **Preference Domain**: `org.mozilla.firefox`
- **Identifier**: `com.organization.firefox.stig.v6r6`
- **Scope**: System (Computer-level)
- **Removal**: Disallowed

### Edge Configuration Profile
- **Preference Domain**: `com.microsoft.Edge`
- **Identifier**: `com.organization.edge.stig.v2r3`
- **Scope**: System (Computer-level)
- **Removal**: Disallowed

---

## Important Customizations Needed

### Before Deploying Chrome Profile

1. **Approved Extensions** (Line 39-41):
   ```xml
   <key>ExtensionInstallAllowlist</key>
   <array>
       <!-- Add your approved extension IDs here -->
       <string>your_extension_id_here</string>
   </array>
   ```

2. **Search Provider** (Lines 44-50):
   - Default: Google Encrypted
   - Change if using different approved search provider

3. **Autoplay Allowlist** (Lines 148-152) - OPTIONAL:
   ```xml
   <key>AutoplayAllowlist</key>
   <array>
       <string>[*.]mil</string>
       <string>[*.]gov</string>
   </array>
   ```

### Before Deploying Firefox Profile

1. **Pop-up Allowlist** (Lines 51-55) - OPTIONAL:
   ```xml
   <key>Allow</key>
   <array>
       <string>http://example.mil</string>
   </array>
   ```

### Before Deploying Edge Profile

1. **Proxy Settings** (Line 39):
   - Default: `{"ProxyMode": "system"}`
   - Options: `direct`, `system`, `auto_detect`, `fixed_servers`, `pac_script`

2. **Approved Extensions** (Lines 145-149) - OPTIONAL:
   ```xml
   <key>ExtensionInstallAllowlist</key>
   <array>
       <string>your_extension_id_here</string>
   </array>
   ```

3. **Search Engine** (Line 52):
   - Default: Bing Encrypted
   - Modify JSON if using different approved search provider

---

## Compliance Verification

The `verify_browser_stig_compliance.sh` script provides automated verification of STIG compliance for all three browsers by reading the system-level preferences and comparing them against STIG requirements.

### What the Script Checks

The verification script validates:
- **Chrome**: 38 key STIG requirements from V2R11
- **Firefox**: 14 key STIG requirements from V6R6
- **Edge**: 52 key STIG requirements from V2R3

The script uses the macOS `defaults read` command to check if policies are properly configured at the system level (`/Library/Preferences/`).

### Prerequisites

1. **Browsers must be installed** - The script checks preferences for browsers, but browsers don't need to be running
2. **Configuration profiles must be deployed** - Either via Jamf or manually installed
3. **Root access required** - Script needs sudo to read system-level preferences

### Running the Verification Script

#### Basic Usage

```bash
# Navigate to the STIG directory
cd ~/path/to/STIG

# Make script executable (if not already done)
chmod +x verify_browser_stig_compliance.sh

# Run compliance check
sudo ./verify_browser_stig_compliance.sh
```

#### Save Results to File

```bash
# Save output to a file for reporting
sudo ./verify_browser_stig_compliance.sh > compliance_report_$(date +%Y%m%d).txt

# Save with timestamp and view results
sudo ./verify_browser_stig_compliance.sh | tee compliance_report_$(date +%Y%m%d_%H%M%S).txt
```

#### Check Specific Browser

The script always checks all three browsers, but you can filter output:

```bash
# Check only Chrome results
sudo ./verify_browser_stig_compliance.sh | grep -A 50 "GOOGLE CHROME"

# Check only failures
sudo ./verify_browser_stig_compliance.sh | grep "FAIL"
```

### Script Output Explained

#### Color Coding
- **GREEN [PASS]**: Setting is correctly configured per STIG requirements
- **RED [FAIL]**: Setting is missing, incorrect, or not configured
- **BLUE**: Section headers and informational text
- **YELLOW**: (Reserved for warnings)

#### Example Output

```
==========================================================================
           Browser STIG Compliance Verification Script
==========================================================================

Checking STIG compliance for Chrome V2R11, Firefox V6R6, and Edge V2R3
Date: Tue Dec 10 09:45:22 PST 2025

==========================================================================
                     GOOGLE CHROME STIG V2R11
==========================================================================

Checking Chrome STIG requirements...

[PASS] DTBC-0001: Firewall traversal disabled
[PASS] DTBC-0002: Geolocation tracking disabled
[FAIL] DTBC-0004: Pop-ups disabled
       Expected: 2 | Actual: 1
[PASS] DTBC-0011: Password Manager disabled
[FAIL] DTBC-0020: Google Sync disabled
       Key not found or not set
...

Chrome STIG Summary: 34 PASS | 4 FAIL

==========================================================================
                    MOZILLA FIREFOX STIG V6R6
==========================================================================

Checking Firefox STIG requirements...

[PASS] V-251546: TLS 1.2 minimum
[PASS] V-251549: Extension auto-update disabled
...

Firefox STIG Summary: 14 PASS | 0 FAIL

==========================================================================
                    MICROSOFT EDGE STIG V2R3
==========================================================================

Checking Edge STIG requirements...

[PASS] V-235720: SmartScreen override blocked
[FAIL] V-235723: InPrivate mode disabled
       Expected: 1 | Actual: 0
...

Edge STIG Summary: 48 PASS | 4 FAIL

==========================================================================
                        OVERALL SUMMARY
==========================================================================

Chrome:  34 PASS | 4 FAIL
Firefox: 14 PASS | 0 FAIL
Edge:    48 PASS | 4 FAIL

Total:   96 PASS | 8 FAIL (104 checks)
Compliance: 92%

==========================================================================
```

#### Exit Codes
- **Exit 0**: All checks passed (100% compliance)
- **Exit 1**: One or more checks failed

### Understanding Failures

When a check fails, the script shows:

```
[FAIL] DTBC-0020: Google Sync disabled
       Expected: 1 | Actual: 0
```

This means:
- **DTBC-0020** is the STIG requirement ID
- The setting should be **1** (true/enabled)
- The actual value is **0** (false/disabled) or not set
- Action needed: Re-deploy the configuration profile or check for conflicts

```
[FAIL] DTBC-0030: Incognito mode disabled
       Key not found or not set
```

This means:
- The preference key doesn't exist in the system preferences
- The configuration profile may not have been applied
- Action needed: Verify profile installation with `sudo profiles list`

### Using with Jamf Pro

#### Option 1: Extension Attribute (Reporting)

Create a Jamf Extension Attribute to report compliance:

```bash
#!/bin/bash
# Extension Attribute: Browser STIG Compliance Percentage

SCRIPT_PATH="/path/to/verify_browser_stig_compliance.sh"

if [ -f "$SCRIPT_PATH" ]; then
    output=$("$SCRIPT_PATH" 2>&1)
    compliance=$(echo "$output" | grep "Compliance:" | awk '{print $2}')
    echo "<result>$compliance</result>"
else
    echo "<result>Script not found</result>"
fi
```

#### Option 2: Policy with Script (Enforcement)

1. **Upload the verification script to Jamf Pro**:
   - Settings → Computer Management → Scripts
   - Upload `verify_browser_stig_compliance.sh`

2. **Create a Policy**:
   - Computers → Policies → New
   - Add the script to the policy
   - Set to run on check-in or recurring schedule
   - Scope to all computers with browsers

3. **View results in logs**:
   - Computers → Policy Logs
   - View script output for each execution

#### Option 3: Self Service Compliance Check

Create a Self Service policy that users can run:

1. Create policy with the verification script
2. Enable "Make Available in Self Service"
3. Users can check compliance on-demand
4. Results appear in policy logs

### Scheduled Compliance Checks

Run automatically via Jamf or local LaunchDaemon:

#### Weekly Compliance Report via Jamf

1. Create a policy that runs the script
2. Set frequency to "Once per week"
3. Configure email notifications for failures
4. Monitor via Jamf dashboard

#### Local Scheduled Check with LaunchDaemon

Create `/Library/LaunchDaemons/com.organization.browser.stig.check.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.organization.browser.stig.check</string>
    <key>ProgramArguments</key>
    <array>
        <string>/path/to/verify_browser_stig_compliance.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>1</integer>
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/var/log/browser_stig_compliance.log</string>
    <key>StandardErrorPath</key>
    <string>/var/log/browser_stig_compliance.error.log</string>
</dict>
</plist>
```

Load the LaunchDaemon:
```bash
sudo launchctl load /Library/LaunchDaemons/com.organization.browser.stig.check.plist
```

### Interpreting Results for Auditors

When providing compliance reports to auditors:

1. **Run the script and save output**:
   ```bash
   sudo ./verify_browser_stig_compliance.sh > compliance_report_$(date +%Y%m%d).txt
   ```

2. **Document any acceptable deviations**:
   - SIPRNet exclusions (SmartScreen, etc.)
   - Organizational policy exceptions
   - Approved allowlists

3. **Show trend over time**:
   - Run weekly and keep historical reports
   - Demonstrate improvement in compliance percentage

4. **Explain failures**:
   - "Key not found" = Profile not applied yet
   - "Expected vs Actual" = Configuration drift

### Troubleshooting Verification Script

#### Script Shows All Failures

**Problem**: All checks show FAIL even after profile deployment

**Solutions**:
```bash
# 1. Verify profiles are installed
sudo profiles list | grep -i stig

# 2. Check if preferences are in the right location
ls -la /Library/Preferences/ | grep -E "(chrome|firefox|edge)"

# 3. Verify preference domain names
defaults domains | grep -E "(chrome|firefox|edge)"

# 4. Try reading one preference manually
sudo defaults read com.google.Chrome PasswordManagerEnabled
```

#### Script Shows "Permission Denied"

**Problem**: Script can't read system preferences

**Solution**:
```bash
# Must run with sudo
sudo ./verify_browser_stig_compliance.sh

# Verify script is executable
chmod +x verify_browser_stig_compliance.sh
```

#### Results Don't Match Browser Behavior

**Problem**: Script shows PASS but browser doesn't follow policy

**Causes**:
1. User-level preferences override system preferences
2. Browser needs restart to apply settings
3. Browser version doesn't support the policy

**Solutions**:
```bash
# Clear user-level overrides
rm ~/Library/Preferences/com.google.Chrome.plist

# Restart browser completely (quit all instances)
killall "Google Chrome" "Firefox" "Microsoft Edge"

# Check browser policy page
# Chrome: chrome://policy
# Firefox: about:policies
# Edge: edge://policy
```

### What the Script Does NOT Check

The verification script does **not** validate:

1. **Browser versions** (DTBC-0050, V-251545, V-235758) - Manual check required
2. **Manually configured settings** - Only checks preference files
3. **Running browser state** - Checks system preferences, not active browser
4. **Extension IDs** - Only verifies blocklist/allowlist keys exist, not content
5. **Complex JSON values** - Some policies like search engines require manual verification
6. **MIME type associations** (V-251550) - Requires manual checking
7. **DOD certificates** (V-251560) - Requires keychain verification

---

## SIPRNet Considerations

Several STIG requirements are marked as **N/A on SIPRNet**:

### Chrome
- DTBC-0008: Default search provider URL (may not apply)
- DTBC-0055: Download restrictions (may not apply)

### Edge
- V-235720, V-235721: SmartScreen requirements
- V-235722: SmartScreen allowlist
- V-235752: Download restrictions
- V-251694: Autoplay allowlist

If deploying on SIPRNet, you may need to adjust or disable these specific settings.

---

## Troubleshooting

### Profile Not Applying

1. **Check profile installation**:
   ```bash
   sudo profiles list | grep -A 5 "stig"
   ```

2. **Check for conflicts**:
   ```bash
   # List all profiles affecting browsers
   sudo profiles list
   ```

3. **Force profile refresh**:
   ```bash
   sudo profiles renew -type enrollment
   ```

### Settings Not Taking Effect

1. **Quit and restart the browser completely**
2. **Check for user-level overrides**:
   ```bash
   # Chrome
   defaults read com.google.Chrome

   # Firefox
   defaults read org.mozilla.firefox

   # Edge
   defaults read com.microsoft.Edge
   ```

3. **Verify browser is managed**:
   - Chrome: Navigate to `chrome://policy`
   - Firefox: Navigate to `about:policies`
   - Edge: Navigate to `edge://policy`

### Manual Preference Setting

If profiles don't work, you can set preferences manually:

```bash
# Example: Disable Chrome password manager
sudo defaults write /Library/Preferences/com.google.Chrome PasswordManagerEnabled -bool false

# Example: Disable Firefox telemetry
sudo defaults write /Library/Preferences/org.mozilla.firefox DisableTelemetry -bool true
```

---

## Version Compliance (CAT I)

### DTBC-0050 (Chrome) / V-251545 (Firefox) / V-235758 (Edge)

**Requirement**: Browsers must run supported versions

This is a **manual check** that cannot be enforced via configuration profile. Organizations must:

1. Monitor browser versions regularly
2. Deploy updates promptly via Jamf
3. Use Jamf's patch management for automated updates
4. Run the verification script to check installed versions

---

## Additional Resources

### Official STIG Documentation
- Location: `/path/to/STIGs/Browsers/`
- Chrome: `U_Google_Chrome_V2R11_STIG/`
- Firefox: `U_MOZ_Firefox_V6R6_STIG/`
- Edge: `U_MS_Edge_V2R3_STIG/`

### Jamf Pro Resources
- Jamf Pro Administrator's Guide
- Configuration Profile Reference: https://developer.apple.com/documentation/

### Browser Policy Documentation
- Chrome Enterprise: https://chromeenterprise.google/policies/
- Firefox Enterprise: https://mozilla.github.io/policy-templates/
- Edge Enterprise: https://docs.microsoft.com/deployedge/

---

## Support

For issues or questions:
1. Review STIG documentation in the local directories
2. Check browser vendor policy documentation
3. Verify macOS 26 compatibility with each browser
4. Test on a single endpoint before deploying fleet-wide

---

## Change Log

### 2025-12-10
- Initial creation
- Chrome STIG V2R11 configuration profile
- Firefox STIG V6R6 configuration profile
- Edge STIG V2R3 configuration profile
- Compliance verification script
- Comprehensive documentation

---

## License

These configuration profiles implement publicly available DISA STIG requirements for use in government and DoD environments.

