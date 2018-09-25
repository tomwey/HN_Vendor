//
//  AccountFinalListVC.m
//  HN_Vendor
//
//  Created by tomwey on 13/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "AccountFinalListVC.h"
#import "Defines.h"

@interface AccountFinalListVC () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@end

@implementation AccountFinalListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = @"结算申报";
    
    self.navBar.rightMarginOfRightItem = 5;
    self.navBar.marginOfFluidItem = 0;

    UIButton *addBtn = HNAddButton(22, self, @selector(add:));
    [self.navBar addFluidBarItem:addBtn atPosition:FluidBarItemPositionTitleRight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"kReloadAccountFinalDataNotification"
                                               object:nil];
    
    [self loadData];
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    id reqParams = @{
                     @"dotype": @"GetData",
                     @"funname": @"供应商查询结算申报APP",
                     @"param1": [userInfo[@"supid"] ?: @"0" description],
                     @"param2": [userInfo[@"loginname"] ?: @"" description],
                     @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
                     @"param4": [self.params[@"contractid"] ?: @"0" description],
                     @"param5": @"",
                     @"param6": @"-1",
                     @"param7": @"",
                     @"param8": @"",
                     };
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil params:reqParams
     completion:^(id result, NSError *error) {
         [me handleResult:result error:error];
     }];
    
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
        [self.tableView showErrorOrEmptyMessage:@"服务器出错了~" reloadDelegate:nil];
    } else {
        if ([result[@"rowcount"] integerValue] > 0) {
            self.dataSource.dataSource = result[@"data"];
            [self.tableView removeErrorOrEmptyTips];
        } else {
            [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
            self.dataSource = nil;
        }
        
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.dataSource.dataSource[indexPath.row];
    
    [self forwardToFinalForm:item];
}

- (UITableView *)tableView
{
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
        [self.contentView addSubview:_tableView];
        
        _tableView.dataSource = self.dataSource;
        _tableView.delegate = self;
        
        _tableView.rowHeight  = 60;
        [self.tableView removeBlankCells];
    }
    return _tableView;
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, @"AccountFinalCell", @"cell.id");
    }
    return _dataSource;
}

- (void)add:(id)sender
{
    [self forwardToFinalForm:self.params];
}

- (void)forwardToFinalForm:(id)params
{
    UIViewController *vc = [[AWMediator sharedInstance] openNavVCWithName:@"AccountFinalFormVC"
                                                                params:params];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
