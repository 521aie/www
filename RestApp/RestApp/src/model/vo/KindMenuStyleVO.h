//
//  KindMenuStyleVO.h
//  RestApp
//
//  Created by zxh on 14-4-19.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "KindMenuStyle.h"
#import "INameValueItem.h"

@interface KindMenuStyleVO : KindMenuStyle<INameValueItem>

/**
 * <code>风格名称</code>.
 */
@property (nonatomic,retain) NSString *styleName;

/**
 * <code>菜类名称</code>.
 */
@property (nonatomic,retain) NSString *kindMenuName;

/**
 * pdaID
 */
@property (nonatomic,retain) NSString *pdaId;

/**
 * pcID
 */
@property (nonatomic,retain) NSString *pcId;

/**
 * 用途为pda的风格名称
 */
@property (nonatomic,retain) NSString *pdaStyleId;
/**
 * 用途为pc屏的风格名称
 */
@property (nonatomic,retain) NSString *pcStyleId;

@end
