//
//  UIViewController+TLHook.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/28.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UIViewController+TLHook.h"
#import "TLSwizzle.h"
#import "TLObjectPath.h"
#import "TLInterfaceManager.h"
#import <objc/runtime.h>

#define SP_ENTER_TIME_KEY @"sp_enterTime"

@implementation UIViewController (TLHook)

- (void)setSp_enterTime:(NSNumber *)sp_enterTime
{
    objc_setAssociatedObject(self, SP_ENTER_TIME_KEY, sp_enterTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)sp_enterTime
{
    return objc_getAssociatedObject(self, SP_ENTER_TIME_KEY);
}

-(void)tl_viewWillAppear:(BOOL)animated {
    self.sp_enterTime = @(CFAbsoluteTimeGetCurrent());
    
    [self tl_viewWillAppear:animated];
}

- (void)tl_viewDidAppear:(BOOL)animated {
    if ([self shouldTrackClass:self.class]) {
        
        // 生成当前页面的信息
        NSArray *currentArray = [self getNaviViewControllers];
        NSMutableString *currentPagePath = [[NSMutableString alloc] init];
        NSInteger pageCount = [currentArray count];
        for (int i=0; i<pageCount; i++) {
            UIViewController *view = [currentArray objectAtIndex:i];
            if ([view title]) {
                [currentPagePath appendString:[view title]];
            }
            else {
                [currentPagePath appendString:[NSString stringWithFormat:@"%@",[view class]]];
            }
            if (i<pageCount-1) {
                [currentPagePath appendString:@":"];
            }
        }
        
        if ([self title]) {
            if (![currentPagePath isEqualToString:@""]) {
                [TLInterfaceManager sharedInstance].current = [NSString stringWithFormat:@"%@:%@", currentPagePath,[self title]];
            }
            else {
                [TLInterfaceManager sharedInstance].current = [self title];
            }
            
            [TLInterfaceManager sharedInstance].currentTitle = [self title];
        }
        else {
            if (![currentPagePath isEqualToString:@""]) {
                [TLInterfaceManager sharedInstance].current = [NSString stringWithFormat:@"%@:%@", currentPagePath,[self class]];
            }
            else {
                [TLInterfaceManager sharedInstance].current = [NSString stringWithFormat:@"%@",[self class]];
            }
            [TLInterfaceManager sharedInstance].currentTitle = [NSString stringWithFormat:@"%@",[self class]];
        }
        
        if ([self parentViewController]) {
            if ([[self parentViewController] isKindOfClass:[UINavigationController class]]) {
                if ([self title]) {
                    [TLInterfaceManager sharedInstance].currentClassName = [self title];
                } else {
                    [TLInterfaceManager sharedInstance].currentClassName = [NSString stringWithFormat:@"%@",[self class]];
                }
            } else {
                if ([[self parentViewController] title]) {
                    [TLInterfaceManager sharedInstance].currentClassName = [NSString stringWithFormat:@"%@",[[self parentViewController] title]];
                } else {
                    [TLInterfaceManager sharedInstance].currentClassName = [NSString stringWithFormat:@"%@",[[self parentViewController] class]];
                }
            }
        }
        else {
            if ([self title]) {
                [TLInterfaceManager sharedInstance].currentClassName = [self title];
            } else {
                [TLInterfaceManager sharedInstance].currentClassName = [NSString stringWithFormat:@"%@",[self class]];
            }
        }
        
        NSLog(@"当前界面信息是: %@\n当前界面类名是: %@\n当前界面标题是: %@",
              [TLInterfaceManager sharedInstance].current,
              [TLInterfaceManager sharedInstance].currentClassName,
              [TLInterfaceManager sharedInstance].currentTitle);
    }
    [self tl_viewDidAppear:animated];
}

- (BOOL)shouldTrackClass:(Class)aClass {
    static NSSet *blacklistedClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *blacklistedClassNames = @[ @"UICompatibilityInputViewController",
                                            @"UIKeyboardCandidateGridCollectionViewController",
                                            @"UIInputWindowController",
                                            @"UICompatibilityInputViewController",
                                            @"UIApplicationRotationFollowingController",
                                            @"UIAlertController",
                                            @"_UIModalItemAppViewController" ];
        NSMutableSet *transformedClasses = [NSMutableSet setWithCapacity:blacklistedClassNames.count];
        for (NSString *className in blacklistedClassNames) {
            if (NSClassFromString(className)) {
                [transformedClasses addObject:NSClassFromString(className)];
            }
        }
        blacklistedClasses = [transformedClasses copy];
    });
    
    return ![blacklistedClasses containsObject:aClass];
}

- (void)tl_viewWillDisappear:(BOOL)animated
{
    if ([self shouldTrackClass:self.class]) {
        CFAbsoluteTime leaveTime = CFAbsoluteTimeGetCurrent();
        NSString *page_duration = [NSString stringWithFormat:@"%f",leaveTime - self.sp_enterTime.doubleValue];
        
        NSLog(@"page_duration: %@ page_class: %@", page_duration, NSStringFromClass(self.class));
        
        // 生成上一页面的信息
        NSMutableArray *referrerArray = [NSMutableArray arrayWithArray:[self getNaviViewControllers]];
        if ([referrerArray count]>0) {
            [referrerArray removeLastObject];
        }
        NSMutableString *referrerPagePath = [[NSMutableString alloc] init];
        NSInteger pageCount = [referrerArray count];
        for (int i=0; i<pageCount; i++) {
            UIViewController *view = [referrerArray objectAtIndex:i];
            if ([view title]) {
                [referrerPagePath appendString:[view title]];
            }
            else {
                [referrerPagePath appendString:[NSString stringWithFormat:@"%@",[view class]]];
            }
            
            if (i<pageCount-1) {
                [referrerPagePath appendString:@":"];
            }
        }
        
        if ([self title]) {
            if (![referrerPagePath isEqualToString:@""]) {
                [TLInterfaceManager sharedInstance].referrer = [NSString stringWithFormat:@"%@:%@", referrerPagePath,[self title]];
            }
            else {
                [TLInterfaceManager sharedInstance].referrer = [self title];
            }
        }
        else {
            if (![referrerPagePath isEqualToString:@""]) {
                [TLInterfaceManager sharedInstance].referrer = [NSString stringWithFormat:@"%@:%@", referrerPagePath,[self class]];
            }
            else {
                [TLInterfaceManager sharedInstance].referrer = [NSString stringWithFormat:@"%@",[self class]];
            }
        }
        
        NSLog(@"上一界面是: %@", [TLInterfaceManager sharedInstance].referrer);
    }
    
    [self tl_viewWillDisappear:animated];
}

-(NSArray *)getNaviViewControllers {
    NSMutableArray *pageArray = [[NSMutableArray alloc] init];
    if (self.presentingViewController) {
        UINavigationController *svc = (UINavigationController *)self.presentingViewController;
        NSArray* arrayControllers = nil;
        if ([svc respondsToSelector:@selector(viewControllers)]) {
            arrayControllers = [svc viewControllers];
        }
        
        [pageArray addObjectsFromArray:[arrayControllers copy]];
    }
    else if(self.presentedViewController) {
        [pageArray addObject:self.presentedViewController];
    }
    else {
        NSArray* arrayControllers = self.navigationController.viewControllers;
        
        [pageArray addObjectsFromArray:[arrayControllers copy]];
        if ([pageArray count]>0) {
            NSUInteger num = [pageArray count];
            [pageArray removeObjectAtIndex:num-1];
        }
    }
    
    return pageArray;
}

@end
