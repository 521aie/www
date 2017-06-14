//
//  TDFTransGoodsListApi.h
//  RestApp
//
//  Created by 刘红琳 on 2017/5/18.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFIssueGoodsListApi.h"

@interface TDFTransGoodsListApi : TDFBaseAPI
//品牌EntityId
@property (nonatomic, copy) NSString *plateEntityId;
@property (nonatomic, assign) BOOL removeChain;

@end
