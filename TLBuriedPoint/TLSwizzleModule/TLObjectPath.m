//
//  TLObjectPath.m
//  Specter
//
//  Created by lichuanjun on 2017/4/1.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLObjectPath.h"
#import "TLInterfaceManager.h"

@implementation TLObjectPath

/**
 * 根据object将其父类生成对应的path
 *
 */
- (NSString *)getPathWithObject:(id)object
{
    NSMutableArray *allParents = [NSMutableArray array];
    
    NSMutableString *pathString = [[NSMutableString alloc] init];
    
    if (object) {
        [pathString appendFormat:@"/%@", [object class]];
    }
    
    NSMutableArray *parentsArray = [NSMutableArray array];
    [parentsArray addObjectsFromArray:[self spGetParentsOfObject:object]];
    
    while([parentsArray count] > 0) {
        
        id tmpObject = nil;
        BOOL isExistWindow = NO;
        for (NSInteger i=0; i< [parentsArray count]; i++) {
            tmpObject = [parentsArray objectAtIndex:i];
            
            if ([tmpObject isKindOfClass:[UIWindow class]]) {
                isExistWindow = YES;
                break;
            }
            
            [allParents addObject:tmpObject];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                [pathString insertString:[NSString stringWithFormat:@"/%@",[tmpObject class]] atIndex:0];
            }
            else {
                NSString *strClassName = [NSString stringWithFormat:@"%@",[tmpObject class]];
                NSRange rangeClassName = [strClassName rangeOfString:@"UITableViewCellScrollView"];
                if (rangeClassName.location == NSNotFound) {
                    [pathString insertString:[NSString stringWithFormat:@"/%@",[tmpObject class]] atIndex:0];
                }
            }
        }
        
        if (isExistWindow) {
            break;
        }
        
        [parentsArray removeAllObjects];
        [parentsArray addObjectsFromArray:[self spGetParentsOfObject:tmpObject]];
    }
    
    NSString *controlOrder = [self createControlOrder:object directFather:[allParents firstObject]];
    NSString *path = [NSString stringWithFormat:@"%@%@",[pathString copy],controlOrder];
    
    return path;
}

-(NSString *) createControlOrder:(id)ctlObject directFather:(id)directFather {
    NSString *strViewId=nil, *strVarE=nil, *controlOrder=nil;
    if ([ctlObject respondsToSelector:@selector(tl_viewId)]) {
        strViewId = [ctlObject tl_viewId];
    }
    if ([ctlObject respondsToSelector:@selector(tl_varE)]) {
        strVarE = [ctlObject tl_varE];
    }
    
    // 生成path的规则
    if (strViewId) {// 1.根据viewId
        if ([ctlObject respondsToSelector:@selector(tl_varA)]) {
            controlOrder = [NSString stringWithFormat:@"[sp_varA==\"%@\"]",[ctlObject tl_varA]];
        }
    }
    else if([ctlObject tag] != 0){// 2.根据tag
        controlOrder = [NSString stringWithFormat:@"[tag==%ld]",(long)[ctlObject tag]];
    }
    else if (strVarE) {// 3.根据fingerprintVersion和text
        controlOrder = [NSString stringWithFormat:@"[(sp_fingerprintVersion >= %d AND sp_varE == \"%@\")]",[ctlObject tl_fingerprintVersion],strVarE];
    }
    else {// 4.根据UIControl在改View上的同类型UIControl的顺序
        if ([directFather isKindOfClass:[UIViewController class]]) {// 处理特殊情况，故事板
            id directFatherView = [directFather view];
            if ([directFatherView isKindOfClass:[ctlObject class]] && [directFatherView isEqual:ctlObject]) {
                controlOrder = @"[0]";
            }
        }
        else {
            NSArray *arraySubViews = [directFather subviews];
            NSMutableArray *arrayCtlSubViews = [NSMutableArray array];
            
            for (NSInteger i = 0; i < [arraySubViews count]; i++) {
                id tmpObject = [arraySubViews objectAtIndex:i];
                if ([tmpObject isKindOfClass:[ctlObject class]]) {
                    [arrayCtlSubViews addObject:tmpObject];
                }
            }
            //            NSLog(@"arrayCtlSubViews: %@", arrayCtlSubViews);
            NSArray *sortedArray = [arrayCtlSubViews sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
                if ([obj1 frame].origin.x < [obj2 frame].origin.x) {
                    return NSOrderedAscending;
                } else if ([obj1 frame].origin.x == [obj2 frame].origin.x) {
                    if ([obj1 frame].origin.y < [obj2 frame].origin.y) {
                        return NSOrderedAscending;
                    } else {
                        return NSOrderedDescending;
                    }
                }
                else {
                    return NSOrderedDescending;
                }
            }];
            //            NSLog(@"sortedArray: %@", sortedArray);
            NSInteger idxObject = 0;
            for (NSInteger i = 0; i < [sortedArray count]; i++) {
                
                id tmpObject = [sortedArray objectAtIndex:i];
                
                if ([tmpObject isKindOfClass:[ctlObject class]]) {
                    if ([tmpObject isEqual:ctlObject]) {
                        controlOrder = [NSString stringWithFormat:@"[%ld]",(long)idxObject];
                        break;
                    }
                    idxObject++;
                }
            }
        }
    }
    
    return controlOrder;
}

/**
 * 根据object获取其所有的父类
 *
 */

- (NSArray *)spGetParentsOfObject:(NSObject *)object
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
    
    NSArray *parentsArray = [self spGetParentsOfObject:object];
    
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
            [newParentsArray addObjectsFromArray:[self spGetParentsOfObject:parent]];
        }
        
        parentsArray = newParentsArray;
    }
    
    return pathString;
}

-(NSString *) getCurrentPageClass
{
    
    NSString *currentUrl = [[NSString alloc] init];
    currentUrl = [NSString stringWithFormat:@"%@",[TLInterfaceManager sharedInstance].currentClassName];
    
    if ([currentUrl isEqualToString:@""]) {
        currentUrl = @"specter_sdk_not_classname";
        
        // 获取当前视图控制器
        UIViewController *curViewController = nil;
        UIViewController *rootViewController = [[UIApplication sharedApplication].windows.firstObject rootViewController];
        if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *containerCtrl = (UITabBarController *)rootViewController;
            curViewController = containerCtrl.selectedViewController;
            
            if ([curViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *naviCtrl = (UINavigationController *)curViewController;
                curViewController = naviCtrl.viewControllers.lastObject;
            }
        }
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *naviCtrl = (UINavigationController *)rootViewController;
            curViewController = naviCtrl.viewControllers.lastObject;
        }
        
        if (curViewController) {
            currentUrl = [NSString stringWithFormat:@"%@",[self class]];
        }
    }
    
    return currentUrl;
}

///**
// * 根据object将其父类生成对应的path
// *
// */
//- (NSString *)getPathWithObject:(id)object
//{
//    NSMutableArray *allObject = [NSMutableArray array];
//
//    NSMutableString *pathString = [[NSMutableString alloc] init];
//
//    if (object) {
//        [pathString appendFormat:@"/%@", [object class]];
//    }
//
//    NSArray *parentsArray = [self getParentsOfObject:object];
//    [allObject addObjectsFromArray:parentsArray];
//
//    BOOL isExistUIWindow = NO;
//    while([parentsArray count]) {
//        NSObject *viewObject=nil,*viewControllerObject=nil;
//        for (NSObject *parent in parentsArray) {
//            if ([parent isKindOfClass:[UIView class]]) {
//                viewObject = parent;
//            }
//            if ([parent isKindOfClass:[UIViewController class]]) {
//                viewControllerObject = parent;
//            }
//
//            if ([parent isKindOfClass:[UIWindow class]]) {
//                isExistUIWindow = YES;
//                break;
//            }
//        }
//
//        if (isExistUIWindow) {
//            break;
//        }
//
//        if (viewControllerObject) {
//            [pathString insertString:[NSString stringWithFormat:@"/%@",[viewControllerObject class]] atIndex:0];
//        }
//        else {
//            if (viewObject) {
//                [pathString insertString:[NSString stringWithFormat:@"/%@",[viewObject class]] atIndex:0];
//            }
//        }
//
//        NSMutableArray *newParentsArray = [NSMutableArray array];
//        for (NSObject *parent in parentsArray) {
//            [newParentsArray addObjectsFromArray:[self getParentsOfObject:parent]];
//        }
//
//        parentsArray = newParentsArray;
//        [allObject addObjectsFromArray:parentsArray];
//    }
//
//    NSString *controlIndex = [self createUIControlIndex:object allObject:allObject];
//    NSString *path = [NSString stringWithFormat:@"%@%@",[pathString copy],controlIndex];
//
//    return path;
//}
//
//-(NSString *) createUIControlIndex:(id)object allObject:(NSMutableArray *)allObject {
//    NSString *strViewId=nil, *strVarE=nil, *controlIndex=nil;
//    if ([object respondsToSelector:@selector(tl_viewId)]) {
//        strViewId = [object tl_viewId];
//    }
//    if ([object respondsToSelector:@selector(tl_varE)]) {
//        strVarE = [object tl_varE];
//    }
//
//    // 生成path的规则
//    if (strViewId) {// 1.根据viewId
//        if ([object respondsToSelector:@selector(tl_varA)]) {
//            controlIndex = [NSString stringWithFormat:@"[sp_varA==\"%@\"]",[object tl_varA]];
//        }
//    }
//    else if([object tag] != 0){// 2.根据tag
//        controlIndex = [NSString stringWithFormat:@"[tag==%ld]",(long)[object tag]];
//    }
//    else if (strVarE) {// 3.3.根据fingerprintVersion和text
//        controlIndex = [NSString stringWithFormat:@"[(sp_fingerprintVersion >= %d AND sp_varE == \"%@\")]",[object tl_fingerprintVersion],strVarE];
//    }
//    else {// 4.根据UIControl在改View上的同类型UIControl的顺序
//        id preObject = [allObject firstObject];
//        NSInteger indexPath = 0;
//        if ([preObject isKindOfClass:[UIViewController class]]) {// 处理特殊情况，故事板
//            preObject = [preObject view];
//            if ([preObject isKindOfClass:[object class]] && preObject == object) {
//                controlIndex = [NSString stringWithFormat:@"[%ld]",(long)indexPath];
//            }
//        }
//        else {
//            for (id subView in [preObject subviews])
//            {
//                if ([subView isKindOfClass:[object class]]) {
//                    if (subView == object) {
//                        controlIndex = [NSString stringWithFormat:@"[%ld]",(long)indexPath];
//                        break;
//                    }
//                    indexPath++;
//                }
////                NSLog(@"subView class:%@",[subView class]);
//            }
//        }
//    }
//
//    return controlIndex;
//}
//
///**
// * 根据object获取其所有的父类
// *
// */
//
//- (NSArray *)getParentsOfObject:(NSObject *)object
//{
//    NSMutableArray *result = [NSMutableArray array];
//    if ([object isKindOfClass:[UIView class]]) {
//        UIView *superview = [(UIView *)object superview];
//        if (superview) {
//            [result addObject:superview];
//        }
//        UIResponder *nextResponder = [(UIView *)object nextResponder];
//        // For UIView, nextResponder should be its controller or its superview.
//        if (nextResponder && nextResponder != superview) {
//            [result addObject:nextResponder];
//        }
//    } else if ([object isKindOfClass:[UIViewController class]]) {
//        UIViewController *parentViewController = [(UIViewController *)object parentViewController];
//        if (parentViewController) {
//            [result addObject:parentViewController];
//        }
//        UIViewController *presentingViewController = [(UIViewController *)object presentingViewController];
//        if (presentingViewController) {
//            [result addObject:presentingViewController];
//        }
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        if (keyWindow.rootViewController == object) {
//            //TODO is there a better way to get the actual window that has this VC
//            [result addObject:keyWindow];
//        }
//    }
//    return [result copy];
//}
//
///**
// * 根据object获取其父类的路径
// *
// */
//- (NSString *)getInterfacePathWithObject:(id)object
//{
//    NSMutableString *pathString = [[NSMutableString alloc] init];
//
//    if (object) {
//        [pathString appendFormat:@"/%@", [object class]];
//    }
//
//    NSArray *parentsArray = [self getParentsOfObject:object];
//
//    BOOL isExistUIWindow = NO;
//    while([parentsArray count]) {
//        NSObject *viewObject=nil,*viewControllerObject=nil;
//        for (NSObject *parent in parentsArray) {
//            if ([parent isKindOfClass:[UIView class]]) {
//                viewObject = parent;
//            }
//            if ([parent isKindOfClass:[UIViewController class]]) {
//                viewControllerObject = parent;
//            }
//
//            if ([parent isKindOfClass:[UIWindow class]]) {
//                isExistUIWindow = YES;
//                break;
//            }
//        }
//
//        if (isExistUIWindow) {
//            break;
//        }
//
//        if (viewControllerObject) {
//            [pathString insertString:[NSString stringWithFormat:@"/%@",[viewControllerObject class]] atIndex:0];
//        }
//        else {
//            if (viewObject) {
//                [pathString insertString:[NSString stringWithFormat:@"/%@",[viewObject class]] atIndex:0];
//            }
//        }
//
//        NSMutableArray *newParentsArray = [NSMutableArray array];
//        for (NSObject *parent in parentsArray) {
//            [newParentsArray addObjectsFromArray:[self getParentsOfObject:parent]];
//        }
//
//        parentsArray = newParentsArray;
//    }
//
//    return pathString;
//}

@end
