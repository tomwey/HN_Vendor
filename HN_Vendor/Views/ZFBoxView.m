//
//  ZFBoxView.m
//  HN_Vendor
//
//  Created by tomwey on 23/05/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import "ZFBoxView.h"
#import "Defines.h"

@interface ZFBoxView()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;

//@property (nonatomic, strong) UIButton *viewReasonBtn;
//@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) UIButton *closeBtn;

//@property (nonatomic, copy) NSString *reason;

@end

@implementation ZFBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
//        self.frame = AWFullScreenBounds();
        
    }
    return self;
}

- (void)showReason:(NSString *)reason
            inView:(UIView *)superView
       commitBlock:(void (^)(ZFBoxView *sender))block
{
//    self.reason = reason;
    
    if ( !self.superview ) {
        [superView addSubview:self];
    }
    
    self.frame = superView.bounds;
    
    [superView bringSubviewToFront:self];
    
    [self sendSubviewToBack:self.maskView];
    
    [self bringSubviewToFront:self.contentView];
    
    self.textView.text = reason;
    self.textView.editable = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.maskView.frame = self.bounds;
    
    self.contentView.frame = CGRectMake(0, 0, self.width - 60, self.width - 60);
    self.contentView.center = CGPointMake(self.width / 2.0, self.height / 2.0);
    
    self.titleLabel.frame = CGRectMake(0, 0, self.contentView.width, 50);
    
//    self.commitBtn.position = CGPointMake(self.contentView.width - self.commitBtn.width - 15,
//                                          self.contentView.height - self.commitBtn.height - 10);
//    self.viewReasonBtn.position = CGPointMake(self.commitBtn.left - 15 - self.viewReasonBtn.width,
//                                              self.commitBtn.top);
//
    self.textView.frame = CGRectMake(15, self.titleLabel.bottom + 5, self.contentView.width - 30,
                                     self.contentView.height - self.titleLabel.bottom - 10);
    
    self.closeBtn.position = CGPointMake(self.contentView.width - 5 - self.closeBtn.width,
                                         self.titleLabel.midY - self.closeBtn.height / 2);
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        [self addSubview:_maskView];
        _maskView.backgroundColor = AWColorFromRGBA(0, 0, 0, 0.8);
        
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)]];
    }
    return _maskView;
}

- (UIView *)contentView
{
    if ( !_contentView ) {
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if ( !_titleLabel ) {
        _titleLabel = AWCreateLabel(CGRectZero,
                                    @"驳回原因",
                                    NSTextAlignmentCenter,
                                    AWSystemFontWithSize(15, NO),
                                    [UIColor whiteColor]);
        [self.contentView addSubview:_titleLabel];
        _titleLabel.backgroundColor = MAIN_THEME_COLOR;
    }
    return _titleLabel;
}

- (UITextView *)textView
{
    if ( !_textView ) {
        _textView = [[UITextView alloc] init];
        [self.contentView addSubview:_textView];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = AWSystemFontWithSize(14, NO);
//        _textView.textColor = AWColorFromHex(@"#666666");
    }
    return _textView;
}

/*
- (UIButton *)viewReasonBtn
{
    if ( !_viewReasonBtn ) {
        _viewReasonBtn = AWCreateTextButton(CGRectMake(0, 0, 90, 40),
                                            @"驳回原因",
                                            MAIN_THEME_COLOR, self, @selector(viewReason));
        [self.contentView addSubview:_viewReasonBtn];
        _viewReasonBtn.backgroundColor = [UIColor whiteColor];
        
        _viewReasonBtn.titleLabel.font = AWSystemFontWithSize(14, NO);
        
        _viewReasonBtn.layer.borderColor = MAIN_THEME_COLOR.CGColor;
        _viewReasonBtn.layer.borderWidth = 0.8;
    }
    return _viewReasonBtn;
}

- (UIButton *)commitBtn
{
    if ( !_commitBtn ) {
        _commitBtn = AWCreateTextButton(CGRectMake(0, 0, 90, 40),
                                        @"立即作废",
                                        [UIColor whiteColor], self, @selector(commit));
        [self.contentView addSubview:_commitBtn];
        
        _commitBtn.backgroundColor = MAIN_THEME_COLOR;
        
        _commitBtn.titleLabel.font = AWSystemFontWithSize(14, NO);
    }
    return _commitBtn;
}
*/

- (UIButton *)closeBtn
{
    if ( !_closeBtn ) {
        _closeBtn = HNCloseButton(34, self, @selector(close));
        [self.contentView addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (void)close
{
    [self removeFromSuperview];
}

/*
- (void)viewReason
{
    [self.textView resignFirstResponder];
    
    self.textView.text = self.reason;
    self.textView.placeholder = nil;
    
    self.textView.editable = NO;
    
    [self.commitBtn setTitle:@"立即作废" forState:UIControlStateNormal];
}

- (void)commit
{
    if ( self.textView.editable ) {
        // 提交
    } else {
        self.textView.text = nil;
        self.textView.placeholder = @"输入作废原因，点击提交";
        self.textView.editable = YES;
        
        [self.commitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    }
}*/

@end
