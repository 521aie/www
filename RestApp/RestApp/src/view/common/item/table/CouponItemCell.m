//
//  CouponItemCell.m
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "ObjectUtil.h"
#import "CouponItemCell.h"

@implementation CouponItemCell

+ (id)getInstance
{
    CouponItemCell *item = [[[NSBundle mainBundle]loadNibNamed:@"CouponItemCell" owner:self options:nil]lastObject];
    if ([item isKindOfClass:[CouponItemCell class]]) {
        return item;
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:COUPON_ITEM_CELL];
}

- (void)initWithData:(Coupon *)coupon
{
    if ([ObjectUtil isNotNull:coupon]) {
        self.nameLbl.text = coupon.name;
        self.memoLbl.text = coupon.memo;
        self.periodLbl.text = [NSString stringWithFormat:NSLocalizedString(@"有效期: %@至%@", nil), [DateUtils formatTimeWithTimestamp:coupon.startTime type:TDFFormatTimeTypeYearMonthDay], [DateUtils formatTimeWithTimestamp:coupon.endTime type:TDFFormatTimeTypeYearMonthDay]];
        
        self.publishLbl.text = [NSString stringWithFormat:NSLocalizedString(@"已发行%li张,已领取%li张,已使用%li张", nil), (long)coupon.totalQuantity, (long)coupon.receiveCondition, (long)coupon.useQuantity];
        
        if (coupon.status==STATUS_COUPON_NORMAL) {
            self.statusLbl.text = NSLocalizedString(@"可领取", nil);
            self.statusLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:170.0/255.0 blue:34.0/255.0 alpha:1.0];
            self.statusImg.image = [UIImage imageNamed:@"ticket_left_use.png"];
        } else if (coupon.status==STATUS_COUPON_PAUSE) {
            self.statusLbl.text = NSLocalizedString(@"已停发", nil);
            self.statusLbl.textColor = [UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
            self.statusImg.image = [UIImage imageNamed:@"ticket_left_unuse.png"];
        } else if (coupon.status==STATUS_COUPON_CANCEL) {
            self.statusLbl.text = NSLocalizedString(@"已过期", nil);
            self.statusLbl.textColor = [UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
            self.statusImg.image = [UIImage imageNamed:@"ticket_left_unuse.png"];
        }
    }
}

@end
