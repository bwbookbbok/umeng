//
//  UmengHelperIos.h
//  umeng
//
//  Created by 何必都 on 7/4/20.
//

#ifndef UmengHelperIos_h
#define UmengHelperIos_h

#import <Flutter/Flutter.h>

@interface UmengHelperIos : NSObject <UNUserNotificationCenterDelegate>

+ (void)iosInit:(NSDictionary *_Nullable)launchOptions appkey:(NSString *_Nullable)appkey channel:(NSString *_Nullable)channel logEnabled:(BOOL)logEnabled pushEnabled:(BOOL)pushEnabled;

+ (void)handleCustomMessagePush:(NSDictionary *_Nullable)userInfo;

+ (instancetype _Nonnull ) singleInstance;

+ (NSString *_Nullable)convertToJsonData:(NSDictionary *_Nullable)dict;

@end

#endif /* UmengHelperIos_h */
