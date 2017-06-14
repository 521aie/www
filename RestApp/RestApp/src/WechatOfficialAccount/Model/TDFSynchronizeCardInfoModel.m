//
//  TDFSynchronizeCardInfoModel.m
//  RestApp
//
//  Created by 黄河 on 2017/3/23.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFSynchronizeCardInfoModel.h"

@implementation TDFSynchronizeCardInfoModel

- (NSString *)obtainItemId {
    return self.cardId;
}

- (NSString *)obtainItemName {
    return self.cardName;
}

- (NSString *)obtainOrignName {
    return self.cardName;
}

- (id)copyWithZone:(NSZone *)zone {
    TDFSynchronizeCardInfoModel *synchronizeModel = [[TDFSynchronizeCardInfoModel allocWithZone:zone] init];
    synchronizeModel.cardId = self.cardId;
    synchronizeModel.cardName = self.cardName;
    return synchronizeModel;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cardId" : @"id",
             @"cardName" : @"name"};
}
@end
