//
//  DeclareListView.m
//  HN_Vendor
//
//  Created by tomwey on 20/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "CommListView.h"
#import "Defines.h"

@interface CommListView () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@property (nonatomic, strong) NSMutableDictionary *contractDeclares;

@end

@implementation CommListView

- (void)startLoading:(void (^)(BOOL succeed, NSError *error))completion
{
    [HNProgressHUDHelper showHUDAddedTo:AWAppWindow() animated:YES];
    
    [self.tableView removeErrorOrEmptyTips];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
//    NSDictionary *params = self.userData;
    NSString *funname = self.userData[@"funname"];
    id reqParams = @{
                      @"dotype": @"GetData",
                      @"funname": funname,
                      @"param1": [userInfo[@"supid"] ?: @"0" description],
                      @"param2": [userInfo[@"loginname"] ?: @"" description],
                      @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
                      };
    
    id params = self.userData[@"params"];
    
    NSMutableDictionary *dict = [reqParams mutableCopy];
    
    for (NSString *key in params) {
        dict[key] = params[key];
    }
    
    __weak typeof(self) me = self;
    [[self apiServiceWithName:@"APIService"]
     POST:nil params:dict
     completion:^(id result, NSError *error) {
                           [me handleResult: result error:error];
                       }];
}

- (void)handleResult:(id)result error:(NSError *)error
{
    [HNProgressHUDHelper hideHUDForView:AWAppWindow() animated:YES];
    
    if ( error ) {
        [self.tableView showErrorOrEmptyMessage:error.localizedDescription reloadDelegate:nil];
    } else {
        if ( [result[@"rowcount"] integerValue] == 0 ) {
            [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
            
            self.dataSource.dataSource = nil;
        } else {
            [self.tableView removeErrorOrEmptyTips];
            
            NSMutableArray *temp = [NSMutableArray array];
            
            if ( temp.count == 0 ) {
                self.dataSource.dataSource = nil;
                [self.tableView showErrorOrEmptyMessage:@"无数据显示" reloadDelegate:nil];
            } else {
                self.dataSource.dataSource = temp;
            }
            
        }
        
        [self.tableView reloadData];
    }
}

- (NSMutableDictionary *)contractDeclares
{
    if ( !_contractDeclares ) {
        _contractDeclares = [@{} mutableCopy];
    }
    return _contractDeclares;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

- (UITableView *)tableView
{
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
        [self addSubview:_tableView];
        
        [_tableView removeBlankCells];
        
        _tableView.dataSource = self.dataSource;
        
        _tableView.delegate   = self;
        
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    }
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.userData[@"cellHeight"] floatValue];
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, self.userData[@"cell"], @"cell.list.id");
        __weak typeof(self) me = self;
        _dataSource.itemDidSelectBlock = ^(UIView<AWTableDataConfig> *sender, id selectedData) {
//            NSLog(@"%@", selectedData);
            UIViewController *owner = me.userData[@"owner"];
            
            UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:me.userData[@"page"]
                                                                        params:selectedData];
            [owner presentViewController:vc animated:YES completion:nil];
        };
    }
    return _dataSource;
}

@end
