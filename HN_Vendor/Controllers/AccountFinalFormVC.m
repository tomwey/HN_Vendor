//
//  AccountFinalFormVC.m
//  HN_Vendor
//
//  Created by tomwey on 20/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "AccountFinalFormVC.h"
#import "Defines.h"

@interface AccountFinalFormVC ()

@property (nonatomic, strong) NSMutableArray *inFormControls;

@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UIButton *zfButton;

@end

@implementation AccountFinalFormVC

- (void)viewDidLoad {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
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
    
    [self addToolButtons];
    
    [self loadData];
    
    self.formObjects[@"apply_date"] = [df stringFromDate:now] ?: @"";
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
    
}

- (void)zfClick
{
    
}

- (void)sendReqForType:(NSInteger)type
{
//    NSMutableArray *temp = [NSMutableArray array];
//    for (id p in photos) {
//        [temp addObject:[p[@"id"] ?: @"" description]];
//    }
//
//    NSString *IDs = [temp componentsJoinedByString:@","];
    
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
              @"param5": @"0",
              @"param6": [self.params[@"contractid"] ?: @"0" description],
              @"param7": [self.formObjects[@"money"] description],
              @"param8": [self.formObjects[@"apply_desc"] description],
              @"param9": @"",
              @"param10": @"0",
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
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
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
        for (id item in data) {
            [self.inFormControls addObject:@{
                                             @"data_type": @"15",
                                             @"datatype_c": @"相关附件",
                                             @"describe": item[@"docname"] ?: @"相关附件",
                                             @"field_name": item[@"typedocid"] ?: @"annexid",
                                             @"item_name": @"",
                                             @"item_value": @"H_APP_Supplier_Annex,AnnexKeyID",
                                             @"required": @(HNIntegerFromObject(item[@"required"], 0))
                                             }];
        }
        
        [self formControlsDidChange];
    }
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
                               @"money": self.params[@"contracttotalmoney"] ?: @"0",
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
                               @"money": self.params[@"contractoutamount"] ?: @"0",
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
