//
//  DeclareListCell.m
//  HN_Vendor
//
//  Created by tomwey on 20/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "DeclareListCell.h"
#import "Defines.h"

@interface DeclareItemView : UIView

- (void)configData:(id)data;

@end

@interface DeclareListCell ()

@property (nonatomic, strong) UIView *viewContainer;

@property (nonatomic, strong) UILabel *titleLabel;

//@property (nonatomic, strong) DeclareItemView *itemView;

@end

@implementation DeclareListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView  = nil;
    }
    return self;
}

- (void)configData:(id)data selectBlock:(void (^)(UIView<AWTableDataConfig> *, id))selectBlock
{
    self.titleLabel.text = data[@"name"];
    
    NSArray *array = data[@"data"];
    
    self.viewContainer.frame = CGRectMake(15, 15, AWFullScreenWidth() - 30, 40 + array.count * 90);
    
    self.titleLabel.frame = CGRectMake(10, 0, self.viewContainer.width - 20, 40);
    
    [self addItems:array];
}

- (void)addItems:(NSArray *)array
{
    for (UIView *view in self.viewContainer.subviews) {
        if ( view != self.titleLabel ) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger i = 0;
    for (id obj in array) {
        
        id data = [obj mutableCopy];
        data[@"order"] = [@(i + 1) description];
        
        DeclareItemView *itemView = [[DeclareItemView alloc] init];
        itemView.frame = CGRectMake(0, 40 + 90 * i,
                                    self.viewContainer.width,
                                    100);
        [self.viewContainer addSubview:itemView];
        
        [itemView configData:data];
        
        AWHairlineView *line = [AWHairlineView horizontalLineWithWidth:self.viewContainer.width - 10
                                                                 color:AWColorFromHex(@"#e6e6e6")
                                                                inView:self.viewContainer];
        line.position = CGPointMake(5, 40 + 90 * i);
        
        i++;
    }
}

- (UIView *)viewContainer
{
    if ( !_viewContainer ) {
        _viewContainer = [[UIView alloc] init];
        
        [self.contentView addSubview:_viewContainer];
        
        _viewContainer.backgroundColor = [UIColor whiteColor];
        
        _viewContainer.cornerRadius = 6;
    }
    return _viewContainer;
}

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentLeft,
                                    AWSystemFontWithSize(14, YES),
                                    AWColorFromRGB(51, 51, 51));
        [self.viewContainer addSubview:_titleLabel];
        
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

@end

///////////////////////////////////////////////////////////////////////////////

@interface DeclareItemView ()

@property (nonatomic, strong) UILabel *orderLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *money1Label; // 申报金额

@property (nonatomic, strong) UILabel *money2Label; // 签证金额

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation DeclareItemView

- (void)configData:(id)data
{
    self.orderLabel.text = data[@"order"];
    
    self.nameLabel.text  = data[@"name"];
    
    if ( data[@"state"] ) {
        self.stateLabel.hidden = NO;
        
        [self updateStateInfo:data[@"state"]];
        
    } else {
        self.stateLabel.hidden = YES;
    }
    
    self.timeLabel.text = data[@"time"];
    
    [self setLabel:self.money1Label forData:data[@"money1"] prefix:@"申报" textColor: MAIN_THEME_COLOR];
    
    [self setLabel:self.money2Label forData:data[@"money1"] prefix:@"签证" textColor: AWColorFromRGB(74,144,226)];
}

- (void)updateStateInfo:(id)state
{
    if ( [state integerValue] == 0 ) {
        self.stateLabel.text = @"已取消";
        self.stateLabel.textColor = AWColorFromRGB(166,166,166);
        self.stateLabel.layer.borderColor = AWColorFromRGB(166,166,166).CGColor;
    } else if ([state integerValue] == 1) {
        self.stateLabel.text = @"申报已审批";
        self.stateLabel.textColor = AWColorFromRGB(74, 144, 226);
        self.stateLabel.layer.borderColor = AWColorFromRGB(74, 144, 226).CGColor;
    } else if ([state integerValue] == 2) {
        self.stateLabel.text = @"签证已审批";
        self.stateLabel.textColor = MAIN_THEME_COLOR;
        self.stateLabel.layer.borderColor = MAIN_THEME_COLOR.CGColor;
    }
}

- (void)setLabel:(UILabel *)label
         forData:(id)moneyVal
          prefix:(NSString *)prefix
       textColor:(UIColor *)color
{
    CGFloat money = [moneyVal floatValue];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f", money / 10000.00];

    NSString *string = [NSString stringWithFormat:@"%@%@万", prefix, moneyStr];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttributes:@{
                              NSFontAttributeName: AWCustomFont(@"PingFang SC", 20),
                              NSForegroundColorAttributeName: color,
                              } range:[string rangeOfString:moneyStr]];
    
    label.attributedText = attrStr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.orderLabel.position = CGPointMake(10, 15);
    
    [self.stateLabel sizeToFit];
    self.stateLabel.width += 6;
    self.stateLabel.height += 4;
    self.stateLabel.position = CGPointMake(self.width - 10 - self.stateLabel.width, self.orderLabel.top);
    
    self.nameLabel.frame = CGRectMake(self.orderLabel.right + 5,
                                      self.orderLabel.top,
                                      self.width - 10 - 98,
                                      50);
    [self.nameLabel sizeToFit];
    
    self.timeLabel.frame = CGRectMake(self.width - 10 - 82, 90 - 10 - 30, 82, 30);
    
    CGFloat width = self.timeLabel.left - self.orderLabel.right - 10;
    
    self.money1Label.frame = self.money2Label.frame = CGRectMake(0, 0, width / 2, 30);
    
    self.money1Label.position = CGPointMake(self.orderLabel.right + 5, self.timeLabel.top);
    self.money2Label.position = CGPointMake(self.money1Label.right + 5, self.money1Label.top);
}

- (UILabel *)orderLabel
{
    if ( !_orderLabel ) {
        _orderLabel = AWCreateLabel(CGRectMake(0, 0, 20, 20),
                                    nil,
                                    NSTextAlignmentCenter,
                                    AWSystemFontWithSize(14, NO),
                                    AWColorFromRGB(176, 176, 176));
        [self addSubview:_orderLabel];
        
        _orderLabel.backgroundColor = AWColorFromRGB(244, 244, 244);
    }
    
    return _orderLabel;
}

- (UILabel *)nameLabel
{
    if ( !_nameLabel ) {
        _nameLabel = AWCreateLabel(CGRectZero,
                                   nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(14, NO),
                                   AWColorFromRGB(51, 51, 51));
        [self addSubview:_nameLabel];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)money1Label
{
    if ( !_money1Label ) {
        _money1Label = AWCreateLabel(CGRectZero,
                                     nil,
                                     NSTextAlignmentLeft,
                                     AWSystemFontWithSize(12, NO),
                                     AWColorFromRGB(193, 193, 193));
        [self addSubview:_money1Label];
        
        _money1Label.adjustsFontSizeToFitWidth = YES;
    }
    return _money1Label;
}

- (UILabel *)money2Label
{
    if ( !_money2Label ) {
        _money2Label = AWCreateLabel(CGRectZero,
                                     nil,
                                     NSTextAlignmentLeft,
                                     AWSystemFontWithSize(12, NO),
                                     AWColorFromRGB(193, 193, 193));
        [self addSubview:_money2Label];
        
        _money2Label.adjustsFontSizeToFitWidth = YES;
    }
    return _money2Label;
}

- (UILabel *)timeLabel
{
    if ( !_timeLabel ) {
        _timeLabel = AWCreateLabel(CGRectZero,
                                   nil,
                                   NSTextAlignmentRight,
                                   AWSystemFontWithSize(14, NO),
                                   AWColorFromRGB(193, 193, 193));
        [self addSubview:_timeLabel];
//        _timeLabel.backgroundColor = [UIColor redColor];
    }
    return _timeLabel;
}

- (UILabel *)stateLabel
{
    if ( !_stateLabel ) {
        _stateLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentCenter,
                                    AWSystemFontWithSize(11, NO),
                                    nil);
        [self addSubview:_stateLabel];
        
        _stateLabel.cornerRadius = 2;
        
        _stateLabel.layer.borderWidth = 0.6;
        
    }
    return _stateLabel;
}

@end
