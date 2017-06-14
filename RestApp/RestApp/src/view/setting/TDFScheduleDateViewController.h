//
//  TDFScheduleDateViewController.h
//  RestApp
//
//  Created by xueyu on 2016/11/7.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFRootViewController.h"
typedef void (^SelectCompletionBlock)(NSArray *);
@interface TDFScheduleDateViewController : TDFRootViewController
@property (nonatomic, strong) NSMutableArray *selectDatas;
@property (nonatomic, copy) SelectCompletionBlock completionBlock;
@end
