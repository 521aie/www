//
//  TDFTextAdEditViewController.h
//  RestApp
//
//  Created by Octree on 7/12/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDFTextEditViewController : UIViewController

@property (strong, nonatomic) void (^finishBlock)(NSString *text);
@property (nonatomic) BOOL forbiddenNewLine;

/** 初始化
 * @parameter title: Nav Title
 * @parameter text: origin text
 * @parameter limit: text length limit
 * @parameter placeholder: placeholder
 * @parameter prompt: text for prompt label
**/
- (instancetype)initWithTitle:(NSString *)title
                         text:(NSString *)text
                        limit:(NSInteger)limit
                  placeholder:(NSString *)placeholder
                       prompt:(NSString *)prompt;


@end
