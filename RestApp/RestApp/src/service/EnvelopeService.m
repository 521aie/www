//
//  SmsService.m
//  RestApp
//
//  Created by zxh on 14-11-10.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EnvelopeService.h"
#import "RestConstants.h"
#import "JsonHelper.h"
#import "Platform.h"
#import "JSONKit.h"

@implementation EnvelopeService

//获得红包列表API.
- (void)listEnvelopeDatatargetWithPage:(NSInteger)page  target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance] getkey:SHOP_ID] forKey:@"shop_id"];
    [param setObject:[[Platform Instance] getkey:SESSION_KEY] forKey:@"session_key"];
    [param setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page_index"];
   
    [super postBossAPI:@"hongbao/v1/get_hongbao_list_by_query" param:param target:target callback:callback];
}

- (void)saveEnvelopeData:(Coupon *)coupon target:(id)target callback:(SEL)callback
{
    NSString* entityId = [[Platform Instance] getkey:ENTITY_ID];
    NSString* shopId = [[Platform Instance] getkey:SHOP_ID];
    coupon.shopId = shopId;
    coupon.entityId = entityId;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
     NSString *query = @"hongbao/v1/publish_hongbao";
    [param setObject:[[coupon dictionaryData] JSONString] forKey:@"coupon_vo"];
    [param setObject:[[Platform Instance] getkey:SESSION_KEY] forKey:@"session_key"];
    [super postBossAPI:query param:param target:target callback:callback];
}

- (void)removeEnvelopeData:(NSInteger)couponId target:(id)target callback:(SEL)callback
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[NSString stringWithFormat:@"%ld", (long)couponId] forKey:@"coupon_id"];
    [param setObject:[[Platform Instance] getkey:SESSION_KEY] forKey:@"session_key"];
    NSString *query = @"hongbao/v1/delete_hongbao";
    [super postBossAPI:query param:param target:target callback:callback];
}
@end
