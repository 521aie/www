//
//  TDFTakeoutSettingsVo.h
//  RestApp
//
//  Created by 栀子花 on 16/9/1.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "EntityObject.h"
@class TDFTakeOutSettings;
@interface TDFTakeoutSettingsVo : EntityObject
@property(nonatomic,strong)TDFTakeOutSettings *takeOutSettings;
@property(nonatomic,copy)NSString *takeoutShortUrl;


 @end
