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

@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, weak) UIButton *codeBtn;

@property (nonatomic, weak) UITextField *codeField;
@property (nonatomic, weak) UITextField *passwordField;
@property (nonatomic, weak) UITextField *passwordField2;

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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id"];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell.id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ( indexPath.row == 0 ) {
            [self addMobileAndCode:cell];
        } else if ( indexPath.row == 1 ) {
            [self addCodeInput:cell];
        } else if ( indexPath.row == 2 ) {
            [self addPasswordInput:cell];
        } else if ( indexPath.row == 3 ) {
            [self addPasswordInput2:cell];
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
    mobileField.font = AWSystemFontWithSize(15, NO);
    mobileField.textColor = AWColorFromHex(@"#999999");
    
    UIButton *codeBtn = AWCreateTextButton(CGRectMake(0, 0, 120, 40), @"获取验证码",
                                           MAIN_THEME_COLOR, self, @selector(getCode:));
    [cell.contentView addSubview:codeBtn];
    
    self.codeBtn = codeBtn;
    
    self.codeBtn.userData = @"59";
    
    codeBtn.titleLabel.font = AWSystemFontWithSize(15, NO);
    codeBtn.position = CGPointMake(self.contentView.width - 10 - codeBtn.width, 5);
}

- (void)getCode:(UIButton *)btn
{
    [self setCodeButtonEnabled:NO];
    
    [self.codeField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    __weak typeof(self) me = self;
    [self requestWithURI:@"sms/send"
                  params:@{ @"Mobile": self.params[@"mobile"] ?: @"",
                            @"Type": @(1)
                            }
              completion:^(BOOL succeed, NSError *error2) {
                  if ( succeed ) {
                      [me startTimer];
                  } else {
                      [me setCodeButtonEnabled:YES];
                  }
              }];
}

- (void)setCodeButtonEnabled:(BOOL)flag
{
    self.codeBtn.userInteractionEnabled = flag;
    
    if ( flag ) {
        [self.codeBtn setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
    } else {
        [self.codeBtn setTitleColor:AWColorFromHex(@"#999999") forState:UIControlStateNormal];
    }
}

- (void)startTimer
{
    [self.countDownTimer setFireDate:[NSDate date]];
}

- (void)requestWithURI:(NSString *)uri
                params:(NSDictionary *)params
            completion:(void (^)(BOOL succeed, NSError *error2))completion
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    NSString *host = @"http://10.19.0.216:8080/api";
    
    NSString *Nonce = [NSString stringWithFormat:@"%ld", (NSInteger)[[NSDate date] timeIntervalSince1970]];
    NSString *Signature = [[NSString stringWithFormat:@"%@HN.Mobile.sms.2018-0", Nonce] md5Hash];
    
    NSMutableDictionary *newParams = [params mutableCopy];
    newParams[@"Nonce"] = Nonce;
    newParams[@"Signature"] = Signature;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:
                             [NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __weak typeof(self) me = self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", host, uri]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:newParams
                                                       options:0
                                                         error:nil];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [me handleResult:data error:error completion:completion];
                                                });
                                            }];
    
    [task resume];
}

- (void)handleResult:(NSData *)data
               error:(NSError *)error
          completion:(void (^)(BOOL succeed, NSError *error2))completion
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
        [self.contentView showHUDWithText:@"服务器出错了~" succeed:NO];
        if ( completion ) {
            completion(NO, error);
        }
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:nil];
        if ( !object ) {
            [self.contentView showHUDWithText:@"解析结果出错" succeed:NO];
            
            if ( completion ) {
                completion(NO, [NSError errorWithDomain:@"解析结果出错"
                                                   code:-9
                                               userInfo:nil]);
            }
        } else {
            NSInteger code = [object[@"code"] integerValue];
            if ( code == 0 ) {
                [self.contentView showHUDWithText:object[@"msg"] succeed:YES];
                if ( completion ) {
                    completion(YES, nil);
                }
            } else {
                [self.contentView showHUDWithText:object[@"msg"] succeed:NO];
                if ( completion ) {
                    completion(NO, [NSError errorWithDomain:object[@"msg"]
                                                       code:code
                                                   userInfo:nil]);
                }
            }
            
            
        }
    }
}

- (void)commit
{
    [self.codeField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    if ( [[self.codeField.text trim] length] == 0 ) {
        [self.contentView showHUDWithText:@"验证码不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    if ( [self.passwordField.text length] == 0 ) {
        [self.contentView showHUDWithText:@"新密码不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    if ( [self.passwordField2.text length] == 0 ) {
        [self.contentView showHUDWithText:@"确认密码不能为空" offset:CGPointMake(0,20)];
        return;
    }
    
    if ( [self.passwordField.text isEqualToString:self.passwordField2.text] == NO ) {
        [self.contentView showHUDWithText:@"两次密码输入不一致" offset:CGPointMake(0,20)];
        return;
    }
    
    __weak typeof(self) me = self;
    [self requestWithURI:@"sms/code_verify"
                  params:@{ @"Mobile": self.params[@"mobile"] ?: @"",
                            @"Type": @(1),
                            @"Code": [self.codeField.text trim] ?: @""
                            }
              completion:^(BOOL succeed, NSError *error2) {
                  if ( succeed ) {
                      [me updatePassword];
                  }
              }];
}

- (void)updatePassword
{
    
}

- (NSTimer *)countDownTimer
{
    if ( !_countDownTimer ) {
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(countDown)
                                                         userInfo:nil
                                                          repeats:YES];
        [_countDownTimer setFireDate:[NSDate distantFuture]];
    }
    return _countDownTimer;
}

- (void)countDown
{
    NSInteger counter = [self.codeBtn.userData integerValue];
    
    if ( counter == 0 ) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        
        self.codeBtn.userData = @"59";
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self setCodeButtonEnabled:YES];
        
    } else {
        [self.codeBtn setTitleColor:AWColorFromHex(@"#999999") forState:UIControlStateNormal];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新发送(%d)", counter]
                      forState:UIControlStateNormal];
        
        self.codeBtn.userData = [@(counter - 1) description];
    }
}

- (void)addCodeInput:(UITableViewCell *)cell
{
    UITextField *mobileField = [[UITextField alloc] init];
    [cell.contentView addSubview:mobileField];
    mobileField.frame = CGRectMake(15, 0, 120, 50);
    self.codeField = mobileField;
    mobileField.placeholder = @"请输入验证码";
}

- (void)addPasswordInput:(UITableViewCell *)cell
{
    UITextField *mobileField = [[UITextField alloc] init];
    [cell.contentView addSubview:mobileField];
    self.passwordField = mobileField;
    mobileField.frame = CGRectMake(15, 0, 260, 50);
    mobileField.secureTextEntry = YES;
    mobileField.placeholder = @"请输入新密码";
}

- (void)addPasswordInput2:(UITableViewCell *)cell
{
    UITextField *mobileField = [[UITextField alloc] init];
    [cell.contentView addSubview:mobileField];
    self.passwordField2 = mobileField;
    mobileField.frame = CGRectMake(15, 0, 260, 50);
    mobileField.secureTextEntry = YES;
    mobileField.placeholder = @"请输入确认密码";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
}

@end
