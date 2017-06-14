//
//  TDFCollectionViewFlowLayout.h
//  RestApp
//
//  Created by 黄河 on 2016/10/28.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, strong)NSMutableArray *itemAttributes;
@property (nonatomic, assign)CGFloat sectionHeight;///透明蒙层在headerview的高度
@end
