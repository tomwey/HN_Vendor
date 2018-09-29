//
//  OutputApplyDetailVC.m
//  HN_Vendor
//
//  Created by tomwey on 28/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "OutputApplyDetailVC.h"
#import "Defines.h"
#import "ApplyDetailCell.h"

@interface OutputApplyDetailVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *rooms;
@property (nonatomic, strong) NSMutableDictionary *roomNodes;

//@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@end

@implementation OutputApplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = self.params[@"contractname"];
    
    [self loadData];
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    self.rooms = [@[] mutableCopy];
    self.roomNodes = [@{} mutableCopy];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    __weak typeof(self) me = self;
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商合同产值申报明细APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": userInfo[@"loginname"] ?: @"",
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": [self.params[@"contractid"] ?: @"0" description],
              @"param5": @"0",
              @"param6": @"2018-09-28",
              } completion:^(id result, NSError *error) {
                  [me handleResult: result error: error];
              }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:self.contentView animated:YES];
    
    if ( error ) {
        [self.tableView showErrorOrEmptyMessage:error.localizedDescription reloadDelegate:nil];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
        } else {
            NSArray *data = result[@"data"];
                
            for (id item in data) {
                NSString *roomName = [item[@"roomname"] description];
                NSMutableArray *arr = self.roomNodes[roomName];
                if ( !arr ) {
                    arr = [@[] mutableCopy];
                    self.roomNodes[roomName] = arr;
                    [arr addObject:item];
                    
                    [self.rooms addObject:roomName];
                } else {
                    [arr addObject:item];
                }
            }
        }
        
        [self.tableView reloadData];
    }
    //    applyoutamount = "387291.00";
    //    confirmoutamount = "0.00";
    //    "submit_date" = "2018-09-28T16:14:10+08:00";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rooms count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.rooms[section];
    return [self.roomNodes[key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyDetailCell *cell = (ApplyDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"cell.id"];
    if ( !cell ) {
        cell = [[ApplyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"cell.id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ( indexPath.section < self.rooms.count ) {
        NSString *key = self.rooms[indexPath.section];
        NSArray *arr = self.roomNodes[key];
        //        NSLog(@"arr: %@", arr);
        if ( indexPath.row < arr.count ) {
            id item = arr[indexPath.row];
            
            [cell configData:item];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.rooms[indexPath.section];
    id item = self.roomNodes[key][indexPath.row];
    id params = [item mutableCopy];
    params[@"contractid"] = self.params[@"contractid"] ?: @"0";
    
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"OutputConfirmCommitVC"
                                                                params:@{ @"floor": params ?: [NSNull null] }];
    
    // 此处会导致卡顿Bug，所以加一个主线程异步执行
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self presentViewController:vc
    //                           animated:YES
    //                         completion:nil];
    //    });
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.rooms[section];
}

- (UITableView *)tableView
{
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                  style:UITableViewStylePlain];
        [self.contentView addSubview:_tableView];
        
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        
        _tableView.rowHeight = 95;
        
        [_tableView removeBlankCells];
    }
    return _tableView;
}

@end
