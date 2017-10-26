//
//  TLHookMananger.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLHookManager.h"
#import "TLObjectPath.h"

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
//    NSLog(@"===indexPath:[%ld:%ld]===tableView:%@===",indexPath.section,indexPath.row,tableView);
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
//    NSLog(@"===collectionView:%@===[%ld:%ld]===",collectionView,indexPath.section,indexPath.row);
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

@end
