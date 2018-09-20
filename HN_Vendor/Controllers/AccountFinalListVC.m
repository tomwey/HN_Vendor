//
//  AccountFinalListVC.m
//  HN_Vendor
//
//  Created by tomwey on 13/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "AccountFinalListVC.h"
#import "Defines.h"

@interface AccountFinalListVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

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
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                  style:UITableViewStylePlain];
    [self.contentView addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    
    [self.tableView removeBlankCells];
    
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
            self.dataSource = result[@"data"];
        } else {
            [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
            self.dataSource = nil;
        }
        
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id"];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell.id"];
    }
    
    return cell;
}

- (void)add:(id)sender
{
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"AccountFinalFormVC"
                                                                params:self.params];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
