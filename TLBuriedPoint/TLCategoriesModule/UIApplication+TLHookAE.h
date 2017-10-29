//
//  UIApplication+TLHookAE.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/29.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (TLHookAE)

- (BOOL)tl_sendAction:(SEL)action to:(id)to from:(id)from forEvent:(UIEvent *)event;

@end
