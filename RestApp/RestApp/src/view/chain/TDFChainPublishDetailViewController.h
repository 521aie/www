//
//  TDFChainPublishDetailViewController.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/21.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFRootViewController.h"

typedef NS_ENUM(NSInteger,ActionType) {
    
    TDFActionSucess = 0, //发布成功
    
    TDFActionFail, //发布失败

};
@interface TDFChainPublishDetailViewController : TDFRootViewController
@property (nonatomic ,strong) NSDictionary *dic ;

@end
