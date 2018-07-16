//
//  UpdatePasswordVC.m
//  HN_Vendor
//
//  Created by tomwey on 16/07/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "UpdatePasswordVC.h"
#import "Defines.h"

@interface UpdatePasswordVC () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UpdatePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"找回密码";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                  style:UITableViewStylePlain];
    [self.contentView addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 50;
    
    self.tableView.scrollEnabled = NO;

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 80)];
    self.tableView.tableFooterView = header;
    
//    self.contentView.backgroundColor = AWColorFromRGB(247, 247, 247);
    
//    header.backgroundColor = self.contentView.backgroundColor;
    
    AWHairlineView *line = [AWHairlineView horizontalLineWithWidth:header.width - 15 color:IOS_DEFAULT_CELL_SEPARATOR_LINE_COLOR
                                                            inView:header];
    line.position = CGPointMake(15, 0);
    
    UIButton *btn = AWCreateTextButton(CGRectMake(15, 30, self.contentView.width - 30, 44), @"提交",
                                        [UIColor whiteColor], self, @selector(commit));
    [header addSubview:btn];
    btn.backgroundColor = MAIN_THEME_COLOR;
    btn.cornerRadius = 22;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id"];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell.id"];
        
        
        if ( indexPath.row == 0 ) {
            [self addMobileAndCode:cell];
        } else if ( indexPath.row == 1 ) {
            [self addCodeInput:cell];
        } else if ( indexPath.row == 2 ) {
            [self addPasswordInput:cell];
        }
    }
    
    return cell;
}

- (void)addMobileAndCode:(UITableViewCell *)cell
{
    UITextField *mobileField = [[UITextField alloc] init];
    [cell.contentView addSubview:mobileField];
    mobileField.frame = CGRectMake(15, 0, 120, 50);
    
    mobileField.text = self.params[@"mobile"];
    mobileField.enabled = NO;
    
    UIButton *codeBtn = AWCreateTextButton(CGRectMake(0, 0, 120, 40), @"获取验证码",
                                           AWColorFromHex(@"#666666"), self, @selector(getCode:));
    [cell.contentView addSubview:codeBtn];
    codeBtn.position = CGPointMake(self.contentView.width - 15 - codeBtn.width, 5);
}

- (void)getCode:(UIButton *)btn
{
    
}

- (void)commit
{
    
}

- (void)addCodeInput:(UITableViewCell *)cell
{
    UITextField *mobileField = [[UITextField alloc] init];
    [cell.contentView addSubview:mobileField];
    mobileField.frame = CGRectMake(15, 0, 120, 50);
    
    mobileField.placeholder = @"请输入验证码";
}

- (void)addPasswordInput:(UITableViewCell *)cell
{
    UITextField *mobileField = [[UITextField alloc] init];
    [cell.contentView addSubview:mobileField];
    mobileField.frame = CGRectMake(15, 0, 120, 50);
    mobileField.secureTextEntry = YES;
    mobileField.placeholder = @"请输入新密码";
}

@end
