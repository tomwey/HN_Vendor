//
//  AccountFinalCell.m
//  HN_Vendor
//
//  Created by tomwey on 21/09/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "AccountFinalCell.h"
#import "Defines.h"

@interface AccountFinalCell ()

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation AccountFinalCell

- (void)configData:(id)data selectBlock:(void (^)(UIView<AWTableDataConfig> *, id))selectBlock
{
    //    addsignmoney = "4454804.97";
    //    addsignnum = 2;
    //    applycontent = "\U6d4b\U8bd5";
    //    applydate = "2018-09-20";
    //    applymoney = "4321.00";
    //    changemoney = "206281.49";
    //    changenum = 29;
    //    contractid = 2194740;
    //    contractmoney = "75926964.9700";
    //    contractname = "\U6885\U6eaa\U6e56\U4e8c\U671f\U603b\U53056#\U30017#\U680b\U603b\U5305\U65bd\U5de5";
    //    contractphyno = "HG-B-CQ-MXH-E311-2016-B-5-1";
    //    "project_id" = 1291439;
    //    "project_name" = "\U6885\U6eaa\U6e56\U4e8c\U671f";
    //    regsignmoney = NULL;
    //    returnmemo = NULL;
    //    signmoney = "71472160.00";
    //    "state_desc" = "\U5f85\U7533\U62a5";
    //    supsettleid = 1;
    //    syssettlemoney = "76133246.46";
    //    totalnodeamount = "52177422.45";
    //    totaloutamount = "74539175.05";
    
    NSString *money = [HNFormatMoney(data[@"applymoney"], @"万") stringByReplacingOccurrencesOfString:@"万" withString:@""];
    
    [self setLabel1:money
               name:@"申报金额"
               unit:@"万"
           forLabel:self.moneyLabel
              color:MAIN_THEME_COLOR];
    
    [self setLabel1:HNDateFromObject(data[@"applydate"], @"T")
               name:@"申报日期"
               unit: nil
           forLabel:self.timeLabel
              color:AWColorFromRGB(74, 144, 226)];
    
    self.stateLabel.text = data[@"state_desc"];
    
    if ( [data[@"state_desc"] isEqualToString:@"已申报"] ) {
        self.stateLabel.backgroundColor = AWColorFromRGB(116,182,102);
    } else if ( [data[@"state_desc"] isEqualToString:@"待申报"] ) {
        self.stateLabel.backgroundColor = AWColorFromRGB(100,100,100);
    } else if ( [data[@"state_desc"] isEqualToString:@"已作废"] ) {
        self.stateLabel.backgroundColor = AWColorFromRGB(166, 166, 166);
    } else if ( [data[@"state_desc"] isEqualToString:@"已取消"] ) {
        self.stateLabel.backgroundColor = AWColorFromRGB(201, 92, 84);
    } else {
        self.stateLabel.backgroundColor = AWColorFromRGB(100,100,100);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width - 30 - 10;
    self.moneyLabel.frame = CGRectMake(15, 0, width * 0.4, self.height);
    self.timeLabel.frame  = CGRectMake(self.moneyLabel.right + 5, 0, width * 0.4, self.height);
    
    self.stateLabel.frame = CGRectMake(0, 0, 50, 28);
    self.stateLabel.center = CGPointMake(self.width - 15 - self.stateLabel.width / 2, self.height / 2);
}

- (void)setLabel1:(id)value
             name:(NSString *)name
             unit:(NSString *)unit
         forLabel:(UILabel *)label
            color:(UIColor *)color
{
    NSString *string = [NSString stringWithFormat:@"%@%@\n%@", value, unit ?: @"", name];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttributes:@{
                                NSFontAttributeName: AWCustomFont(@"PingFang SC", 18),
                                NSForegroundColorAttributeName: color
                                } range:[string rangeOfString:value]];
    
    label.attributedText = attrString;
}

- (UILabel *)moneyLabel
{
    if ( !_moneyLabel ) {
        _moneyLabel = AWCreateLabel(CGRectZero,
                                    nil, NSTextAlignmentLeft, AWSystemFontWithSize(12, NO), AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_moneyLabel];
        _moneyLabel.numberOfLines = 2;
        _moneyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel
{
    if ( !_timeLabel ) {
        _timeLabel = AWCreateLabel(CGRectZero,
                                   nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(12, NO),
                                   AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_timeLabel];
        _timeLabel.numberOfLines = 2;
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

- (UILabel *)stateLabel
{
    if ( !_stateLabel ) {
        _stateLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentCenter,
                                    AWSystemFontWithSize(12, NO),
                                    AWColorFromHex(@"#999999"));
        [self.contentView addSubview:_stateLabel];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.cornerRadius = 2;
        _stateLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _stateLabel;
}

@end
