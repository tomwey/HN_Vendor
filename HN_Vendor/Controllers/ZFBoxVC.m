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
}

- (void)close
{
    [self.textView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
