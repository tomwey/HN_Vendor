//
//  DeclareListVC.m
//  HN_Vendor
//
//  Created by tomwey on 13/12/2017.
//  Copyright © 2017 tomwey. All rights reserved.
//

#import "DeclareListVC.h"
#import "Defines.h"

@interface DeclareListVC () <AWPagerTabStripDataSource>

@property (nonatomic, strong) UIView *subHeader;
@property (nonatomic, strong) AWPagerTabStrip *tabStrip;

@property (nonatomic, strong) NSArray *tabTitles;

@end

@implementation DeclareListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBar.title = @"变更申报";
    
    self.navBar.rightMarginOfRightItem = 5;
    self.navBar.marginOfFluidItem = 0;
    
    UIButton *searchBtn = HNSearchButton(22, self, @selector(search:));
    [self.navBar addFluidBarItem:searchBtn atPosition:FluidBarItemPositionTitleRight];
    
    UIButton *addBtn = HNAddButton(22, self, @selector(add:));
    [self.navBar addFluidBarItem:addBtn atPosition:FluidBarItemPositionTitleRight];
    
    [self addSegmentControls];
}

- (void)addSegmentControls
{
    self.tabTitles = @[@{
                           @"name": @"已申报",
                           @"type": @"0",
                           @"page": @"",
                           },
                       @{
                           @"name": @"待申报",
                           @"type": @"1",
                           @"page": @"",
                           },
                       ];
    
    self.tabStrip = [[AWPagerTabStrip alloc] init];
    [self.contentView addSubview:self.tabStrip];
    self.tabStrip.backgroundColor = [UIColor whiteColor];//MAIN_THEME_COLOR;
    
    self.tabStrip.tabWidth = self.contentView.width / 2;
    
    self.tabStrip.titleAttributes = @{ NSForegroundColorAttributeName: AWColorFromRGB(168, 168, 168),
                                       NSFontAttributeName: AWSystemFontWithSize(14, NO) };;
    self.tabStrip.selectedTitleAttributes = @{ NSForegroundColorAttributeName: MAIN_THEME_COLOR,
                                               NSFontAttributeName: AWSystemFontWithSize(14, NO) };
    
    //    self.tabStrip.delegate   = self;
    self.tabStrip.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    self.tabStrip.didSelectBlock = ^(AWPagerTabStrip* stripper, NSUInteger index) {
        //        weakSelf.swipeView.currentPage = index;
//        __strong CityMapBIVC *strongSelf = weakSelf;
//        if ( strongSelf ) {
//            // 如果duration设置为大于0.0的值，动画滚动，tab stripper动画会有bug
//            [strongSelf.swipeView scrollToPage:index duration:0.0f]; // 0.35f
//            [strongSelf swipeViewDidEndDecelerating:strongSelf.swipeView];
//        }
    };
}

- (NSInteger)numberOfTabs:(AWPagerTabStrip *)tabStrip
{
    return self.tabTitles.count;
}

- (NSString *)pagerTabStrip:(AWPagerTabStrip *)tabStrip titleForIndex:(NSInteger)index
{
    return self.tabTitles[index][@"name"];
}

- (void)search:(id)sender
{
    
}

- (void)add:(id)sender
{
    
}

@end
