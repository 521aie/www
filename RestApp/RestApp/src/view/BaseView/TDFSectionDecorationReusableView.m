//
//  TDFSectionDecorationReusableView.m
//  RestApp
//
//  Created by 黄河 on 2016/10/28.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFSectionDecorationReusableView.h"

@implementation TDFSectionDecorationReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        self.layer.cornerRadius = 8;
    }
    return self;
}
@end
