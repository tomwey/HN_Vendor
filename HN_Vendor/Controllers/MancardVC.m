//
//  MancardVC.m
//  HN_ERP
//
//  Created by tomwey on 2/8/17.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "MancardVC.h"
#import "Defines.h"
#import <AddressBook/AddressBook.h>
#import "ContactInsertHistory.h"
#import "ContactInsertHistoryTable.h"
#import "CTPersistance.h"

@interface MancardVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) NSDictionary *manData;

//@property (nonatomic) ABAddressBookRef addressBook;

@property (nonatomic, strong) ContactInsertHistoryTable *contactTable;

@property (nonatomic, assign) BOOL hideTel;

@end

@implementation MancardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"用户信息";
    
    self.dataSource = [@[] mutableCopy];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                  style:UITableViewStyleGrouped];
    [self.contentView addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    
    [self.tableView removeBlankCells];
    
    [self addTableHeader];
    
//    [self addTableFooter];
    
    [self openCardForManID:self.params[@"manid"]];
}

- (void)addTableHeader
{
    SettingTableHeader *settingHeader = [[SettingTableHeader alloc] init];
    UIView *tableHeader = [[UIView alloc] initWithFrame:settingHeader.frame];
    [tableHeader addSubview:settingHeader];
//    self.tableHeader = settingHeader;
    
    self.tableView.tableHeaderView = tableHeader;
    
    settingHeader.currentUser = self.params;
    
//    UIImageView *headerBG = AWCreateImageView(@"setting-header.png");
//    headerBG.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height * 0.3);
//    headerBG.contentMode = UIViewContentModeScaleAspectFill;
//    headerBG.clipsToBounds = YES;
//    headerBG.userInteractionEnabled = YES;
//
//    self.tableView.tableHeaderView = headerBG;
//
//    self.avatarView = AWCreateImageView(@"default_avatar.png");
//    self.avatarView.frame = CGRectMake(0, 0, 60, 60);
//    [headerBG addSubview:self.avatarView];
//    self.avatarView.cornerRadius = self.avatarView.height / 2;
//    self.avatarView.center = CGPointMake(headerBG.width / 2, headerBG.height / 2 - 20);
//
//    self.nameLabel = AWCreateLabel(CGRectMake(0, 0, 80, 34),
//                                   nil, NSTextAlignmentCenter,
//                                   [UIFont systemFontOfSize:15], [UIColor whiteColor]);
//    [headerBG addSubview:self.nameLabel];
//    self.nameLabel.text = self.params[@"supname"];
//
//    self.nameLabel.cornerRadius = 6;
//    self.nameLabel.backgroundColor = AWColorFromRGBA(0, 0, 0, 0.7);
//
//    self.nameLabel.center = CGPointMake(self.avatarView.midX, self.avatarView.bottom + self.nameLabel.height / 2 + 10);
}

- (void)addTableFooter
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 80)];
    self.tableView.tableFooterView = view;
//    view.backgroundColor = AWColorFromRGB(213, 213, 213);
    
    AWButton *button = [[AWButton alloc] initWithTitle:@"同步到手机通讯录" color:MAIN_THEME_COLOR];
    [view addSubview:button];
    button.frame = CGRectMake(0, 0, self.contentView.width * 0.8, 40);
    button.outline = YES;
    
    button.center = CGPointMake(view.width / 2, view.height / 2);
    
    [button addTarget:self forAction:@selector(syncContacts)];
}

- (void)_addContactToAddressBook
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    
    CTPersistanceCriteria *criteria = [[CTPersistanceCriteria alloc] init];
    criteria.whereCondition = @"mobile = :mobile";
    criteria.whereConditionParams = @{ @"mobile": self.manData[@"mobile"],
                                       };
    ContactInsertHistory *history = (ContactInsertHistory *)[self.contactTable findFirstRowWithCriteria:criteria error:nil];
    
    ABRecordRef person;
    if ( !history ) {
        person = ABPersonCreate();
    } else {
        NSNumber *pid = history.personID;
        person = ABAddressBookGetPersonWithRecordID(addressBook, [pid intValue]);
    }

    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)self.manData[@"man_name"], nil);
    
    // 手机
    ABMultiValueRef phoneMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);

    NSString *mobile = [NSString stringWithFormat:@"+86 %@", self.manData[@"mobile"]];
    ABMultiValueAddValueAndLabel(phoneMultiValue, (__bridge CFStringRef)mobile, kABPersonPhoneMobileLabel, nil);
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneMultiValue, nil);
    
    // 邮箱
    NSString *email = self.manData[@"email"];
    ABMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFStringRef)email, (__bridge CFStringRef)@"邮箱", nil);
    
    ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
    
    ABAddressBookAddRecord(addressBook, person, nil);
    
    CFErrorRef error = NULL;
    ABAddressBookSave(addressBook, &error);
    
    NSLog(@"error: %@", (__bridge NSError *)error);
    if ( error ) {
        CFStringRef domain = CFErrorGetDomain(error);
//        [self.contentView makeToast:(__bridge NSString *)domain];
        [self.contentView showHUDWithText:(__bridge NSString *)domain succeed:NO];
    } else {
        if ( !history ) {
            history = [[ContactInsertHistory alloc] init];
            history.mobile = self.manData[@"mobile"];
            history.personID = @(ABRecordGetRecordID(person));
            
            [self.contactTable insertRecord:history error:nil];
        }
//        [self.contentView makeToast:@"同步成功"];
        [self.contentView showHUDWithText:@"已同步到通讯录" succeed:YES];
    }
    
    CFRelease(person);
//    CFRelease(addressBook);
}

- (void)_showDeniedAccessAlert
{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    UIAlertAction *okAction   = [UIAlertAction actionWithTitle:@"设置"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy&path=CONTACTS"]];
                                                       }];
    UIAlertController *alertCtrl =
    [UIAlertController alertControllerWithTitle:@"需要权限"
                                        message:@"“合能地产”需要获得访问通讯录的权限"
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:cancelAction];
    [alertCtrl addAction:okAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)syncContacts
{
    if (!self.manData || self.hideTel) return;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined ) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ( granted ) {
                    [self _addContactToAddressBook];
                } else {
                    [self _showDeniedAccessAlert];
                }
            });
        });
    } else if ( ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized ) {
        [self _addContactToAddressBook];
    } else {
        [self _showDeniedAccessAlert];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *data = self.dataSource[section][@"data"];
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell.id"];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell.id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    id item = self.dataSource[indexPath.section];
    NSArray *data = item[@"data"];
    
    cell.textLabel.text = data[indexPath.row][@"label"];
    cell.detailTextLabel.text = HNStringFromObject(data[indexPath.row][@"value"], @"无");
    
    if ( [cell.textLabel.text hasPrefix:@"手机"] ) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.dataSource[indexPath.row];
    if ([item[@"label"] hasPrefix:@"手机"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    [NSString stringWithFormat:@"tel:%@", item[@"value"]]]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id item = self.dataSource[section];
    return item[@"name"];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (void)openCardForManID:(NSString *)manID
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil params:@{
                       @"dotype": @"GetData",
                       @"funname": @"供应商获取用户信息APP",
                       @"param1": [self.params[@"supid"] ?: @"0" description],
                       @"param2": [self.params[@"loginname"] ?: @"" description],
                       @"param3": [self.params[@"symbolkeyid"] ?: @"0" description],
//                       @"manid": [manID description],
                       } completion:^(id result, NSError *error) {
                           [me handleMancard:result error: error];
                       }];
}

- (void)handleMancard:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
//        [self.contentView makeToast:error.domain];
        [self.contentView showHUDWithText:error.domain succeed:NO];
    } else {
        id dict = [result[@"data"] firstObject];
        
        self.manData = dict;
        
        NSDictionary *dict1 = @{
                                @"name": @"基本信息",
                                @"data": @[
                                        @{
                                            @"label": @"供应商全称：",
                                            @"value": dict[@"supname"] ?: @"",
                                            @"isLink": @(NO),
                                            },
                                        @{
                                            @"label": @"供应商简称：",
                                            @"value": dict[@"supaccountname"] ?: @"",
                                            @"isLink": @(NO),
                                            }
                                        ]
                                };
        
        [self.dataSource addObject:dict1];
        
        NSDictionary *dict2 = @{
                                @"name": @"登录信息 (以下都可用于登录)",
                                @"data": @[
                                        @{
                                            @"label": @"供应商唯一标识：",
                                            @"value": dict[@"supid"] ?: @"",
                                            @"isLink": @(NO),
                                            },
                                        @{
                                            @"label": @"供应商登录名：",
                                            @"value": dict[@"supaccountcode"] ?: @"",
                                            @"isLink": @(NO),
                                            },
                                        @{
                                            @"label": @"供应商手机：",
                                            @"value": dict[@"supaccounttel"] ?: @"",
                                            @"isLink": @(NO),
                                            }
                                        ]
                                };
        
        [self.dataSource addObject:dict2];
        
        /*
        [self.dataSource addObject:@{
                                     @"label": @"供应商唯一标识：",
                                     @"value": dict[@"supid"] ?: @"",
                                     @"isLink": @(NO),
                                     }];
        
        [self.dataSource addObject:@{
                                     @"label": @"名字：",
                                     @"value": dict[@"supname"] ?: @"",
                                     @"isLink": @(NO),
                                     }];
        
        [self.dataSource addObject:@{
                                     @"label": @"账号代码：",
                                     @"value": dict[@"supaccountcode"] ?: @"",
                                     @"isLink": @(NO),
                                     }];
        
        [self.dataSource addObject:@{
                                     @"label": @"登录名：",
                                     @"value": dict[@"supaccountname"] ?: @"",
                                     @"isLink": @(NO),
                                     }];
        
        [self.dataSource addObject:@{
                                     @"label": @"供应商手机：",
                                     @"value": dict[@"supaccounttel"] ?: @"",
                                     @"isLink": @(NO),
                                     }];*/
        

        
        [self.tableView reloadData];
    }
}

- (ContactInsertHistoryTable *)contactTable
{
    if ( !_contactTable ) {
        _contactTable = [[ContactInsertHistoryTable alloc] init];
    }
    return _contactTable;
}

@end
