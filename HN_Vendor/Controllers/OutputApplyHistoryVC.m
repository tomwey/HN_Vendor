//
//  OutputApplyHistoryVC.m
//  HN_Vendor
//
//  Created by tomwey on 26/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "OutputApplyHistoryVC.h"
#import "Defines.h"

@interface OutputApplyHistoryVC () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AWTableViewDataSource *dataSource;

@property (nonatomic, strong) UIButton *yearBtn;

@property (nonatomic, strong) UILabel *applyTotalLabel;
@property (nonatomic, strong) UILabel *confirmTotalLabel;

@property (nonatomic, assign) NSInteger nowYear;

@property (nonatomic, strong) UIView *tableHeader;

@end

@implementation OutputApplyHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    self.navBar.title = self.params[@"contractname"];
    
    [self initTableHeader];
    
    [self loadData];
}

- (void)initTableHeader
{
    self.tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 120)];
    self.tableHeader.backgroundColor = MAIN_THEME_COLOR;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 120)];
    [header addSubview:self.tableHeader];
    
    self.tableView.tableHeaderView = header;
    
    self.yearBtn = AWCreateTextButton(CGRectMake(0, 0, 102, 40),
                                      [NSString stringWithFormat:@"%d年", self.nowYear],
                                      [UIColor whiteColor],
                                      self, @selector(openPicker));
    [self.tableHeader addSubview:self.yearBtn];
    
    self.yearBtn.userData = @{ @"name": [NSString stringWithFormat:@"%@年", @(self.nowYear)],
                               @"value": [@(self.nowYear) description] };
    
    self.yearBtn.center = CGPointMake(header.width / 2, 5 + self.yearBtn.height / 2);
    
    UIImageView *triangle = AWCreateImageView(@"icon_triangle.png");
    [self.yearBtn addSubview:triangle];
    triangle.image = [[UIImage imageNamed:@"icon_triangle.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    triangle.tintColor = [UIColor whiteColor];
    triangle.position = CGPointMake(self.yearBtn.width - triangle.width - 2,
                                    self.yearBtn.height / 2 - triangle.height / 2 - 2);
    
    UILabel *applyTotalLabel = AWCreateLabel(CGRectZero,
                                             nil,
                                             NSTextAlignmentCenter,
                                             AWSystemFontWithSize(12, NO),
                                             [UIColor whiteColor]);
    [self.tableHeader addSubview:applyTotalLabel];
    
    self.applyTotalLabel = applyTotalLabel;
    
    applyTotalLabel.frame = CGRectMake(15, self.yearBtn.bottom + 5,
                                       (self.contentView.width - 30 - 20) / 2,
                                       60);
    applyTotalLabel.numberOfLines = 2;
    applyTotalLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *confirmTotalLabel = AWCreateLabel(CGRectZero,
                                             nil,
                                             NSTextAlignmentCenter,
                                             AWSystemFontWithSize(12, NO),
                                             [UIColor whiteColor]);
    [self.tableHeader addSubview:confirmTotalLabel];
    
    self.confirmTotalLabel = confirmTotalLabel;
    
    confirmTotalLabel.frame = CGRectMake(applyTotalLabel.right + 20,
                                         self.yearBtn.bottom + 5,
                                       (self.contentView.width - 30 - 20) / 2,
                                       60);
    
    confirmTotalLabel.numberOfLines = 2;
    confirmTotalLabel.adjustsFontSizeToFitWidth = YES;
    
    [self setLabelValue:@"--"
               forLabel:self.applyTotalLabel
                   unit:@""
                   name: @"申报总金额(元)"];
    
    [self setLabelValue:@"--"
               forLabel:self.confirmTotalLabel
                   unit:@""
                   name: @"确认总金额(元)"];
}

- (void)setLabelValue:(id)value
             forLabel:(UILabel *)label
                 unit:(NSString *)unit
                 name:(NSString *)name
{
    NSString *val = [value description];
    NSString *str = [NSString stringWithFormat:@"%@\n%@%@",
                     val, unit ?: @"", name];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttributes:@{
                           NSFontAttributeName: AWSystemFontWithSize(18, NO)
                           }
                  range:[str rangeOfString:val]];
    
    label.attributedText = attr;
}

- (void)openPicker
{
    SelectPicker *picker = [[SelectPicker alloc] init];
    picker.frame = self.contentView.bounds;
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (int i=self.nowYear; i>= 1990; i--) {
        id pair = @{ @"name": [NSString stringWithFormat:@"%d年", i],
                     @"value": [NSString stringWithFormat:@"%@", @(i)]
                     };
        [temp addObject:pair];
    }
    
    picker.options = [temp copy];
    picker.currentSelectedOption = self.yearBtn.userData;
    [picker showPickerInView:self.contentView];
    
    __weak typeof(self) me = self;
    picker.didSelectOptionBlock = ^(SelectPicker *sender, id selectedOption, NSInteger index) {
        NSString *name = selectedOption[@"name"];
        if ( [name isEqualToString:[me.yearBtn currentTitle]] == NO ) {
            [me.yearBtn setTitle:name forState:UIControlStateNormal];
            
            me.yearBtn.userData = selectedOption;
            
            [me loadData];
        }
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.dataSource.dataSource[indexPath.row];
    id params = [item mutableCopy];
    params[@"contractid"] = self.params[@"contractid"] ?: @"0";
    params[@"contractname"] = self.params[@"contractname"] ?: @"";
    UIViewController *vc = [[AWMediator sharedInstance] openVCWithName:@"OutputApplyDetailVC" params:params];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadData
{
    [HNProgressHUDHelper showHUDAddedTo:self.contentView animated:YES];
    
    id userInfo = [[UserService sharedInstance] currentUser];
    
    __weak typeof(self) me = self;
    
    [[self apiServiceWithName:@"APIService"]
     POST:nil
     params:@{
              @"dotype": @"GetData",
              @"funname": @"供应商查询合同申报历史APP",
              @"param1": [userInfo[@"supid"] ?: @"0" description],
              @"param2": userInfo[@"loginname"] ?: @"",
              @"param3": [userInfo[@"symbolkeyid"] ?: @"0" description],
              @"param4": @"1",
              @"param5": [self.params[@"contractid"] ?: @"0" description],
              @"param6": [self.yearBtn.userData[@"value"] description],
              @"param7": @"0",
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
            self.dataSource.dataSource = nil;
            
            [self setLabelValue:@"--"
                       forLabel:self.applyTotalLabel
                           unit:@""
                           name:@"申报总金额(元)"];
            [self setLabelValue:@"--"
                       forLabel:self.confirmTotalLabel
                           unit:@""
                           name:@"确认总金额(元)"];
        } else {
            self.dataSource.dataSource = result[@"data"];
            [self.tableView removeErrorOrEmptyTips];
            
            [self updateTotalStats];
        }
        
        [self.tableView reloadData];
    }
//    applyoutamount = "387291.00";
//    confirmoutamount = "0.00";
//    "submit_date" = "2018-09-28T16:14:10+08:00";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = - scrollView.contentOffset.y;
    if ( y > 0 ) {
        //        CGFloat width = self.originalHeaderSize.width + y * 5 / 3;
        CGFloat height = 120;// + y;
        self.tableHeader.frame =
        CGRectMake(0, scrollView.contentOffset.y, self.tableHeader.width, height);
        //        self.capView.center =
        //        CGPointMake(self.contentView.center.x,
        //                    self.capView.center.y );
    }
}

- (void)updateTotalStats
{
    float apply = 0.0;
    float confirm = 0.0;
    for (id item in self.dataSource.dataSource) {
        apply += [item[@"applyoutamount"] floatValue];
        confirm += [item[@"confirmoutamount"] floatValue];
    }
    
    [self setLabelValue:HNFormatMoney2(@(apply), @"元")
               forLabel:self.applyTotalLabel
                   unit:@""
                   name:@"申报总金额(元)"];
    [self setLabelValue:HNFormatMoney2(@(confirm), @"元")
               forLabel:self.confirmTotalLabel
                   unit:@""
                   name:@"确认总金额(元)"];
}

- (UITableView *)tableView
{
    if ( !_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                                  style:UITableViewStylePlain];
        [self.contentView addSubview:_tableView];
        
        _tableView.dataSource = self.dataSource;
        _tableView.delegate   = self;
        
        _tableView.rowHeight = 60;
        
        [_tableView removeBlankCells];
    }
    return _tableView;
}

- (AWTableViewDataSource *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = AWTableViewDataSourceCreate(nil, @"ApplyHisCell", @"cell.id");
    }
    
    return _dataSource;
}

@end
