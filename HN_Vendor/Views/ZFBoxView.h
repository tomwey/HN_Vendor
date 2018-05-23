//
//  ZFBoxView.h
//  HN_Vendor
//
//  Created by tomwey on 23/05/2018.
//  Copyright © 2018 tomwey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFBoxView : UIView

- (void)showReason:(NSString *)reason
            inView:(UIView *)superView
       commitBlock:(void (^)(ZFBoxView *sender))block;

@end
