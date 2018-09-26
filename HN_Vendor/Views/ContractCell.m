//
//  ContractCell.m
//  HN_Vendor
//
//  Created by tomwey on 20/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "ContractCell.h"
#import "Defines.h"

@interface ContractCell ()

@property (nonatomic, strong) UILabel *noLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *outputmoneyLabel;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *projNameNoLabel;

@property (nonatomic, strong) UIButton *historyBtn;

@end

@implementation ContractCell

- (void)configData:(id)data selectBlock:(void (^)(UIView<AWTableDataConfig> *, id))selectBlock
{
    self.noLabel.text = data[@"contractphyno"];
    
    self.nameLabel.text = data[@"contractname"];
    
    // 设置金额
//    NSString *money = HNFormatMoney2(data[@"contractmoney"], nil);
//    NSString *string = [@"签约金额: " stringByAppendingString:money];
    
    [self setLabel1:data[@"contractmoney"]
               name:@"总金额"
           forLabel:self.moneyLabel color:MAIN_THEME_COLOR];
    
    [self setLabel1:data[@"contractoutamount"]
               name:@"已完成产值"
           forLabel:self.outputmoneyLabel color:AWColorFromRGB(74, 144, 226)];
    
    float total = [data[@"contractmoney"] floatValue];
    
    float val1 = [data[@"contractoutamount"] floatValue];
    
    float val = val1 / total * 100.0;
    NSString *ss = nil;
    if ( val < 100 ) {
        ss = [NSString stringWithFormat:@"%.1f", val];
    } else {
        ss = @"100";
    }
    
    NSString *string = [NSString stringWithFormat:@"%@%%\n已完成产值占比", ss];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttributes:@{
                                NSFontAttributeName: AWCustomFont(@"PingFang SC", 18),
                                NSForegroundColorAttributeName: AWColorFromRGB(120, 120, 120)
                                } range:[string rangeOfString:ss]];
    
    self.percentLabel.attributedText = attrString;
    
    // 设置状态
    NSString *stateName = nil;
    UIColor *color = nil;
    
    if ( [data[@"appstatus"] integerValue] == 40 ) {
        stateName = @"执行中";
        color = MAIN_THEME_COLOR;
    } else if ([data[@"appstatus"] integerValue] == 50) {
        stateName = @"已结算";
        color = AWColorFromRGB(116, 182, 102);
    } else if ([data[@"appstatus"] integerValue] == 70) {
        stateName = @"已解除";
        color = AWColorFromRGB(201, 92, 84);
    }
    self.stateLabel.text = data[@"appstatusdesc"];
    self.stateLabel.textColor = color;
    self.stateLabel.layer.borderColor = color.CGColor;
    
    self.timeLabel.text = HNDateFromObject(data[@"signdate"], @"T");
    self.projNameNoLabel.text = data[@"project_name"];
    
    if ( [data[@"d_type"] isEqualToString:@"2"] ) {
        self.historyBtn.hidden = NO;
    } else {
        self.historyBtn.hidden = YES;
    }
    
    self.historyBtn.userData = data;
}

- (void)setLabel1:(id)value name:(NSString *)name forLabel:(UILabel *)label color:(UIColor *)color
{
    NSString *money = [HNFormatMoney(value, @"万") stringByReplacingOccurrencesOfString:@"万" withString:@""];
    NSString *string = [NSString stringWithFormat:@"%@万\n%@", money, name];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttributes:@{
                                NSFontAttributeName: AWCustomFont(@"PingFang SC", 18),
                                NSForegroundColorAttributeName: color
                                } range:[string rangeOfString:money]];
    
    label.attributedText = attrString;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.noLabel.frame = CGRectMake(15, 10, self.width - 30 - self.historyBtn.width, 30);
    
    self.historyBtn.position = CGPointMake(self.width - 10 - self.historyBtn.width,
                                           self.noLabel.midY - self.historyBtn.height / 2);
    
    self.nameLabel.frame = CGRectMake(15, self.noLabel.bottom, self.noLabel.width,
                                      50);
    [self.nameLabel sizeToFit];
    
    self.projNameNoLabel.frame = self.noLabel.frame;
    
    self.projNameNoLabel.top = self.height - 10 - self.projNameNoLabel.height;
    
    self.timeLabel.frame = self.projNameNoLabel.frame;
    
//    self.moneyLabel.frame = self.noLabel.frame;
//    self.moneyLabel.top = self.timeLabel.top - self.moneyLabel.height;
    
    CGFloat width = (self.width - 30 - 10) / 3.0;
    
    self.moneyLabel.frame =
    self.outputmoneyLabel.frame  =
    self.percentLabel.frame    = CGRectMake(0, 0, width, 44);
    
    self.moneyLabel.position = CGPointMake(self.noLabel.left, self.timeLabel.top - 44 - 5);
    self.outputmoneyLabel.position  = CGPointMake(self.moneyLabel.right + 5, self.moneyLabel.top);
    self.percentLabel.position    = CGPointMake(self.outputmoneyLabel.right + 5, self.moneyLabel.top);
    
    [self.stateLabel sizeToFit];
    self.stateLabel.width += 6;
    self.stateLabel.height += 6;
    self.stateLabel.position = CGPointMake(self.width - 15 - self.stateLabel.width,
                                           self.timeLabel.midY - self.stateLabel.height / 2);
    
    self.timeLabel.width = 80;
    self.timeLabel.left = self.stateLabel.left - 10 - 80;
}

- (void)viewHistory:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kViewApplyHistoryNotification"
                                                        object:sender.userData];
}

- (UIButton *)historyBtn
{
    if ( !_historyBtn ) {
        _historyBtn = AWCreateTextButton(CGRectMake(0, 0, 80, 40),
                                         @"申报历史 »",
                                         AWColorFromHex(@"#999999"),
                                         self, @selector(viewHistory:));
        [self.contentView addSubview:_historyBtn];
        _historyBtn.titleLabel.font = AWSystemFontWithSize(14, NO);
    }
    return _historyBtn;
}

- (UILabel *)noLabel
{
    if ( !_noLabel ) {
        _noLabel = AWCreateLabel(CGRectZero,
                                 nil,
                                 NSTextAlignmentLeft,
                                 AWSystemFontWithSize(12, NO),
                                 AWColorFromRGB(186, 186, 186));
        [self.contentView addSubview:_noLabel];
        
        _noLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _noLabel;
}

- (UILabel *)nameLabel
{
    if ( !_nameLabel ) {
        _nameLabel = AWCreateLabel(CGRectZero,
                                 nil,
                                 NSTextAlignmentLeft,
                                 AWSystemFontWithSize(15, NO),
                                 AWColorFromRGB(51, 51, 51));
        [self.contentView addSubview:_nameLabel];
        
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)moneyLabel
{
    if ( !_moneyLabel ) {
        _moneyLabel = AWCreateLabel(CGRectZero,
                                   nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(10, NO),
                                   self.noLabel.textColor);
        _moneyLabel.numberOfLines = 2;
        _moneyLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UILabel *)outputmoneyLabel
{
    if ( !_outputmoneyLabel ) {
        _outputmoneyLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentCenter,
                                    AWSystemFontWithSize(10, NO),
                                    self.noLabel.textColor);
        _outputmoneyLabel.numberOfLines = 2;
        _outputmoneyLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.contentView addSubview:_outputmoneyLabel];
    }
    return _outputmoneyLabel;
}

- (UILabel *)percentLabel
{
    if ( !_percentLabel ) {
        _percentLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentRight,
                                    AWSystemFontWithSize(10, NO),
                                    self.noLabel.textColor);
        _percentLabel.numberOfLines = 2;
        _percentLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.contentView addSubview:_percentLabel];
    }
    return _percentLabel;
}

- (UILabel *)stateLabel
{
    if ( !_stateLabel ) {
        _stateLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentCenter,
                                    AWSystemFontWithSize(11, NO),
                                    nil);
        [self.contentView addSubview:_stateLabel];
        
        _stateLabel.cornerRadius = 2;
        _stateLabel.layer.borderWidth = 0.6;
    }
    return _stateLabel;
}

- (UILabel *)projNameNoLabel
{
    if ( !_projNameNoLabel ) {
        _projNameNoLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, NO),
                                    self.noLabel.textColor);
        [self.contentView addSubview:_projNameNoLabel];
    }
    return _projNameNoLabel;
}

- (UILabel *)timeLabel
{
    if ( !_timeLabel ) {
        _timeLabel = AWCreateLabel(CGRectZero,
                                         nil,
                                         NSTextAlignmentRight,
                                         AWSystemFontWithSize(14, NO),
                                         self.noLabel.textColor);
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
