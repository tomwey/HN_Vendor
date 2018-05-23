//
//  ZFBoxVC.m
//  HN_Vendor
//
//  Created by tomwey on 23/05/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "ZFBoxVC.h"
#import "Defines.h"

@interface ZFBoxVC ()

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation ZFBoxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"作废";
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self addLeftItemWithView:HNCloseButton(34, self, @selector(close))];
    
    self.textView = [[UITextView alloc] init];
    [self.contentView addSubview:self.textView];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.frame = CGRectMake(15, 15, self.contentView.width - 30, 120);
    self.textView.placeholder = @"输入作废原因";
    self.textView.font = AWSystemFontWithSize(15, NO);
    
    self.commitBtn = AWCreateTextButton(CGRectMake(15, self.textView.bottom + 15, self.contentView.width - 30, 50), @"提交", [UIColor whiteColor], self, @selector(commit));
    [self.contentView addSubview:self.commitBtn];
    self.commitBtn.backgroundColor = MAIN_THEME_COLOR;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)commit
{
    [self.textView resignFirstResponder];
    
    if ( [self.params[@"zf_type"] integerValue] == 1 ) {
        [self sendDeclareZF];
    } else if ( [self.params[@"zf_type"] integerValue] == 2 ) {
        [self sendSignZF];
    }
}

- (void)sendDeclareZF
{
    if ( [[self.textView.text trim] length] == 0 ) {
        [self.contentView showHUDWithText:@"作废原因不能为空" offset:CGPointMake(0,20)];
        return;
    }
    // 发请求
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    NSString *changeID = [self.params[@"supchangeid"] ?: @"0" description];
    
//    [self hideKeyboard];
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商变更指令操作APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": @"4",
              @"param5": changeID,
              @"param6": @"",
              @"param7": @"",
              @"param8": @"",
              @"param9": @"",
              @"param10": @"",
              @"param11": @"",
              @"param12": @"",
              @"param13": @"",
              @"param14": self.textView.text
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
        if ( [self.params[@"zf_type"] integerValue] == 1 ) {
            if ( [result[@"rowcount"] integerValue] == 0 ) {
                
            } else {
                id item = [result[@"data"] firstObject];
                if ( [item[@"hinttype"] integerValue] == 1 ||
                    (item[@"code"] && [item[@"code"] integerValue] == 0) ||
                    ([[[item allValues] firstObject] integerValue] == 1) ) {
                    NSString *msg = item[@"hint"] ?: @"操作成功";
                    [AWAppWindow() showHUDWithText:msg succeed:YES];
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadDeclareDataNotification" object:nil];
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"kNeedDismissNotification" object:nil];
                    }];
                } else {
                    [self.contentView showHUDWithText:item[@"hint"] succeed:NO];
                }
            }
            // 变更处理
        } else {
            if ( [result[@"rowcount"] integerValue] == 0 ) {
                
            } else {
                id item = [result[@"data"] firstObject];
                if ( [item[@"hinttype"] integerValue] == 1 ||
                    (item[@"code"] && [item[@"code"] integerValue] == 0) ||
                    ([[[item allValues] firstObject] integerValue] == 1) ) {
                    NSString *msg = item[@"hint"] ?: @"操作成功";
                    [AWAppWindow() showHUDWithText:msg succeed:YES];
                    
//                    if ( self.params[@"_flag"] ) {
//                        //                    [self.presentingViewController dismissViewControllerAnimated:YES
//                        //                                                                  completion:^{
//                        //                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadDeclareDataNotification" object:nil];
//                        //                                                                  }];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNeedDismissNotification"
//                                                                            object:nil];
//                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadDeclareDataNotification" object:nil];
                            [[NSNotificationCenter defaultCenter]
                             postNotificationName:@"kNeedDismissNotification" object:nil];
                        }];
//                    }
                    
                } else {
                    [self.contentView showHUDWithText:item[@"hint"] succeed:NO];
                }
            }
            // 签证处理
        }
        
    }
}

- (void)sendSignZF
{
    if ( [[self.textView.text trim] length] == 0 ) {
        [self.contentView showHUDWithText:@"作废原因不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    // 发请求
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    NSString *visaID = [self.params[@"supvisaid"] ?: @"0" description];
    
//    [self hideKeyboard];
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商发起变更签证APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": [userInfo[@"loginname"] ?: @"" description],
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": @"4",
              @"param5": visaID,
              @"param6": @"",
              @"param7": @"",
              @"param8": @"",
              @"param9": @"1",
              @"param10": @"",
              @"param11": @"",
              @"param12": @"",
              @"param13": @"",
              @"param14": @"",
              @"param15": @"1",
              @"param16": self.textView.text
              } completion:^(id result, NSError *error) {
                  [me handleResult:result error:error];
              }];
}

- (void)close
{
    [self.textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
