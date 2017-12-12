//
//  ContractCell.m
//  HN_ERP
//
//  Created by tomwey on 24/10/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "ContractCell.h"
#import "Defines.h"

@interface CustomProgressView : UIView

@property (nonatomic, assign) float progress;

@property (nonatomic, strong) UIColor *progressColor;

@end

@interface ContractCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *contractNoLabel;
@property (nonatomic, strong) UILabel *contractNameLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *realLabel;
@property (nonatomic, strong) CustomProgressView *progressView;
@property (nonatomic, strong) UILabel *progressDescLabel;

@property (nonatomic, copy) void (^didSelectItemBlock)(UIView<AWTableDataConfig> *sender, id data);

@end

@implementation ContractCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configData:(id)data selectBlock:(void (^)(UIView<AWTableDataConfig> *sender, id selectedData))selectBlock
{
    self.didSelectItemBlock = selectBlock;
    
    self.userData = data;
    
    self.contractNoLabel.text = [NSString stringWithFormat:@"   %@", [data[@"contractphyno"] description]];
    self.contractNameLabel.text = [data[@"contractname"] description];
    self.companyLabel.text = [data[@"supname"] description];
    
    NSString *str = [NSString stringWithFormat:@"总金额：%@", HNFormatMoney(data[@"contractmoney"], @"万")];
    
    NSRange range = [str rangeOfString:@"："];
    range.location += 1;
    range.length = str.length - range.location;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttributes:@{ NSForegroundColorAttributeName: MAIN_THEME_COLOR,
                             NSFontAttributeName: AWCustomFont(@"PingFang SC", 16)}
                    range:range];
    self.totalLabel.attributedText = string;
    
    str = [NSString stringWithFormat:@"累计产值：%@", HNFormatMoney(data[@"contractfactoutvalue"], @"万")];
    
    range = [str rangeOfString:@"："];
    range.location += 1;
    range.length = str.length - range.location;
    
    string = [[NSMutableAttributedString alloc] initWithString:str];
    [string addAttributes:@{ NSForegroundColorAttributeName: MAIN_THEME_COLOR,
                             NSFontAttributeName: AWCustomFont(@"PingFang SC", 16)}
                    range:range];
    self.realLabel.attributedText = string;
    
    self.progressView.progress = [data[@"outvaluerate"] floatValue] / 100.0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:[NSDate date]];
    
    self.progressDescLabel.text = [NSString stringWithFormat:@"截止%d月，完成%.1f%%", month, [data[@"outvaluerate"] floatValue]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.containerView.frame = CGRectMake(15,
                                          0,
                                          self.width - 30,
                                          205);
    
    self.contractNoLabel.frame = CGRectMake(0, 0, self.containerView.width,
                                            30);
    
    self.contractNameLabel.frame = CGRectMake(10,
                                              self.contractNoLabel.bottom + 5,
                                              self.containerView.width - 20,
                                              50);
    
    self.companyLabel.frame = CGRectMake(self.contractNameLabel.left,
                                         self.contractNameLabel.bottom + 5,
                                         self.contractNameLabel.width,
                                         30);
    
    self.totalLabel.frame = self.realLabel.frame =
    self.companyLabel.frame;
    
    self.totalLabel.width = self.realLabel.width = self.companyLabel.width / 2;
    
    self.totalLabel.top = self.companyLabel.bottom;
    self.realLabel.top = self.totalLabel.top;
    
    self.realLabel.left = self.totalLabel.right;
    
    self.progressView.frame = self.companyLabel.frame;
    self.progressView.top = self.realLabel.bottom + 5;
    self.progressView.height = 15;
    
    self.progressDescLabel.frame = self.progressView.frame;
    self.progressDescLabel.top = self.progressView.bottom + 5;
}

- (UIView *)containerView
{
    if ( !_containerView ) {
        _containerView = [[UIView alloc] init];
        [self.contentView addSubview:_containerView];
        
        _containerView.layer.borderColor = AWColorFromRGB(198, 219, 174).CGColor;
        _containerView.layer.borderWidth = 0.6;
        
        [_containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tap)]];
    }
    return _containerView;
}

- (void)tap
{
    if ( self.didSelectItemBlock ) {
        self.didSelectItemBlock(self, self.userData);
    }
}

- (UILabel *)contractNoLabel
{
    if ( !_contractNoLabel ) {
        _contractNoLabel = AWCreateLabel(CGRectZero,
                                         nil,
                                         NSTextAlignmentLeft,
                                         AWSystemFontWithSize(13, NO),
                                         [UIColor whiteColor]);
        [self.containerView addSubview:_contractNoLabel];
        
        _contractNoLabel.backgroundColor = AWColorFromRGB(198, 219, 174);
    }
    return _contractNoLabel;
}

- (UILabel *)contractNameLabel
{
    if ( !_contractNameLabel ) {
        _contractNameLabel = AWCreateLabel(CGRectZero,
                                         nil,
                                         NSTextAlignmentLeft,
                                         AWSystemFontWithSize(16, YES),
                                         AWColorFromRGB(74, 74, 74));
        [self.containerView addSubview:_contractNameLabel];
        _contractNameLabel.numberOfLines = 2;
        _contractNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _contractNameLabel;
}

- (UILabel *)companyLabel
{
    if ( !_companyLabel ) {
        _companyLabel = AWCreateLabel(CGRectZero,
                                         nil,
                                         NSTextAlignmentLeft,
                                         AWSystemFontWithSize(14, NO),
                                         self.contractNameLabel.textColor);
        [self.containerView addSubview:_companyLabel];
    }
    return _companyLabel;
}

- (UILabel *)totalLabel
{
    if ( !_totalLabel ) {
        _totalLabel = AWCreateLabel(CGRectZero,
                                      nil,
                                      NSTextAlignmentLeft,
                                      AWSystemFontWithSize(14, NO),
                                      self.contractNameLabel.textColor);
        [self.containerView addSubview:_totalLabel];
        _totalLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _totalLabel;
}

- (UILabel *)realLabel
{
    if ( !_realLabel ) {
        _realLabel = AWCreateLabel(CGRectZero,
                                    nil,
                                    NSTextAlignmentRight,
                                    AWSystemFontWithSize(14, NO),
                                    self.contractNameLabel.textColor);
        [self.containerView addSubview:_realLabel];
        _realLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _realLabel;
}

- (CustomProgressView *)progressView
{
    if ( !_progressView ) {
        _progressView = [[CustomProgressView alloc] init];
        [self.containerView addSubview:_progressView];
        
        _progressView.progressColor = AWColorFromRGB(235,197, 176);
        _progressView.backgroundColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (UILabel *)progressDescLabel
{
    if ( !_progressDescLabel ) {
        _progressDescLabel = AWCreateLabel(CGRectZero,
                                   nil,
                                   NSTextAlignmentLeft,
                                   AWSystemFontWithSize(14, NO),
                                   AWColorFromRGB(216, 216, 216));
        [self.containerView addSubview:_progressDescLabel];
    }
    return _progressDescLabel;
}

@end

@interface CustomProgressView ()

@property (nonatomic, strong) UIView *progressView;

@end

@implementation CustomProgressView

- (void)setProgress:(float)progress
{
    if ( _progress != progress ) {
        _progress = progress;
        
        if (_progress > 1.0) {
            _progress = 1.0;
        }
        [self setNeedsLayout];
    }
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    
    self.progressView.backgroundColor = progressColor;
    
    self.layer.borderColor = progressColor.CGColor;
    self.layer.borderWidth = 0.6;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width * self.progress;
    
    self.progressView.frame = self.bounds;
    self.progressView.width = width;
}

- (UIView *)progressView
{
    if ( !_progressView ) {
        _progressView = [[UIView alloc] init];
        [self addSubview:_progressView];
    }
    return _progressView;
}

@end
