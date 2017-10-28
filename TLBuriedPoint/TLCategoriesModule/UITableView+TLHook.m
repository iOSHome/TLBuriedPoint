//
//  UITableView+TLHook.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UITableView+TLHook.h"
#import "TLSwizzle.h"
#import "TLHookManager.h"

#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#else
#import <objc/objc-class.h>
#endif

@implementation UITableViewDelegateForwarder

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    if([_delegate respondsToSelector:selector]) {
        // 调回原delegate对象
        [invocation invokeWithTarget:_delegate];
        //
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


@implementation UITableView (TLHook)

+ (void)load {
    NSError *error = NULL;
    
    [self tl_swizzleMethod:@selector(setDelegate:)
                withMethod:@selector(setTLDelegate:)
                     error:&error];
    if (error) {
        NSLog(@"Failed to swizzle setDelegate: on UITableView. Details: %@", error);
        error = NULL;
    }
}

- (void)setTLDelegate:(id<UITableViewDelegate>)delegate {
    if (!delegate) {
        [self setTLDelegate:nil];
        return;
    }
    
    UITableViewDelegateForwarder *delegateForwarder = [[UITableViewDelegateForwarder alloc] init];
    delegateForwarder.delegate = delegate;
    self.delegateForward = delegateForwarder;
    
    [self setTLDelegate:nil];
    [self setTLDelegate:delegateForwarder];
}

- (void)setDelegateForward:(UITableViewDelegateForwarder *)delegateForward {
    objc_setAssociatedObject(self, @selector(delegateForward), delegateForward, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewDelegateForwarder *)delegateForward {
    return objc_getAssociatedObject(self, @selector(delegateForward));
}

@end
