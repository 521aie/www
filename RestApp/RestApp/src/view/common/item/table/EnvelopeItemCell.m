//
//  EnvelopeItemCell.m
//  RestApp
//
//  Created by 邵建青 on 15-1-13.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "DateUtils.h"
#import "ObjectUtil.h"
#import "JsonHelper.h"
#import "CouponShop.h"
#import "EnvelopeItemCell.h"

@implementation EnvelopeItemCell

+ (id)getInstance
{
    EnvelopeItemCell *item = [[[NSBundle mainBundle]loadNibNamed:@"EnvelopeItemCell" owner:self options:nil]lastObject];
    if ([item isKindOfClass:[EnvelopeItemCell class]]) {
        return item;
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ENVELOPE_ITEM_CELL];
}

- (void)initWithData:(Coupon *)coupon
{
    if ([ObjectUtil isNotNull:coupon]) {
        NSString *price = [NSString stringWithFormat:@"%0.0f", coupon.price];
        self.nameLbl.text = price;
        self.periodLbl.text = [NSString stringWithFormat:NSLocalizedString(@"有效期至%@", nil), [DateUtils formatTimeWithTimestamp:coupon.endTime type:TDFFormatTimeTypeChineseWithWeek]];
        self.publishLbl.text = [NSString stringWithFormat:NSLocalizedString(@"已领取%li个,已使用%li个", nil), (long)coupon.receiveQuantity, (long)coupon.useQuantity];
        if (coupon.status==STATUS_COUPON_NORMAL) {
            self.statusLbl.text = NSLocalizedString(@"可领取", nil);
            self.statusImg.image =  [UIImage imageNamed:@"bag_icon.png"];
            self.nameLbl.textColor = [UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
            self.statusLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:170.0/255.0 blue:34.0/255.0 alpha:1.0];
            if (coupon.receiveQuantity>=coupon.totalQuantity) {
                self.statusLbl.text = NSLocalizedString(@"已领完", nil);
                self.statusImg.image =  [UIImage imageNamed:@"bag_grey_icon.png"];
                self.nameLbl.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0];
                self.statusLbl.textColor = [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
            }
        } else if (coupon.status==STATUS_COUPON_PAUSE) {
            self.statusLbl.text = NSLocalizedString(@"已停发", nil);
            self.statusImg.image =  [UIImage imageNamed:@"bag_grey_icon.png"];
            self.nameLbl.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1.0];
            self.statusLbl.textColor = [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
        } else if (coupon.status==STATUS_COUPON_CANCEL) {
            self.statusLbl.text = NSLocalizedString(@"已过期", nil);
            self.statusImg.image =  [UIImage imageNamed:@"bag_grey_icon.png"];
            self.nameLbl.textColor = [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
            self.statusLbl.textColor = [UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
        }
        
        if ([ObjectUtil isNotEmpty:coupon.shopList]) {
            CouponShop *shop=[JsonHelper dicTransObj:[coupon.shopList objectAtIndex:0] obj:[CouponShop alloc]];
            self.shopLbl.text = shop.shopName;
        } else {
            self.shopLbl.text = @"";
        }
        
        [self.nameLbl sizeToFit];
        
        CGRect unitFrame = self.unitLbl.frame;
        unitFrame.origin.x = self.nameLbl.frame.origin.x + self.nameLbl.frame.size.width;
        self.unitLbl.frame = unitFrame;
    }
}

@end
