//
//  OutputCommitVC.m
//  HN_ERP
//
//  Created by tomwey on 29/01/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "OutputCommitVC.h"
#import "Defines.h"

@interface OutputCommitVC ()

@property (nonatomic, weak) UITextView *textView;

@end

@implementation OutputCommitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"申报流程";
    
    __weak typeof(self) me = self;
    [self addRightItemWithTitle:@"提交"
                titleAttributes:@{
                                  NSFontAttributeName: AWSystemFontWithSize(15, NO)
                                  }
                           size:CGSizeMake(60, 40)
                    rightMargin:5
                       callback:^{
                           [me commit];
                       }];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 15, self.contentView.width - 30,
                                                                    120)];
    [self.contentView addSubview:textView];
    self.textView = textView;
    textView.font = AWSystemFontWithSize(15, NO);
    textView.placeholder = @"输入意见";
    
    textView.layer.borderColor = AWColorFromRGB(216, 216, 216).CGColor;
    textView.layer.borderWidth = 0.6;
}

- (void)commit
{
    if ( [[self.textView.text trim] length] == 0 ) {
        [self.contentView showHUDWithText:@"意见不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    [self.textView resignFirstResponder];
    
//    id user = [[UserService sharedInstance] currentUser];
//    NSString *manID = [user[@"man_id"] ?: @"0" description];
    id userInfo = [[UserService sharedInstance] currentUser];
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商发起产值申报流程APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": userInfo[@"loginname"] ?: @"",
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": [self.params[@"contractid"] ?: @"0" description],
              @"param5": @"0",
              @"param6": @"1",
              @"param7": [self.textView.text trim] ?: @"",
              } completion:^(id result, NSError *error) {
                  [me handleResult:result error: error];
              }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
        [self.contentView showHUDWithText:@"服务器出错了！" succeed:NO];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            [self.contentView showHUDWithText:@"未知原因提交失败" succeed:NO];
        } else {
            id item = [result[@"data"] firstObject];
            
            if ( [item[@"hinttype"] integerValue] == 1 ) {
                [AWAppWindow() showHUDWithText:item[@"hint"] succeed:YES];
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"kOutputDeclareDidCommitNotification"
                 object:nil];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.contentView showHUDWithText:item[@"hint"] succeed:NO];
            }
        }
    }
}

@end
