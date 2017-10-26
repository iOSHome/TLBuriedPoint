//
//  TLRootViewController.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLRootViewController.h"
#import "TLAppDelegate.h"

@interface TLRootViewController ()

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

@end

@implementation TLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addCell:@"UITableView" class:@"TLTableViewController"];
    [self addCell:@"UICollectionView" class:@"TLCollectionViewController"];
    [self addCell:@"UIGestureRecognizer" class:@"TLGestureRecognizerViewController"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"埋点设计";
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _titles.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"buriedPointIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        
        TLAppDelegate *appDelegate = (TLAppDelegate *) [UIApplication sharedApplication].delegate;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            UINavigationController *navigationController = (UINavigationController *) appDelegate.viewController;
            [navigationController pushViewController:ctrl animated:YES];
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UISplitViewController *splitViewController = (UISplitViewController *) appDelegate.viewController;
            UINavigationController *navigationController = [splitViewController.viewControllers objectAtIndex:1];
            [navigationController popToRootViewControllerAnimated:NO];
            [navigationController pushViewController:ctrl animated:YES];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UILabel *lblTitle = [[UILabel alloc] init];
        lblTitle.backgroundColor = [UIColor grayColor];
        lblTitle.textColor = [UIColor whiteColor];
        lblTitle.text = @"Hook 列表控件";
        return lblTitle;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

@end
