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

@property (nonatomic, strong) NSMutableArray *inFormControls;

@property (nonatomic, strong) NSMutableArray *projectIDs;
@property (nonatomic, strong) NSMutableArray *projectNames;

@end

@implementation DeclareSearchVC

- (void)viewDidLoad {
    self.inFormControls = [@[@{
                                 @"data_type": @"1",
                                 @"datatype_c": @"文本框",
                                 @"describe": @"关键字",
                                 @"field_name": @"keyword",
                                 @"placeholder": @"输入变更主题/内容",
                                 @"item_name": @"",
                                 @"item_value": @"",
                                 @"required": @"0",
                                 },
                             @{
                                 @"data_type": @"9",
                                 @"datatype_c": @"下拉选",
                                 @"describe": @"申报状态",
                                 @"field_name": @"state",
                                 @"item_name": @"全部,待申报,被驳回,已取消,已申报,已审批,已签证,已作废",
                                 @"item_value": @"-1,0,5,8,10,40,60,80",
                                 @"required": @"0",
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
                                 @"required": @"0",
                                 },
                             @{
                                 @"data_type": @"9",
                                 @"datatype_c": @"下拉选",
                                 @"describe": @"项目",
                                 @"field_name": @"project",
                                 @"item_name": @"全部",
                                 @"item_value": @"0",
                                 @"required": @"0",
                                 },
                             ] mutableCopy];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.projectIDs = [@[] mutableCopy];
    [self.projectIDs addObject:@"0"];
    
    self.projectNames = [@[] mutableCopy];
    [self.projectNames addObject:@"全部"];
    
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
              @"funname": @"供应商查询合同列表APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              } completion:^(id result, NSError *error) {
                  [me handleResult:result error:error];
              }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if (!error && [result[@"rowcount"] integerValue] > 0) {
        NSArray *data = result[@"data"];
        
//        "project_id" = 1291426;
//        "project_name" = "\U73cd\U5b9d\U9526\U57ce\U4e00\U671f";
        
        for (id item in data) {
            if ( ![self.projectNames containsObject:item[@"project_name"]] ) {
                [self.projectNames addObject:item[@"project_name"]];
                [self.projectIDs addObject:[item[@"project_id"] description]];
            }
        }
        
        if (self.projectNames.count > 1) {
            id dict = [self.inFormControls lastObject];
            NSMutableDictionary *newDict = [dict mutableCopy];
            newDict[@"item_name"] = [self.projectNames componentsJoinedByString:@","];
            newDict[@"item_value"] = [self.projectIDs componentsJoinedByString:@","];
            [self.inFormControls replaceObjectAtIndex:3 withObject:newDict];
            
            [self formControlsDidChange];
        }
    }
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
    return self.inFormControls;
}

@end
