//
//  TDFFunctionTableViewCell.h
//  RestApp
//
//  Created by 黄河 on 2016/10/19.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TDFFunctionVo;
@interface TDFFunctionTableViewCell : UITableViewCell

@property (nonatomic, strong)UIView *shadowView;

@property (nonatomic, strong)UIControl *rightControl;

@property (nonatomic, copy)void (^selectBlock)(TDFFunctionTableViewCell *cell);

- (void)initWithData:(TDFFunctionVo *)data;
@end
