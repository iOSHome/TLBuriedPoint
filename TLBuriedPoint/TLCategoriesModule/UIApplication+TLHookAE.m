//
//  UIApplication+TLHookAE.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/29.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UIApplication+TLHookAE.h"
#import "TLHookAE+TLAutomaticEvents.h"
#import "TLAutomaticEventsConstants.h"

#import "TLObjectPath.h"

@implementation UIApplication (TLHookAE)

- (BOOL)tl_sendAction:(SEL)action to:(id)to from:(id)from forEvent:(UIEvent *)event {
    
    if (event && from && [from isKindOfClass:[UIControl class]]) {
        if ([TLHookAE sharedInstance].validationEnabled) {
            CGFloat pointX = 0.0;
            CGFloat pointY = 0.0;
            if ([event respondsToSelector:@selector(allTouches)]) {
                UITouch *vTouch = [[[event allTouches] allObjects] firstObject];
                if (vTouch.phase != UITouchPhaseEnded) {
                    return [self tl_sendAction:action to:to from:from forEvent:event];
                }
                UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
                
                if (vTouch && window) {
                    CGPoint vPoint  = [vTouch locationInView:window];
                    pointX = vPoint.x;
                    pointY = vPoint.y;
                }
            }
            
            //测试获取path函数
            TLObjectPath *objPath = [[TLObjectPath alloc] init];
            NSString *path = [objPath getPathWithObject:from];
            NSString *eventName = [NSString stringWithFormat:@"%@_%@",kObjectEventPrefix,[from class]];
            NSString *current = [objPath getCurrentPageClass];
            
            NSMutableDictionary *dictProperties = [[NSMutableDictionary alloc] init];
            [dictProperties setObject:@"ui_control"
                               forKey:@"event_type"];
            [dictProperties setObject:@(pointX)
                               forKey:@"position_x"];
            [dictProperties setObject:@(pointY)
                               forKey:@"position_y"];
            [dictProperties setObject:[NSString stringWithFormat:@"%@",NSStringFromSelector(action)]
                               forKey:@"action"];
            [dictProperties setObject:path
                               forKey:@"path"];
            [dictProperties setObject:eventName
                               forKey:@"eventName"];
            [dictProperties setObject:current
                               forKey:@"currentClass"];
            
            NSLog(@"%@", dictProperties);
        }
    }
    return [self tl_sendAction:action to:to from:from forEvent:event];
}

//- (void)sp_sendEvent:(UIEvent *)event {
//
//    NSLog(@"====%@====",event);
//
//    [self sp_sendEvent: event];
////    if (event.type==UIEventTypeTouches) {
////        UITouch *touch = [event allTouches].anyObject;
////        switch (touch.phase) {
////            case UITouchPhaseBegan:
////                NSLog(@"UITouchPhaseBegan");
////                break;
////            case UITouchPhaseMoved:
////                NSLog(@"UITouchPhaseMoved");
////                break;
////            case UITouchPhaseStationary:
////                NSLog(@"UITouchPhaseStationary");
////                break;
////            case UITouchPhaseEnded:
////                NSLog(@"UITouchPhaseEnded");
////                break;
////            case UITouchPhaseCancelled:
////                NSLog(@"UITouchPhaseCancelled");
////                break;
////            default:
////                break;
////        }
////    }
//}

@end
