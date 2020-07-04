#import "UmengHelperIos.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMPush/UMessage.h>
#import <UserNotifications/UserNotifications.h>
#import <UMCommonLog/UMCommonLogHeaders.h>

extern FlutterEventSink _eventSink;
@implementation UmengHelperIos

// 初始化友盟
+ (void)iosInit:(NSDictionary *_Nullable)launchOptions appkey:(NSString *)appkey channel:(NSString *)channel logEnabled:(BOOL)logEnabled pushEnabled:(BOOL)pushEnabled {
    [UMConfigure setLogEnabled:logEnabled];
    
    [UMConfigure setAnalyticsEnabled:YES];
    
    [UMConfigure initWithAppkey:appkey channel:channel];
    
    NSLog(@"application init umeng ok");
    if (pushEnabled) {
        // Push组件基本功能配置
        UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
        if (@available(iOS 10.0, *)) {
//            [UNUserNotificationCenter currentNotificationCenter].delegate = [UmengHelperIos singleInstance];
        } else {
            // Fallback on earlier versions
        }
        [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"================= PUSH授权成功 ====================");
            }else{
                NSLog(@"================= PUSH拒绝授权 ====================");
            }
        }];
        
        
        [[NSNotificationCenter defaultCenter] addObserver: [UmengHelperIos singleInstance] selector:@selector(handleNotification:) name:@"umeng_analytics_push" object:nil];
    }
}

- (void)handleNotification:(NSNotification *)notification
{
    NSLog(@"notification = %@", notification.name);
    NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:notification.name, @"name", nil];
    _eventSink([UmengHelperIos convertToJsonData: userInfo]);
}



// 处理友盟推送
+ (void)handleCustomMessagePush:(NSDictionary *)userInfo {
    if (userInfo)
    {
        if ([userInfo objectForKey:@"custom_message"])
        {
            //通知到Flutter
            _eventSink([self convertToJsonData: userInfo]);
        }
    }
}



static UmengHelperIos * _instance = nil;

+ (instancetype) singleInstance
{
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[UmengHelperIos alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}


+ (NSString *)convertToJsonData:(NSDictionary *)dict
{
    if (dict == nil) {
        return @"";
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
