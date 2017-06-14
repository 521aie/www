//
//  WaiterEvaluateDetailCell.m
//  RestApp
//
//  Created by xueyu on 15/9/25.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "FormatUtil.h"
#import "WaiterEvaluateDetailCell.h"

@implementation WaiterEvaluateDetailCell

- (void)initWithData:(WaiterEvaluateCommentData *)commentData
{
    CGRect newFrame = self.evaluateDate.frame;
    newFrame.origin.x = SCREEN_WIDTH-newFrame.size.width-15;
    self.evaluateDate.frame = newFrame;

    self.customerName.text = [FormatUtil formatStringRelpace:commentData.customerName start:1 replace:@"***"];
    self.customerIcon.image = [self imageStatusForComment:commentData.commentStatus];
    self.evaluateComment.text = commentData.comment;

    self.evaluateComment.numberOfLines = 0;
    self.evaluateDate.text = [DateUtils formatTimeWithTimestamp:commentData.createdAt type:TDFFormatTimeTypeYearMonthDay];
    
    CGRect rect = self.evaluateComment.frame;
    rect.size.height = [[self class] textHeight:self.evaluateComment.text];
    self.evaluateComment.frame = rect;
}

+ (CGFloat)totalHeight:(WaiterEvaluateCommentData *)commentData
{
    // 不变的部分
    CGFloat staticHeight = 50 + 5;
    // 变化的部分
    CGFloat dynamicHeight = [self textHeight:commentData.comment];
    
    return staticHeight + dynamicHeight;
}

// 高度计算公式
+ (CGFloat)textHeight:(NSString *)string
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(280,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}
//好评，差评显示
- (UIImage *)imageStatusForComment:(int)status
{
    if (status == STATUS_BAD) {
        return [UIImage imageNamed:@"ico_review_bad2"];
    } else {
        return [UIImage imageNamed:@"ico_review_good"];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect backGroundRect = self.background.frame;
    backGroundRect.size.height = self.bounds.size.height-1;
    self.background.frame = backGroundRect;
}

@end
