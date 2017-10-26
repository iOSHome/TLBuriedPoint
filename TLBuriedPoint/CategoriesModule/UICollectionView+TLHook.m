//
//  UICollectionView+TLHook.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "UICollectionView+TLHook.h"
#import "TLSwizzle.h"
#import "TLHookManager.h"

#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#else
#import <objc/objc-class.h>
#endif

@implementation UICollectionViewDelegateForwarder

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    if([_delegate respondsToSelector:selector])
    {
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

@implementation UICollectionView (TLHook)

+ (void)load {
    NSError *error = NULL;
    
    [self tl_swizzleMethod:@selector(setDelegate:)
                withMethod:@selector(setTLDelegate:)
                     error:&error];
    if (error) {
        NSLog(@"Failed to swizzle setDelegate: on UICollectionView. Details: %@", error);
        error = NULL;
    }
}

- (void)setTLDelegate:(id<UICollectionViewDelegate>)delegate {
    [self setDelegateForward:nil];
    if (!delegate) {
        [self setTLDelegate:nil];
        return;
    }
    
    UICollectionViewDelegateForwarder *delegateForwarder = [[UICollectionViewDelegateForwarder alloc] init];
    delegateForwarder.delegate = delegate;
    [self setDelegateForward:delegateForwarder];
    
    [self setTLDelegate:nil];
    [self setTLDelegate:delegateForwarder];
}

- (void)setDelegateForward:(UICollectionViewDelegateForwarder *)delegateForward {
    objc_setAssociatedObject(self, @selector(delegateForward), delegateForward, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UICollectionViewDelegateForwarder *)delegateForward {
    return objc_getAssociatedObject(self, @selector(delegateForward));
}

@end
