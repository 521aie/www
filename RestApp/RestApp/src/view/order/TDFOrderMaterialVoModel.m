//
//  TDFOrderMaterialVoModel.m
//  RestApp
//
//  Created by QiYa on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//
#import "YYModel.h"

#import "TDFOrderMaterialVoModel.h"


@implementation TDFOrderDetailMaterialVoModel
+ (instancetype)modelWithDictionary:(NSDictionary*)dic {
    return [TDFOrderDetailMaterialVoModel yy_modelWithDictionary:dic];
}
@end

@implementation TDFOrderMaterialVoModel
+ (instancetype)modelWithDictionary:(NSDictionary*)dic {
    
    TDFOrderMaterialVoModel *model = [TDFOrderMaterialVoModel new];
    model.isAllSelected = [[dic objectForKey:@"isAllSelected"] boolValue];
    model.labelMaterialId = [dic objectForKey:@"labelMaterialId"] ?: @"";
    model.labelMaterialName = [dic objectForKey:@"labelMaterialName"] ?: @"";
    
    NSArray *mainArr = [dic objectForKey:@"mainMaterialLabelList"] ?: @[];
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:1];
    
    if (mainArr.count > 0) {
        [mainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = (NSArray *)obj1;
            if (arr.count > 0) {
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    // 为了方便数据处理 把labelMaterialId加塞到下一层模型数据中
                    TDFOrderDetailMaterialVoModel *detailModel = [TDFOrderDetailMaterialVoModel modelWithDictionary:obj2];
                    detailModel.labelMaterialId = model.labelMaterialId;
                    [tempArr addObject:detailModel];
                    
                }];
                
            }
            
            if (arr.count % 4 != 0) {
                for (int i = 0; i < 4 - arr.count % 4; i++) {
                    [tempArr addObject:[TDFOrderDetailMaterialVoModel modelWithDictionary:@{}]];
                }
            }
            
        }];
    }
    
    model.mainMaterialLabelList = tempArr.copy;
    
    return model;
}
@end


