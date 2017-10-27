//
//  WKWebView+TLHook.h
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/27.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKNavigationDelegateForwarder : NSObject<WKNavigationDelegate>

@property (nonatomic, weak, nullable) id <WKNavigationDelegate> navigationDelegate;

@end

@interface WKWebView (TLHook)

@end
