//
//  DeclareSearchVC.m
//  HN_Vendor
//
//  Created by tomwey on 21/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "DeclareSearchVC.h"
#import "Defines.h"

@interface DeclareSearchVC ()

@end

@implementation DeclareSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)done
{
    [self hideKeyboard];
    
    if ( self.formObjects.count == 0 ) {
        return;
    }
    
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"DeclareSearchResultVC" params:self.formObjects];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)formControls
{
    return @[@{
                 @"data_type": @"1",
                 @"datatype_c": @"文本框",
                 @"describe": @"关键字",
                 @"field_name": @"keyword",
                 @"placeholder": @"输入变更主题/内容",
                 @"item_name": @"",
                 @"item_value": @"",
                 },
             @{
                 @"data_type": @"9",
                 @"datatype_c": @"下拉选",
                 @"describe": @"申报状态",
                 @"field_name": @"state",
                 @"item_name": @"全部,待申报,被驳回,已取消,已申报,已审批,已签证,已作废",
                 @"item_value": @"-1,0,5,8,10,40,60,80",
                 },
             @{
                 @"data_type":  @"13",
                 @"datatype_c": @"日期范围组合控件",
                 @"describe":   @"申报日期",
                 @"field_name": @"publish_date",
                 @"item_name":  @"",
                 @"item_value": @"",
                 @"sub_describe": @"起始日期,截止日期",
                 @"split_desc": @"至",
                 @"split_symbol": @" ",
                 }];
}

@end
