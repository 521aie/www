//
//  ShopEvaluateHeader.m
//  RestApp
//
//  Created by iOS香肠 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "ObjectUtil.h"
#import "ItemFactory.h"
#import "StarRatingView.h"
#import "ShopEvaluateItem.h"
#import "ShopEvaluateHeader.h"
#import "ShopEvaluateView.h"
#import "ShopEvaluateHeader.h"
#import "ShopEvaluateViewData.h"

@implementation ShopEvaluateHeader

+ (ShopEvaluateHeader *)createShopEvaluateHeader:(ShopEvaluateView *)evaluateView
{
    ShopEvaluateHeader *evaluateHeader = [[[NSBundle mainBundle]loadNibNamed:@"ShopEvaluateHeader" owner:self options:nil]lastObject];
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
        _listContainer.frame = CGRectMake(0, 100, SCREEN_WIDTH, 193);
        _listContainer.layer.masksToBounds = YES;
    }
    return _listContainer;
}


- (UIView *)operContainer {
    if(!_operContainer) {
        _operContainer = [[UIView alloc] init];
        _operContainer.frame = CGRectMake(0, 293, SCREEN_WIDTH, 40);
        
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

- (void)initHeader:(ShopEvaluateView *)evaluateViewTemp
{
    CGRect frame = self.Topview.frame;
    frame.size.width = SCREEN_WIDTH;
    self.Topview.frame = frame;
    
    evaluateView = evaluateViewTemp;
    collapseHeight = SHOP_EVALUATE_ITEM_HEIGHT + SHOPOPERATE_BTN_HEIGHT + TOPVIEW_BTN_HEIGHT;
}

- (void)initWithData:(ShopEvaluateViewData *)shopEvaluateViewData
{
    if (shopEvaluateViewData!=nil) {
        isExpanded = NO;
        self.shopEvaluateDataList = shopEvaluateViewData.shopReportVoList;
        [self renderShopDetailView:shopEvaluateViewData];
        [self renderStarSignView:shopEvaluateViewData];
        [self resetListView];
        [self renderListView:self.shopEvaluateDataList];
    }
}

- (void)renderShopDetailView:(ShopEvaluateViewData *)data
{
    self.ShopnameLabel.text = data.shopName;
    CGRect ShopnameLabel =self.ShopnameLabel.frame;
    ShopnameLabel.size.width=[self labelAutoCalculateRectWith:data.shopName FontSize:13 MaxSize:CGSizeMake(250, 21)].width
    ;
    self.ShopnameLabel.frame =ShopnameLabel;
    CGRect picFrame = self.picImage.frame;
    picFrame.size.width = data.experienceCount*15;
    self.picImage.frame = picFrame;
    CGRect predicFrame = self.goooPredicLabel.frame;
    predicFrame.origin.x = picFrame.origin.x + picFrame.size.width + 2;
    self.goooPredicLabel.frame = predicFrame;
    self.goooPredicLabel.text = [NSString stringWithFormat:NSLocalizedString(@"好评率%@", nil),data.goodPercent];
    self.tasteLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%0.1f分", nil), data.taste];
    self.speedLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%0.1f分", nil), data.speed];
    self.environmentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%0.1f分", nil), data.environment];
}

- (void)renderStarSignView:(ShopEvaluateViewData *)data
{
    for (UIView *view in self.picImage.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0;i<data.experienceCount; i++) {
        UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(i*15 , 0, 15,17)];
        image.image = [UIImage imageNamed:@"ico_lvl_1.png"];
        [self.picImage addSubview:image];
    }
    
    if (self.tasteSign!=nil) {
        [self.tasteSign removeFromSuperview];
    }
    
    if (self.speedSign!=nil) {
        [self.speedSign removeFromSuperview];
    }
    
    if (self.environmentSign!=nil) {
        [self.environmentSign removeFromSuperview];
    }
    
    self.tasteSign = [[StarRatingView alloc]initWithFrame:CGRectMake(0, 0, self.tasteimage.frame.size.width, self.tasteimage.frame.size.height) starLevel:data.taste];
    [self.tasteimage addSubview:self.tasteSign];
    self.speedSign = [[StarRatingView alloc]initWithFrame:CGRectMake(0, 0, self.speedimage.frame.size.width, self.speedimage.frame.size.height) starLevel:data.speed];
    [self.speedimage addSubview:self.speedSign];
    self.environmentSign = [[StarRatingView alloc]initWithFrame:CGRectMake(0, 0, self.environmentimage.frame.size.width, self.environmentimage.frame.size.height) starLevel:data.environment];
    [self.environmentimage addSubview:self.environmentSign];
}

- (void)renderListView:(NSArray *)list
{
    if ([ObjectUtil isNotEmpty:list]) {
        for (NSInteger i=0;i<list.count; ++i) {
            ShopEvaluateItem *item = [ItemFactory getShopEvaluateIteam];
            ShopEvaluateItemData *data = list[i];
            [item shopdata:data];
            CGRect frame = item.frame;
            frame.size.width = SCREEN_WIDTH;
            frame.origin.y = i*SHOP_EVALUATE_ITEM_HEIGHT;
            item.frame = frame;
            [self.listContainer addSubview:item];
        }
        expandedHeight = SHOP_EVALUATE_ITEM_HEIGHT*list.count + SHOPOPERATE_BTN_HEIGHT+TOPVIEW_BTN_HEIGHT;
    }
}
- (void)resetListView
{
    for (ShopEvaluateItem *item in self.listContainer.subviews) {
        [item removeFromSuperview];
        [ItemFactory restoreShopEvaluateItem:item];
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
    operFrame.origin.y = collapseHeight - SHOPOPERATE_BTN_HEIGHT;
    listFrame.size.height = SHOP_EVALUATE_ITEM_HEIGHT;
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
    operFrame.origin.y = expandedHeight - SHOPOPERATE_BTN_HEIGHT;
    listFrame.size.height = SHOP_EVALUATE_ITEM_HEIGHT*self.shopEvaluateDataList.count;
    self.frame = frame;
    self.operContainer.frame = operFrame;
    self.listContainer.frame = listFrame;
    self.operContainer.hidden = YES;
    [evaluateView refreshHeaderView];
}

- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    
    return labelSize;
}

@end
