//
//  TDFLabelFactory.h
//  RestApp
//
//  Created by Octree on 3/2/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDFComponentFactory.h"

typedef NS_ENUM(NSInteger, TDFLabelType) {
    TDFLabelTypeTitle,
    TDFLabelTypeSubTitle,
    TDFLabelTypeContent,
    TDFLabelTypeComment,
};

@interface TDFLabelFactory : TDFComponentFactory

- (UILabel *)labelForType:(TDFLabelType)type;

@end
