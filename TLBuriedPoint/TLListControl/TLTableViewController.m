//
//  TLTableViewController.m
//  iosFetchModuleTech
//
//  Created by lichuanjun on 2017/4/10.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLTableViewController.h"

@interface TLTableViewController ()

@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation TLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *arrDataItem1 = [[NSArray alloc] initWithObjects:@"cell00", @"cell01", @"cell02", @"cell03", @"cell04", @"cell05", nil];
    NSArray *arrDataItem2 = [[NSArray alloc] initWithObjects:@"cell10", @"cell11", @"cell12", @"cell13", @"cell14", @"cell15", nil];
    self.arrData = [[NSMutableArray alloc] initWithObjects:arrDataItem1, arrDataItem2, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.arrData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *arrItem = [self.arrData objectAtIndex:indexPath.section];
    cell.textLabel.text = [arrItem objectAtIndex:indexPath.row];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    lblTitle.text = [NSString stringWithFormat:@"section header %ld",section];
    lblTitle.textColor = [UIColor redColor];
    [headerView addSubview:lblTitle];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor darkGrayColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    lblTitle.text = [NSString stringWithFormat:@"section footer %ld",section];
    lblTitle.textColor = [UIColor yellowColor];
    [footerView addSubview:lblTitle];
    
    return footerView;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
    
    NSArray *arrItem = [self.arrData objectAtIndex:indexPath.section];
    NSLog(@"%@",[arrItem objectAtIndex:indexPath.row]);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
