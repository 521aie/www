//
//  NSString+Sino.h
//  RestApp
//
//  Created by Octree on 12/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Sino)

@property (nonatomic, readonly) NSUInteger tdf_sinoCharactorCount;
@property (nonatomic, readonly) NSUInteger tdf_asciiCharactorCount;
//  一个汉字相当于两个字母
@property (nonatomic, readonly) NSUInteger tdf_byteLength;
//  一个汉字相当于两个字母
- (NSString *)tdf_substringWithByteLength:(NSInteger)length;

@end
