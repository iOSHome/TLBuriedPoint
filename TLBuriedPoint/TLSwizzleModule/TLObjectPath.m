//
//  TLObjectPath.m
//  Specter
//
//  Created by lichuanjun on 2017/4/1.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLObjectPath.h"

@implementation TLObjectPath

/**
 * 根据object将其父类生成对应的path
 *
 */
- (NSString *)getPathWithObject:(id)object
{
    NSMutableArray *allObject = [NSMutableArray array];
    
    NSMutableString *pathString = [[NSMutableString alloc] init];
    
    if (object) {
        [pathString appendFormat:@"/%@", [object class]];
    }
    
    NSArray *parentsArray = [self getParentsOfObject:object];
    [allObject addObjectsFromArray:parentsArray];
    
    BOOL isExistUIWindow = NO;
    while([parentsArray count]) {
        NSObject *viewObject=nil,*viewControllerObject=nil;
        for (NSObject *parent in parentsArray) {
            if ([parent isKindOfClass:[UIView class]]) {
                viewObject = parent;
            }
            if ([parent isKindOfClass:[UIViewController class]]) {
                viewControllerObject = parent;
            }
            
            if ([parent isKindOfClass:[UIWindow class]]) {
                isExistUIWindow = YES;
                break;
            }
        }
        
        if (isExistUIWindow) {
            break;
        }
        
        if (viewControllerObject) {
            [pathString insertString:[NSString stringWithFormat:@"/%@",[viewControllerObject class]] atIndex:0];
        }
        else {
            if (viewObject) {
                [pathString insertString:[NSString stringWithFormat:@"/%@",[viewObject class]] atIndex:0];
            }
        }
        
        NSMutableArray *newParentsArray = [NSMutableArray array];
        for (NSObject *parent in parentsArray) {
            [newParentsArray addObjectsFromArray:[self getParentsOfObject:parent]];
        }

        parentsArray = newParentsArray;
        [allObject addObjectsFromArray:parentsArray];
    }
    
    NSString *controlIndex = [self createUIControlIndex:object allObject:allObject];
    NSString *path = [NSString stringWithFormat:@"%@%@",[pathString copy],controlIndex];
    
    return path;
}

-(NSString *) createUIControlIndex:(id)object allObject:(NSMutableArray *)allObject {
    NSString *strViewId=nil, *strVarE=nil, *controlIndex=nil;
    if ([object respondsToSelector:@selector(tl_viewId)]) {
        strViewId = [object tl_viewId];
    }
    if ([object respondsToSelector:@selector(tl_varE)]) {
        strVarE = [object tl_varE];
    }
    
    // 生成path的规则
    if (strViewId) {// 1.根据viewId
        if ([object respondsToSelector:@selector(tl_varA)]) {
            controlIndex = [NSString stringWithFormat:@"[sp_varA==\"%@\"]",[object tl_varA]];
        }
    }
    else if([object tag] != 0){// 2.根据tag
        controlIndex = [NSString stringWithFormat:@"[tag==%ld]",(long)[object tag]];
    }
    else if (strVarE) {// 3.3.根据fingerprintVersion和text
        controlIndex = [NSString stringWithFormat:@"[(sp_fingerprintVersion >= %d AND sp_varE == \"%@\")]",[object tl_fingerprintVersion],strVarE];
    }
    else {// 4.根据UIControl在改View上的同类型UIControl的顺序
        id preObject = [allObject firstObject];
        NSInteger indexPath = 0;
        if ([preObject isKindOfClass:[UIViewController class]]) {// 处理特殊情况，故事板
            preObject = [preObject view];
            if ([preObject isKindOfClass:[object class]] && preObject == object) {
                controlIndex = [NSString stringWithFormat:@"[%ld]",(long)indexPath];
            }
        }
        else {
            for (id subView in [preObject subviews])
            {
                if ([subView isKindOfClass:[object class]]) {
                    if (subView == object) {
                        controlIndex = [NSString stringWithFormat:@"[%ld]",(long)indexPath];
                        break;
                    }
                    indexPath++;
                }
//                NSLog(@"subView class:%@",[subView class]);
            }
        }
    }
    
    return controlIndex;
}

/**
 * 根据object获取其所有的父类
 *
 */

- (NSArray *)getParentsOfObject:(NSObject *)object
{
    NSMutableArray *result = [NSMutableArray array];
    if ([object isKindOfClass:[UIView class]]) {
        UIView *superview = [(UIView *)object superview];
        if (superview) {
            [result addObject:superview];
        }
        UIResponder *nextResponder = [(UIView *)object nextResponder];
        // For UIView, nextResponder should be its controller or its superview.
        if (nextResponder && nextResponder != superview) {
            [result addObject:nextResponder];
        }
    } else if ([object isKindOfClass:[UIViewController class]]) {
        UIViewController *parentViewController = [(UIViewController *)object parentViewController];
        if (parentViewController) {
            [result addObject:parentViewController];
        }
        UIViewController *presentingViewController = [(UIViewController *)object presentingViewController];
        if (presentingViewController) {
            [result addObject:presentingViewController];
        }
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow.rootViewController == object) {
            //TODO is there a better way to get the actual window that has this VC
            [result addObject:keyWindow];
        }
    }
    return [result copy];
}

/**
 * 根据object获取其父类的路径
 *
 */
- (NSString *)getInterfacePathWithObject:(id)object
{
    NSMutableString *pathString = [[NSMutableString alloc] init];
    
    if (object) {
        [pathString appendFormat:@"/%@", [object class]];
    }
    
    NSArray *parentsArray = [self getParentsOfObject:object];
    
    BOOL isExistUIWindow = NO;
    while([parentsArray count]) {
        NSObject *viewObject=nil,*viewControllerObject=nil;
        for (NSObject *parent in parentsArray) {
            if ([parent isKindOfClass:[UIView class]]) {
                viewObject = parent;
            }
            if ([parent isKindOfClass:[UIViewController class]]) {
                viewControllerObject = parent;
            }
            
            if ([parent isKindOfClass:[UIWindow class]]) {
                isExistUIWindow = YES;
                break;
            }
        }
        
        if (isExistUIWindow) {
            break;
        }
        
        if (viewControllerObject) {
            [pathString insertString:[NSString stringWithFormat:@"/%@",[viewControllerObject class]] atIndex:0];
        }
        else {
            if (viewObject) {
                [pathString insertString:[NSString stringWithFormat:@"/%@",[viewObject class]] atIndex:0];
            }
        }
        
        NSMutableArray *newParentsArray = [NSMutableArray array];
        for (NSObject *parent in parentsArray) {
            [newParentsArray addObjectsFromArray:[self getParentsOfObject:parent]];
        }
        
        parentsArray = newParentsArray;
    }
    
    return pathString;
}

@end
