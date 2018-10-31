//
//  WorkVC.m
//  HN_ERP
//
//  Created by tomwey on 1/18/17.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "WorkVC2.h"
#import "Defines.h"

@interface WorkVC2 () <UIAlertViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation WorkVC2

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
//        self.modules = [[NSMutableArray alloc] init];
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                        image:[UIImage imageNamed:@"tab_work.png"]
                                                selectedImage:[UIImage imageNamed:@"tab_work_click.png"]];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView.backgroundColor = AWColorFromRGB(239, 239, 239);
    
    UIImageView *header = AWCreateImageView(nil);
    header.image = AWImageNoCached(@"work-header.jpg");
    header.frame = CGRectMake(0, 0, self.contentView.width,
                              self.contentView.width * header.image.size.height /
                              header.image.size.width);
    [self.contentView addSubview:header];
    
    NSLog(@"%@", NSStringFromCGSize(header.frame.size));
    
    self.dataSource = @[
                        @{
                            @"icon": @"icon_declare.png",
                            @"name": @"变更申报",
                            @"page": @"DeclareListVC",
                            @"color": @"#5F79C7",
                            @"size": @"{24,24}"
                            },
                        
                        @{
                            @"icon": @"icon_wgqr.png",
                            @"name": @"完工确认",
                            @"page": @"WorkDoneConfirmVC",
                            @"color": /*@"213,156,85"*/@"#7FB762",
                            @"size": @"{30,30}"
                            },
                        @{
                            @"icon": @"icon_sign_2.png",
                            @"name": @"签证申报",
                            @"page": @"SignListVC",
                            @"color": @"#D59C55",
                            @"size": @"{26,26}"
                            },
                        
                        @{
                            @"icon": @"icon_chanzhi.png",
                            @"name": @"产值申报",
                            @"page": @"ContractListVC",
                            @"color": @"#CA5B54",
                            @"size": @"{28,28}",
                            @"params": @"2",
                            },
                        
//                        @{
//                            @"icon": @"icon_czfh.png",
//                            @"name": @"产值复核",
//                            @"page": @"OutputDoneConfirmVC",
//                            @"color": /*@"213,156,85"*/@"#7FB762",
//                            @"size": @"{28,28}"
//                            },
                        
                        @{
                            @"icon": @"icon_jiesuan.png",
                            @"name": @"结算申报",
                            @"page": @"ContractListVC",
                            @"color": @"#CA5B54",
                            @"size": @"{26,26}",
                            @"params": @"1",
                            },
                        @{
                            @"icon": @"icon_contract_2.png",
                            @"name": @"合同执行",
                            @"page": @"ContractListVC",
                            @"color": @"#5F79C7",
                            @"size": @"{30,30}",
                            @"params": @"0",
                            },
                        @{
                            @"icon": @"icon_report_2.png",
                            @"name": @"投诉建议",
                            @"page": @"ReportListVC",
                            @"color": @"#D59C55",
                            @"size": @"{26,26}"
                            }
                        ];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
//    layout.headerReferenceSize = CGSizeMake(self.contentView.width, 40);
    
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds
                                                 collectionViewLayout:layout];
    
    self.mainCollectionView.height -= (50 + header.height);
    self.mainCollectionView.top = header.bottom;
    
    [self.contentView addSubview:self.mainCollectionView];
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.mainCollectionView registerClass:[MyCollectionCell class]
                forCellWithReuseIdentifier:@"cell.id"];
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionCell *cell = (MyCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell.id" forIndexPath:indexPath];
    
    //    id secDict = self.dataDict[@"sections"][indexPath.section];
//    cell.backgroundColor = [UIColor redColor];
    
    id item = self.dataSource[indexPath.row];
    
    cell.item = item;
    
    return cell;
}

- (NSInteger)numberOfCols
{
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(floor((self.contentView.width - 2 * 5) / [self numberOfCols]),
                      64);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 5, 10, 5);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionCell *cell = (MyCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    NSString *msg = cell.titleLabel.text;
    
    NSLog(@"%@",cell.item);
    
    [self openPage:cell.item];
}

- (void)openPage:(id)item
{
    NSString *vcName = item[@"page"];
    id params = nil;
    if ( item[@"params"] ) {
        params = @{ @"data": item[@"params"] };
    }
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:vcName params:params];
    [AWAppWindow().navController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

////////////////////////////////////////////////////////////////////
@interface MyCollectionCell ()

@property (nonatomic, strong, readwrite) UIImageView *iconView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation MyCollectionCell

- (void)setItem:(id)item
{
    _item = item;
    
    self.titleLabel.text = item[@"name"];
    
//    if ( item[@"color"] ) {
        UIImage *image = [[UIImage imageNamed:item[@"icon"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.iconView.image = image;
        self.iconView.tintColor = AWColorFromHex(item[@"color"]);
    
    CGSize size = CGSizeFromString(item[@"size"]);
    self.iconView.frame = CGRectMake(0, 0, size.width, size.height);
//    } else {
//        self.iconView.image = [UIImage imageNamed:item[@"icon"]];
//        self.iconView.tintColor = nil;
//    }
}

- (UIImageView *)iconView
{
    if ( !_iconView ) {
        _iconView = AWCreateImageView(nil);
        [self.contentView addSubview:_iconView];
        //        _iconView.backgroundColor = AWColorFromHex(@"#e6e6e6");
        
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = AWCreateLabel(CGRectZero, nil,
                                    NSTextAlignmentCenter,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromHex(@"#333333"));
        [self.contentView addSubview:_titleLabel];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(0, self.height - 30, self.width, 30);
//    self.iconView.frame = CGRectMake(0, 0, 30, 30);
    self.iconView.center = CGPointMake(self.width / 2.0, self.iconView.height / 2.0);
}

@end

/////////////////////////////////////////////////////////////////////////////////
