//
//  PantryRender.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PantryRender : NSObject

+(NSMutableArray*) listPrintNums;
+(NSMutableArray*) listPantryDetails;
+(NSMutableArray*) listIsAuto;
+(NSMutableArray*) listWidth;
+(NSMutableArray*) listLineCounts:(NSString*)lineWidth;
//传菜设备
+(NSMutableArray*) listPrintDevice;
//标签纸规格型号
+(NSMutableArray *) listTagSpec;
@end
