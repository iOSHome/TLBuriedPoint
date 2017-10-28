//
//  WKWebView+TLHook.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/27.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "WKWebView+TLHook.h"
#import "TLSwizzle.h"
#import "TLHookManager.h"
#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#else
#import <objc/objc-class.h>
#endif

@implementation WKNavigationDelegateForwarder

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    if([_navigationDelegate respondsToSelector:selector]) {
        // 调回原delegate对象
        [invocation invokeWithTarget:_navigationDelegate];
        
        TLHookManager *tlhm = [TLHookManager sharedInstance];
        if ([tlhm respondsToSelector:selector]) {
            [invocation invokeWithTarget:tlhm];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)selector
{
    return [_navigationDelegate respondsToSelector:selector];
}

- (id)methodSignatureForSelector:(SEL)selector
{
    return [(NSObject *)_navigationDelegate methodSignatureForSelector:selector];
}

@end


@implementation WKWebView (TLHook)

+ (void)load {
    NSError *error = NULL;
    
    [self tl_swizzleMethod:@selector(setNavigationDelegate:)
                withMethod:@selector(setTLNavigationDelegate:)
                     error:&error];
    if (error) {
        NSLog(@"Failed to swizzle setNavigationDelegate: on WKWebView. Details: %@", error);
        error = NULL;
    }
}

- (void)setTLNavigationDelegate:(id<WKNavigationDelegate>)navigationDelegate {
    if (!navigationDelegate) {
        [self setTLNavigationDelegate:nil];
        return;
    }
    
    WKNavigationDelegateForwarder *delegateForwarder = [[WKNavigationDelegateForwarder alloc] init];
    delegateForwarder.navigationDelegate = navigationDelegate;
    self.delegateForward = delegateForwarder;
    
    [self setTLNavigationDelegate:nil];
    [self setTLNavigationDelegate:delegateForwarder];
}

- (void)setDelegateForward:(WKNavigationDelegateForwarder *)navigationDelegateForward {
    objc_setAssociatedObject(self, @selector(navigationDelegateForward), navigationDelegateForward, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WKNavigationDelegateForwarder *)navigationDelegateForward {
    return objc_getAssociatedObject(self, @selector(navigationDelegateForward));
}

@end
