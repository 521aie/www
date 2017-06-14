//
//  TDFLabelFactory.m
//  RestApp
//
//  Created by Octree on 3/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFLabelFactory.h"
#import "UIColor+Hex.h"

@implementation TDFLabelFactory


- (UILabel *)labelForType:(TDFLabelType)type {

    UILabel *label = [[UILabel alloc] init];

    UIColor *color;
    UIFont *font;
    switch (type) {
        case TDFLabelTypeTitle:
            font = [UIFont boldSystemFontOfSize:18];
            color = [UIColor colorWithHeX:0x333333];
            break;
        case TDFLabelTypeSubTitle:
            font = [UIFont systemFontOfSize:13];
            color = [UIColor colorWithHeX:0x666666];
            break;
        case TDFLabelTypeContent:
            font = [UIFont systemFontOfSize:15];
            color = [UIColor colorWithHeX:0x333333];
            break;
        case TDFLabelTypeComment:
            font = [UIFont systemFontOfSize:11];
            color = [UIColor colorWithHeX:0x666666];
            break;
    }
    
    label.textColor = color;
    label.font = font;
    return label;
}



@end
