//
//  MenuRender.h
//  RestApp
//
//  Created by zxh on 14-5-6.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuRender : NSObject
+ (NSMutableArray *)listDataKind;

+ (NSMutableArray *)listBillType;
+ (NSMutableArray *)listBillPer;
+ (NSMutableArray *)listDataTime;

+ (NSMutableArray *)listAutoDay;

+ (NSMutableArray*) listDeductKind;


+(NSMutableArray*) listServiceFeeMode;

+(NSMutableArray*) listMenuUnits:(NSString*)units;

+(NSMutableArray*) listAcridLevels;
+(NSString*) getDeductdLabel:(short) val;

+(NSString*) getServiceFeeLabel:(short) val;
+ (NSString*)obtainItem:(NSMutableArray*)list itemId:(NSString*)itemId;

+ (MenuRender *)render;
- (NSMutableArray *)menuStepLengthArray;
//+(NSString*) getbillTypeUnit:(short)btype;
@end
