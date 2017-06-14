//
//  ShopTemplate.h
//  RestApp
//
//  Created by zxh on 14-4-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseShopTemplate.h"
#import "INameValueItem.h"

typedef enum
{
    PRINT_80=42,
    PRINT_76=38,
    PRINT_58=32

} SHOPTEMPLATE_LINE_WITH_ENUM;

typedef enum
{
    SHOPTEMPLATE_TYPE_CASH=1,
    SHOPTEMPLATE_TYPE_BASE=2,
    SHOPTEMPLATE_TYPE_PANTRY=3
} SHOPTEMPLATE_TYPE_ENUM;

@interface ShopTemplate : BaseShopTemplate<INameValueItem>

/**
 * <code>打印模板的类别Id</code>.
 */
@property (nonatomic,retain) NSString *kindPrintTemplateId;

/**
 * <code>打印模板类别名称</code>.
 */
@property (nonatomic,retain) NSString *kindPrintTemplateName;

/**
 * <code>出单类型</code>.
 */
@property short kindType;


/** 预览图路径. */
@property (nonatomic,retain) NSString *filePath;

@end
