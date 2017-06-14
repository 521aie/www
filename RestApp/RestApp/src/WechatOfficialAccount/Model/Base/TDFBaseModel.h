//
//  TDFBaseModel.h
//  RestApp
//
//  Created by Octree on 9/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDFBaseModel : NSObject

@property (nonatomic, copy) NSString *_id;

//   版本号.
@property (nonatomic, assign) int lastVer;

//   记录创建时间.
@property (nonatomic, assign) long createTime;

//   修改时间.
@property (nonatomic, assign) long opTime;

//   是否有效.
@property (nonatomic, assign) int isValid;

@end
