//
//  TDFWXNotificationModel.m
//  RestApp
//
//  Created by Octree on 18/3/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFWXNotificationModel.h"

@implementation TDFWXNotificationModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id",
             };
}

- (NSString *)targetName {

    switch (self.targetType) {
        case TDFWXNotificationTargetTypeAll:
            return @"全部微信粉丝";
            break;
        case TDFWXNotificationTargetTypeTagGroup:
            return self.tagName;
            break;
        case TDFWXNotificationTargetTypeIntelligentGroup:
            return self.groupName;
            break;
    }
}

- (NSInteger)targetMemberNumber {

    switch (self.targetType) {
        case TDFWXNotificationTargetTypeAll:
            return self.fansNumber;
            break;
        case TDFWXNotificationTargetTypeTagGroup:
            return self.tagMemberNumber;
            break;
        case TDFWXNotificationTargetTypeIntelligentGroup:
            return self.groupMemberNumber;
            break;
    }
}

@end


@implementation TDFWXContentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id",
             };
}


- (NSString *)obtainItemId {

    return self._id;
}

- (NSString *)obtainItemName {

    return self.name;
}

- (NSString *)obtainOrignName {

    return nil;
}

@end
