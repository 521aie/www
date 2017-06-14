//
//  ShopReviewInfo.m
//  RestApp
//
//  Created by Octree on 18/7/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopReviewInfo.h"

@implementation ShopReviewInfo


#pragma mark - YYModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"_id" : @"id",
             @"longitude": @"longtitude",
             @"logoLongitude": @"logoLongtitude",
//             @"status": @"auditStatus",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"shopLogoImg" : [ShopImg class]};
}


//@property (copy, nonatomic, readonly) NSString *statusTitle;
//@property (copy, nonatomic, readonly) NSString *statusDetail;
//@property (strong, nonatomic) NSDate *createdAt;

- (NSString *)statusTitle {

    switch (self.status) {
            
        case ShopReviewStateNone: {
        
            return NSLocalizedString(@"本店资料未提交审核", nil);
        }
        case ShopReviewStateWaiting: {
            
            return NSLocalizedString(@"本资料已提交，审核中", nil);
        }
        case ShopReviewStateAccept: {
            
            return NSLocalizedString(@"本资料已审核通过", nil);
        }
        case ShopReviewStateReject: {
            
            return NSLocalizedString(@"资料审核未通过，请完善后重新提交", nil);
        }
    }
}


- (NSString *)statusDetail {

    switch (self.status) {
            
        case ShopReviewStateNone: {
            
            return NSLocalizedString(@"请完善资料并提交审核，否则无法在顾客端“附近的店”中显示", nil);
        }
        case ShopReviewStateWaiting: {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = NSLocalizedString(@"MM月dd日 HH:mm", nil);
            NSDate *date = [NSDate dateWithTimeIntervalSince1970: self.createTime];
            return [NSString stringWithFormat:NSLocalizedString(@"提交时间：%@（72小时内完成审核）", nil), [formatter stringFromDate: date]];
        }
        case ShopReviewStateAccept: {
            
            return nil;
        }
        case ShopReviewStateReject: {
            
            return [NSString stringWithFormat:NSLocalizedString(@"失败原因：%@", nil), self.memo];
        }
    }
}

- (NSDictionary *)doorImageDictionary {

    for (NSDictionary *dict in self.imgLists) {
    
        if ([dict[ @"type" ] integerValue] == 2) {
        
            return dict;
        }
    }
    
    return nil;
}

@end
