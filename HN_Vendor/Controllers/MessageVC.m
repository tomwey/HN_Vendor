//
//  MessageVC.m
//  HN_ERP
//
//  Created by tomwey on 1/18/17.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "MessageVC.h"
#import "Defines.h"

@interface MessageVC () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@end

@implementation MessageVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息"
                                                        image:[UIImage imageNamed:@"tab_message.png"]
                                                selectedImage:[UIImage imageNamed:@"tab_message_click.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"消息";
    
    [self addLeftItemWithView:nil];
    
    NSArray *data = @[@{ @"icon": @"msg_icon_todo.png",
                           @"name": @"1、2、9楼B户型增加1个厨房插座",
                           @"proj_name": @"枫丹三",
                           @"time": @"2017-01-01",
                           @"state": @"0",
                           },
                        @{ @"icon": @"msg_icon_ann.png",
                           @"name": @"增加样板间找平施工",
                           @"proj_name": @"枫丹三",
                           @"time": @"2017-01-01",
                           @"state": @"1",
                           },
                        @{ @"icon": @"msg_icon_document.png",
                           @"name": @"【进度款】5#楼3-8层",
                           @"proj_name": @"枫丹三",
                           @"time": @"2017-01-01",
                           @"state": @"2",
                           },
                      @{ @"icon": @"msg_icon_document.png",
                         @"name": @"【进度款】6#楼5-10层",
                         @"proj_name": @"枫丹三",
                         @"time": @"2017-01-01",
                         @"state": @"3",
                         },
                        ];
    
    self.dataSource = AWTableViewDataSourceCreate(data, @"MessageCell", @"msg.cell");
    
    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                  style:UITableViewStylePlain];
    [self.contentView addSubview:self.tableView];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate   = self;
    
    self.tableView.rowHeight = 80;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
//    self.tableView.backgroundColor = [UIColor redColor];
    
    [self.tableView removeBlankCells];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
