//
//  TLHookMananger.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLHookManager.h"
#import "TLObjectPath.h"

#if TARGET_OS_IPHONE
#import <objc/runtime.h>
#import <objc/message.h>
#else
#import <objc/objc-class.h>
#endif

@implementation TLHookManager

+ (TLHookManager *)sharedInstance
{
    static TLHookManager *sharedStatisticHookManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedStatisticHookManagerInstance = [[self alloc] init];
    });
    return sharedStatisticHookManagerInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - function

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TLObjectPath *objPath = [[TLObjectPath alloc] init];
    NSString *path = [objPath getPathWithObject:tableView];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *label = (cell && cell.textLabel && cell.textLabel.text) ? cell.textLabel.text : @"";
    NSDictionary *dit = @{
                          kObjectPathName: path,
                          @"Cell Index": [NSString stringWithFormat: @"%ld", (unsigned long)indexPath.row],
                          @"Cell Section": [NSString stringWithFormat: @"%ld", (unsigned long)indexPath.section],
                          @"Cell Label": label
                          };
    NSLog(@"%@",dit);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TLObjectPath *objPath = [[TLObjectPath alloc] init];
    NSString *path = [objPath getPathWithObject:collectionView];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSString *label = (cell && cell.backgroundColor) ? [NSString stringWithFormat:@"%@",cell.backgroundColor] : @"";
    NSDictionary *dit = @{
                          kObjectPathName: path,
                          @"Collection Index": [NSString stringWithFormat: @"%ld", (unsigned long)indexPath.row],
                          @"Collection Section": [NSString stringWithFormat: @"%ld", (unsigned long)indexPath.section],
                          @"Collection backgroundColor": label
                          };
    NSLog(@"%@",dit);
}

-(void)gestureRecognizerAction:(UIGestureRecognizer*)gestureRecognizer{

    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {// 轻触/点按
        UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)gestureRecognizer;
        [self tapGestureAction:tapGestureRecognizer];
    }
    
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {// 滑动手势
        UISwipeGestureRecognizer *swipeGestureRecognizer = (UISwipeGestureRecognizer *)gestureRecognizer;
        [self swipeGestureAction:swipeGestureRecognizer];
    }
    
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {// 长按手势
        UILongPressGestureRecognizer *longGestureRecognizer = (UILongPressGestureRecognizer *)gestureRecognizer;
        [self longPressGestureAction:longGestureRecognizer];
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {// 捏合手势，缩放用
        
        UIPinchGestureRecognizer *pinchGestureRecognizer = (UIPinchGestureRecognizer *)gestureRecognizer;
        [self pinchGestureAction:pinchGestureRecognizer];
    }
    
    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {// 旋转手势
        UIRotationGestureRecognizer *rotationGestureRecognizer = (UIRotationGestureRecognizer *)gestureRecognizer;
        [self rotationGestureAction:rotationGestureRecognizer];
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {// 拖拽手势
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        [self panGestureAction:panGestureRecognizer];
    }
    
    if ( [gestureRecognizer.view respondsToSelector: @selector( setText: )] == YES ) {
        NSLog(@"%@",[gestureRecognizer.view tl_text]);
    }
}

-(void)tapGestureAction:(UITapGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.numberOfTapsRequired) {
        case 1: // 单击
        {
            NSLog(@"单击");
        }
            break;
        case 2: // 双击
        {
            NSLog(@"双击");
        }
            break;
        default:
            break;
    }
}

-(void)longPressGestureAction:(UILongPressGestureRecognizer *)gestureRecognizer {

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按开始...");
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"长按结束...");
    }
}

-(void)swipeGestureAction:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionUp: // 向上滑动
        {
            NSLog(@"向上滑动");
        }
            break;
        case UISwipeGestureRecognizerDirectionDown: // 向下滑动
        {
            NSLog(@"向下滑动");
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft: // 向左滑动
        {
            NSLog(@"向左滑动");
        }
            break;
        case UISwipeGestureRecognizerDirectionRight: // 向右滑动
        {
            NSLog(@"向右滑动");
        }
            break;
        default:
            break;
    }
}

-(void)pinchGestureAction:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.scale > 1) {
        NSLog(@"向外捏合");
    } else {
        NSLog(@"向内捏合");
    }
}

-(void)rotationGestureAction:(UIRotationGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"旋转开始...");
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"旋转结束...");
    }
}

-(void)panGestureAction:(UIPanGestureRecognizer *)gestureRecognizer {

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"拖动开始...");
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"拖动结束...");
    }
}

@end
