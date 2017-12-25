//
//  DeclareListView.m
//  HN_Vendor
//
//  Created by tomwey on 20/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "DeclareListView.h"
#import "Defines.h"

@interface DeclareListView () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@end

@implementation DeclareListView

- (void)startLoading:(void (^)(BOOL succeed, NSError *error))completion
{
    [HNProgressHUDHelper showHUDAddedTo:AWAppWindow() animated:YES];
    
    [self.tableView removeErrorOrEmptyTips];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    NSDictionary *params = self.userData;
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil params:@{
                       @"dotype": @"GetData",
                       @"funname": @"供应商查询变更指令列表APP",
                       @"param1": [userInfo[@"supid"] ?: @"0" description],
                       @"param2": [userInfo[@"loginname"] ?: @"" description],
                       @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
                       @"param4": @"0",
                       @"param5": params[@"keyword"] ?: @"",
                       @"param6": [params[@"state"] ?: @"-1" description],
                       @"param7": params[@"begin_time"] ?: @"",
                       @"param8": params[@"end_time"] ?: @"",
                       } completion:^(id result, NSError *error) {
                           [me handleResult: result error:error];
                       }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.dataSource.dataSource = @[
//                                       @{
//                                           @"name": @"幸福麓山一期(1-3、7-10#楼)建设工程施工合同",
//                                           @"data": @[
//                                                   @{
//                                                       @"name": @"1、2、9楼B户型增加一个厨房插座",
//                                                       @"money1": @"200000",
//                                                       @"money2": @"150000",
//                                                       @"time": @"2017-10-26",
//                                                       @"state": @"0",
//                                                       },
//                                                   @{
//                                                       @"name": @"1、2、9楼B户型增加一个厨房插座",
//                                                       @"money1": @"200000",
//                                                       @"money2": @"150000",
//                                                       @"time": @"2017-10-26",
//                                                       @"state": @"1",
//                                                       },
//                                                   @{
//                                                       @"name": @"1、2、9楼B户型增加一个厨房插座",
//                                                       @"money1": @"200000",
//                                                       @"money2": @"150000",
//                                                       @"time": @"2017-10-26",
//                                                       @"state": @"2",
//                                                       },
//                                                   ],
//                                           },
//                                       @{
//                                           @"name": @"幸福麓山一期(1-3、7-10#楼)建设工程施工合同",
//                                           @"data": @[
//                                                   @{
//                                                       @"name": @"1、2、9楼B户型增加一个厨房插座",
//                                                       @"money1": @"200000",
//                                                       @"money2": @"150000",
//                                                       @"time": @"2017-10-26",
//                                                       @"state": @"0",
//                                                       },
//                                                   @{
//                                                       @"name": @"1、2、9楼B户型增加一个厨房插座",
//                                                       @"money1": @"200000",
//                                                       @"money2": @"150000",
//                                                       @"time": @"2017-10-26",
//                                                       @"state": @"1",
//                                                       }
//                                                   ],
//                                           },
//                                       ];
//        [HNProgressHUDHelper hideHUDForView:AWAppWindow() animated:YES];
//
//        [self.tableView reloadData];
//    });
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:AWAppWindow() animated:YES];
    
    if ( error ) {
        [self.tableView showErrorOrEmptyMessage:error.localizedDescription reloadDelegate:nil];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
            
            self.dataSource.dataSource = nil;
        } else {
            [self.tableView removeErrorOrEmptyTips];
            
            self.dataSource.dataSource = result[@"data"];
        }
        
        [self.tableView reloadData];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

- (UITableView *)tableView
{
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        [self addSubview:_tableView];
        
        [_tableView removeBlankCells];
        
        _tableView.dataSource = self.dataSource;
        
        _tableView.delegate   = self;
        
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.dataSource.dataSource[indexPath.row];
    NSArray *data = item[@"data"];
    
    return (40 + data.count * 90) + 15;
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, @"DeclareListCell", @"cell.list.id");
    }
    return _dataSource;
}

@end
