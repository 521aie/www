//
//  ChainPublishHistoryVo.m
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "ChainPublishHistoryVo.h"

@implementation ChainPublishHistoryVo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"plateMenuVoList" : [PlateMenuVoList class],@"plateShopVoList" : [PlateShopVoList class]};
}

@end
