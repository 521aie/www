//
//  PlateBranchVo.h
//  RestApp
//
//  Created by iOS香肠 on 2016/10/23.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlateShopVoList.h"
@interface PlateBranchVo : NSObject <INameValueItem>


/**
 * branch id
 */
@property(nonatomic, strong) NSString *branchEntityId;
/**
 * 品牌下的门店
 */
@property (nonatomic ,strong)NSMutableArray *plateShopVoList;
/**
    品牌名称
 **/
@property (nonatomic ,strong)NSString * brandName;

@property (nonatomic ,strong)NSString *branchName;

@property(nonatomic, assign) BOOL isSelected;

- (void) setIsSelect:(BOOL)isSelect;


@end
