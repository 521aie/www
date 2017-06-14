//
//  Pantry.h
//  RestApp
//
//  Created by zxh on 14-5-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BasePantry.h"
#import "INameValueItem.h"

@interface Pantry : BasePantry<INameValueItem>
/**
 * 是否是连锁数据
 */
@property (nonatomic,assign) BOOL isChain;

/**
 * <code>关联的出品方案字符串</code>.
 */
@property (nonatomic,retain) NSString *producePlanStr;

/**
 * <code>关联的出品方案集合</code>.
 */
@property (nonatomic,strong) NSMutableArray* pantryPlans;

/**


 * 主键id
 */
@property (nonatomic,strong) NSString * pantryId;


@property (nonatomic,strong) NSString *pantryDevOption;
/**
 * <code>打印机</code>.
 */
@property (nonatomic, assign)int printerSwitch;
/**
 * <code></code>.
 */
@property (nonatomic, assign)int paperHeight;

//分类IdList
@property (nonatomic , strong) NSMutableArray *kindIds;
//商品IdList
@property (nonatomic , strong) NSMutableArray *menuIds;
//传菜区域idLIst
@property (nonatomic , strong) NSMutableArray *areaIds;
+(id) pantryPlans_class;

@end


@interface AreaPantry : Base<INameValueItem>
/**
 * <code>打印机Ip</code>.
 */
@property (nonatomic,copy) NSString *ipAddress;
/**
 * <code>每行字符数</code>.
 */
@property int rowNum;
/**
 * <code>纸张宽度</code>.
 */
@property int paperWidth;
/**
 * <code>区域对象列表</code>.
 */
@property (nonatomic,strong) NSMutableArray *areaList;
/**
 * <code>区域对象列表字符串</code>.
 */
@property (nonatomic,strong) NSString *areaNameListStr;


-(id)initWithDictionary:(NSDictionary *)dictionary;
@end
