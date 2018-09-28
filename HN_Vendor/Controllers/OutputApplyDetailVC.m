//
//  OutputApplyDetailVC.m
//  HN_Vendor
//
//  Created by tomwey on 28/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "OutputApplyDetailVC.h"
#import "Defines.h"

@interface OutputApplyDetailVC ()

@end

@implementation OutputApplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
              @"funname": @"供应商合同产值申报明细APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": userInfo[@"loginname"] ?: @"",
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": [self.params[@"contractid"] ?: @"0" description],
              @"param5": @"0",
              @"param6": @"2018-09-28",
              } completion:^(id result, NSError *error) {
                  [me handleResult: result error: error];
              }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
//        [self.tableView showErrorOrEmptyMessage:error.localizedDescription reloadDelegate:nil];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
//            [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
//            self.dataSource.dataSource = nil;
//
//            [self setLabelValue:@"--"
//                       forLabel:self.applyTotalLabel
//                           unit:@""
//                           name:@"申报总金额(元)"];
//            [self setLabelValue:@"--"
//                       forLabel:self.confirmTotalLabel
//                           unit:@""
//                           name:@"确认总金额(元)"];
        } else {
//            self.dataSource.dataSource = result[@"data"];
//            [self.tableView removeErrorOrEmptyTips];
//
//            [self updateTotalStats];
        }
        
//        [self.tableView reloadData];
    }
    //    applyoutamount = "387291.00";
    //    confirmoutamount = "0.00";
    //    "submit_date" = "2018-09-28T16:14:10+08:00";
}

@end
