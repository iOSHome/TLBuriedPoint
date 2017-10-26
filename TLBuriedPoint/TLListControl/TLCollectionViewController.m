//
//  TLCollectionViewController.m
//  iosFetchModuleTech
//
//  Created by lichuanjun on 2017/4/10.
//  Copyright © 2017年 lichuanjun. All rights reserved.
//

#import "TLCollectionViewController.h"

@interface TLCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation TLCollectionViewController

static NSString * const reuseIdentifier = @"CollectionCell";

- (instancetype)init
{
    //创建一个流式布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置每个cell的大小
    layout.itemSize = CGSizeMake(80, 80);
    //设置每个cell间的最小水平间距
    layout.minimumInteritemSpacing = 0;
    //设置每个cell间的行间距
    layout.minimumLineSpacing = 5;
    //设置每一组距离四周的内边距
    layout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    layout.headerReferenceSize = CGSizeMake(0, 20);
    layout.footerReferenceSize = CGSizeMake(0, 20);
    
    //返回
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes 注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //注册区头视图
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //注册区尾视图
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    NSArray *arrItem1 = [[NSArray alloc] initWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor], [UIColor cyanColor], [UIColor magentaColor], nil];
    NSArray *arrItem2 = [[NSArray alloc] initWithObjects:[UIColor blackColor], [UIColor purpleColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor brownColor], [UIColor lightGrayColor], nil];
    self.arrData = [[NSMutableArray alloc] initWithObjects:arrItem1, arrItem2, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>
// 在代理方法中设置相应的数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.arrData.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.arrData objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [[self.arrData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    [cell setBackgroundColor:[UIColor greenColor]];
    NSLog(@"%ld-%ld",indexPath.section,indexPath.row);
}

////当每个区的区头高度不一样时通过此方法设置区头高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return CGSizeMake(0, 100);
//    }
//    return CGSizeMake(0, 0.001);
//}
//
////当每个区的区尾高度不一样是通过该方法设置高度
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return CGSizeMake(0, 0.001);
//    }
//    return CGSizeMake(0, 40);
//}

//设置每个区的item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //返回每个item的大小
    if (indexPath.section == 0) {
        return CGSizeMake(150, 150);
    }
    return CGSizeMake(100, 100);
}

//设置区头区尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind: kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor lightGrayColor];
        return headerView;
    }
    else
    { UICollectionReusableView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor purpleColor];
        return footerView;
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
}
 */

@end
