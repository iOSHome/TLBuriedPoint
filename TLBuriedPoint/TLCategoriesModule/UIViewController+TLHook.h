//
//  UIViewController+TLHook.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/28.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TLHook)

- (void)tl_viewDidAppear:(BOOL)animated;
- (void)tl_viewWillAppear:(BOOL)animated;
- (void)tl_viewWillDisappear:(BOOL)animated;

@end
