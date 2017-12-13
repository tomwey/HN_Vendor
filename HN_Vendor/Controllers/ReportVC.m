//
//  ReportVC.m
//  HN_Vendor
//
//  Created by tomwey on 13/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "ReportVC.h"

@interface ReportVC ()

@end

@implementation ReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray *)formControls
{
    return @[
             @{
                 @"data_type": @"14",
                 @"datatype_c": @"单选按钮",
                 @"describe": @"类型",
                 @"field_name": @"type",
                 @"item_name": @"投诉,建议",
                 @"item_value": @"1,0",
                 },
             @{
                 @"data_type": @"1",
                 @"datatype_c": @"文本框",
                 @"describe": @"主题",
                 @"field_name": @"title",
                 @"item_name": @"",
                 @"item_value": @"",
                 },
             @{
                 @"data_type": @"9",
                 @"datatype_c": @"下拉选",
                 @"describe": @"项目名称",
                 @"field_name": @"project",
                 @"item_name": @"全部,红文,通知/公告,计划",
                 @"item_value": @"-1,0,1,2",
                 },
             @{
                 @"data_type": @"9",
                 @"datatype_c": @"下拉选",
                 @"describe": @"事项类型",
                 @"field_name": @"event_type",
                 @"item_name": @"全部,红文,通知/公告,计划",
                 @"item_value": @"-1,0,1,2",
                 },
             @{
                 @"data_type": @"9",
                 @"datatype_c": @"下拉选",
                 @"describe": @"相关合同",
                 @"field_name": @"constract",
                 @"item_name": @"全部,红文,通知/公告,计划",
                 @"item_value": @"-1,0,1,2",
                 },
             @{
                 @"data_type": @"10",
                 @"datatype_c": @"多行文本",
                 @"describe": @"说明",
                 @"field_name": @"opinion",
                 @"item_name": @"",
                 @"item_value": @"",
                 },
             @{
                 @"data_type": @"15",
                 @"datatype_c": @"文本框",
                 @"describe": @"附件",
                 @"field_name": @"related_annex",
                 @"item_name": @"",
                 @"item_value": @"H_WF_INST_M,About_Annex",
                 },
    ];
}

- (BOOL)supportsTextArea { return NO; }

- (BOOL)supportsAttachment { return NO; }

- (BOOL)supportsCustomOpinion { return NO; };

@end
