//
//  TDFOAMenuModel.m
//  RestApp
//
//  Created by Octree on 6/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFOAMenuModel.h"

@implementation TDFOAMenuMessageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
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

- (NSURL *)demoImageURL {
    
    if (!self.demoPic) {
        return nil;
    }
    
    return [NSURL URLWithString:self.demoPic];
}

@end


@implementation TDFOAMenuURLModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id",
             @"detail" : @"description"
             };
}

- (NSString *)obtainItemId {

    return [NSString stringWithFormat:@"%zd", self.urlType];
}

- (NSString *)obtainItemName {

    return self.urlName;
}

- (NSString *)obtainOrignName {

    return nil;
}


- (instancetype)copyWithZone:(NSZone *)zone {
    
    TDFOAMenuURLModel *model = [[[self class] allocWithZone:zone] init];
    model.demoPic = self.demoPic;
    model.detail = self.detail;
    model.url = self.url;
    model.urlName = self.urlName;
    model.urlType = self.urlType;
    model.menuType = self.menuType;
    return model;
}

- (NSURL *)demoImageURL {

    if (!self.demoPic) {
        return nil;
    }
    
    return [NSURL URLWithString:self.demoPic];
}

@end

@implementation TDFOAMenuModel

- (instancetype)copyWithZone:(NSZone *)zone {

    TDFOAMenuModel *model = [[[self class] allocWithZone:zone] init];
    model.name = self.name;
    model.urlDetail = self.urlDetail;
    model.subMenus = self.subMenus;
    model.type = self.type;
    model.shopName = self.shopName;
    model.shopId = self.shopId;
    model.messageDetail = self.messageDetail;
    model.plateId = self.plateId;
    model.plateName = self.plateName;
    model.scopeType = self.scopeType;
    return model;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"_id" : @"id"
             };
}



+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"urlDetail" : [TDFOAMenuURLModel class],
             };
}

@end
