//
//  ShopCustomEvaluateCell.m
//  RestApp
//
//  Created by iOS香肠 on 15/9/23.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "FormatUtil.h"
#import "NSString+Estimate.h"
#import "ShopCustomEvaluateCell.h"

@implementation ShopCustomEvaluateCell

- (void)initWithData:(ShopEvaluateCellData *)data
{
    [self resetFrame];

    self.customerNameLabel.text = [FormatUtil formatStringRelpace:data.customerName start:1 replace:@"***"];
    self.customerNameLabel.adjustsFontSizeToFitWidth=YES;
    self.commentLabel.text = data.comment;
    self.createdAt.text = [DateUtils formatTimeWithTimestamp:data.createdAt type:TDFFormatTimeTypeYearMonthDay];
    self.icoImage.image = [self imagWith:(NSInteger)data.commentStatus];
    CGRect rect = self.commentLabel.frame;
    rect.size.height = [[self class] textHeight:self.commentLabel.text];
    self.commentLabel.frame = rect;
    CGFloat height = [ShopCustomEvaluateCell totalHeight:data];
    CGRect bgFrame = self.background.frame;
    bgFrame.size.height = height-1;
    self.background.frame = bgFrame;
}

- (void)resetFrame {
    CGRect newFrame = self.createdAt.frame;
    newFrame.origin.x = SCREEN_WIDTH-newFrame.size.width-15;
    self.createdAt.frame = newFrame;
}
- (NSString *)customerNameHide:(NSMutableString *)customerName
{
    if (customerName ==nil) {
        NSString *str =@"***";
        return str;
    } else if (customerName.length==0) {
        NSString *str=[NSString stringWithFormat:@"%@***",customerName];
        return str;
    }
   
    NSString *string = [customerName substringToIndex:1];
    NSString *str=[NSString stringWithFormat:@"%@***",string];
    return str;
}

- (UIImage *)imagWith:(NSInteger)data
{
    if (data==1) {
        UIImage *image =[UIImage imageNamed:@"ico_review_good.png"];
        return  image;
    } else if (data==0) {
        UIImage *image = [UIImage imageNamed:@"ico_review_bad2.png"];
        return  image;
    }
    return nil;
}

+ (CGFloat)totalHeight:(ShopEvaluateCellData*)commentData
{
    CGFloat staticHeight = 50 + 5;
    CGFloat dynamicHeight = [self textHeight:commentData.comment];
    return (staticHeight + dynamicHeight);
}

+ (CGFloat)textHeight:(NSString *)string
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(307,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}

@end
