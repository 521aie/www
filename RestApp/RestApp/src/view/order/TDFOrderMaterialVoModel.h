//
//  TDFOrderMaterialVoModel.h
//  RestApp
//
//  Created by QiYa on 2017/2/4.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TDFOrderDetailMaterialVoModel : NSObject
@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic, copy)NSString *labelId;
@property (nonatomic, copy)NSString *labelMaterialId; // 为方便数据处理，从上一层模型人工加塞而来，接口数据不直接返回
@property (nonatomic, copy)NSString *labelName;
@property (nonatomic, assign)int sortCode;

+ (instancetype)modelWithDictionary:(NSDictionary*)dic;
@end

@interface TDFOrderMaterialVoModel : NSObject
@property (nonatomic, assign)BOOL isAllSelected;
@property (nonatomic, copy)NSString *labelMaterialId;
@property (nonatomic, copy)NSString *labelMaterialName;
@property (nonatomic, copy)NSArray<TDFOrderDetailMaterialVoModel *> *mainMaterialLabelList;

+ (instancetype)modelWithDictionary:(NSDictionary*)dic;
@end


