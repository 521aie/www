//
//  PlateMenuVoList.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INameValueItem.h"
@interface PlateMenuVoList : NSObject<INameValueItem>

@property (nonatomic ,assign) BOOL isSelected;

@property (nonatomic ,strong) NSString *menuId;

@property (nonatomic ,strong) NSString *menuName;

@end
