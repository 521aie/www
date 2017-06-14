//
//  TDFSettingService.h
//  RestApp
//
//  Created by hulatang on 16/7/29.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFHTTPClient.h"
#import "Platform.h"
#import "ShopDetail.h"
#import "ShopTemplate.h"
#import "TimeArrangeVO.h"
#import "OpenTimePlan.h"
#import "KindPayDetailOption.h"
#import "DiscountPlan.h"
#import "FeePlan.h"
#import "AreaFeePlan.h"
#import "KindPay.h"
#import "DicItem.h"
#import "TailDeal.h"
#import "RestConstants.h"
#import "KindMenuStyleVO.h"
#import "TDFResponseModel.h"

@interface TDFSettingService : NSObject

///获取必选商品列表
- (nullable NSURLSessionDataTask *)getMustSelectGoodsList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                  failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

///获取所有商品列表（必选商品设置用）
- (nullable NSURLSessionDataTask *)getAllSelectGoodsList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                 failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
///保存必选商品设置
- (nullable NSURLSessionDataTask *)saveForceMenuWith:(nonnull NSDictionary *)param and:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

///删除必选商品
- (nullable NSURLSessionDataTask *)deleteForceMenuWith:(nonnull NSDictionary *)param and:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                             failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
///获取所需餐盒列表
- (nullable NSURLSessionDataTask *)getBoxSelectList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                 failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

///得到贷款公司列表
- (nullable NSURLSessionDataTask *)getLoanCompanyListWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                  failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

///保存贷款协议
- (nullable NSURLSessionDataTask *)saveLoanAgreementWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                 failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//获取商户贷款状态
- (nullable NSURLSessionDataTask *)getShopLoanStatusWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                 failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//向服务器发送点击分享链接的类型
- (nullable NSURLSessionDataTask *)sendHistoryWithParam:(nonnull NSDictionary *)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                                 failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

/**
 *  店家LOGO 查询
 */
- (void)loadShopLogoImageWithCallBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;


/**
 *  店家LOGO save
 */
- (void)saveShopLogoImageWithShopImage:(nonnull NSString *)shopImage callBack:(nonnull void (^)(TDFResponseModel *_Nonnull))callBack;


/**
 *   保存自动领券开关设置
 */

- (nullable NSURLSessionDataTask *)savePacketWithParam:(nonnull NSDictionary *)params
                                           sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock
                                          failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


//加载餐店基础设置
- (nullable NSURLSessionDataTask *)obtainBaseShopDetailSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//餐店基础设置保存
- (nullable NSURLSessionDataTask *)saveBaseShopDetail:(ShopDetail *_Nonnull)shopdetail sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//加载打折方案列表
- (nullable NSURLSessionDataTask *) listDiscountPlanSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//加载营业时间
- (nullable NSURLSessionDataTask *) loadOpenTimePlanSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存营业时间
- (nullable NSURLSessionDataTask *) updateOpenTimePlan:(OpenTimePlan *_Nonnull)plan sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//加载营业班次
- (nullable NSURLSessionDataTask *) listTimeArrangeSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存营业班次
- (nullable NSURLSessionDataTask *) saveTimeArrange:(TimeArrangeVO *_Nonnull)timeArrange sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//删除营业班次
- (nullable NSURLSessionDataTask *) removeTimeArrange:(NSString *_Nonnull)objId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//加载挂账列表
- (nullable NSURLSessionDataTask *) listSignBillKindPaySucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存挂账信息
- (nullable NSURLSessionDataTask *) saveSignBillKindPay:(KindPay*_Nonnull)kindPay signers:(NSMutableArray*_Nonnull)signers sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//更新挂账信息
- (nullable NSURLSessionDataTask *) updateSignBillKindPay:(KindPay*_Nonnull)kindPay signers:(NSMutableArray*_Nonnull)signers signerIds:(NSMutableArray*_Nonnull)signerIds  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

////保存信息
//- (nullable NSURLSessionDataTask *) updateSignBillKindPay:(KindPay*_Nonnull)kindPay signers:(NSMutableArray*_Nonnull)signers signerIds:(NSMutableArray*_Nonnull)signerIds  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//添加挂账人
- (nullable NSURLSessionDataTask *) saveKindPayDetailOption:(KindPayDetailOption*_Nonnull)option  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//更新挂账人
- (nullable NSURLSessionDataTask *) updateKindPayDetailOption:(KindPayDetailOption*_Nonnull)option  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//更新本店签字人
//- (nullable NSURLSessionDataTask *) updateKindPayDetailOption:(KindPayDetailOption*_Nonnull)option  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//付款方式新增
- (nullable NSURLSessionDataTask *) saveKindPay:(KindPay*_Nonnull)kindPay  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//更新付款方式
- (nullable NSURLSessionDataTask *) updateKindPay:(KindPay*_Nonnull)kindPay  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//代金券面额保存
- (nullable NSURLSessionDataTask *) saveVoucher:(NSDictionary *_Nonnull)param  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;


//代金券面额删除
- (nullable NSURLSessionDataTask *) deleteVoucher:(NSDictionary *_Nonnull)param sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//付款方式删除
- (nullable NSURLSessionDataTask *) removeKindPays:(NSMutableArray *_Nonnull)ids sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//付款方式排序
- (nullable NSURLSessionDataTask *) sortKindPays:(NSMutableArray *_Nonnull)ids sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;




//加载付款方式的签字员工
- (nullable NSURLSessionDataTask *) listSignBillDetailOption:(NSString *_Nonnull)kindPayId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//删除签字员工
- (nullable NSURLSessionDataTask *) removeKindPayDetailOptions:(NSMutableArray*_Nonnull)ids  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存付款方式的签字员工
- (nullable NSURLSessionDataTask *) saveSignBillRelation:(NSString *_Nonnull)kindPayId signers:(NSString *_Nonnull)signer sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//签字人排序
- (nullable NSURLSessionDataTask *) sortKindPayDetailOptions:(NSMutableArray*_Nonnull)ids detailId:(NSString*_Nonnull)detailId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//收银单据模板列表
- (nullable NSURLSessionDataTask *) listShopTemplateSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//收银单据模板修改
- (nullable NSURLSessionDataTask *) updateShopTemplate:(ShopTemplate*_Nonnull)shopTemplate sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//加载打印模板
- (nullable NSURLSessionDataTask *) listPrintTemplateVOs:(NSString*_Nonnull)templateType lineWidth:(NSString*_Nonnull)width  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//加载营业短信联系人
- (nullable NSURLSessionDataTask *) listLinkManSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//设置服务列表(如客单备注列表)
- (nullable NSURLSessionDataTask *) listDicItem:(NSString*_Nonnull)code sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
//设置服务保存
- (nullable NSURLSessionDataTask *) saveDicItem:(DicItem*_Nonnull)dicItem code:(NSString*_Nonnull)code  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//设置服务批量删除
- (nullable NSURLSessionDataTask *) removeDicItems:(NSMutableArray*_Nonnull)ids code:(NSString*_Nonnull)code  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//	设置服务排序
- (nullable NSURLSessionDataTask *) sortDicItems:(NSMutableArray*_Nonnull)ids code:(NSString*_Nonnull)code  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//尾数处理列表
- (nullable NSURLSessionDataTask *)  listTailDealSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//尾数处理保存
- (nullable NSURLSessionDataTask *)  aveTailDeal:(TailDeal*_Nonnull)tailDeal sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//尾数处理删除
- (nullable NSURLSessionDataTask *) removeTailDeals:(NSMutableArray*_Nonnull)idLIst sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
//操作原因列表
- (nullable NSURLSessionDataTask *) listReasonsSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//电子菜谱排版列表
- (nullable NSURLSessionDataTask *) listKindMenuStyleSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//电子菜谱排版更新
- (nullable NSURLSessionDataTask *) updateKindMenuStyle:(KindMenuStyleVO* _Nonnull)kindMenuStyleVO sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//打折方案明细
- (nullable NSURLSessionDataTask *) editDiscountPlanItemId:(NSString *_Nonnull)itemId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//打折方案保存
- (nullable NSURLSessionDataTask *)  saveDiscountPlan:(DiscountPlan*_Nonnull)discountPlan isAllKind:(NSString*_Nonnull)isAllKindStr userIds:(NSMutableArray*_Nonnull)userIds kindIds:(NSMutableArray*_Nonnull)kindIds menuIds:(NSMutableArray*_Nonnull)menuIds sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//打折方案更新
- (nullable NSURLSessionDataTask *) updateDiscountPlan:(DiscountPlan*_Nonnull)discountPlan isAllKind:(NSString*_Nonnull)isAllKindStr userIds:(NSMutableArray*_Nonnull)userIds kindIds:(NSMutableArray*_Nonnull)kindIds menuIds:(NSMutableArray*_Nonnull)menuIds sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//打折方案删除
- (nullable NSURLSessionDataTask *) removeDiscountPlan:(NSString*_Nonnull)objId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//打折方案排序
- (nullable NSURLSessionDataTask *) sortDiscountPlans:(NSMutableArray*)ids sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//解绑收银机
- (nullable NSURLSessionDataTask *) cancelBindSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//解绑情况
- (nullable NSURLSessionDataTask *) searchQueueBindSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//解绑排队机
- (nullable NSURLSessionDataTask *) cancelQueueBindSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//列出所有的附加费列表
- (nullable NSURLSessionDataTask *)  listFeePlanSucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//列出绑定附加费的区域
- (nullable NSURLSessionDataTask *) listAreaFeePlanId:(NSString *_Nonnull)feePlanId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//删除附加费
- (nullable NSURLSessionDataTask *) removeFeePlan:(NSString* _Nonnull)objId sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存附加费
- (nullable NSURLSessionDataTask *) saveFeePlan:(FeePlan*_Nonnull)feePlan ids:(NSMutableArray*_Nonnull)ids area:(AreaFeePlan*_Nonnull)areaFeePlan sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//更新附加费
- (nullable NSURLSessionDataTask *) updateFeePlan:(FeePlan*_Nonnull)feePlan ids:(NSMutableArray*_Nonnull)ids area:(AreaFeePlan*_Nonnull)areaFeePlan sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//系统参数列表
- (nullable NSURLSessionDataTask *)  listConfig:(NSString *_Nonnull)kindCode sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//系统参数保存
- (nullable NSURLSessionDataTask *) saveConfig:(NSMutableArray *_Nonnull)ids sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//收银打印列表
- (nullable NSURLSessionDataTask *) loadPrintPara:(NSString *_Nonnull)kindCode sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//收银打印保存
- (nullable NSURLSessionDataTask *)savePrintParaConfig:(NSMutableArray*_Nonnull)ids shopLogo:(NSString *_Nonnull)logo memo:(NSString*_Nonnull)shopMemo sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;

//保存店家图片信息Logo
- (nullable NSURLSessionDataTask *)saveShopImgFilePath:(NSString *_Nonnull)filePath  sucessBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))sucessBlock failureBlock:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;



@end
