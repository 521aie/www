//
//  TDFScheduleDayCell.h
//  RestApp
//
//  Created by xueyu on 2016/11/7.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameValueItem.h"
//@interface TDFScheduleDay : NSObject<INameValueItem>
//
//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, assign) BOOL isSelect;
//
//@end

@interface TDFScheduleDayCell : UICollectionViewCell
-(void)initData:(id)title datas:(NSArray *)datas;
@end
