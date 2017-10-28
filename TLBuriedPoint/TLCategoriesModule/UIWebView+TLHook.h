//
//  UIWebView+TLHook.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/27.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebViewDelegateForwarder : NSObject<UIWebViewDelegate>

@property (nonatomic, weak, nullable) id <UIWebViewDelegate> delegate;

@end

@interface UIWebView (TLHook)

@end
