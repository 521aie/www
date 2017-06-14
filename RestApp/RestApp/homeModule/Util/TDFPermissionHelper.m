//
//  TDFPermissionHelper.m
//  RestApp
//
//  Created by happyo on 2017/4/22.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFPermissionHelper.h"

@implementation TDFPermissionHelper

+ (instancetype)sharedInstance
{
    static TDFPermissionHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[TDFPermissionHelper alloc] init];
    });
    return helper;
}

- (NSArray<NSString *> *)notLockedActionCodeList
{
    NSMutableArray<NSString *> *notLockedList = [NSMutableArray array];
    
    for (TDFHomeGroupForwardChildCellModel *forwardModel in self.functionModelList) {
        if (!forwardModel.isLock) {
            [notLockedList addObject:forwardModel.actionCode];
        }
    }
    
    return notLockedList;
}

- (NSArray<TDFFunctionVo *> *)allModuleChargeList
{
    return [self functionVoListWithForwardModelList:self.functionModelList];
}

- (BOOL)isLockedWithActionCode:(NSString *)actionCode
{
    BOOL isLocked = NO;
    for (TDFHomeGroupForwardChildCellModel *childModel in self.functionModelList) {
        if ([childModel.actionCode isEqualToString:actionCode]) {
            isLocked = childModel.isLock;
        }
    }
    
    return isLocked;
}

- (NSArray<TDFFunctionVo *> *)functionVoListWithForwardModelList:(NSArray<TDFHomeGroupForwardChildCellModel *> *)forwardModelList
{
    NSMutableArray<TDFFunctionVo *> *functionVoList = [NSMutableArray<TDFFunctionVo *> array];
    
    for (TDFHomeGroupForwardChildCellModel *forwardModel in forwardModelList) {
        TDFFunctionVo *functionVo = [[TDFFunctionVo alloc] init];
    
        functionVo.id = forwardModel._id;
        functionVo.actionName = forwardModel.title;
        functionVo.actionCode = forwardModel.actionCode;
        functionVo.actionId = forwardModel.actionId;
        functionVo.isHide = forwardModel.isHide;
        functionVo.isLock = [forwardModel.actionCode isEqualToString:@"TO_SUPPLY_MANAGE"] || [forwardModel.actionCode isEqualToString:@"PHONE_KOUBEI_SHOP"] ? 0 : forwardModel.isLock;
        functionVo.isOpen = [forwardModel.actionCode isEqualToString:@"TO_SUPPLY_MANAGE"] || [forwardModel.actionCode isEqualToString:@"PHONE_KOUBEI_SHOP"] ? 1 : forwardModel.isOpen;
        TDFFunctionVoIconImageUrl *imageUrl = [[TDFFunctionVoIconImageUrl alloc] init];
        imageUrl.sUrl = forwardModel.iconUrl;
        functionVo.iconImageUrl = imageUrl;
        
        [functionVoList addObject:functionVo];
    }
    
    return functionVoList;
}

@end
