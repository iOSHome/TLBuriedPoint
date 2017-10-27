//
//  TLRootViewController.m
//  TLBuriedPoint
//
//  Created by lichuanjun on 2017/10/26.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLRootViewController.h"
#import "TLAppDelegate.h"


@interface TLSectionView : NSObject

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

@end

@implementation TLSectionView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.titles = @[].mutableCopy;
        self.classNames = @[].mutableCopy;
    }
    
    return self;
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

@end



@interface TLRootViewController ()

@property (nonatomic, strong) NSMutableArray<TLSectionView *> *sections;

@end

@implementation TLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sections = @[].mutableCopy;
    
    TLSectionView *sectionView1 = [[TLSectionView alloc] init];
    [sectionView1 addCell:@"UITableView" class:@"TLTableViewController"];
    [sectionView1 addCell:@"UICollectionView" class:@"TLCollectionViewController"];
    [self.sections addObject:sectionView1];
    
    TLSectionView *sectionView2 = [[TLSectionView alloc] init];
    [sectionView2 addCell:@"UIGestureRecognizer" class:@"TLGestureRecognizerViewController"];
    [self.sections addObject:sectionView2];
    
    TLSectionView *sectionView3 = [[TLSectionView alloc] init];
    [sectionView3 addCell:@"UIWebView" class:@"TLUIWebViewController"];
    [sectionView3 addCell:@"WKWebView" class:@"TLWKWebViewController"];
    [self.sections addObject:sectionView3];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.sections[section].titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"buriedPointIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    TLSectionView *sectionView = self.sections[indexPath.section];
    cell.textLabel.text = sectionView.titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TLSectionView *sectionView = self.sections[indexPath.section];
    NSString *className = sectionView.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = sectionView.titles[indexPath.row];
        
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
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.backgroundColor = [UIColor grayColor];
    lblTitle.textColor = [UIColor whiteColor];
    
    switch (section) {
        case 0:
        {
            lblTitle.text = @"Hook 列表控件";
            return lblTitle;
        }
            break;
        case 1:
        {
            lblTitle.text = @"Hook 手势控件";
            return lblTitle;
        }
            break;
        case 2:
        {
            lblTitle.text = @"Hook 网页控件";
            return lblTitle;
        }
            break;
        default:
            break;
    }

    return nil;
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
