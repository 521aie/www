//
//  EmployeeUserVo.m
//  RestApp
//
//  Created by zishu on 16/7/11.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EmployeeUserVo.h"
#import "ExtraActionVo.h"
#import "ObjectUtil.h"

@implementation EmployeeUserVo

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.employeeVo = [[Employee alloc] initWithDictionary:dic[@"employeeVo"]];
        
        self.userBranchVoList = [self convertToBranchVoListByArr:dic[@"userBranchVoList"]];
        
        self.userPlateVoList = [self convertToPlateListByArr:dic[@"userPlateVoList"]];
        
        self.userShopVoList = [self convertToShopListByArr:dic[@"userShopVoList"]];
        
        self.extraActionVoList = [self convertToextraActionListByArr:dic[@"extraActionVoList"]];
        
        self.userVo = [[UserVO alloc] initWithDictionary:dic[@"userVo"]];
    }
    return self;
}

- (NSMutableArray *)convertToBranchVoListByArr:(NSArray *)arr
{
    NSMutableArray *branchList = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSDictionary *dictionary in arr) {
            if ([ObjectUtil isNotEmpty:dictionary]) {
                 BranchVo*branchVo = [[BranchVo alloc]initWithDictionary:dictionary];
                [branchList addObject:branchVo];
            }
        }
        return branchList;
    }
    return nil;
}

- (NSMutableArray *)convertToPlateListByArr:(NSArray *)arr
{
    NSMutableArray *plateList = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSDictionary *dictionary in arr) {
            if ([ObjectUtil isNotEmpty:dictionary]) {
                Plate *plateVo = [[Plate alloc]initWithDictionary:dictionary];
                [plateList addObject:plateVo];
            }
        }
        return plateList;
    }
    return nil;
}

- (NSMutableArray *)convertToShopListByArr:(NSArray *)arr
{
    NSMutableArray *shopList = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSDictionary *dictionary in arr) {
            if ([ObjectUtil isNotEmpty:dictionary]) {
                ShopVO *shopVO = [[ShopVO alloc]initWithDictionary:dictionary];
                [shopList addObject:shopVO];
            }
        }
        return shopList;
    }
    return nil;
}

- (NSMutableArray *)convertToextraActionListByArr:(NSArray *)arr
{
    NSMutableArray *actionList = [[NSMutableArray alloc]init];
    if ([ObjectUtil isNotEmpty:arr]) {
        for (NSDictionary *dictionary in arr) {
            if ([ObjectUtil isNotEmpty:dictionary]) {
                ExtraActionVo *action = [[ExtraActionVo alloc]initWithDictionary:dictionary];
                [actionList addObject:action];
            }
        }
        return actionList;
    }
    return nil;
}

@end
