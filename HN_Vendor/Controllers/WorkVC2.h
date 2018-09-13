//
//  WorkVC.h
//  HN_ERP
//
//  Created by tomwey on 1/18/17.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "BaseNavBarVC.h"

@interface WorkVC2 : BaseVC

@end

@interface MyCollectionCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *iconView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong) id item;

@end
