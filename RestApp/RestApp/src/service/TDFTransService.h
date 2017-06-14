//
//  TDFTransService.h
//  RestApp
//
//  Created by 黄河 on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"
#import "Platform.h"
#import "RestConstants.h"
#import "TDFResponseModel.h"
#import "Pantry.h"
#import "BackupPrinter.h"
@interface TDFTransService : NSObject

+ (instancetype)shareInstance;

///获取一菜一切列表
- (nullable NSURLSessionDataTask *)getSuitMenuPrinterList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

///添加不需要一菜一切的打印设置
- (nullable NSURLSessionDataTask *)updateSuitMenuPrinterInfoWithKindMenuIDs:(NSString *_Nonnull)kindMenuIDs success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//传菜方案列表
- (nullable NSURLSessionDataTask *)pantryListWithParam:(NSMutableDictionary *_Nullable)param success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存传菜方案
- (nullable NSURLSessionDataTask *) savePantry:(Pantry*_Nonnull)pantry isAllArea:(NSInteger)isAllArea plateEntityId:(NSString *_Nullable)plateEntityId success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//更新传菜方案
- (nullable NSURLSessionDataTask *) updatePantry:(Pantry*_Nonnull)pantry isAllArea:(NSInteger)isAllArea  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//删除传菜方案
- (nullable NSURLSessionDataTask *) removePantry:(NSString*_Nonnull)pantryId lastVer:(NSInteger)lastVer  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//获取传菜方案所关联的商品分类、商品、区域
- (nullable NSURLSessionDataTask *) listPantryDetail:(NSString*_Nonnull)pantryId  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//得到末级分类(传菜分类)
- (nullable NSURLSessionDataTask *) endKindPantryList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存使用此设备传菜的商品分类（传菜分类）  pantryId:(NSString*_Nonnull)pantryId 
-  (nullable NSURLSessionDataTask *) saveKindProducePlan:(NSMutableArray*_Nonnull )kindIds success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存使用此设备传菜的商品
-  (nullable NSURLSessionDataTask *) saveMenuProducePlan:(NSMutableArray*_Nonnull)menuIds pantryId:(NSString*_Nonnull)pantryId  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//删除使用此设备传菜的商品分类或者商品
-  (nullable NSURLSessionDataTask *) emoveMenuProducePlan:(NSString*_Nonnull)kindMenuId  isKind:(BOOL)isKind   lastVer:(NSInteger)lastVer  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存使用此设备传菜的区域
-  (nullable NSURLSessionDataTask *) saveArea:(NSMutableArray*_Nonnull)areaIds  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//删除使用此设备传菜的区域
-  (nullable NSURLSessionDataTask *) delArea:(NSString*_Nonnull)pantryPlanAreaId  lastVer:(NSInteger)lastVer success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//得到所有的原/备用打印机ip
-  (nullable NSURLSessionDataTask *) listBackupPrinter:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//新增备用打印机ip
-  (nullable NSURLSessionDataTask *) saveBackupPrinter:(BackupPrinter* _Nonnull)backupPrinter success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//修改备用打印机ip
-  (nullable NSURLSessionDataTask *) updateBackupPrinter:(BackupPrinter*_Nonnull)backupPrinter success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//删除备用打印机ip
-  (nullable NSURLSessionDataTask *) removeBackupPrinter:(NSString*_Nonnull)objId lastVer:(NSInteger)lastVer success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//加载未出单商品
-  (nullable NSURLSessionDataTask *) listNoPrintMenuSampleWithParam:(NSMutableDictionary *_Nullable)param success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//更新未出单商品
-  (nullable NSURLSessionDataTask *) updateIsPrint:(NSMutableArray*_Nonnull)ids flag:(NSString*_Nonnull)flag success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

-  (nullable NSURLSessionDataTask *) saveNoPrintChain:(NSMutableArray*_Nonnull)ids plateEntityId:(NSString*_Nonnull)plateEntityId success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

-  (nullable NSURLSessionDataTask *) delateNoPrintChain:(NSMutableArray*_Nonnull)ids success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查询打印区域列表
-  (nullable NSURLSessionDataTask *) getAreaPrinterListSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//查询单条打印设置
-  (nullable NSURLSessionDataTask *) getAreaPrinterById:(NSString *_Nonnull)printerId success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


//挂账处理-还款- 获取付款方式
- (nullable NSURLSessionDataTask *)listDicSysItems:(NSString*_Nonnull)code success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//传菜 - 详情页获取打印机相关信息
- (nullable NSURLSessionDataTask *)getPrintTypeNameSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


@end
