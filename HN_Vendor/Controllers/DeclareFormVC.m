//
//  DeclareFormVC.m
//  HN_Vendor
//
//  Created by tomwey on 26/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "DeclareFormVC.h"
#import "Defines.h"

@interface DeclareFormVC ()

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) NSMutableArray *projects;

@property (nonatomic, strong) NSMutableDictionary *contracts;

@property (nonatomic, strong) NSMutableDictionary *contracts2;

@property (nonatomic, strong) NSMutableArray *changeEvents;

@property (nonatomic, strong) NSMutableArray *changeReason;

@property (nonatomic, assign) NSInteger counter;

@property (nonatomic, strong) NSMutableArray *inFormControls;

//@property (nonatomic, strong) NSDictionary *selectedContract;

@end

@implementation DeclareFormVC

- (void)viewDidLoad {
    
    self.inFormControls =
    [@[
      @{
          @"data_type": @"9",
          @"datatype_c": @"下拉选",
          @"describe": @"项目名称",
          @"field_name": @"proj_name",
          @"item_name": @"枫丹铂麓一期",
          @"placeholder": @"选择项目",
          @"item_value": @"30",
          @"change_action": @"projectDidSelect:",
          },
      @{
          @"data_type": @"9",
          @"datatype_c": @"下拉选",
          @"describe": @"合同名称",
          @"field_name": @"contract_name",
          @"placeholder": @"选择合同",
          @"item_name": @"",
          @"item_value": @"",
          @"change_action": @"contractDidSelect:",
          },
      
      @{
          @"data_type": @"1",
          @"datatype_c": @"文本框",
          @"describe": @"合同金额",
          @"field_name": @"money",
          @"item_name": @"",
          @"item_value": @"",
          @"placeholder": @"请先选择合同",
          @"readonly": @"1",
          },
      @{
          @"data_type": @"1",
          @"datatype_c": @"文本框",
          @"describe": @"合同编号",
          @"field_name": @"contract_no",
          @"item_name": @"",
          @"item_value": @"",
          @"readonly": @"1",
          @"placeholder": @"请先选择合同",
          },
      @{
          @"data_type": @"1",
          @"datatype_c": @"文本框",
          @"describe": @"事项主题",
          @"field_name": @"subject",
          @"item_name": @"",
          @"item_value": @"",
          },
      @{
          @"data_type": @"9",
          @"datatype_c": @"下拉选",
          @"describe": @"变更事项进展",
          @"field_name": @"event_type",
          @"item_name": @"未开始,已保存",
          @"item_value": @"30,3",
          },
      @{
          @"data_type": @"9",
          @"datatype_c": @"下拉选",
          @"describe": @"变更原因",
          @"field_name": @"event_reason",
          @"item_name": @"弥补缺陷,其它",
          @"item_value": @"30,3",
          },
      @{
          @"data_type": @"10",
          @"datatype_c": @"多行文本",
          @"describe": @"变更内容",
          @"field_name": @"change_content",
          @"item_name": @"",
          @"item_value": @"",
          },
      @{
          @"data_type": @"1",
          @"datatype_c": @"文本框",
          @"describe": @"申报金额",
          @"field_name": @"money2",
          @"item_name": @"",
          @"item_value": @"",
          @"keyboard_type": @(UIKeyboardTypeNumberPad),
          },
      @{
          @"data_type": @"20",
          @"datatype_c": @"上传组件",
          @"describe": @"照片",
          @"field_name": @"photos",
          @"item_name": @"",
          @"item_value": @"",
          @"annex_table_name": @"H_APP_Supplier_Contract_Change_Annex",
          @"annex_field_name": @"AnnexKeyID",
          },
      ] mutableCopy];
    
    [super viewDidLoad];
    
    self.projects = [@[] mutableCopy];
    self.contracts = [@{} mutableCopy];
    self.contracts2 = [@{} mutableCopy];
    self.changeReason = [@[] mutableCopy];
    self.changeEvents = [@[] mutableCopy];
    
    self.navBar.title = self.params[@"title"] ?: @"";
    
    [self addLeftItemWithView:HNCloseButton(34, self, @selector(close))];
    
    UIButton *commitBtn = AWCreateTextButton(CGRectMake(0, 0, self.contentView.width / 2,
                                                        50),
                                             @"提交",
                                             [UIColor whiteColor],
                                             self,
                                             @selector(commit));
    [self.contentView addSubview:commitBtn];
    commitBtn.backgroundColor = MAIN_THEME_COLOR;
    commitBtn.position = CGPointMake(0, self.contentView.height - 50);
    
    self.commitButton = commitBtn;
    
    UIButton *moreBtn = AWCreateTextButton(CGRectMake(0, 0, self.contentView.width / 2,
                                                      50),
                                           @"保存",
                                           IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR,
                                           self,
                                           @selector(save));
    [self.contentView addSubview:moreBtn];
    moreBtn.backgroundColor = [UIColor whiteColor];
    moreBtn.position = CGPointMake(commitBtn.right, self.contentView.height - 50);
    
    self.saveButton = moreBtn;
    
    UIView *hairLine = [AWHairlineView horizontalLineWithWidth:moreBtn.width
                                                         color:IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR
                                                        inView:moreBtn];
    hairLine.position = CGPointMake(0,0);
    
    commitBtn.left = 0;
    moreBtn.left = commitBtn.right;
    
    self.tableView.height -= moreBtn.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self loadData];
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
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
              @"param1": @"变更事项进展"
              } completion:^(id result, NSError *error) {
                  [me loadDone2:result error: error];
              }];
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商取值列表数据查询APP",
              @"param1": @"变更原因"
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
            if (item && item[@"contractid"]) {
                self.contracts2[[item[@"contractid"] description]] = item;
            }
            
            NSString *projName = item[@"project_name"];
            if ( !projName ) {
                continue;
            }
            
            [self.projects addObject:projName];
            
            NSMutableArray *obj = self.contracts[projName];
            if ( !obj ) {
                obj = [[NSMutableArray alloc] init];
                self.contracts[projName] = obj;
            }
            
            if ( ![obj containsObject:item] ) {
                [obj addObject:item];
            }
        }
    }
    
    [self loadDone];
}

- (void)loadDone2:(id)result error:(NSError *)error
{
    if ( [result[@"rowcount"] integerValue] > 0 ) {
        for (id item in result[@"data"]) {
            [self.changeEvents addObject:@{
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
            [self.changeReason addObject:@{
                                           @"name": item[@"dic_name"] ?: @"",
                                           @"value": item[@"dic_value"] ?: @"",
                                           }];
        }
    }
    
    [self loadDone];
}

- (void)projectDidSelect:(id)selectedItem
{
    [self.formObjects removeObjectForKey:@"contract_name"];
    [self.formObjects removeObjectForKey:@"money"];
    [self.formObjects removeObjectForKey:@"contract_no"];
    
    NSArray *array = self.contracts[selectedItem[@"name"]];
    
    NSMutableArray *temp1 = [NSMutableArray array];
    NSMutableArray *temp2 = [NSMutableArray array];
    for (id item in array) {
        [temp1 addObject:item[@"contractname"]];
        [temp2 addObject:item[@"contractid"]];
    }
    
    id dict = [self.inFormControls objectAtIndex:1];
    NSMutableDictionary *newDict = [dict mutableCopy];
    newDict[@"item_name"] = [temp1 componentsJoinedByString:@","];
    newDict[@"item_value"] = [temp2 componentsJoinedByString:@","];
    [self.inFormControls replaceObjectAtIndex:1 withObject:newDict];
    
    [self formControlsDidChange];
}

- (void)contractDidSelect:(id)selectedItem
{
    id item = self.contracts2[[selectedItem[@"value"] description]];
    
    if (item) {
        self.formObjects[@"contract_no"] = item[@"contractphyno"];
        self.formObjects[@"money"] = item[@"contractmoney"];
        
//        [self formControlsDidChange];
        [self.tableView reloadData];
    }
}

- (void)loadDone
{
    self.counter ++;
    
    if ( self.counter == 3 ) {
        [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
        
        id dict = [self.inFormControls objectAtIndex:0];
        NSMutableDictionary *newDict = [dict mutableCopy];
        newDict[@"item_name"] = [self.projects componentsJoinedByString:@","];
        newDict[@"item_value"] = [self.projects componentsJoinedByString:@","];
        [self.inFormControls replaceObjectAtIndex:0 withObject:newDict];
        
        ///
        dict = [self.inFormControls objectAtIndex:5];
        NSMutableArray *temp1 = [NSMutableArray array];
        NSMutableArray *temp2 = [NSMutableArray array];
        for (id item in self.changeEvents) {
            [temp1 addObject:item[@"name"]];
            [temp2 addObject:item[@"value"]];
        }
        
        newDict = [dict mutableCopy];
        newDict[@"item_name"] = [temp1 componentsJoinedByString:@","];
        newDict[@"item_value"] = [temp2 componentsJoinedByString:@","];
        
        [self.inFormControls replaceObjectAtIndex:5 withObject:newDict];
        
        
        ////
        dict = [self.inFormControls objectAtIndex:6];
        temp1 = [NSMutableArray array];
        temp2 = [NSMutableArray array];
        for (id item in self.changeReason) {
            [temp1 addObject:item[@"name"]];
            [temp2 addObject:item[@"value"]];
        }
        
        newDict = [dict mutableCopy];
        newDict[@"item_name"] = [temp1 componentsJoinedByString:@","];
        newDict[@"item_value"] = [temp2 componentsJoinedByString:@","];
        
        [self.inFormControls replaceObjectAtIndex:6 withObject:newDict];
        
        
        [self formControlsDidChange];
    }
}

//@iSupID bigint,
//@sLoginName varchar(30),
//@iSymbolKeyID bigint,
//@iOperateType int, --1保存草稿  2-提交   3--删除   4-取消
//@iChangeID bigint,--变更/指令ID  新建的变更/指令则为0
//@sChangeType varchar(20), --变更/指令
//@iContractID bigint,--合同ID
//@sTheme varchar(500), --主题
//@sProgress varchar(30),--事项当前进展
//@iChangeReasonID bigint,--变更/指令原因
//@dChangeMoney decimal(18,2),--变更金额
//@sContentDesc varchar(8000),--变更内容
//@sAnnexIDs varchar(500)='',--附件/图片ID

- (void)sendReqForType:(NSInteger)type
{
    // 合同
    NSString *contractID = @"";
    if ( self.formObjects[@"contract_name"] ) {
        contractID = [self.formObjects[@"contract_name"][@"value"] description];
    }
    if ( contractID.length == 0 ) {
        [self.contentView showHUDWithText:@"必须选择合同" offset:CGPointMake(0,20)];
        return;
    }
    
    // 主题
    NSString *theme = self.formObjects[@"subject"] ?: @"";
    theme = [theme trim];
    if ( theme.length == 0 ) {
        [self.contentView showHUDWithText:@"变更主题不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    // 事项进展
    NSString *eventType = @"";
    if ( self.formObjects[@"event_type"] ) {
        eventType = [self.formObjects[@"event_type"][@"value"] description];
    }
    if ( eventType.length == 0 ) {
        [self.contentView showHUDWithText:@"必须选择事项进展" offset:CGPointMake(0,20)];
        return;
    }
    
    // 变更原因
    NSString *reasonID = @"";
    if ( self.formObjects[@"event_reason"] ) {
        reasonID = [self.formObjects[@"event_reason"][@"value"] description];
    }
    
    if ( reasonID.length == 0 ) {
        [self.contentView showHUDWithText:@"必须选择变更原因" offset:CGPointMake(0,20)];
        return;
    }
    
    // 变更金额
    NSString *money = [self.formObjects[@"money2"] ?: @"" description];
    if ( money.length == 0 ) {
        [self.contentView showHUDWithText:@"变更金额不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    // 变更内容
    NSString *opinion = [[self.formObjects[@"opinion"] ?: @"" description] trim];
    if ( opinion.length == 0 ) {
        [self.contentView showHUDWithText:@"变更内容不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    // 附件
    NSArray *photos = self.formObjects[@"photos"] ?: @[];
    if ( photos.count == 0 ) {
        [self.contentView showHUDWithText:@"至少需要上传一张图片" offset:CGPointMake(0,20)];
        return;
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    for (id p in photos) {
        [temp addObject:[p[@"id"] ?: @"" description]];
    }
    
    NSString *IDs = [temp componentsJoinedByString:@","];
    
    // 发请求
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    NSString *changeID = [self.params[@"change_id"] ?: @"0" description];
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商变更指令操作APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": [@(type) description],
              @"param5": changeID,
              @"param6": @"变更",
              @"param7": contractID,
              @"param8": theme,
              @"param9": eventType,
              @"param10": reasonID,
              @"param11": money,
              @"param12": opinion,
              @"param13": IDs,
              } completion:^(id result, NSError *error) {
                  [me handleResult:result error:error];
              }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
//        NSLog(@"error: %@", error);
        [self.contentView showHUDWithText:error.localizedDescription succeed:NO];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            
        } else {
//            hint = "\U4fdd\U5b58\U6210\U529f\Uff01";
//            hinttype = 1;
//            supchangeid = 6;
            
//            {
//                code = 0;
//            }
            
            id item = [result[@"data"] firstObject];
            if ( [item[@"hinttype"] integerValue] == 1 ) {
                [self.navigationController.view showHUDWithText:item[@"hint"] succeed:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.contentView showHUDWithText:item[@"hint"] succeed:NO];
            }
        }
    }
}

- (void)commit
{
//    NSLog(@"%@", self.formObjects);
    [self sendReqForType:2];
}

- (void)save
{
//    NSLog(@"%@", self.formObjects)
    [self sendReqForType:1];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    [super keyboardWillShow:noti];
    
    NSDictionary *userInfo = noti.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.commitButton.top =
        self.saveButton.top =
        self.contentView.height - CGRectGetHeight(frame) - self.commitButton.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    [super keyboardWillHide:noti];
    
    NSDictionary *userInfo = noti.userInfo;
    
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.commitButton.top =
        self.saveButton.top =
        self.contentView.height - self.commitButton.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (NSArray *)formControls
{
    return self.inFormControls;
}

- (BOOL)supportsTextArea
{
    return NO;
}

- (BOOL)supportsAttachment
{
    return NO;
}

- (BOOL)supportsCustomOpinion
{
    return NO;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end