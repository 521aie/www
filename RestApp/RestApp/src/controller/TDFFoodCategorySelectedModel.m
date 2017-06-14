//
//  TDFFoodCategorySelectedModel.m
//  RestApp
//
//  Created by happyo on 2016/11/30.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFFoodCategorySelectedModel.h"

@implementation TDFFoodCategorySelectedModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.menuVos = [NSMutableArray array];
    }
    
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"menuVos" : [TDFFoodSelectedModel class]};
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    TDFFoodCategorySelectedModel *copy = [[[self class] allocWithZone:zone] init];
    
    copy.kindMenuId = [self.kindMenuId mutableCopy];
    copy.kindMenuName = [self.kindMenuName mutableCopy];
    copy.isSelected = self.isSelected;
    NSMutableArray *menuVosCopy = [NSMutableArray array];
    
    for (TDFFoodSelectedModel *model in self.menuVos) {
        [menuVosCopy addObject:model];
    }
    copy.menuVos = menuVosCopy;
    
    return copy;
}


@end
