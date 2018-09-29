//
//  OutputDeclareCell.m
//  HN_ERP
//
//  Created by tomwey on 25/01/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "ApplyDetailCell.h"
#import "Defines.h"

@interface ApplyDetailCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *moneyTypeLabel;

@property (nonatomic, strong) UILabel *outMoneyLabel;
@property (nonatomic, strong) UILabel *payMoneyLabel;

//@property (nonatomic, strong) UIImageView *confirmView;

@end

@implementation ApplyDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configData:(id)data
{
//    appcomplete = 1;
//    appcompletedate = "2018-09-28";
//    completeprocess = NULL;
//    contractpaynodeid = 5589033;
//    "flow_mid" = 534306;
//    nodeamount = "271104.04";
//    nodename = "\U5168\U90e8\U65bd\U5de5\U5b8c\U6210\Uff08\U7ed3\U6784\U4e8c\U6b21\U6539\U9020\U5de5\U7a0b\Uff09";
//    outamount = "387291.00";
//    roomids = 2279;
//    roomname = "4#";
//    "submit_date" = "2018-09-28T16:14:10+08:00";
//    supapplyid = 1;
//    surecomplete = 0;
//    surecompletedate = NULL;
    
    self.nameLabel.text = data[@"nodename"];
    
    AWLabelFormatShow(self.moneyTypeLabel, @"申报产值",
                      HNFormatMoney2(data[@"outamount"], @"万"),
                      @"万",
                      AWCustomFont(@"PingFang SC", 16),
                      MAIN_THEME_COLOR,
                      NO);
    
    AWLabelFormatShow(self.outMoneyLabel, @"完成进度",
                      @(HNIntegerFromObject(data[@"completeprocess"], 0)),
                      @"%",
                      AWCustomFont(@"PingFang SC", 16),
                      AWColorFromRGB(74, 144, 226),
                      NO);
    
    AWLabelFormatShow(self.payMoneyLabel, @"完成时间",
                      HNDateFromObject(data[@"appcompletedate"], @"T"),
                      @"",
                      AWCustomFont(@"PingFang SC", 16),
                      AWColorFromRGB(110, 110, 110),
                      NO);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake(15, 5, self.width - 30, 40);
    
    CGFloat width = (self.nameLabel.width - 10) / 3.0;
    
    self.moneyTypeLabel.frame = CGRectMake(self.nameLabel.left,
                                           self.nameLabel.bottom,
                                           width,
                                           40);
    
    self.outMoneyLabel.frame = CGRectMake(self.moneyTypeLabel.right + 5,
                                          self.moneyTypeLabel.top,
                                          width, 40);
    
    self.payMoneyLabel.frame = CGRectMake(self.outMoneyLabel.right + 5,
                                          self.moneyTypeLabel.top,
                                          width, 40);
    
//    self.confirmView.position = CGPointMake(self.width - self.confirmView.width, 0);
}

//- (UIImageView *)confirmView
//{
//    if (!_confirmView) {
//        _confirmView = AWCreateImageView(nil);
//        [self.contentView addSubview:_confirmView];
//
//        _confirmView.frame = CGRectMake(0, 0, 32, 33);
//    }
//    return _confirmView;
//}

- (UILabel *)nameLabel
{
    if ( !_nameLabel ) {
        _nameLabel = AWCreateLabel(CGRectZero,
                                   nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(14, NO),
                                   AWColorFromRGB(74, 74, 74));
        [self.contentView addSubview:_nameLabel];
        _nameLabel.numberOfLines = 2;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
}

- (UILabel *)moneyTypeLabel
{
    if ( !_moneyTypeLabel ) {
        _moneyTypeLabel = AWCreateLabel(CGRectZero,
                                   nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(12, NO),
                                   AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_moneyTypeLabel];
        _moneyTypeLabel.numberOfLines = 2;
        _moneyTypeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _moneyTypeLabel;
}

- (UILabel *)outMoneyLabel
{
    if ( !_outMoneyLabel ) {
        _outMoneyLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentCenter,
                                        AWSystemFontWithSize(12, NO),
                                        AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_outMoneyLabel];
        _outMoneyLabel.numberOfLines = 2;
        _outMoneyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _outMoneyLabel;
}

- (UILabel *)payMoneyLabel
{
    if ( !_payMoneyLabel ) {
        _payMoneyLabel = AWCreateLabel(CGRectZero,
                                        nil,
                                        NSTextAlignmentRight,
                                        AWSystemFontWithSize(12, NO),
                                        AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_payMoneyLabel];
        _payMoneyLabel.numberOfLines = 2;
        _payMoneyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _payMoneyLabel;
}

@end
