//
//  ApplyHisCell.m
//  HN_Vendor
//
//  Created by tomwey on 28/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "ApplyHisCell.h"
#import "Defines.h"

@interface ApplyHisCell()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *applyLabel;
@property (nonatomic, strong) UILabel *confirmLabel;

@end

@implementation ApplyHisCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configData:(id)data selectBlock:(void (^)(UIView<AWTableDataConfig> *sender, id selectedData))selectBlock
{
    AWLabelFormatShow(self.dateLabel, @"申报日期",
                      HNDateFromObject(data[@"submit_date"], @"T"),
                      @"",
                      AWCustomFont(@"PingFang SC", 16),
                     AWColorFromRGB(110, 110, 110),
                      NO);
    
    AWLabelFormatShow(self.applyLabel, @"申报金额",
                      HNFormatMoney2(data[@"applyoutamount"], @"元"),
                      @"元",
                      AWCustomFont(@"PingFang SC", 16),
                      MAIN_THEME_COLOR,
                      NO);
    
    AWLabelFormatShow(self.confirmLabel, @"确认金额",
                      HNFormatMoney2(data[@"confirmoutamount"], @"元"),
                      @"元",
                      AWCustomFont(@"PingFang SC", 16),
                      AWColorFromRGB(74, 144, 226),
                      NO);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = (self.width - 30 - 10) / 3.0;
    
    self.dateLabel.frame = CGRectMake(15,
                                      self.height / 2 - 20,
                                      width,
                                      40);
    
    self.applyLabel.frame = CGRectMake(self.dateLabel.right + 5,
                                          self.dateLabel.top,
                                          width, 40);
    
    self.confirmLabel.frame = CGRectMake(self.applyLabel.right + 5,
                                          self.dateLabel.top,
                                          width, 40);
}

- (UILabel *)dateLabel
{
    if ( !_dateLabel ) {
        _dateLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentLeft,
                                        AWSystemFontWithSize(12, NO),
                                        AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_dateLabel];
        _dateLabel.numberOfLines = 2;
        _dateLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _dateLabel;
}

- (UILabel *)applyLabel
{
    if ( !_applyLabel ) {
        _applyLabel = AWCreateLabel(CGRectZero,
                                       nil,
                                       NSTextAlignmentCenter,
                                       AWSystemFontWithSize(12, NO),
                                       AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_applyLabel];
        _applyLabel.numberOfLines = 2;
        _applyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _applyLabel;
}

- (UILabel *)confirmLabel
{
    if ( !_confirmLabel ) {
        _confirmLabel = AWCreateLabel(CGRectZero,
                                       nil,
                                       NSTextAlignmentRight,
                                       AWSystemFontWithSize(12, NO),
                                       AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_confirmLabel];
        _confirmLabel.numberOfLines = 2;
        _confirmLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _confirmLabel;
}

@end
