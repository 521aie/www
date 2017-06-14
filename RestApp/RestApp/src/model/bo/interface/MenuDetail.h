//
//  MenuDetail.h
//  RestApp
//
//  Created by zxh on 14-5-5.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "IImageData.h"
#import "BaseMenuDetail.h"

@interface MenuDetail : BaseMenuDetail<IImageData>

/**
 * <code>服务器地址</code>.
 */
@property (nonatomic,retain) NSString *server;
/**
 * <code>服务器位置路径</code>.
 */
@property (nonatomic,retain) NSString *path;

@property (nonatomic,retain) NSString *filePath;

@property (nonatomic,retain) NSString *type;
@end
