//
//  ReportVC.m
//  HN_Vendor
//
//  Created by tomwey on 13/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "ReportVC.h"
#import "Defines.h"

@interface ReportVC ()

@property (nonatomic, strong) NSMutableArray *inFormControls;

@property (nonatomic, assign) NSInteger counter;

@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) NSMutableArray *contracts;

@property (nonatomic, strong) NSMutableArray *tsValues; // 投诉选项
@property (nonatomic, strong) NSMutableArray *jyValues; // 建议选项

@end

@implementation ReportVC

- (void)viewDidLoad {
    
    self.inFormControls = [@[
                            @{
                                @"data_type": @"9",
                                @"datatype_c": @"下拉选",
                                @"describe": @"类型",
                                @"field_name": @"type",
                                @"item_name": @"投诉,建议",
                                @"item_value": @"1,2",
                                @"change_action": @"typeDidChange:",
                                },
                            @{
                                @"data_type": @"9",
                                @"datatype_c": @"下拉选",
                                @"describe": @"事项类型",
                                @"field_name": @"event_type",
                                @"item_name": @"",
                                @"item_value": @"",
                                },
                            @{
                                @"data_type": @"9",
                                @"datatype_c": @"下拉选",
                                @"describe": @"项目名称",
                                @"field_name": @"project",
                                @"item_name": @"",
                                @"item_value": @"",
                                },
                            @{
                                @"data_type": @"9",
                                @"datatype_c": @"下拉选",
                                @"describe": @"相关合同",
                                @"field_name": @"contract",
                                @"item_name": @"",
                                @"item_value": @"",
                                @"required": @"0",
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
                                @"data_type": @"1",
                                @"datatype_c": @"文本框",
                                @"describe": @"联系人",
                                @"field_name": @"link_man",
                                @"item_name": @"",
                                @"item_value": @"",
                                },
                            @{
                                @"data_type": @"1",
                                @"datatype_c": @"文本框",
                                @"describe": @"联系人称谓",
                                @"field_name": @"link_man_title",
                                @"item_name": @"",
                                @"item_value": @"",
                                },
                            @{
                                @"data_type": @"1",
                                @"datatype_c": @"文本框",
                                @"describe": @"联系电话",
                                @"field_name": @"link_man_mobile",
                                @"item_name": @"",
                                @"item_value": @"",
                                @"keyboard_type": @(UIKeyboardTypePhonePad),
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
                                @"data_type": @"20",
                                @"datatype_c": @"上传组件",
                                @"describe": @"照片",
                                @"field_name": @"photos",
                                @"item_name": @"",
                                @"item_value": @"",
                                @"annex_table_name": @"H_SY_Complain_Suggest_Annex",
                                @"annex_field_name": @"AnnexKeyID",
                                @"required": @"0",
                                },
                            ] mutableCopy];
    
    [super viewDidLoad];
    
    self.navBar.title = @"投诉建议";
    
    __weak typeof(self) me = self;
    [self addRightItemWithTitle:@"提交"
                titleAttributes: @{ NSFontAttributeName: AWSystemFontWithSize(14, NO) }
                           size: CGSizeMake(40, 40)
                    rightMargin:5
                       callback:^{
                           [me commit];
                       }];
    
    [self loadData];
}

- (void)commit
{
    NSString *type = @"";
    if ( self.formObjects[@"type"] ) {
        type = [self.formObjects[@"type"][@"value"] ?: @"" description];
    }
    if ( type.length == 0 ) {
        [self.contentView showHUDWithText:@"必须选择类型" offset:CGPointMake(0,20)];
        return;
    }
    
    NSString *etype = @"";
    if ( self.formObjects[@"event_type"] ) {
        etype = [self.formObjects[@"event_type"][@"value"] ?: @"" description];
    }
    if ( etype.length == 0 ) {
        [self.contentView showHUDWithText:@"必须选择事项类型" offset:CGPointMake(0,20)];
        return;
    }
    
    NSString *projectID = @"";
    if ( self.formObjects[@"project"] ) {
        projectID = [self.formObjects[@"project"][@"value"] ?: @"" description];
    }
    if ( projectID.length == 0 ) {
        [self.contentView showHUDWithText:@"必须选择项目" offset:CGPointMake(0,20)];
        
        return;
    }
    
    NSString *subject = self.formObjects[@"title"] ?: @"";
    if ( subject.length == 0 ) {
        [self.contentView showHUDWithText:@"主题不能为空" offset:CGPointMake(0,20)];
        
        return;
    }
    
    NSString *linkMan = self.formObjects[@"link_man"] ?: @"";
    if ( linkMan.length == 0 ) {
        [self.contentView showHUDWithText:@"联系人不能为空" offset:CGPointMake(0,20)];
        
        return;
    }
    
    NSString *linkManTitle = self.formObjects[@"link_man_title"] ?: @"";
    if ( subject.length == 0 ) {
        [self.contentView showHUDWithText:@"联系人称谓不能为空" offset:CGPointMake(0,20)];
        
        return;
    }
    
    NSString *linkManMobile = self.formObjects[@"link_man_mobile"] ?: @"";
    if ( linkManMobile.length == 0 ) {
        [self.contentView showHUDWithText:@"联系电话不能为空" offset:CGPointMake(0,20)];
        
        return;
    }
    
    NSString *content = self.formObjects[@"opinion"] ?: @"";
    if ( content.length == 0 ) {
        [self.contentView showHUDWithText:@"说明不能为空" offset:CGPointMake(0,20)];
        
        return;
    }
    
    // 照片
    NSArray *photos = self.formObjects[@"photos"];
    NSMutableArray *temp = [NSMutableArray array];
    for (id item in photos) {
        [temp addObject:[item[@"id"] description]];
    }
    NSString *attachments = [temp componentsJoinedByString:@","];
    
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商发起投诉建议APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": type,
              @"param5": etype,
              @"param6": projectID,
              @"param7": [self.formObjects[@"contract"][@"value"] ?: @"" description],
              @"param8": subject,
              @"param9": linkMan,
              @"param10": linkManTitle,
              @"param11": linkManMobile,
              @"param12": content,
              @"param13": attachments,
              } completion:^(id result, NSError *error) {
                  [me handleResult:result error:error];
              }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    if ( error ) {
        [self.contentView showHUDWithText:error.localizedDescription succeed:NO];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            [self.contentView showHUDWithText:@"提交失败！" succeed:NO];
        } else {
            id item = [result[@"data"] firstObject];
            if ( item && [item[@"code"] integerValue] == 0 ) {
                [self.contentView showHUDWithText:@"提交成功！" succeed:YES];
                [self resetForm];
            } else {
                [self.contentView showHUDWithText:@"提交失败！" succeed:NO];
            }
        }
    }
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    self.projects = [@[] mutableCopy];
    self.contracts = [@[] mutableCopy];
    
    self.tsValues = [@[] mutableCopy];
    self.jyValues = [@[] mutableCopy];
    
    __weak typeof(self) me = self;
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商查询合同列表APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              } completion:^(id result, NSError *error) {
                  [me loadDone1:result error:error];
              }];
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商取值列表数据查询APP",
              @"param1": @"投诉事项类型"
              } completion:^(id result, NSError *error) {
                  [me loadDone2:result error: error];
              }];
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商取值列表数据查询APP",
              @"param1": @"建议事项类型"
              } completion:^(id result, NSError *error) {
                  [me loadDone3:result error: error];
              }];
}

- (void)loadDone1:(id)result error:(NSError *)error
{
    if ( [result[@"rowcount"] integerValue] > 0 ) {
        NSArray *data = result[@"data"];
        
        //        appstatus = 40;
        //        appstatusdesc = "\U6267\U884c\U4e2d";
        //        contractid = 2206412;
        //        contractmoney = 1957620;
        //        contractname = "\U5173\U4e8e\U4ee5\U73cd\U5b9d\U4e00\U671f\U9879\U76ee\U5546\U54c1\U623f\U4f5c\U4ef7\U652f\U4ed8\U4e00\U671f\U9879\U76ee\U63a8\U4ecb\U670d\U52a1\U8d39\U7684\U534f\U8bae\U4e66";
        //        contractphyno = "\U5408\Uff08JC\Uff09-E312-2017-003";
        //        contractsysno = "\U5408\Uff08JC\Uff09-E312-2017-003";
        //        "project_name" = "\U73cd\U5b9d\U9526\U57ce\U4e00\U671f";
        //        signdate = "2017-06-02T00:00:00+08:00";
        
        for (id item in data) {
            BOOL exist = [self projectIsExists:item];
            
            if ( !exist ) {
                [self.projects addObject:@{ @"value": [item[@"project_id"] ?: @"0" description],
                                            @"name": item[@"project_name"] ?: @"" }];
            }
        }
        
        self.contracts = [data mutableCopy];
    }
    
    [self loadDone];
}

- (BOOL)projectIsExists:(id)item
{
    for (id dic in self.projects) {
        if ( [[dic[@"value"] description] isEqualToString:[item[@"project_id"] description]] ) {
            return YES;
        }
    }
    return NO;
}

- (void)loadDone2:(id)result error:(NSError *)error
{
    if ( [result[@"rowcount"] integerValue] > 0 ) {
        for (id item in result[@"data"]) {
            [self.tsValues addObject:@{
                                           @"name": item[@"dic_name"] ?: @"",
                                           @"value": item[@"dic_value"] ?: @"",
                                           }];
        }
    }
    
    [self loadDone];
}

- (void)loadDone3:(id)result error:(NSError *)error
{
    if ( [result[@"rowcount"] integerValue] > 0 ) {
        //        self.changeReason = [result[@"data"] mutableCopy];
        for (id item in result[@"data"]) {
            [self.jyValues addObject:@{
                                           @"name": item[@"dic_name"] ?: @"",
                                           @"value": item[@"dic_value"] ?: @"",
                                           }];
        }
    }
    
    [self loadDone];
}

- (void)loadDone
{
    self.counter ++;
    
    if ( self.counter == 3 ) {
        [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
        
        NSMutableArray *temp1 = [NSMutableArray array];
        NSMutableArray *temp2 = [NSMutableArray array];
        
        for (id item in self.projects) {
            [temp1 addObject:item[@"name"]];
            [temp2 addObject:item[@"value"]];
        }
        
        id dict = [self.inFormControls objectAtIndex:2];
        NSMutableDictionary *newDict = [dict mutableCopy];
        newDict[@"item_name"] = [temp1 componentsJoinedByString:@","];
        newDict[@"item_value"] = [temp2 componentsJoinedByString:@","];
        [self.inFormControls replaceObjectAtIndex:2 withObject:newDict];
        
        ///
        dict = [self.inFormControls objectAtIndex:3];
        temp1 = [NSMutableArray array];
        temp2 = [NSMutableArray array];
        for (id item in self.contracts) {
            [temp1 addObject:item[@"contractname"] ?: @""];
            [temp2 addObject:[item[@"contractid"] ?: @"0" description]];
        }
        
        newDict = [dict mutableCopy];
        newDict[@"item_name"] = [temp1 componentsJoinedByString:@","];
        newDict[@"item_value"] = [temp2 componentsJoinedByString:@","];
        
        [self.inFormControls replaceObjectAtIndex:3 withObject:newDict];
        
        [self formControlsDidChange];
    }
    
//    [self prepareFormObjects];
}

- (void)typeDidChange:(id)selectedItem
{
    [self.formObjects removeObjectForKey:@"event_type"];
    
    NSMutableArray *temp1 = [NSMutableArray array];
    NSMutableArray *temp2 = [NSMutableArray array];
    
    NSInteger type = [selectedItem[@"value"] integerValue];
    
    NSArray *array = type == 1 ? self.tsValues : self.jyValues;
    
    for (id item in array) {
        [temp1 addObject:item[@"name"]];
        [temp2 addObject:item[@"value"]];
    }
    
    id dict = [self.inFormControls objectAtIndex:1];
    NSMutableDictionary *newDict = [dict mutableCopy];
    newDict[@"item_name"] = [temp1 componentsJoinedByString:@","];
    newDict[@"item_value"] = [temp2 componentsJoinedByString:@","];
    [self.inFormControls replaceObjectAtIndex:1 withObject:newDict];
    
    [self formControlsDidChange];
}

- (NSArray *)formControls
{
//    @iSupID bigint,
//    @sLoginName varchar(30),
//    @iSymbolKeyID bigint,
//    @iTypeID int, --1-投诉  2-建议
//    @iSmallTypeID bigint, --事项类型
//    @iProjectID bigint,--合同ID
//    @iContractID bigint,--项目ID
//    @sTheme varchar(1000), --主题
//    @sLinkMan varchar(30),--联系人
//    @sLinkManTitle varchar(20),--联系人称谓
//    @sLinkManTel varchar(30),--联系电话
//    @sContentDesc varchar(5000),--内容
//    @sAnnexIDs varchar(500)=''--附件/图片ID
    return self.inFormControls;
}

- (BOOL)supportsTextArea { return NO; }

- (BOOL)supportsAttachment { return NO; }

- (BOOL)supportsCustomOpinion { return NO; };

@end
