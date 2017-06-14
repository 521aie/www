//
//  PlateKindMenuVo.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlateMenuVoList.h"
@interface PlateKindMenuVo : NSObject<INameValueItem>
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, strong) NSString * kindMenuId;
@property(nonatomic, strong) NSString * kindMenuName;
@property(nonatomic, strong) NSString * parentKindMenuName;
@property (nonatomic ,strong) NSMutableArray * plateMenuVoList;

@end
