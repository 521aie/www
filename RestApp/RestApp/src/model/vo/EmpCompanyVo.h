//
//  EmpCompanyVo.h
//  RestApp
//
//  Created by chaiweiwei on 16/7/12.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MemberUserVo.h"
#import "BranchTreeVo.h"

@interface EmpCompanyVo : MTLModel<MTLJSONSerializing>

//连锁总部
@property (nonatomic,copy) MemberUserVo *brandVo;
//分公司
@property (nonatomic,copy) NSArray *branchVoList;
//门店
@property (nonatomic,copy) NSArray *shopVoList;

@end
