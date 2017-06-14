//
//  CustomEvalutaeCell.m
//  RestApp
//
//  Created by iOS香肠 on 15/9/22.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "FormatUtil.h"
#import "TotalEvaluateCell.h"
#import "NSString+Estimate.h"

@implementation TotalEvaluateCell

- (void)initWithData:(TotalEvaluateCellData *)data
{
    [self resetFrame];
    
    self.customNameLabel.text = [FormatUtil formatStringRelpace:data.customerName start:1 replace:@"***"];
    self.customNameLabel.adjustsFontSizeToFitWidth=YES;
    self.waiterNamelabel .text = data.waiterName;
    self.commentForShoplabel.text = data.commentForShop;
    self.commentForWaiterlabel.text = data.commentForWaiter;
    self.createdAt.text = [DateUtils formatTimeWithTimestamp:data.createdAt type:TDFFormatTimeTypeYearMonthDay];
    self.commentWaiterIco.image = [self imagWith:data.commentStatusForWaiter];
    self.commentShopIco.image = [self imagWith:data.commentStatusForShop];
    [self updateViewSize:data];
}

- (void)resetFrame {
    CGRect newFrame = self.createdAt.frame;
    newFrame.origin.x = SCREEN_WIDTH-newFrame.size.width-15;
    self.createdAt.frame = newFrame;
    
    newFrame = self.commentForWaiterView.frame;
    newFrame.size.width = SCREEN_WIDTH;
    self.commentForWaiterView.frame = newFrame;
    
    newFrame = self.commentForShopView.frame;
    newFrame.size.width = SCREEN_WIDTH;
    self.commentForShopView.frame = newFrame;
}

+ (CGFloat)totalHeight:(TotalEvaluateCellData *)commentData
{
    CGFloat staticsHeight = 40;
    CGFloat dynamicHeight1 = 0;
    CGFloat dynamicHeight2 = 0;
    
    if ([NSString isNotBlank:commentData.commentForWaiter]) {
        dynamicHeight1 = [self textHeight:commentData.commentForWaiter]+24;
    }
    dynamicHeight2 = [self textHeight:commentData.commentForShop]+24;
   
    return staticsHeight + dynamicHeight1 + dynamicHeight2;
}

+ (CGFloat)textHeight:(NSString *)string
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(295, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
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

- (void)updateViewSize:(TotalEvaluateCellData *)data
{
    CGRect waiterCommentRect = self.commentForWaiterlabel.frame;
    CGRect waiterCommentViewRect = self.commentForWaiterView.frame;
    
    if ([NSString isNotBlank:data.commentForWaiter]) {
        waiterCommentRect.size.height = [TotalEvaluateCell textHeight:self.commentForWaiterlabel.text];
        waiterCommentViewRect.size.height = waiterCommentRect.size.height + waiterCommentRect.origin.y + 4;
    } else {
        waiterCommentRect.size.height = 0;
        waiterCommentViewRect.size.height = 0;
    }
    
    self.commentForWaiterlabel.frame = waiterCommentRect;
    self.commentForWaiterView.frame = waiterCommentViewRect;
    CGRect shopCommentRect = self.commentForShoplabel.frame;
    shopCommentRect.size.height = [TotalEvaluateCell textHeight:self.commentForShoplabel.text];
    self.commentForShoplabel.frame = shopCommentRect;
    CGRect shopCommentViewRect = self.commentForShopView.frame;
    shopCommentViewRect.origin.y = waiterCommentViewRect.origin.y + waiterCommentViewRect.size.height;
    shopCommentViewRect.size.height = shopCommentRect.origin.y + shopCommentRect.size.height + 4;
    self.commentForShopView.frame = shopCommentViewRect;
    
    CGRect bgFrame = self.background.frame;
    bgFrame.size.height = shopCommentViewRect.size.height + shopCommentViewRect.origin.y + 9;
    self.background.frame = bgFrame;
    
    CGRect frame = self.frame;
    frame.size.height = shopCommentViewRect.size.height + shopCommentViewRect.origin.y + 10;
    self.frame = frame;
}

@end
