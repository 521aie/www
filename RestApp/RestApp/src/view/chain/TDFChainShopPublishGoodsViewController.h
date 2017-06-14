//
//  TDFChainShopPublishGoodsViewController.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/20.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDFRootViewController.h"
#import "MultiCheckHandle.h"

#define PULIMENUDefine  14 //标识商品
#define PULISHOPDefine  15 //标识门店
#define  PUBLIFAILURESHSTATUS  2 //发布失败
@interface TDFChainShopPublishGoodsViewController : TDFRootViewController<MultiCheckHandle>
@property (nonatomic ,strong) NSDictionary *dic;
@end
