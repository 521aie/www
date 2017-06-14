//
//  TDFFunctionPopView.h
//  RestApp
//
//  Created by 黄河 on 2016/10/19.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDFFunctionKindVo;
@class TDFForwardGroup;
@interface TDFFunctionPopView : UIView

@property (nonatomic, copy)void(^backBlock)();

- (void)loadDataWithFunctionKindVo:(TDFFunctionKindVo *)kindVo
                      andIndexPath:(NSIndexPath *)indexPath;

- (void)loadDataWithKindVo:(TDFForwardGroup *)kindVo
                      andIndexPath:(NSIndexPath *)indexPath;
@end
