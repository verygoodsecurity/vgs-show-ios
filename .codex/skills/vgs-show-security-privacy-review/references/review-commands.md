# Review Commands

1. Search for deprecated APIs
   - grep -R "@available" -n Sources
2. Scan logging and analytics
   - grep -R "VGSLogger" -n Sources
   - grep -R "VGSAnalyticsClient" -n Sources
3. Confirm contentPath usage
   - grep -R "contentPath" -n Sources
4. Check privacy manifest
   - cat Sources/VGSShowSDK/PrivacyInfo.xcprivacy
