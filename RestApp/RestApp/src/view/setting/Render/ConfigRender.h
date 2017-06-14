//
//  ConfigRender.h
//  RestApp
//
//  Created by zxh on 14-4-4.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EditItemRadio,ConfigVO;

@interface ConfigRender : NSObject
+(NSMutableDictionary*) transDic:(NSMutableArray *) arrs;
+(ConfigVO*)fillConfig:(NSString*) key withControler:(EditItemRadio*) rdo withMap:(NSMutableDictionary*) map;
+(void)fillSystemConfig:(NSString*) key withControler:(EditItemRadio*) rdo withMap:(NSDictionary*) map;
+(NSString*) getOptionName:(ConfigVO*) vo;
@end
