#import "UmengPlugin.h"
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMPush/UMessage.h>

FlutterMethodChannel* methodChannel;
FlutterEventChannel* eventChannel;
FlutterEventSink _eventSink;

@implementation UmengPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  methodChannel = [FlutterMethodChannel methodChannelWithName:@"flutter_umeng_20200703_channel" binaryMessenger:[registrar messenger]];
  UmengPlugin* instance = [[UmengPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:methodChannel];

  eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter_umeng_20200703_channel/event" binaryMessenger:[registrar messenger]];
    
  [eventChannel setStreamHandler:instance];
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _eventSink = eventSink;
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  _eventSink = nil;
  return nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"%@", call.method);
    
  if ([@"addTags" isEqualToString:call.method]) {
      [self addTags:call result:result];
  } else if ([@"deleteTags" isEqualToString:call.method]) {
      [self deleteTags:call result:result];
  } else if ([@"addAlias" isEqualToString:call.method]) {
      [self addAlias:call result:result];
  } else if ([@"setAlias" isEqualToString:call.method]) {
      [self setAlias:call result:result];
  } else if ([@"deleteAlias" isEqualToString:call.method]) {
      [self deleteAlias:call result:result];
  } else if ([@"pageStart" isEqualToString:call.method]) {
      [self pageStart:call result:result];
  } else if ([@"pageEnd" isEqualToString:call.method]) {
      [self pageEnd:call result:result];
  } else if ([@"event" isEqualToString:call.method]) {
      [self event:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (void)event:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* eventId = call.arguments[@"eventId"];
    NSString* label = call.arguments[@"label"];
    if (label == nil) {
        [MobClick event:eventId];
    } else {
        [MobClick event:eventId label:label];
    }
}

- (void)pageStart:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* pageName = call.arguments[@"pageName"];
  [MobClick beginLogPageView:pageName];
}

- (void)pageEnd:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString* pageName = call.arguments[@"pageName"];
  [MobClick endLogPageView:pageName];
}

- (void)addTags:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *tags = call.arguments[@"tags"];
  [UMessage addTags:tags response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
  }];
}

- (void)deleteTags:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *tags = call.arguments[@"tags"];
  [UMessage deleteTags:tags response:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
  }];
}

- (void)addAlias:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *alias = call.arguments[@"alias"];
  NSString *type = call.arguments[@"type"];
  [UMessage addAlias:alias type:type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
  }];
}

- (void)setAlias:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *alias = call.arguments[@"alias"];
  NSString *type = call.arguments[@"type"];
  [UMessage setAlias:alias type:type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
  }];
}

- (void)deleteAlias:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *alias = call.arguments[@"alias"];
  NSString *type = call.arguments[@"type"];
  [UMessage removeAlias:alias type:type response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
  }];
}

@end
