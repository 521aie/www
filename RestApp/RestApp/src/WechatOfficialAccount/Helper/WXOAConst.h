//
//  WXOAConst.h
//  RestApp
//
//  Created by Octree on 9/1/17.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#ifndef WXOAConst_h
#define WXOAConst_h

#if !defined(WXOALocalizedString)
/**
 从 WechatMarketing.strings 文件获取 localized string

 @param key key
 @return localized string
 */
#   define WXOALocalizedString(key) NSLocalizedStringFromTable(key, @"WechatMarketing", nil)
#endif

#if !defined(WXOALocalizedFormat)
#   define WXOALocalizedFormat(key,...) \
    [NSString stringWithFormat:NSLocalizedStringFromTable(key, @"WechatMarketing", nil), __VA_ARGS__]
#endif

#endif /* WXOAConst_h */
