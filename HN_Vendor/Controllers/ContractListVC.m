//
//  ContractListVC.m
//  HN_Vendor
//
//  Created by tomwey on 13/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "ContractListVC.h"
#import "Defines.h"

@interface ContractListVC () <UITableViewDelegate, AWPagerTabStripDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@property (nonatomic, strong) AWPagerTabStrip *tabStrip;

@property (nonatomic, strong) NSArray *tabTitles;

@property (nonatomic, strong) NSArray *rawData;

@end

@implementation ContractListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"合同执行";
    
    if ( [self.params[@"data"] integerValue] == 1 ) {
        [self addSegmentControls];
        
        self.tableView.top = self.tabStrip.bottom;
        self.tableView.height -= self.tabStrip.height;
    }
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewApplyHistory:)
                                                 name:@"kViewApplyHistoryNotification"
                                               object:nil];
}

- (void)addSegmentControls
{
    self.tabTitles = @[@{
                           @"name": @"未结算",
                           @"type": @"0",
                           @"page": @"",
                           },
                       @{
                           @"name": @"已结算",
                           @"type": @"1",
                           @"page": @"",
                           },
                       ];
    
    self.tabStrip = [[AWPagerTabStrip alloc] init];
    [self.contentView addSubview:self.tabStrip];
    self.tabStrip.backgroundColor = [UIColor whiteColor];//MAIN_THEME_COLOR;
    
    self.tabStrip.tabWidth = self.contentView.width / 2;
    
    self.tabStrip.titleAttributes = @{ NSForegroundColorAttributeName: AWColorFromRGB(168, 168, 168),
                                       NSFontAttributeName: AWSystemFontWithSize(14, NO) };;
    self.tabStrip.selectedTitleAttributes = @{ NSForegroundColorAttributeName: MAIN_THEME_COLOR,
                                               NSFontAttributeName: AWSystemFontWithSize(14, NO) };
    
    //    self.tabStrip.delegate   = self;
    self.tabStrip.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    self.tabStrip.didSelectBlock = ^(AWPagerTabStrip* stripper, NSUInteger index) {
        //        weakSelf.swipeView.currentPage = index;
//        __strong SignListVC *strongSelf = weakSelf;
//        if ( strongSelf ) {
//            // 如果duration设置为大于0.0的值，动画滚动，tab stripper动画会有bug
//            [strongSelf.swipeView scrollToPage:index duration:0.0f]; // 0.35f
//            [strongSelf swipeViewDidEndDecelerating:strongSelf.swipeView];
        [weakSelf handleData:index];
//        }
    };
    
}

- (NSInteger)numberOfTabs:(AWPagerTabStrip *)tabStrip
{
    return self.tabTitles.count;
}

- (NSString *)pagerTabStrip:(AWPagerTabStrip *)tabStrip titleForIndex:(NSInteger)index
{
    return self.tabTitles[index][@"name"];
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    __weak typeof(self) me = self;
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil params:@{
                       @"dotype": @"GetData",
                       @"funname": @"供应商查询合同列表APP",
                       @"param1": [userInfo[@"supid"] ?: @"0" description],
                       @"param2": userInfo[@"loginname"] ?: @"",
                       @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
                       } completion:^(id result, NSError *error) {
                           [me handleResult:result error:error];
                       }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
//
//        self.dataSource.dataSource = @[
//                                       @{
//                                           @"_no": @"合同编号：合(WA)-E211-2015-004",
//                                           @"name": @"幸福麓山一期(1-3、7-10#楼)建设工程施工合同",
//                                           @"proj_name": @"枫丹铂麓一期",
//                                           @"time": @"2017-10-10",
//                                           @"state": @"1",
//                                           @"money": @"170142375",
//                                           },
//                                       @{
//                                           @"_no": @"合同编号：合(WA)-E211-2015-004",
//                                           @"name": @"幸福麓山一期(1-3、7-10#楼)建设工程施工合同",
//                                           @"proj_name": @"四季康城",
//                                           @"time": @"2017-09-01",
//                                           @"state": @"2",
//                                           @"money": @"90142375",
//                                           },
//                                       @{
//                                           @"_no": @"合同编号：合(WA)-E211-2015-004",
//                                           @"name": @"幸福麓山一期(1-3、7-10#楼)建设工程施工合同",
//                                           @"proj_name": @"枫丹铂麓一期",
//                                           @"time": @"2017-10-10",
//                                           @"state": @"1",
//                                           @"money": @"170142375",
//                                           },
//                                       ];
//
//        [self.tableView reloadData];
//    });
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
        [self.tableView showErrorOrEmptyMessage:error.localizedDescription reloadDelegate:nil];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
            self.dataSource.dataSource = nil;
            self.rawData = nil;
        } else {
            NSMutableArray *temp = [NSMutableArray array];
            for (id item in result[@"data"]) {
                id obj = [item mutableCopy];
                obj[@"d_type"] = self.params[@"data"] ?: @"";
                
                [temp addObject:obj];
            }
            
            self.dataSource.dataSource = temp;
            
            [self.tableView removeErrorOrEmptyTips];
            
            self.rawData = result[@"data"];
        }
        
        if ( [self.params[@"data"] integerValue] == 1 ) {
            [self handleData:self.tabStrip.selectedIndex];
        } else {
            
            [self.tableView reloadData];
        }
        
    }
}

- (void)handleData:(int)type
{
    NSMutableArray *temp = [NSMutableArray array];
    for (id item in self.rawData) {
        if ( type == 0 ) {
            if ( ![item[@"issettled"] boolValue] ) {
                [temp addObject:item];
            }
        } else {
            if ( [item[@"issettled"] boolValue] ) {
                [temp addObject:item];
            }
        }
    }
    
    if ( [temp count] == 0 ) {
        [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
        self.dataSource.dataSource = nil;
    } else {
        self.dataSource.dataSource = temp;
         [self.tableView removeErrorOrEmptyTips];
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( [self.params[@"data"] isEqualToString:@"0"] ) {
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"ContractDetailVC"
                                                                    params:
                                self.dataSource.dataSource[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ( [self.params[@"data"] isEqualToString:@"1"] ) {
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"AccountFinalListVC"
                                                                    params:
                                self.dataSource.dataSource[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ( [self.params[@"data"] isEqualToString:@"2"] ) {
        UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"OutputConfirmListVC"
                                                                    params:
                                self.dataSource.dataSource[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
//    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"ContractDetailVC"
//                                                                params:
//                            self.dataSource.dataSource[indexPath.row]];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewApplyHistory:(NSNotification *)noti
{
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"OutputApplyHistoryVC" params:noti.object];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView
{
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                  style:UITableViewStylePlain];
        [self.contentView addSubview:_tableView];
        
        [_tableView removeBlankCells];
        
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        _tableView.dataSource = self.dataSource;
        _tableView.delegate   = self;
        
        _tableView.rowHeight = 170;
        
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, @"ContractCell", @"cell.id");
    }
    return _dataSource;
}

@end
