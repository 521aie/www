//
//  TotalEvaluateHeader.m
//  RestApp
//
//  Created by Shaojianqing on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "ItemFactory.h"
#import "TotalEvaluateItem.h"
#import "TotalEvaluateView.h"
#import "TotalEvaluateHeader.h"
#import "TotalEvaluateData.h"

@implementation TotalEvaluateHeader

+ (TotalEvaluateHeader *)createTotalEvaluateHeader:(TotalEvaluateView *)evaluateView
{
    TotalEvaluateHeader *evaluateHeader = [[[NSBundle mainBundle]loadNibNamed:@"TotalEvaluateHeader" owner:self options:nil]lastObject];
    [evaluateHeader initHeader:evaluateView];
    return evaluateHeader;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.listContainer];
    [self addSubview:self.operContainer];
}

- (UIView *)listContainer {
    if(!_listContainer) {
        _listContainer = [[UIView alloc] init];
        _listContainer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 196);
        _listContainer.layer.masksToBounds = YES;
    }
    return _listContainer;
}


- (UIView *)operContainer {
    if(!_operContainer) {
        _operContainer = [[UIView alloc] init];
        _operContainer.frame = CGRectMake(0, 196, SCREEN_WIDTH, 40);
        
        NSString *text = NSLocalizedString(@"展开上月及历史汇总", nil);
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:text forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1] forState:UIControlStateNormal];
        btn.frame = _operContainer.bounds;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(operateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_operContainer addSubview:btn];
        
        
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:@"ico_arr_expand"];
        icon.frame = CGRectMake(SCREEN_WIDTH/2.0f + size.width/2.0f+10, 9, 22, 22);
        [_operContainer addSubview:icon];
    }
    return _operContainer;
}

- (void)initHeader:(TotalEvaluateView *)evaluateViewTemp
{
    evaluateView = evaluateViewTemp;
    collapseHeight = TOTAL_EVALUATE_ITEM_HEIGHT + OPERATE_BTN_HEIGHT;
    isExpanded = NO;
}

- (void)initWithData:(NSArray *)list
{
    [self resetListView];
    [self renderListView:list];
}

- (void)renderListView:(NSArray *)list
{
    self.totalEvaluateDataList = list;
    if ([ObjectUtil isNotEmpty:list]) {
        for (NSInteger i=0;i<list.count;++i) {
            TotalEvaluateItem *item = [ItemFactory getTotalEvaluateItem];
            TotalEvaluateData *total = list[i];
            [item initWithData:total];
            CGRect frame = item.frame;
            frame.size.width = SCREEN_WIDTH;
            frame.origin.y = i*TOTAL_EVALUATE_ITEM_HEIGHT;
            item.frame = frame;
            [self.listContainer addSubview:item];
        }
        
        expandedHeight = TOTAL_EVALUATE_ITEM_HEIGHT*list.count + OPERATE_BTN_HEIGHT;
    }
}

- (void)resetListView
{
    for (TotalEvaluateItem *item in self.listContainer.subviews) {
        [item removeFromSuperview];
        [ItemFactory restoreTotalEvaluateItem:item];
    }
}

- (IBAction)operateBtnClick:(id)sender
{
    if (isExpanded) {
        isExpanded = NO;
        [self collapseHeader];
    } else {
        isExpanded = YES;
        [self expandeHeader];
    }
}

- (void)collapseHeader
{
    CGRect frame = self.frame;
    CGRect operFrame = self.operContainer.frame;
    CGRect listFrame = self.listContainer.frame;
    frame.size.height = collapseHeight;
    operFrame.origin.y = collapseHeight - OPERATE_BTN_HEIGHT;
    listFrame.size.height = TOTAL_EVALUATE_ITEM_HEIGHT;
    self.frame = frame;
    self.operContainer.frame = operFrame;
    self.listContainer.frame = listFrame;
    self.operContainer.hidden = NO;
    [evaluateView refreshHeaderView];
}

- (void)expandeHeader
{
    CGRect frame = self.frame;
    CGRect operFrame = self.operContainer.frame;
    CGRect listFrame = self.listContainer.frame;
    frame.size.height = expandedHeight ;
    operFrame.origin.y = expandedHeight - OPERATE_BTN_HEIGHT;
    listFrame.size.height = TOTAL_EVALUATE_ITEM_HEIGHT*self.totalEvaluateDataList.count;
    self.frame = frame;
    self.operContainer.frame = operFrame;
    self.listContainer.frame = listFrame;
    self.operContainer.hidden = YES;
    [evaluateView refreshHeaderView];
}

@end
