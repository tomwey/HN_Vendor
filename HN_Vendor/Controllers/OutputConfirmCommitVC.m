//
//  OutputConfirmCommitVC.m
//  HN_ERP
//
//  Created by tomwey on 29/01/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "OutputConfirmCommitVC.h"
#import "Defines.h"
#import "UploadImageControl.h"

@interface OutputConfirmCommitVC () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

//@property (nonatomic, weak) UIButton *save2TodoBtn;
//@property (nonatomic, weak) UIButton *commitBtn;

@property (nonatomic, weak) UIButton *doneBtn;

@property (nonatomic, assign) CGFloat currentBottom;
@property (nonatomic, assign) CGFloat currentBottom2;

// 上传组件
@property (nonatomic, weak) UploadImageControl *uploadControl;
@property (nonatomic, weak) UILabel *uploadLabel;

// 进度组件
@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UILabel  *currentProgressLabel;

@property (nonatomic, assign) NSInteger beginVal;

@property (nonatomic, weak) UIButton *confirmDone;

// 完成日期
@property (nonatomic, weak) UIView   *dateView;
@property (nonatomic, weak) UIButton *date1Btn;
@property (nonatomic, weak) UIButton *date2Btn;
@property (nonatomic, strong) id serverDates;

// 确认说明
@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, strong) UITextView *confirmDescText;
@property (nonatomic, weak) UILabel *confirmLabel;

@property (nonatomic, strong) UIView *movingView;

@property (nonatomic, strong) id annexData;
@property (nonatomic, strong) NSError *annexError;

@property (nonatomic, strong) id confirmHisData;
@property (nonatomic, strong) NSError *confirmHisError;

@property (nonatomic, assign) NSInteger counter;

@property (nonatomic, strong) UIView *fixedControlContainer;

@property (nonatomic, strong) UIView *confirmHistoryContainer;

@property (nonatomic, strong) UIView *sureDescContainer;

@property (nonatomic, weak) UIButton *currentConfirmBtn;

@end

@implementation OutputConfirmCommitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"产值确认";
    
//    [self addLeftItemWithView:HNCloseButton(34, self, @selector(close))];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    // 初始化滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.scrollView];
    self.scrollView.showsVerticalScrollIndicator = NO;

    self.scrollView.height -= 70;
    self.scrollView.delegate = self;
    
    self.fixedControlContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width,
                                                                          240)];
    [self.scrollView addSubview:self.fixedControlContainer];
//    self.fixedControlContainer.backgroundColor = [UIColor redColor];
    
    // 初始化输入控件
//    [self initFormControls];
    
    // 初始化提交按钮
//    [self initCommitButtons];
//    [self initCommitButton];
    
    [self loadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.confirmDescText resignFirstResponder];
}

- (void)initCommitButton
{
    UIButton *commitBtn = AWCreateTextButton(CGRectMake(0, 0, self.contentView.width - 30,
                                                        50),
                                             @"产值确认",
                                             [UIColor whiteColor],
                                             self,
                                             @selector(btnClicked:));
    [self.contentView addSubview:commitBtn];
    
    commitBtn.backgroundColor = MAIN_THEME_COLOR;
    commitBtn.position = CGPointMake(15, self.contentView.height - 50 - 15);
    
    commitBtn.cornerRadius = 25;
    
    self.doneBtn = commitBtn;
    
    commitBtn.userData = @{ @"type": @"1" };
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    [self loadData];
    
//    if ( [self hasConfirmAbility] == NO ) {
//        [self.navigationController.view showHUDWithText:@"您只有查看权限" offset:CGPointMake(0,20)];
//
//        commitBtn.hidden = YES;
//    }
    
    [self disableUI];
}

- (void)disableUI
{
    NSInteger state = [self.params[@"floor"][@"nodecompletestatusnum"] integerValue];
    if ( state == 3 || state == 4 ) {
        for (UIView *view in self.scrollView.subviews) {
            if ( [view isKindOfClass:[UploadImageControl class]] ) {
                UploadImageControl *control = (UploadImageControl *)view;
                control.enabled = NO;
            } else {
                view.userInteractionEnabled = NO;
            }
        }
        
        self.doneBtn.userInteractionEnabled = NO;
        self.doneBtn.backgroundColor = AWColorFromRGB(216, 216, 216);
    }
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationOptions = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    self.keyboardFrame = keyboardFrame;
    
    //    [self updateSearchBoxPosition];
    
    self.scrollView.contentInset          =
    self.scrollView.scrollIndicatorInsets =
    UIEdgeInsetsMake(0, 0, keyboardFrame.size.height, 0);
    
    CGRect r = [self.contentView convertRect:self.confirmDescText.frame
                                    fromView:self.scrollView];
    r.origin.y = self.confirmDescText.top;
    r.size.height = self.keyboardFrame.size.height;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationOptions
                     animations:
     ^{
         [self.scrollView scrollRectToVisible:r animated:NO];
     } completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationOptions = [noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:animationOptions
                     animations:
     ^{
         self.scrollView.contentInset          =
         self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
     } completion:nil];
}

- (void)btnClicked:(UIButton *)sender
{
    if ( [sender.userData[@"type"] isEqualToString:@"1"] ) {
        [self doConfirm];
    } else {
        [self cancelConfirm];
    }
}

- (void)doConfirm
{
    //    @iOutNodeID bigint,--节点类型ID
    //    @iContractPayNodeID bigint,--节点ID
    //    @sRoomIDs varchar(200),--楼栋ID
    //    @dBeginValue decimal(18,2),--开始工程量
    //    @dEndValue decimal(18,2),--结束工程量
    //    @sMemo varchar(2000),--说麦
    //    @sAnnexIDs varchar(200),--附件ID,多个附件以逗号间隔
    //    @iConfirmType int, ---1 确认  -1 取消确认
    //    @iManID bigint,--操作人员ID
    
    // 检查提交数据
    //    if ( !self.currentConfirmFloor ) {
    //        [self.contentView showHUDWithText:@"产值确认楼层必选" offset:CGPointMake(0,20)];
    //        return;
    //    }
    //
    NSString *beginVal = [@(self.beginVal) description];
    
    NSInteger value = [self.currentProgressLabel.text integerValue];
    
    if (value == 0 || value < self.beginVal ) {
        [self.contentView showHUDWithText:@"产值确认完成进度必须设置" offset:CGPointMake(0,20)];
        return;
    }
    
    NSString *endVal   = [@(value) description];
    
    NSString *confirmDesc = [self.confirmDescText.text trim];
    if ( confirmDesc.length == 0 ) {
        [self.contentView showHUDWithText:@"进度说明不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    //    NSString *annexIDs = @"";
    NSArray *IDs = self.uploadControl.attachmentIDs;
    if ( IDs.count == 0 ) {
        [self.contentView showHUDWithText:@"至少需要上传一张图片" offset:CGPointMake(0,20)];
        return;
    }
    
    NSString *annexIDs = [IDs componentsJoinedByString:@","];
    
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id user = [[UserService sharedInstance] currentUser];
    NSString *manID = [user[@"man_id"] description];
    manID = manID ?: @"0";
    
    //    contractpaynodeid
    NSString *outNodeId = [[self.params[@"floor"][@"outnodeid"] description] isEqualToString:@"NULL"] ? @"0" : [self.params[@"floor"][@"outnodeid"] description];
    NSString *payOutNodeId = [[self.params[@"floor"][@"contractpaynodeid"] description] isEqualToString:@"NULL"] ? @"0" : [self.params[@"floor"][@"contractpaynodeid"] description];
    // 合同：2220895 节点ID: 0 payoutnodeid: 5594217
    
    __weak typeof(self) me = self;
    
    [self checkIsCommit:payOutNodeId completion:^(id res, NSError *err) {
        if ( err ) {
            [HNProgressHUDHelper hideHUDForView:me.contentView animated:YES];
            
            [me.contentView showHUDWithText:err.localizedDescription succeed:NO];
        } else {
            if ( [res[@"rowcount"] integerValue] == 0 ) {
                [HNProgressHUDHelper hideHUDForView:me.contentView animated:YES];
                
                [me.contentView showHUDWithText:@"未知错误" succeed:NO];
            } else {
                id item = res[@"data"][0];
                NSInteger type = [item[@"hinttype"] integerValue];
                if (type == 0) {
                    [HNProgressHUDHelper hideHUDForView:me.contentView animated:YES];
                    [me.contentView showHUDWithText:item[@"hint"] succeed:NO];
                } else {
                    // 产值确认
                    id userInfo = [[UserService sharedInstance] currentUser];
                    
                    [[me apiServiceWithName:@"APIService"]
                     POST:nil
                     params:@{
                              @"dotype": @"GetData",
                              @"funname": @"供应商合同产值节点确认APP",
                              @"param1": [userInfo[@"supid"] ?: @"0" description],
                              @"param2": userInfo[@"loginname"] ?: @"",
                              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
                              @"param4": [me.params[@"floor"][@"contractid"] description],
                              @"param5": outNodeId,
                              @"param6": payOutNodeId,
                              @"param7": [me.params[@"floor"][@"roomids"] description],
                              @"param8": beginVal,
                              @"param9": endVal,
                              @"param10": confirmDesc,
                              @"param11": annexIDs,
                              @"param12": @"1",
                              @"param13": @"0",
                              @"param14": @"",
                              @"param15": [me.date1Btn currentTitle] ?: @"",
                              @"param16": [me.date2Btn currentTitle] ?: @"",
                              @"param17": @"2",
                              @"param18": [me.uploadControl.deletedAttachmentIDs componentsJoinedByString:@","],
                              } completion:^(id result, NSError *error) {
                                  [me handleResult2:result error:error];
                              }];
                }
            }
        }
    }];
}

- (void)checkIsCommit:(id)nodeID completion:(void (^)(id res, NSError *err))completion
{
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商判断当前节点可否进行产值确认APP",
              @"param1": [nodeID description]
              } completion:^(id result, NSError *error) {
                  if ( completion ) {
                      completion(result, error);
                  }
              }];
}

- (void)cancelConfirm
{
    // 检查提交数据
    NSInteger value = [self.currentProgressLabel.text integerValue];
    
    if ( value == self.beginVal ) {
        [self.contentView showHUDWithText:@"取消确认完成进度必须设置" offset:CGPointMake(0,20)];
        return;
    }
    
    if ( value > self.beginVal ) {
        [self.contentView showHUDWithText:@"取消确认完成进度必须小于当前完成进度" offset:CGPointMake(0,20)];
        return;
    }
    
    NSString *endVal   = [@(self.beginVal) description];
    NSString *beginVal = [@(value) description];
    
    NSString *confirmDesc = [self.confirmDescText.text trim];
    
//    if ( confirmDesc.length == 0 ) {
//        [self.contentView showHUDWithText:@"进度说明不能为空" offset:CGPointMake(0,20)];
//        return;
//    }
    
    //    NSString *annexIDs = @"";
    NSArray *IDs = self.uploadControl.attachmentIDs;
    NSString *annexIDs = [IDs componentsJoinedByString:@","] ?: @"";
    
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id user = [[UserService sharedInstance] currentUser];
    NSString *manID = [user[@"man_id"] description];
    manID = manID ?: @"0";
    
    NSString *outNodeId = [[self.params[@"floor"][@"outnodeid"] description] isEqualToString:@"NULL"] ? @"0" : [self.params[@"floor"][@"outnodeid"] description];
    NSString *payOutNodeId = [[self.params[@"floor"][@"contractpaynodeid"] description] isEqualToString:@"NULL"] ? @"0" : [self.params[@"floor"][@"contractpaynodeid"] description];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    __weak typeof(self) me = self;
    
    [self checkCanCancel:value result:^(BOOL flag) {
        if ( !flag ) {
            [me.contentView showHUDWithText:@"不能进行取消确认操作" succeed:NO];
            [HNProgressHUDHelper hideHUDForView:me.contentView animated:YES];
        } else {
            [[me apiServiceWithName:@"APIService"]
             POST:nil
             params:@{
                      @"dotype": @"GetData",
                      @"funname": @"供应商合同产值节点确认APP",
                      @"param1": [userInfo[@"supid"] ?: @"0" description],
                      @"param2": userInfo[@"loginname"] ?: @"",
                      @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
                      @"param4": [self.params[@"floor"][@"contractid"] description],
                      @"param5": outNodeId,
                      @"param6": payOutNodeId,
                      @"param7": [self.params[@"floor"][@"roomids"] description],
                      @"param8": endVal,
                      @"param9": beginVal,
                      @"param10": confirmDesc,
                      @"param11": annexIDs,
                      @"param12": @"-1",
                      @"param13": @"0",
                      @"param14": @"",
                      @"param15": [self.date1Btn currentTitle] ?: @"",
                      @"param16": [self.date2Btn currentTitle] ?: @"",
                      @"param17": @"2",
                      @"param18": @"",
//                      @"param1": [me.params[@"floor"][@"contractid"] description],
//                      @"param2": outNodeId,
//                      @"param3": payOutNodeId,
//                      @"param4": [me.params[@"floor"][@"roomids"] description],
//                      @"param5": endVal,
//                      @"param6": beginVal,
//                      @"param7": confirmDesc,
//                      @"param8": annexIDs,
//                      @"param9": @"-1",
//                      @"param10": manID,
//                      @"param11": @"",
//                      @"param12": [me.date1Btn currentTitle] ?: @"",
//                      @"param13": [me.date2Btn currentTitle] ?: @"",
//                      @"param14": @"2",
//                      @"param15": @"",
                      } completion:^(id result, NSError *error) {
                          [me handleResult3:result error:error];
                      }];
        }
    }];
}

- (void)handleResult2:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView: self.contentView animated:YES];
    if ( error ) {
        [self.contentView showHUDWithText:error.localizedDescription succeed:NO];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            [self.contentView showHUDWithText:@"产值确认失败" succeed:NO];
        } else {
            id item = [result[@"data"] firstObject];
            
            NSInteger type = [item[@"hinttype"] integerValue];
            if (type == 1) {
                [AWAppWindow() showHUDWithText:item[@"hint"] succeed:YES];
                
//                [self close];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kOutputDidConfirmNotification"
                                                                    object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                [self.contentView showHUDWithText:item[@"hint"] succeed:NO];
            }
        }
        
    }
}

- (void)handleResult3:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView: self.contentView animated:YES];
    if ( error ) {
        [self.contentView showHUDWithText:error.localizedDescription succeed:NO];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            [self.contentView showHUDWithText:@"产值取消确认失败" succeed:NO];
        } else {
            id item = [result[@"data"] firstObject];
            
            NSInteger type = [item[@"hinttype"] integerValue];
            if (type == 1) {
                [AWAppWindow() showHUDWithText:item[@"hint"] succeed:YES];
                
                [self.navigationController popViewControllerAnimated:YES];
//                [self close];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kOutputDidConfirmNotification"
                                                                    object:nil];
            } else {
                [self.contentView showHUDWithText:item[@"hint"] succeed:NO];
            }
        }
    }
}

- (void)checkCanCancel:(NSInteger)value result:(void (^)(BOOL flag))resultBlock
{
    id user = [[UserService sharedInstance] currentUser];
    NSString *manID = [user[@"man_id"] description];
    manID = manID ?: @"0";
    
    NSString *nodeId = HNStringFromObject(self.params[@"floor"][@"outnodeid"], @"0");
    NSString *payNodeId = HNStringFromObject(self.params[@"floor"][@"contractpaynodeid"], @"0");
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"产值确认判断是否允许撤销产值APP",
              @"param1": [self.params[@"floor"][@"contractid"] description],
              @"param2": nodeId,
              @"param3": payNodeId,
              @"param4": [self.params[@"floor"][@"roomids"] description],
              @"param5": [@(value) description],
              @"param6": manID,
              } completion:^(id result, NSError *error) {
                  if ( error ) {
                      [me.contentView showHUDWithText:@"判断是否允许撤销产值出错，请重试" succeed:NO];
                      if (resultBlock) {
                          resultBlock(NO);
                      }
                      
                  } else {
                      id item = [result[@"data"] firstObject];
                      if ( item && [item[@"hinttype"] integerValue] == 1 ) {
                          if (resultBlock) {
                              resultBlock(YES);
                          }
                      } else {
                          // 不能取消
                          if (resultBlock) {
                              resultBlock(NO);
                          }
                      }
                  }
              }];
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"获取服务器时间APP"
              } completion:^(id result, NSError *error) {
                  [me handleResult1:result error:error];
              }];
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"产值确认取节点附件清单APP",
              @"param1": [@(HNIntegerFromObject(self.params[@"floor"][@"contractid"], 0)) description],
              @"param2": [@(HNIntegerFromObject(self.params[@"floor"][@"outnodeid"], 0)) description],
              @"param3": [@(HNIntegerFromObject(self.params[@"floor"][@"contractpaynodeid"], 0)) description],
              } completion:^(id result, NSError *error) {
                  [me handleResult4:result error:error];
              }];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商查询合同产值节点确认记录APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": userInfo[@"loginname"] ?: @"",
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": [@(HNIntegerFromObject(self.params[@"floor"][@"contractid"], 0)) description],
              @"param5": [@(HNIntegerFromObject(self.params[@"floor"][@"contractpaynodeid"], 0)) description],
              } completion:^(id result, NSError *error) {
                  [me handleResult5:result error:error];
              }];
}

- (void)handleResult5:(id)result error:(NSError *)error
{
    self.confirmHisData = result;
    self.confirmHisError = error;
    
    [self loadDone];
}

- (void)handleResult4:(id)result error:(NSError *)error
{
    self.annexData = result;
    self.annexError = error;
    
    [self loadDone];
}

- (void)handleResult1:(id)result error:(NSError *)error
{
//    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( !error ) {
        if ( [result[@"rowcount"] integerValue] > 0 ) {
            self.serverDates = [result[@"data"] firstObject];
        }
    }
    
//    [self updateDates];
    
    [self loadDone];
}

- (void)loadDone
{
    if ( ++self.counter == 3 ) {
        [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
        
        self.counter = 0;
        
        [self initFormControls];
        
        [self initCommitButton];
        
        [self initSureDesc];
        
        [self initConfirmHis];
        
        [self updateDates];
    }
}

- (void)initSureDesc
{
    self.sureDescContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.fixedControlContainer.bottom + 10, self.contentView.width, 30)];
    
    [self.scrollView addSubview:self.sureDescContainer];
    
    UIView *tag = [[UIView alloc] initWithFrame:CGRectMake(15, 9, 4, 12)];
    [self.sureDescContainer addSubview:tag];
    tag.backgroundColor = MAIN_THEME_COLOR;
    
    UILabel *label = AWCreateLabel(CGRectMake(tag.right + 5, 0, 180, 30), @"产值复核说明",
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(15, YES),
                                   AWColorFromHex(@"#333333"));
    [self.sureDescContainer addSubview:label];
    
    NSString *memo = HNStringFromObject(self.params[@"surecompletememo"], @"");
    if (memo.length == 0) {
        UILabel *errorLabel = AWCreateLabel(CGRectMake(15, label.bottom + 10,
                                                       self.contentView.width - 30, 50),
                                            @"无数据显示", NSTextAlignmentCenter,
                                            AWSystemFontWithSize(14, NO), AWColorFromHex(@"#cccccc"));
        [self.sureDescContainer addSubview:errorLabel];
        errorLabel.adjustsFontSizeToFitWidth = YES;
        
        self.sureDescContainer.height = errorLabel.bottom + 5;
    } else {
        UILabel *label2 = AWCreateLabel(CGRectMake(15, label.bottom + 10,
                                 self.contentView.width - 30, 5000),
                      memo, NSTextAlignmentLeft,
                      AWSystemFontWithSize(14, NO), AWColorFromHex(@"#666666"));
        [self.sureDescContainer addSubview:label2];
        label2.numberOfLines = 0;
        
        [label2 sizeToFit];
        
        label2.width = self.contentView.width - 30;
        label2.top   = label.bottom + 10;
        
        self.sureDescContainer.height = label2.bottom + 10;
    }
}

- (void)initConfirmHis
{
    self.confirmHistoryContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.sureDescContainer.bottom + 10, self.contentView.width, 100)];
    
    [self.scrollView addSubview:self.confirmHistoryContainer];
    
    UIView *tag = [[UIView alloc] initWithFrame:CGRectMake(15, 9, 4, 12)];
    [self.confirmHistoryContainer addSubview:tag];
    tag.backgroundColor = MAIN_THEME_COLOR;
    
    UILabel *label = AWCreateLabel(CGRectMake(tag.right + 5, 0, 180, 30), @"产值确认记录",
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(15, YES),
                                   AWColorFromHex(@"#333333"));
    [self.confirmHistoryContainer addSubview:label];
    
    NSString *errorMsg = nil;
    if ( self.confirmHisError ) {
        errorMsg = self.confirmHisError.localizedDescription;
    } else {
        if ([self.confirmHisData[@"rowcount"] integerValue] == 0) {
            errorMsg = @"无数据显示";
        }
    }
    
    if ( !errorMsg ) {
        [self initConfirmProgressBar:label.bottom];
    } else {
        UILabel *errorLabel = AWCreateLabel(CGRectMake(15, label.bottom + 10,
                                                       self.contentView.width - 30, 50),
                                            errorMsg, NSTextAlignmentCenter,
                                            AWSystemFontWithSize(14, NO), AWColorFromHex(@"#cccccc"));
        [self.confirmHistoryContainer addSubview:errorLabel];
        errorLabel.numberOfLines = 2;
        errorLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.width,
                                             self.confirmHistoryContainer.bottom + 5);
}

- (void)initConfirmProgressBar:(CGFloat)pos
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, pos + 56,
                                                            self.contentView.width - 30, 2)];
    line.backgroundColor = AWColorFromHex(@"#999999");
    [self.confirmHistoryContainer addSubview:line];
    
    NSArray *data = self.confirmHisData[@"data"];
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:@{
                      @"endvalue": @"0",
                      }];
    
    BOOL has100 = NO;
    for (id item in data) {
        if ( [item[@"endvalue"] floatValue] == 100 ) {
            has100 = YES;
        }
        
        [temp addObject:item];
    }
    
    if ( !has100 ) {
        [temp addObject:@{
                          @"endvalue": @"100",
                          @"not_value": @"1"
                          }];
    }
    
    NSInteger count = temp.count;
    
    CGFloat percent = 100.0 / (count - 1);
    NSInteger index = 0;
    for (id item in temp) {
        NSString *suffix = @"●";
        if ( [item[@"endvalue"] floatValue] == 0 ||
            ([item[@"endvalue"] floatValue] == 100 && [item[@"not_value"] integerValue] == 1)
            ) {
            suffix = @"";
        }
        UIButton *btn = AWCreateTextButton(CGRectMake(0, 0, 50, 60),
                                           [NSString stringWithFormat:@"%d%%\n\n%@",
                                            [item[@"endvalue"] integerValue], suffix],
                                           AWColorFromHex(@"#666666"),
                                           self, @selector(showDetail:));
        [self.confirmHistoryContainer addSubview:btn];
        btn.titleLabel.numberOfLines = 3;
        btn.titleLabel.font = AWSystemFontWithSize(14, NO);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat progress = percent * index++;
        
        //        btn.backgroundColor = [UIColor redColor];
        btn.center = CGPointMake(15 + (self.contentView.width - 90) * progress / 100.0 + btn.width / 2, pos + 10 + btn.height / 2);
        
        btn.userData = item;
        
        btn.userInteractionEnabled = [suffix length] > 0;
        
        id lastItem = [data lastObject];
        if ( [item[@"endvalue"] floatValue] == [lastItem[@"endvalue"] floatValue] ) {
            [self showDetail:btn];
        }
    }
}

- (void)showDetail:(UIButton *)sender
{
    if ( self.currentConfirmBtn == sender ) {
        return;
    }
    
    if ( self.currentConfirmBtn ) {
//        self.currentConfirmBtn.titleLabel.textColor = AWColorFromHex(@"#666666");
        [self.currentConfirmBtn setTitleColor:AWColorFromHex(@"#666666") forState:UIControlStateNormal];
    }
    
//    sender.titleLabel.textColor = MAIN_THEME_COLOR;
    [sender setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
    
    self.currentConfirmBtn = sender;
    
    [self showConfirmDesc:sender.userData];
}

- (void)showConfirmDesc:(id)item
{
    
    [[self.confirmHistoryContainer viewWithTag:1011011] removeFromSuperview];
    [[self.confirmHistoryContainer viewWithTag:1011012] removeFromSuperview];
    [[self.confirmHistoryContainer viewWithTag:1011013] removeFromSuperview];
    [[self.confirmHistoryContainer viewWithTag:1011014] removeFromSuperview];
    
    UILabel *label1 = AWCreateLabel(CGRectMake(15, 100, 80, 30),
                                    @"完成时间",
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromHex(@"#999999"));
    [self.confirmHistoryContainer addSubview:label1];
    
    label1.tag = 1011011;
    
    UILabel *label1_1 = AWCreateLabel(CGRectMake(label1.right,
                                                 label1.top,
                                                 160, 30),
                                      HNDateTimeFromObject(item[@"confirm_date"], @"T"),
                                      NSTextAlignmentLeft,
                                      AWSystemFontWithSize(14, NO), AWColorFromHex(@"#333333"));
    [self.confirmHistoryContainer addSubview:label1_1];
    
    label1_1.tag = 1011012;
    
    UILabel *label2 = AWCreateLabel(CGRectMake(15, label1.bottom + 5, 80, 30),
                                    @"完成说明",
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromHex(@"#999999"));
    [self.confirmHistoryContainer addSubview:label2];
    
    label2.tag = 1011013;
    
    CGFloat width = self.contentView.width - label1.right - 15;
    UILabel *label2_2 = AWCreateLabel(CGRectMake(label1.right,
                                                 label1.bottom + 5,
                                                 width,
                                                 2000),
                                      item[@"memo"],
                                      NSTextAlignmentLeft,
                                      AWSystemFontWithSize(14, NO),
                                      label1_1.textColor);
    label2_2.numberOfLines = 0;
    
    [self.confirmHistoryContainer addSubview:label2_2];
    
    label2_2.tag = 1011014;
    
    [label2_2 sizeToFit];
    
    label2_2.width = width;
    label2_2.top = label1.bottom + 11;
    
    self.confirmHistoryContainer.height = label2_2.bottom + 15;
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.width, self.confirmHistoryContainer.bottom + 10);
}

- (BOOL)hasConfirmAbility
{
    NSArray *abilities = [AppManager sharedInstance].manAbilities[@"产值确认"];
    return abilities.count > 1;
}

- (void)initFormControls
{
    self.beginVal = HNIntegerFromObject(self.params[@"floor"][@"nodecurendvalue"], 0);
    
    UILabel *nodeName = AWCreateLabel(CGRectMake(15, 15,
                                                 self.contentView.width - 30,
                                                 1000),
                                      nil,
                                      NSTextAlignmentLeft,
                                      AWSystemFontWithSize(14, YES),
                                      AWColorFromRGB(74, 74, 74));
    [self.scrollView addSubview:nodeName];
    nodeName.numberOfLines = 0;
    nodeName.text = self.params[@"floor"][@"outnodename"] ?: self.params[@"floor"][@"nodename"];
    [nodeName sizeToFit];
    
    self.currentBottom = nodeName.bottom + 15;
    
    [self addUploadFiles];
    
    self.fixedControlContainer.top = self.currentBottom;
    
    [self addDoneProgress];
    
    [self addDateButtons];
    
    [self addConfirmDesc];
    
    self.fixedControlContainer.height = self.currentBottom2;
    
    self.currentBottom = self.fixedControlContainer.bottom;
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.width, self.currentBottom);
    
    [self showOrHideDate:self.beginVal];
}

- (void)showOrHideDate:(NSInteger)value
{
    if ( value < 100 ) {
        self.dateView.hidden = YES;
        
        self.confirmLabel.top = self.dateView.top;
    } else {
        self.dateView.hidden = NO;
        
        self.confirmLabel.top = self.dateView.bottom + 20;
    }
    
    self.confirmDescText.top = self.confirmLabel.bottom + 5;
    
    self.fixedControlContainer.height = self.confirmDescText.bottom;
    
    self.sureDescContainer.top = self.fixedControlContainer.bottom + 10;
    
    self.confirmHistoryContainer.top = self.sureDescContainer.bottom + 10;
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.width, self.confirmHistoryContainer.bottom + 5);
}

- (void)updateDates
{
    NSInteger state = [self.params[@"floor"][@"nodecompletestatusnum"] integerValue];
    NSString *date1, *date2;
    if ( state == 1 ) { // 未确认产值使用默认值
        date1 = HNStringFromObject(self.serverDates[@"defaultdate"], @"");
        date2 = HNStringFromObject(self.serverDates[@"defaultpaydate"], @"");
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
        if ( date1.length == 0 ) {
            date1 = [df stringFromDate:[NSDate date]];
        }
        
        if (date2.length == 0) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            date2 = [df stringFromDate:[calendar dateByAddingUnit:NSCalendarUnitMonth
                                                            value:1
                                                           toDate:[NSDate date]
                                                          options:0]];
        }
    } else {
        date1 = HNDateFromObject(self.params[@"floor"][@"factenddate"] ?: self.params[@"floor"][@"appcompletedate"], @"T");
        date2 = HNDateFromObject(self.params[@"floor"][@"planpaydate"], @"T");
    }
    
    [self.date1Btn setTitle:date1 forState:UIControlStateNormal];
    
    [self.date2Btn setTitle:date2 forState:UIControlStateNormal];
}

- (void)addDateButtons
{
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentBottom2,
                                                                self.contentView.width, 80)];
    [self.fixedControlContainer addSubview:dateView];
    
    self.dateView = dateView;
    
    UILabel *label1 = AWCreateLabel(CGRectMake(0, 0, 88, 34),
                                    @"实际完成日期",
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromRGB(74, 74, 74));
    [self.dateView addSubview:label1];
    
    label1.position = CGPointMake(15, 0);
    
    NSString *date1 = HNStringFromObject(self.serverDates[@"defaultdate"], @"");
    NSString *date2 = HNStringFromObject(self.serverDates[@"defaultpaydate"], @"");
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    if ( date1.length == 0 ) {
        date1 = [df stringFromDate:[NSDate date]];
    }
    
    if (date2.length == 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        date2 = [df stringFromDate:[calendar dateByAddingUnit:NSCalendarUnitMonth
                                                        value:1
                                                       toDate:[NSDate date]
                                                      options:0]];
    }
    
    UIButton *date1Btn = AWCreateTextButton(CGRectMake(0, 0, 118, 40),
                                            date1,
                                            label1.textColor,
                                            self,
                                            @selector(openDatePicker2:));
    [self.dateView addSubview:date1Btn];
    
    self.date1Btn = date1Btn;
    
    date1Btn.titleLabel.font = label1.font;
    
    UIImageView *triangle = AWCreateImageView(@"icon_triangle.png");
    [date1Btn addSubview:triangle];
    triangle.frame = CGRectMake(0, 0, 16, 16);
    triangle.image = [[UIImage imageNamed:@"icon_triangle.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    triangle.tintColor = AWColorFromHex(@"#666666");
    triangle.position = CGPointMake(date1Btn.width - triangle.width - 2,
                                    date1Btn.height / 2 - triangle.height / 2 - 1);
    
    date1Btn.position = CGPointMake(label1.right, label1.midY - date1Btn.height / 2);
    
    date1Btn.tag = 10011;
    
    UILabel *label2 = AWCreateLabel(CGRectMake(0, 0, 88, 34),
                                    @"计划付款日期",
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromRGB(74, 74, 74));
    [self.dateView addSubview:label2];
    
    label2.position = CGPointMake(15, label1.bottom);
    
    UIButton *date2Btn = AWCreateTextButton(CGRectMake(0, 0, 118, 40),
                                            date2,
                                            label1.textColor,
                                            self,
                                            @selector(openDatePicker2:));
    [self.dateView addSubview:date2Btn];
    
    self.date2Btn = date2Btn;
    
    date2Btn.titleLabel.font = label2.font;
    
    date2Btn.tag = 10012;
    
    triangle = AWCreateImageView(@"icon_triangle.png");
    [date2Btn addSubview:triangle];
    triangle.frame = CGRectMake(0, 0, 16, 16);
    triangle.image = [[UIImage imageNamed:@"icon_triangle.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    triangle.tintColor = AWColorFromHex(@"#666666");
    triangle.position = CGPointMake(date2Btn.width - triangle.width - 2,
                                    date2Btn.height / 2 - triangle.height / 2 - 1);
    
    date2Btn.position = CGPointMake(label2.right, label2.midY - date2Btn.height / 2);
    
    self.currentBottom2 = self.dateView.bottom + 20;
}

- (void)openDatePicker2:(UIButton *)sender
{
    DatePicker *picker = [[DatePicker alloc] init];
    picker.frame = self.contentView.bounds;
    [picker showPickerInView:self.contentView];
    
    if ( sender.tag == 10011 ) {
        picker.currentSelectedDate = [self dateFromString:[sender currentTitle]];
        picker.minimumDate  = [self dateFromString:self.serverDates[@"canselstartdate"]];
        picker.maximumDate  = [self dateFromString:self.serverDates[@"canselenddate"]];
    } else if (sender.tag == 10012) {
        picker.currentSelectedDate = [self dateFromString:[sender currentTitle]];
        
        picker.minimumDate  = [self dateFromString:self.serverDates[@"defaultdate"]];
        picker.maximumDate  = nil;
    }
    
    static NSDateFormatter *df;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
    });
    
    __weak typeof(self) me = self;
    picker.didSelectDateBlock = ^(DatePicker *picker, NSDate *selectedDate) {
        //        if ( sender.tag == 10011 ) {
        [sender setTitle:[df stringFromDate:selectedDate] forState:UIControlStateNormal];
        //        } else if (sender.tag == 10012) {
        //
        //        }
        
        if (sender.tag == 10011) {
            NSDate *date = [df dateFromString:[sender currentTitle]];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *date2 = [calendar dateByAddingUnit:NSCalendarUnitMonth
                                 value:1
                                toDate:date
                               options:0];
            [me.date2Btn setTitle:[df stringFromDate:date2] forState:UIControlStateNormal];
        }
    };
}

- (NSDate *)dateFromString:(NSString *)dateStr
{
    static NSDateFormatter *df;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyy-MM-dd";
    });
    
    if ( dateStr.length == 0 ) {
        return [NSDate date];
    }
    
    return [df dateFromString:dateStr];
}

- (void)addConfirmDesc
{
    UILabel *label = AWCreateLabel(CGRectMake(15, self.currentBottom2, 88, 34),
                                    @"进度说明",
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromRGB(74, 74, 74));
    [self.fixedControlContainer addSubview:label];
    
    self.confirmLabel = label;
    
    UITextView *textView = [[UITextView alloc] init];
    [self.fixedControlContainer addSubview:textView];
    
    self.confirmDescText = textView;
    textView.font = AWSystemFontWithSize(14, NO);
    textView.frame = CGRectMake(15, label.bottom + 5,
                                self.contentView.width - 30,
                                80);
    
    self.currentBottom2 = textView.bottom + 10;
    
    textView.placeholder = @"输入进度说明";
    
    textView.layer.borderColor = AWColorFromRGB(216, 216, 216).CGColor;
    textView.layer.borderWidth = 0.6;
}

- (void)addDoneProgress
{
    // 显示输入进度
    UILabel *label = AWCreateLabel(CGRectMake(15, 0,
                                              93,
                                              30),
                                   nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(14, NO),
                                   AWColorFromRGB(74, 74, 74));
    [self.fixedControlContainer addSubview:label];
    
    NSString *string = @"*完成进度";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    [attr addAttributes:@{ NSForegroundColorAttributeName: MAIN_THEME_COLOR } range:NSMakeRange(0, 1)];
    
    label.attributedText = attr;
    
    UIButton *btn = AWCreateTextButton(CGRectMake(0, 0, 88, 40),
                                       @"已完成",
                                       MAIN_THEME_COLOR,
                                       self,
                                       @selector(confirmDone:));
    [self.fixedControlContainer addSubview:btn];
    
    self.confirmDone = btn;
    
    btn.position = CGPointMake(self.contentView.width - btn.width,
                               label.bottom);
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    btn.titleLabel.font = AWSystemFontWithSize(14, NO);
    
    UIImageView *iconView = AWCreateImageView(nil);
    iconView.image = [[UIImage imageNamed:@"icon_checkbox_no.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn addSubview:iconView];
    iconView.tintColor = MAIN_THEME_COLOR;//AWColorFromRGB(74, 74, 74);
    iconView.frame = CGRectMake(5, btn.height / 2 - 8,16, 16);
    iconView.tag = 10201;
    
    UILabel *label1 = AWCreateLabel(CGRectMake(0, 0, 50, 30),
                                    @"100%",
                                    NSTextAlignmentRight,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromRGB(74, 74, 74));
    
    [self.fixedControlContainer addSubview:label1];
    
    label1.position = CGPointMake(btn.left - 5 - label1.width,
                                  btn.midY - label1.height / 2);
    
    UILabel *label2 = AWCreateLabel(CGRectMake(0, 0, 40, 30),
                                    [NSString stringWithFormat:@"%@%%", @(self.beginVal)],
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromRGB(74, 74, 74));
    
    [self.fixedControlContainer addSubview:label2];
    
    self.currentProgressLabel = label2;
    
    label2.position = CGPointMake(15, label1.top);
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0,
                                                                  label1.left - label2.right,
                                                                  20)];
    [self.fixedControlContainer addSubview:slider];
    self.slider = slider;
    
    slider.center = CGPointMake(label2.right + slider.width / 2,label2.midY);
    
    slider.minimumValue = HNIntegerFromObject(self.params[@"floor"][@"minnum"], 0);
    slider.maximumValue = HNIntegerFromObject(self.params[@"floor"][@"maxnum"], 100);
    slider.value = HNIntegerFromObject(self.params[@"floor"][@"nodecurendvalue"], 0);
    slider.minimumTrackTintColor = MAIN_THEME_COLOR;
    
    [self updateConfirmDoneState];
    
    [slider addTarget:self
               action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(touchEnded:)
     forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    self.currentBottom2 = label2.bottom + 30;
}

- (void)confirmDone:(UIButton *)sender
{
    id data = sender.userData;
    if ( data && [data[@"selected"] integerValue] == 1 ) {
        self.slider.value = self.beginVal;
    } else {
        self.slider.value = 100;
    }
    
    self.currentProgressLabel.text = [NSString stringWithFormat:@"%@%%", @((int)self.slider.value)];
    
    [self updateConfirmDoneState];
    
    if ( self.slider.value == 100 ) {
        [self setCanCancel:NO];
    }
}

- (void)updateConfirmDoneState
{
//    id data = self.confirmDone.userData;
    UIImageView *view = (UIImageView *)[self.confirmDone viewWithTag:10201];
    
    if ( self.slider.value == 100.0 ) {
        view.image = [[UIImage imageNamed:@"icon_checkbox_yes.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.confirmDone.userData = @{ @"selected": @"1" };
    } else {
        view.image = [[UIImage imageNamed:@"icon_checkbox_no.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.confirmDone.userData = nil;
    }
    
    [self showOrHideDate:self.slider.value];
}

- (void)valueChanged:(UISlider *)slider
{
    [slider setValue:((int)((slider.value + 2.5) / 5) * 5) animated:NO];
    
    self.currentProgressLabel.text = [NSString stringWithFormat:@"%@%%", @((int)slider.value)];
    
    [self updateConfirmDoneState];
}

- (void)touchEnded:(UISlider *)sender
{
    NSInteger currentVal = self.beginVal; //[self.currentValueLabel.text integerValue];
    if ( sender.value < currentVal ) {
        [self checkIsCancel:sender.value];
    } else {
        [self setCanCancel:NO];
    }
}

- (void)setCanCancel:(BOOL)flag
{
    [self updateUploadLabelText:flag];
    if ( flag ) {
        self.doneBtn.userData = @{ @"type": @"0" };
        self.doneBtn.layer.borderColor = MAIN_THEME_COLOR.CGColor;
        self.doneBtn.layer.borderWidth = 0.6;
        self.doneBtn.backgroundColor = [UIColor whiteColor];
        [self.doneBtn setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
        
        [self.doneBtn setTitle:@"取消确认" forState:UIControlStateNormal];
    } else {
        self.doneBtn.userData = @{ @"type": @"1" };
        self.doneBtn.layer.borderColor = MAIN_THEME_COLOR.CGColor;
        self.doneBtn.layer.borderWidth = 0.6;
        self.doneBtn.backgroundColor = MAIN_THEME_COLOR;
        [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.doneBtn setTitle:@"产值确认" forState:UIControlStateNormal];
    }
}

- (void)checkIsCancel:(NSInteger)value
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id user = [[UserService sharedInstance] currentUser];
    NSString *manID = [user[@"man_id"] description];
    manID = manID ?: @"0";
    
    NSString *nodeId = HNStringFromObject(self.params[@"floor"][@"outnodeid"], @"0");
    NSString *payNodeId = HNStringFromObject(self.params[@"floor"][@"contractpaynodeid"], @"0");
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"产值确认判断是否允许撤销产值APP",
              @"param1": [self.params[@"floor"][@"contractid"] description],
              @"param2": nodeId,
              @"param3": payNodeId,
              @"param4": [self.params[@"floor"][@"roomids"] description],
              @"param5": [@(value) description],
              @"param6": manID,
              } completion:^(id result, NSError *error) {
                  [me handleResult6:result error:error];
              }];
}

- (void)handleResult6:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
        [self.contentView showHUDWithText:@"判断是否允许撤销产值出错，请重试" succeed:NO];
        // 不能取消
        
        //        [self.contentView showHUDWithText:error.localizedDescription succeed:NO];
        
        [self setCanCancel:NO];
        
        self.slider.value = self.beginVal;//[self.currentValueLabel.text integerValue];
        self.currentProgressLabel.text = [NSString stringWithFormat:@"%@%%", @((int)self.slider.value)];
    } else {
        id item = [result[@"data"] firstObject];
        if ( item && [item[@"hinttype"] integerValue] == 1 ) {
            [self setCanCancel:YES];
        } else {
            // 不能取消
            [self setCanCancel:NO];
            
            [self.contentView showHUDWithText:item[@"hint"] offset:CGPointMake(0, 20)];
            
            self.slider.value = self.beginVal;//[self.currentValueLabel.text integerValue];
            self.currentProgressLabel.text = [NSString stringWithFormat:@"%@%%", @((int)self.slider.value)];
        }
    }
}

- (void)addUploadFiles
{
    UILabel *label = AWCreateLabel(CGRectMake(15,
                                              self.currentBottom,
                                              78, 25),
                                   nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(14, NO),
                                   AWColorFromRGB(74, 74, 74));
    [self.scrollView addSubview:label];
    
    self.uploadLabel = label;
    
    [self updateUploadLabelText:NO];
    
//    UploadImageControl *uploadControl = [[UploadImageControl alloc] init];
//    [self.scrollView addSubview:uploadControl];
    
    NSMutableArray *temp = [NSMutableArray array];
    
    if ( [self.annexData[@"rowcount"] integerValue] > 0 && self.annexData[@"data"] ) {
        
        NSArray *array = self.annexData[@"data"];
        for (id obj in array) {
            id ID = obj[@"annexkeyid"] ?: @"0";
            NSString *imageUrl = [[obj[@"annexurl"] componentsSeparatedByString:@"?"] lastObject];
            NSDictionary *params = [imageUrl queryDictionaryUsingEncoding:NSUTF8StringEncoding];
            imageUrl = [params[@"file"] stringByAppendingPathComponent:@"contents"];
            
            id item = @{ @"id": ID, @"imageURL": imageUrl };
            [temp addObject:item];
        }
    }
    
    UploadImageControl *uploadControl = [[UploadImageControl alloc] initWithAttachments:temp];
//    uploadControl.tag = 1002;
    uploadControl.owner = self;
    
    uploadControl.annexTableName = @"H_OPM_OutValue_Month_Fact_Annex";
    uploadControl.annexFieldName = @"MonthFactAnnexID";
    
    [self.scrollView addSubview:uploadControl];
    
//    uploadControl.frame = CGRectMake(label.right, 10,
//                                     self.contentView.width - label.right - 10 - 15,
//                                     60);
    
    [uploadControl updateHeight];
    
    self.uploadControl = uploadControl;
    
    uploadControl.frame = CGRectMake(label.right + 5, self.currentBottom,
                                     self.contentView.width - label.right - 20,
                                     60);
    
    [uploadControl updateHeight];
    
//    uploadControl.owner = self;
    
    __weak typeof(self) me = self;
    uploadControl.didUploadedImagesBlock = ^(UploadImageControl *sender) {
        me.currentBottom = uploadControl.bottom + 30;
        
        me.fixedControlContainer.top = me.currentBottom;
        
        me.confirmHistoryContainer.top = me.fixedControlContainer.bottom + 10;
        
        me.scrollView.contentSize = CGSizeMake(me.contentView.width,
                                               me.confirmHistoryContainer.bottom + 5);
    };
    
    self.currentBottom = uploadControl.bottom + 30;
}

- (void)updateUploadLabelText:(BOOL)isCancel
{
    if ( isCancel ) {
        self.uploadLabel.text = @"上传图片";
    } else {
        NSString *string = @"*上传图片";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttributes:@{ NSForegroundColorAttributeName: MAIN_THEME_COLOR } range:NSMakeRange(0, 1)];
        
        self.uploadLabel.attributedText = attr;
    }
}

- (BOOL)supportsSwipeToBack
{
    return NO;
}

- (void)close
{
    [self.confirmDescText resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
