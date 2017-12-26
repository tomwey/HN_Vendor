//
//  PayListVC.m
//  HN_Vendor
//
//  Created by tomwey on 26/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "PayListVC.h"
#import "Defines.h"

@interface PayListVC () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@end

@implementation PayListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = [self.params[@"moneytypename"] stringByAppendingString:@"明细"];
    
    [self addLeftItemWithView:HNCloseButton(34, self, @selector(close))];
    
    [self startLoadingData];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startLoadingData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    __weak typeof(self) me = self;
    id userInfo = [[UserService sharedInstance] currentUser];
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商查询合同付款列表APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": [self.params[@"contractid"] ?: @"0" description],
              @"param5": [self.params[@"moneytypeid"] ?: @"0" description],
              @"param6": @"",
              @"param7": @"",
              @"param8": @"",
              } completion:^(id result, NSError *error) {
                  [me handleResult:result error:error];
              }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
//    if ( error ) {
//        [self.contentView showHUDWithText:error.localizedDescription succeed:NO];
//    } else {
//        if ( [result[@"rowcount"] integerValue] == 0 ) {
//            [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
//            self.dataSource.dataSource = nil;
//        } else {
//            [self.tableView removeErrorOrEmptyTips];
//            self.dataSource.dataSource = result[@"data"];
//        }
//
//        [self.tableView reloadData];
//    }
}

- (UITableView *)tableView
{
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self.dataSource;
        _tableView.delegate   = self;
        
        [_tableView removeBlankCells];
        
        [self.contentView addSubview:_tableView];
        
        _tableView.rowHeight = 98;
        
        _tableView.separatorColor = AWColorFromHex(@"#e6e6e6");
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"PayListVC" params:self.dataSource.dataSource[indexPath.row]];
    
    UIViewController *owner = self.userData[@"owner"];
    [owner presentViewController:vc animated:YES completion:nil];
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, @"ContractPayCell", @"cell.id");
    }
    return _dataSource;
}

@end
