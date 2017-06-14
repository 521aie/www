//
//  IEditItemImageEvent.h
//  RestApp
//
//  Created by zxh on 14-7-17.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol IEditItemImageEvent <NSObject>

@optional
/**
 * 图片确认.
 */
- (void)onConfirmImgClick:(NSInteger)btnIndex;

/**
 * 图片确认，带标记(区分多个上传时使用).
 */
- (void)onConfirmImgClickWithTag:(NSInteger)btnIndex tag:(NSInteger)tag;

/**
 * 删除图片.
 */
- (void)onDelImgClick;

/**
 * 删除图片,带标记.
 */
- (void)onDelImgClickWithTag:(NSInteger)tag;

/**
 * 删除图片,带路径.
 */
- (void)onDelImgClickWithPath:(NSString *)path;

/**
 * 重新刷新界面尺寸.
 */
- (void)updateViewSize;

@end
