//
//  OutputApplyHistoryVC.m
//  HN_Vendor
//
//  Created by tomwey on 26/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "OutputApplyHistoryVC.h"
#import "Defines.h"

@interface OutputApplyHistoryVC ()

@end

@implementation OutputApplyHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    addsignmoney = "4454804.97";
//    appstatus = 40;
//    appstatusdesc = "\U6267\U884c\U4e2d";
//    "area_id" = 1679437;
//    "area_name" = "\U957f\U6c99";
//    changemoney = "206281.49";
//    contractid = 2194740;
//    contractmoney = "75926964.9700";
//    contractname = "\U6885\U6eaa\U6e56\U4e8c\U671f\U603b\U53056#\U30017#\U680b\U603b\U5305\U65bd\U5de5";
//    contractoutamount = "75086982.02";
//    contractphyno = "HG-B-CQ-MXH-E311-2016-B-5-1";
//    contractsysno = "MX-\U603b\U5305\U7c7b1-16-003";
//    contracttotalmoney = "76133246.46";
//    contracttypeid = 56;
//    contracttypename = "\U65bd\U5de5\U603b\U5305\U5408\U540c";
//    contracttypeno = "05.2.1";
//    "d_type" = 2;
//    issettled = 0;
//    "project_id" = 1291439;
//    "project_name" = "\U6885\U6eaa\U6e56\U4e8c\U671f";
//    resignmoney = NULL;
//    signdate = "2016-09-07";
//    signmoney = "71472160.00";
    
    self.navBar.title = self.params[@"contractname"];
    
    [self loadData];
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    __weak typeof(self) me = self;
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商查询合同申报历史APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": userInfo[@"loginname"] ?: @"",
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": @"1",
              @"param5": [self.params[@"contractid"] ?: @"0" description],
              @"param6": @"2018",
              @"param7": @"0",
              } completion:^(id result, NSError *error) {
                  [me handleResult: result error: error];
              }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    
}

@end
