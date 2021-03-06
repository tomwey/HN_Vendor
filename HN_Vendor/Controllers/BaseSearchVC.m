//
//  BaseSearchVC.m
//  HN_ERP
//
//  Created by tomwey on 4/12/17.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "BaseSearchVC.h"
#import "Defines.h"

@interface BaseSearchVC ()

@property (nonatomic, weak) UIButton *doneBtn;
@property (nonatomic, weak) UIButton *resetBtn;

@end

@implementation BaseSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.title = self.params[@"title"] ?: @"搜索";
    
    [self addRightItemWithView:nil];
    
    UIButton *closeBtn = HNCloseButton(34, self, @selector(close));
    [self addLeftItemWithView:closeBtn leftMargin:2];
    
    UIButton *commitBtn = AWCreateTextButton(CGRectMake(0, 0, self.contentView.width / 2,
                                                        50),
                                             @"搜索",
                                             [UIColor whiteColor],
                                             self,
                                             @selector(done));
    [self.contentView addSubview:commitBtn];
    commitBtn.backgroundColor = MAIN_THEME_COLOR;
    commitBtn.position = CGPointMake(0, self.contentView.height - 50);
    
    self.doneBtn = commitBtn;
    
    UIButton *moreBtn = AWCreateTextButton(CGRectMake(0, 0, self.contentView.width / 2,
                                                      50),
                                           @"重置",
                                           IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR,
                                           self,
                                           @selector(reset));
    [self.contentView addSubview:moreBtn];
    moreBtn.backgroundColor = [UIColor whiteColor];
    moreBtn.position = CGPointMake(commitBtn.right, self.contentView.height - 50);
    
    self.resetBtn = moreBtn;
    
    UIView *hairLine = [AWHairlineView horizontalLineWithWidth:moreBtn.width
                                                         color:IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR
                                                        inView:moreBtn];
    hairLine.position = CGPointMake(0,0);
    
    moreBtn.left = 0;
    commitBtn.left = moreBtn.right;
    
    self.tableView.height -= moreBtn.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self prepareFormObjects];
}

- (void)prepareFormObjects
{
    NSDictionary *searchConditions = self.params[@"search_conditions"];
    if ( searchConditions.count > 0 ) {
        for (id key in searchConditions) {
            id value = searchConditions[key];
            self.formObjects[key] = value;
        }
        [self.tableView reloadData];
    }
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.doneBtn.top =
        self.resetBtn.top =
        self.contentView.height - CGRectGetHeight(frame) - self.doneBtn.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.doneBtn.top =
        self.resetBtn.top =
        self.contentView.height - self.doneBtn.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSDictionary *searchCondition = self.params[@"search_conditions"];
    if ( ![searchCondition isEqualToDictionary:self.formObjects] ) {
        NSLog(@"search conditions: %@", self.formObjects);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNeedSearchNotification" object:self.formObjects];
    }
}

- (void)close
{
    [self hideKeyboard];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done
{
    [self hideKeyboard];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reset
{
    //    [self hideKeyboard];
    
    [self resetForm];
}

- (BOOL)supportsTextArea
{
    return NO;
}

@end
