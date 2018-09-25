//
//  AccountFinalFormVC.m
//  HN_Vendor
//
//  Created by tomwey on 20/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "AccountFinalFormVC.h"
#import "Defines.h"
#import "ZFBoxView.h"

@interface AccountFinalFormVC ()

@property (nonatomic, strong) NSMutableArray *inFormControls;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIButton *zfButton;

@property (nonatomic, strong) NSArray *annexList;
@property (nonatomic, strong) NSArray *annexData;

@property (nonatomic, assign) NSInteger counter;

@end

@implementation AccountFinalFormVC

- (void)viewDidLoad {
    
    self.inFormControls = [@[
                            @{
                                @"data_type": @"1",
                                @"datatype_c": @"文本框",
                                @"describe": @"申报金额(元)",
                                @"field_name": @"money",
                                @"item_name": @"",
                                @"item_value": @"",
                                @"keyboard_type": @(UIKeyboardTypeNumbersAndPunctuation),
                                },
                            @{
                                @"data_type": @"1",
                                @"datatype_c": @"文本框",
                                @"describe": @"申报日期",
                                @"field_name": @"apply_date",
                                @"item_name": @"",
                                @"item_value": @"",
                                @"readonly": @"1",
                                @"required": @"0"
                                },
                            @{
                                @"data_type": @"10",
                                @"datatype_c": @"多行文本",
                                @"describe": @"申报说明",
                                @"field_name": @"apply_desc",
                                @"item_name": @"",
                                @"item_value": @"",
                                },
                            
                            ] mutableCopy];
    [super viewDidLoad];
    
    self.navBar.title = @"发起结算申报";
    
    [self addLeftItemWithView:HNCloseButton(34, self, @selector(close))];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initHeader];
    
//    [self addToolButtons];
    
    if ( !self.params[@"state_num"] ) {
        // 新建
        self.disableFormInputs = NO;
//        self.totalCounter = 3;
        
        [self addToolButtons];
    } else {
        // 添加状态显示
//        self.totalCounter = 4; // 加载附件
        
        if ([self.params[@"state_num"] integerValue] == 0 || [self.params[@"state_num"] integerValue] == 5) {
            // 待申报
            self.disableFormInputs = NO;
            [self addToolButtons];
        } else if ( [self.params[@"state_num"] integerValue] == 10 ) {
            // 已申报
            self.disableFormInputs = YES;
            [self addCancelButton];
        } else {
            self.disableFormInputs = YES;
        }
        
    }
    
    if ([self.params[@"state_num"] integerValue] == 5) {
        // 被驳回，显示驳回原因
        __weak typeof(self) me = self;
        [self addRightItemWithTitle:@"驳回原因"
                    titleAttributes:@{
                                      NSFontAttributeName: AWSystemFontWithSize(15, NO)
                                      }
                               size:CGSizeMake(80,40)
                        rightMargin:5 callback:^{
                            [me showZFBox];
                        }];
        
        [self showZFBox];
    }
    
//    self.counter = 2;
    
    [self loadData];
    
    // 填充数据
//    [self populateData];
}

- (void)showZFBox
{
    [[[ZFBoxView alloc] init] showReason:self.params[@"returnmemo"]
                                  inView:self.view
                             commitBlock:^(ZFBoxView *sender) {
                                 
                             }];
}

- (void)addCancelButton
{
    UIButton *cancelBtn = AWCreateTextButton(CGRectMake(0, 0, self.contentView.width,
                                                        50),
                                             @"取消",
                                             [UIColor whiteColor],
                                             self,
                                             @selector(cancelClick));
    [self.contentView addSubview:cancelBtn];
    cancelBtn.backgroundColor = MAIN_THEME_COLOR;
    cancelBtn.position = CGPointMake(0, self.contentView.height - 50);
    
    self.tableView.height -= cancelBtn.height;
}

- (void)populateData
{
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    self.formObjects[@"apply_date"] = self.params[@"applydate"] ?: [df stringFromDate:now];
    
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
    
    if ( self.params[@"applymoney"] ) {
        self.formObjects[@"money"] = self.params[@"applymoney"];
    }
    
    if ( self.params[@"applycontent"] ) {
        self.formObjects[@"apply_desc"] = self.params[@"applycontent"];
    }
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    [super keyboardWillShow:noti];
    
    NSDictionary *userInfo = noti.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.commitButton.top =
        self.zfButton.top =
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
        self.zfButton.top =
        self.saveButton.top =
        self.contentView.height - self.commitButton.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addToolButtons
{
    CGFloat width = self.contentView.width / 2.0;
    CGFloat left = 0;
    
    if ( [self.params[@"state_num"] integerValue] == 5 ) {
        width = self.contentView.width / 3.0;
        
        UIButton *zfBtn = AWCreateTextButton(CGRectMake(0, 0, width, 50),
                                             @"作废",
                                             [UIColor whiteColor],
                                             self, @selector(zfClick));
        [self.contentView addSubview:zfBtn];
        zfBtn.backgroundColor = AWColorFromRGB(102, 102, 102);
        zfBtn.position = CGPointMake(0, self.contentView.height - 50);
        
        self.zfButton = zfBtn;
        
        left = self.zfButton.right;
    }
    
    UIButton *commitBtn = AWCreateTextButton(CGRectMake(0, 0, width,
                                                        50),
                                             @"提交",
                                             [UIColor whiteColor],
                                             self,
                                             @selector(commit));
    [self.contentView addSubview:commitBtn];
    commitBtn.backgroundColor = MAIN_THEME_COLOR;
    commitBtn.position = CGPointMake(left, self.contentView.height - 50);
    
    self.commitButton = commitBtn;
    
    UIButton *moreBtn = AWCreateTextButton(CGRectMake(0, 0, width,
                                                      50),
                                           @"保存",
                                           MAIN_THEME_COLOR,
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
    
    //    UIButton *commitBtn = AWCreateTextButton(CGRectMake(0, 0, self.contentView.width / 2,
    //                                                        50),
    //                                             @"提交",
    //                                             [UIColor whiteColor],
    //                                             self,
    //                                             @selector(commit));
    //    [self.contentView addSubview:commitBtn];
    //    commitBtn.backgroundColor = MAIN_THEME_COLOR;
    //    commitBtn.position = CGPointMake(0, self.contentView.height - 50);
    //
    //    self.commitButton = commitBtn;
    //
    //    UIButton *moreBtn = AWCreateTextButton(CGRectMake(0, 0, self.contentView.width / 2,
    //                                                      50),
    //                                           @"保存",
    //                                           MAIN_THEME_COLOR,
    //                                           self,
    //                                           @selector(save));
    //    [self.contentView addSubview:moreBtn];
    //    moreBtn.backgroundColor = [UIColor whiteColor];
    //    moreBtn.position = CGPointMake(commitBtn.right, self.contentView.height - 50);
    //
    //    self.saveButton = moreBtn;
    //
    //    UIView *hairLine = [AWHairlineView horizontalLineWithWidth:moreBtn.width
    //                                                         color:IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR
    //                                                        inView:moreBtn];
    //    hairLine.position = CGPointMake(0,0);
    //
    //    commitBtn.left = 0;
    //    moreBtn.left = commitBtn.right;
    
    self.tableView.height -= moreBtn.height;
}

- (void)save
{
    [self sendReqForType:1];
}

- (void)commit
{
    [self sendReqForType:2];
}

- (void)zfClick
{
    id newParams = [self.params mutableCopy];
    newParams[@"zf_type"] = @"2";
    
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"ZFBoxVC" params:newParams];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)cancelClick
{
    [self sendReqForType:4];
}

- (void)sendReqForType:(NSInteger)type
{
//    NSMutableArray *temp = [NSMutableArray array];
//    for (id p in photos) {
//        [temp addObject:[p[@"id"] ?: @"" description]];
//    }
//
//    NSString *IDs = [temp componentsJoinedByString:@","];
    
    // 附件必填检查
    for (id item in self.annexList) {
        NSString *key = [NSString stringWithFormat:@"annex_%@", item[@"typedocid"]];
        if ( [item[@"required"] boolValue] ) {
            if ( [self.formObjects[key] count] == 0 ) {
                [self.contentView showHUDWithText:[NSString stringWithFormat:@"%@不能为空", item[@"docname"]]];
                return;
            }
        }
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    for (id key in self.formObjects) {
        if ( [key hasPrefix:@"annex_"] ) {
            NSArray *arr = self.formObjects[key];
            NSLog(@"%@", arr);
            NSMutableArray *arr2 = [NSMutableArray array];
            for (id item in arr) {
                [arr2 addObject:item[@"id"]];
            }
            [temp addObject:[NSString stringWithFormat:@"%@:%@",
                             [[key componentsSeparatedByString:@"_"] lastObject],
                             [arr2 componentsJoinedByString:@","]]];
        }
    }
    
    NSString *ids = [temp componentsJoinedByString:@";"];
    
    // 发请求
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
//    NSString *visaID = [self.params[@"supvisaid"] ?: @"0" description];
    
    [self hideKeyboard];

    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商提交结算申报APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": [@(type) description],
              @"param5": [self.params[@"supsettleid"] ?: @"0" description],
              @"param6": [self.params[@"contractid"] ?: @"0" description],
              @"param7": [self.formObjects[@"money"] description],
              @"param8": [self.formObjects[@"apply_desc"] description],
              @"param9": ids,
              @"param10": @"1",
              @"param11": @"",
              } completion:^(id result, NSError *error) {
                  [me handleResult2:result error:error];
              }];
}

- (void)handleResult2:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
        //        NSLog(@"error: %@", error);
        [self.contentView showHUDWithText:error.localizedDescription succeed:NO];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            
        } else {
            id item = [result[@"data"] firstObject];
            if ( [item[@"hinttype"] integerValue] == 1 ||
                (item[@"code"] && [item[@"code"] integerValue] == 0) ||
                ([[[item allValues] firstObject] integerValue] == 1) ) {
                NSString *msg = item[@"hint"] ?: @"操作成功";
                [AWAppWindow() showHUDWithText:msg succeed:YES];
                
//                if ( self.params[@"_flag"] ) {
//                    //                    [self.presentingViewController dismissViewControllerAnimated:YES
//                    //                                                                  completion:^{
//                    //                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadDeclareDataNotification" object:nil];
//                    //                                                                  }];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNeedDismissNotification"
//                                                                        object:nil];
//                } else {
//                    [self dismissViewControllerAnimated:YES completion:^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadDeclareDataNotification" object:nil];
//                    }];
//                }
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadAccountFinalDataNotification" object:nil];
                }];
                
            } else {
                [self.contentView showHUDWithText:item[@"hint"] succeed:NO];
            }
        }
    }
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    __weak typeof(self) me = self;
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商取附件清单APP",
              @"param1": [self.params[@"contracttypeid"] ?: @"0" description],
              @"param2": @"1",
              @"param3": @"12"
              } completion:^(id result, NSError *error) {
                  [me handleResult:result error: error];
              }];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商取附件文档APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": [self.params[@"supsettleid"] ?: @"0" description],
              @"param5": @"H_APP_Supplier_Contract_Settle_Apply",
              } completion:^(id result, NSError *error) {
                  [me handleResult3:result error: error];
              }];
}

- (void)handleResult3:(id)result error:(NSError *)error
{
    if ( result && [result[@"rowcount"] integerValue] > 0 ) {
        NSArray *data = result[@"data"];
        for (id item in data) {
            NSString *key = [NSString stringWithFormat:@"annex_%@", item[@"annextypeid"]];
            NSDictionary *params = [[item[@"annexurl"] description] queryDictionaryUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableArray *temp = [self.formObjects[key] ?: @[] mutableCopy];
            [temp addObject:@{
                              @"id": item[@"annexkeyid"] ?: @"0",
                              @"imageURL": [params[@"hnapp://open-file?file"] ?: @"" stringByAppendingPathComponent:@"contents"],
                              @"imageName": params[@"filename"] ?: @""
                              }];
            self.formObjects[key] = [temp copy];

        }
    }
    
    [self loadDone];
}

- (void)loadDone
{
    if ( ++self.counter == 2 ) {
        self.counter = 0;
        [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
        
        [self populateData];
    }
}

- (void)handleResult:(id)result error:(NSError *)error
{
//    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( result && [result[@"rowcount"] integerValue] > 0 ) {
//        billtypeid = 12;
//        billtypename = "\U7ed3\U7b97";
//        contracttypeid = 0;
//        "create_date" = NULL;
//        "create_id" = NULL;
//        deleted = 0;
//        docmemo = NULL;
//        docname = "\U5de5\U7a0b\U79fb\U4ea4\U8bb0\U5f55";
//        docno = NULL;
//        docorder = 2;
//        "edit_date" = NULL;
//        "edit_id" = NULL;
//        "industry_id" = 1;
//        isvalid = 1;
//        typedocid = 2;
        
        NSArray *data = result[@"data"];
        self.annexList = data;
        
        for (id item in data) {
            NSString *key = @"annexid";
            if ( item[@"typedocid"] ) {
                key = [NSString stringWithFormat:@"annex_%@", item[@"typedocid"]];
            }
            [self.inFormControls addObject:@{
                                             @"data_type": @"21",
                                             @"datatype_c": @"相关附件",
                                             @"describe": item[@"docname"] ?: @"相关附件",
                                             @"field_name": key,
                                             @"item_name": @"",
                                             @"item_value": @"H_APP_Supplier_Annex,AnnexKeyID",
                                             @"required": @(HNIntegerFromObject(item[@"required"], 0))
                                             }];
        }
        
        [self formControlsDidChange];
    }
    
    [self loadDone];
}

- (void)initHeader
{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, self.contentView.width, 170);
    header.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = header;
    
    UILabel *name = AWCreateLabel(CGRectMake(15, 0, header.width - 30, 50),
                                  self.params[@"contractname"], NSTextAlignmentLeft,
                                  AWSystemFontWithSize(16, NO), AWColorFromHex(@"#333333"));
    name.numberOfLines = 2;
    name.adjustsFontSizeToFitWidth = YES;
    [header addSubview:name];
    
    NSArray *statsData = @[
                           @{
                               @"name": @"系统结算总金额",
                               @"money": self.params[@"contracttotalmoney"] ?: self.params[@"syssettlemoney"] ?: @"0",
                               @"align": @"0",
                               },
                           @{
                               @"name": @"签约金额",
                               @"money": self.params[@"signmoney"] ?: @"0",
                               @"align": @"1",
                               },
                           @{
                               @"name": @"重计量金额",
                               @"money": self.params[@"resignmoney"] ?: @"0",
                               @"align": @"2",
                               },
                           @{
                               @"name": @"补充合同金额",
                               @"money": self.params[@"addsignmoney"] ?: @"0",
                               @"align": @"0",
                               },
                           @{
                               @"name": @"签证金额",
                               @"money": self.params[@"changemoney"] ?: @"0",
                               @"align": @"1",
                               },
                           @{
                               @"name": @"产值确认金额",
                               @"money": self.params[@"contractoutamount"] ?: self.params[@"totaloutamount"] ?: @"0",
                               @"align": @"2",
                               },
                           ];
    
    CGFloat width = (self.contentView.width - 30 - 10) / 3;
    for (int i=0; i<statsData.count; i++) {
        CGRect frame = CGRectMake(0, 0, width, 44);
        UILabel *label = AWCreateLabel(frame, nil, NSTextAlignmentLeft, AWSystemFontWithSize(12, NO), AWColorFromHex(@"#999999"));
        [header addSubview:label];
        label.numberOfLines = 2;
        label.adjustsFontSizeToFitWidth = YES;
        
        int m = i % 3;
        int n = i / 3;
        
        label.position = CGPointMake( (width + 5) * m + 15, name.bottom + 5 + n * ( 44 + 5 ));
        
        id item = statsData[i];
        
        if ( [item[@"align"] isEqualToString: @"1"] ) {
            label.textAlignment = NSTextAlignmentCenter;
        } else if ( [item[@"align"] isEqualToString: @"2"] ) {
            label.textAlignment = NSTextAlignmentRight;
        }
        
        [self setLabel1:item[@"money"]
                   name:item[@"name"]
               forLabel:label
                  color:AWColorFromHex(@"#666666")];
    }
    
    UIView *spliter = [[UIView alloc] initWithFrame:CGRectMake(0, header.height - 5,
                                                               header.width, 5)];
    spliter.backgroundColor = self.contentView.backgroundColor;
    [header addSubview:spliter];
}

- (void)setLabel1:(id)value name:(NSString *)name forLabel:(UILabel *)label color:(UIColor *)color
{
    NSString *money = [HNFormatMoney(value, @"万") stringByReplacingOccurrencesOfString:@"万" withString:@""];
    NSString *string = [NSString stringWithFormat:@"%@\n%@万", name, money];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttributes:@{
                                NSFontAttributeName: AWCustomFont(@"PingFang SC", 18),
                                NSForegroundColorAttributeName: color
                                } range:[string rangeOfString:money]];
    
    label.attributedText = attrString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000000001;
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
