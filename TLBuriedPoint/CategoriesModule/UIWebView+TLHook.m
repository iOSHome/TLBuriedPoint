//
//  UIWebView+TLHook.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/27.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UIWebView+TLHook.h"
#import "TLSwizzle.h"
#import "TLHookManager.h"
#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#else
#import <objc/objc-class.h>
#endif

@implementation UIWebViewDelegateForwarder

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    if([_delegate respondsToSelector:selector]) {
        // 调回原delegate对象
        [invocation invokeWithTarget:_delegate];
        
        TLHookManager *tlhm = [TLHookManager sharedInstance];
        if ([tlhm respondsToSelector:selector]) {
            [invocation invokeWithTarget:tlhm];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)selector
{
    return [_delegate respondsToSelector:selector];
}

- (id)methodSignatureForSelector:(SEL)selector
{
    return [(NSObject *)_delegate methodSignatureForSelector:selector];
}

@end

@implementation UIWebView (TLHook)

+ (void)load {
    NSError *error = NULL;
    
    [self tl_swizzleMethod:@selector(setDelegate:)
                withMethod:@selector(setTLDelegate:)
                     error:&error];
    if (error) {
        NSLog(@"Failed to swizzle setDelegate: on UIWebView. Details: %@", error);
        error = NULL;
    }
}

- (void)setTLDelegate:(id<UIWebViewDelegate>)delegate {
    if (!delegate) {
        [self setTLDelegate:nil];
        return;
    }
    
    UIWebViewDelegateForwarder *delegateForwarder = [[UIWebViewDelegateForwarder alloc] init];
    delegateForwarder.delegate = delegate;
    self.delegateForward = delegateForwarder;
    
    [self setTLDelegate:nil];
    [self setTLDelegate:delegateForwarder];
}

- (void)setDelegateForward:(UIWebViewDelegateForwarder *)delegateForward {
    objc_setAssociatedObject(self, @selector(delegateForward), delegateForward, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWebViewDelegateForwarder *)delegateForward {
    return objc_getAssociatedObject(self, @selector(delegateForward));
}

@end
