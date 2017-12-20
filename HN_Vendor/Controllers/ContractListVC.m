//
//  ContractListVC.m
//  HN_Vendor
//
//  Created by tomwey on 13/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "ContractListVC.h"
#import "Defines.h"

@interface ContractListVC () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@end

@implementation ContractListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"合同执行";
    
    [self loadData];
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
        
        self.dataSource.dataSource = @[
                                       @{
                                           @"_no": @"合同编号：合(WA)-E211-2015-004",
                                           @"name": @"幸福麓山一期(1-3、7-10#楼)建设工程施工合同",
                                           @"proj_name": @"枫丹铂麓一期",
                                           @"time": @"2017-10-10",
                                           @"state": @"1",
                                           @"money": @"170142375",
                                           },
                                       @{
                                           @"_no": @"合同编号：合(WA)-E211-2015-004",
                                           @"name": @"幸福麓山一期(1-3、7-10#楼)建设工程施工合同",
                                           @"proj_name": @"四季康城",
                                           @"time": @"2017-09-01",
                                           @"state": @"2",
                                           @"money": @"90142375",
                                           },
                                       @{
                                           @"_no": @"合同编号：合(WA)-E211-2015-004",
                                           @"name": @"幸福麓山一期(1-3、7-10#楼)建设工程施工合同",
                                           @"proj_name": @"枫丹铂麓一期",
                                           @"time": @"2017-10-10",
                                           @"state": @"1",
                                           @"money": @"170142375",
                                           },
                                       ];
        
        [self.tableView reloadData];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        _tableView.rowHeight = 150;
        
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
