//
//  NSNotificationCenter+TLHookAE.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/29.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "NSNotificationCenter+TLHookAE.h"
#import "TLHookAE+TLAutomaticEvents.h"
#import "TLAutomaticEventsConstants.h"

#import "TLObjectPath.h"


@implementation NSNotificationCenter (TLHookAE)

- (void)tl_postNotification:(NSNotification *)notification {
    if ([NSNotificationCenter shouldTrackNotificationNamed:notification.name]) {
        if ([TLHookAE sharedInstance].validationEnabled) {
            [[TLHookAE sharedAutomatedInstance] track:kAutomaticEventName];
            
            NSLog(@"");
        }
    }
    
    [self tl_postNotification:notification];
}

- (void)tl_postNotificationName:(NSString *)name
                         object:(nullable id)object
                       userInfo:(nullable NSDictionary *)info {
    if ([object isKindOfClass:[UITextField class]]) {
        if ([TLHookAE sharedInstance].validationEnabled) {
            if ([NSNotificationCenter shouldTrackNotificationNamed:name]) {
                //测试获取path函数
                TLObjectPath *objPath = [[TLObjectPath alloc] init];
                NSString *path = [objPath getPathWithObject:object];
                NSString *eventName = [NSString stringWithFormat:@"%@_%@",kObjectEventPrefix,[UITextField class]];
                
                NSString *current = [objPath getCurrentPageClass];

                NSMutableDictionary *dictProperties = [[NSMutableDictionary alloc] init];
                [dictProperties setObject:@"ui_control"
                                   forKey:@"ui_textfield"];
                [dictProperties setObject:path
                                   forKey:@"path"];
                [dictProperties setObject:current
                                   forKey:@"current"];
                
                [[TLHookAE sharedAutomatedInstance] track:[eventName lowercaseString] properties:dictProperties];
            }
        }
    }
    
    [self tl_postNotificationName:name object:object userInfo:info];
}

+ (BOOL)shouldTrackNotificationNamed:(NSString *)name {
    // iOS spams notifications. We're whitelisting for now.
    NSArray *names = @[
                       // UITextField Editing
                       UITextFieldTextDidEndEditingNotification,
                       //                       UITextFieldTextDidChangeNotification,
                       
                       // UIApplication Lifecycle
                       UIApplicationDidFinishLaunchingNotification,
                       UIApplicationDidEnterBackgroundNotification,
                       UIApplicationDidBecomeActiveNotification ];
    NSSet<NSString *> *whiteListedNotificationNames = [NSSet setWithArray:names];
    return [whiteListedNotificationNames containsObject:name];
}


@end

