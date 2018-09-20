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
    
//    addsignmoney = "4454804.97";
//    addsignnum = 2;
//    applycontent = "\U6d4b\U8bd5";
//    applydate = "2018-09-20";
//    applymoney = "4321.00";
//    changemoney = "206281.49";
//    changenum = 29;
//    contractid = 2194740;
//    contractmoney = "75926964.9700";
//    contractname = "\U6885\U6eaa\U6e56\U4e8c\U671f\U603b\U53056#\U30017#\U680b\U603b\U5305\U65bd\U5de5";
//    contractphyno = "HG-B-CQ-MXH-E311-2016-B-5-1";
//    "project_id" = 1291439;
//    "project_name" = "\U6885\U6eaa\U6e56\U4e8c\U671f";
//    regsignmoney = NULL;
//    returnmemo = NULL;
//    signmoney = "71472160.00";
//    "state_desc" = "\U5f85\U7533\U62a5";
//    supsettleid = 1;
//    syssettlemoney = "76133246.46";
//    totalnodeamount = "52177422.45";
//    totaloutamount = "74539175.05";
    
    return cell;
}

- (void)add:(id)sender
{
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"AccountFinalFormVC"
                                                                params:self.params];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
