//
//  TDFTransService.m
//  RestApp
//
//  Created by 黄河 on 16/9/6.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTransService.h"
#import "YYModel.h"
#import "JsonHelper.h"

@implementation TDFTransService
+ (instancetype)shareInstance
{
    static TDFTransService *service = nil;
    static dispatch_once_t onceTime;
    dispatch_once(&onceTime, ^{
        if (!service) {
            service = [[TDFTransService alloc] init];
        }
    });
    return service;
}

- (TDFRequestModel *)getRequestModelWithPath:(NSString *)path params:(NSDictionary *)params{
    
    TDFRequestModel *requestModel = [[TDFRequestModel alloc] init];
    requestModel.requestType = TDFHTTPRequestTypePOST;
    requestModel.serverRoot = kTDFBossAPI;
    requestModel.serviceName = path;
    requestModel.signType = TDFHTTPRequestSignTypeBossAPI;
    requestModel.timeout =  60;
    
    NSMutableDictionary *mutableParams = params? [params mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:1];
    mutableParams[@"session_key"] = [[Platform Instance] getkey:SESSION_KEY];
    
    requestModel.parameters = [mutableParams copy];
    
    return requestModel;
}


- (NSURLSessionDataTask *)getRequestSessionDataTaskWithRequestModel:(TDFRequestModel *)requestModel sucess:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nonnull))sucessBlock failure:(nullable void (^)(NSURLSessionDataTask * _Nonnull, NSError * _Nonnull))failureBlock
{
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if(model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                sucessBlock(model.sessionDataTask,model.responseObject);
            }else{
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

///获取一菜一切列表
- (nullable NSURLSessionDataTask *)getSuitMenuPrinterList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/cash/v2/get_kind_menu_print_settings" params:nil];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;

}

///添加不需要一菜一切的打印设置
- (nullable NSURLSessionDataTask *)updateSuitMenuPrinterInfoWithKindMenuIDs:(NSString *)kindMenuIDs success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/cash/v1/add_kind_menu_print_settings" params:@{@"kind_menu_ids":kindMenuIDs}];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (nullable NSURLSessionDataTask *)pantryListWithParam:(NSMutableDictionary *)param success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock;
{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v2/list" params: param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (nullable NSURLSessionDataTask *) savePantry:(Pantry*_Nonnull)pantry isAllArea:(NSInteger)isAllArea plateEntityId:(NSString *)plateEntityId success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
     [params setObject:[NSString stringWithFormat:@"%ld",(long)isAllArea] forKey:@"is_all_area"];
    params[@"plate_entity_id"] = plateEntityId;
     [params setObject:[pantry yy_modelToJSONString] forKey:@"pantry_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pantry/v2/save" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (nullable NSURLSessionDataTask *) updatePantry:(Pantry*_Nonnull)pantry isAllArea:(NSInteger)isAllArea  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)isAllArea] forKey:@"is_all_area"];
    [params setObject:[pantry yy_modelToJSONString] forKey:@"pantry_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"pantry/v2/update" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (nullable NSURLSessionDataTask *) removePantry:(NSString*_Nonnull)pantryId lastVer:(NSInteger)lastVer  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)lastVer] forKey:@"last_ver"];
    [params setObject:pantryId forKey:@"pantry_id"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v1/remove" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

- (nullable NSURLSessionDataTask *) listPantryDetail:(NSString*_Nonnull)pantryId  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:pantryId forKey:@"pantry_id"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v1/list_detail" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

- (nullable NSURLSessionDataTask *) endKindPantryList:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v1/list_end_kind" params: params];
//    requestModel.serverRoot = @"http://mock.2dfire-daily.com/mock-serverapi/mockjsdata/209";
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}
//pantryId:(NSString*_Nonnull)pantryId
-  (nullable NSURLSessionDataTask *) saveKindProducePlan:(NSMutableArray*_Nonnull )kindIds  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
//    [params setObject:pantryId forKey:@"pantry_id"];
    [params setObject:[JsonHelper arrTransJson:kindIds] forKey:@"ids_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v1/save_kind" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

-  (nullable NSURLSessionDataTask *) saveMenuProducePlan:(NSMutableArray*_Nonnull)menuIds pantryId:(NSString*_Nonnull)pantryId  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:pantryId forKey:@"pantry_id"];
    [params setObject:[JsonHelper arrTransJson:menuIds] forKey:@"ids_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v1/save_menu" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

-  (nullable NSURLSessionDataTask *) emoveMenuProducePlan:(NSString*_Nonnull)kindMenuId  isKind:(BOOL)isKind   lastVer:(NSInteger)lastVer  success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    if (isKind) {
        [params setObject:kindMenuId forKey:@"id"];
    }
    else
    {
         [params setObject:kindMenuId forKey:@"id"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld",lastVer] forKey:@"last_ver"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v1/remove_menu_or_kind" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

-  (nullable NSURLSessionDataTask *) saveArea:(NSMutableArray*_Nonnull)areaIds success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
//    [params setObject:pantryId forKey:@"pantry_id"];
    [params setObject:[JsonHelper arrTransJson:areaIds] forKey:@"area_ids_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v1/save_area" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

-  (nullable NSURLSessionDataTask *) delArea:(NSString*_Nonnull)pantryPlanAreaId  lastVer:(NSInteger)lastVer success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:pantryPlanAreaId forKey:@"pantry_area_id"];
    [params setObject:[NSString stringWithFormat:@"%ld",lastVer] forKey:@"last_ver"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry/v1/remove_area" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

-  (nullable NSURLSessionDataTask *) listBackupPrinter:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/backup_printer/v1/list" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

-  (nullable NSURLSessionDataTask *) saveBackupPrinter:(BackupPrinter* _Nonnull)backupPrinter success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:[backupPrinter yy_modelToJSONString] forKey:@"backup_printer_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/backup_printer/v1/save" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

-  (nullable NSURLSessionDataTask *) updateBackupPrinter:(BackupPrinter*_Nonnull)backupPrinter success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:[backupPrinter yy_modelToJSONString] forKey:@"backup_printer_str"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/backup_printer/v1/update" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

-  (nullable NSURLSessionDataTask *) removeBackupPrinter:(NSString*_Nonnull)objId lastVer:(NSInteger)lastVer success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:objId forKey:@"backup_printer_id"];
    [params setObject:[NSString stringWithFormat:@"%ld",lastVer] forKey:@"last_ver"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/backup_printer/v1/remove" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

-  (nullable NSURLSessionDataTask *) listNoPrintMenuSampleWithParam:(NSMutableDictionary *)param success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry_menu/v2/list_no_print" params: param];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
}

-  (nullable NSURLSessionDataTask *) updateIsPrint:(NSMutableArray*_Nonnull)ids flag:(NSString*_Nonnull)flag success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setObject:[JsonHelper arrTransJson:ids] forKey:@"ids_str"];
    [params  setObject:flag forKey:@"flag"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry_menu/v2/update_no_print" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

-  (nullable NSURLSessionDataTask *) saveNoPrintChain:(NSMutableArray*_Nonnull)ids plateEntityId:(NSString*_Nonnull)plateEntityId success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    params[@"ids_str"] = [JsonHelper arrTransJson:ids] ;
    params[@"plate_entity_id"] = plateEntityId;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry_menu/v1/save_no_print_4_chain" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

-  (nullable NSURLSessionDataTask *) delateNoPrintChain:(NSMutableArray*_Nonnull)ids success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    params[@"relation_ids_str"] = [JsonHelper arrTransJson:ids] ;
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"/pantry_menu/v1/delete_no_print_4_chain" params: params];
    NSURLSessionDataTask *task = [[TDFHTTPClient sharedInstance] sendRequestWithRequestModel:requestModel progress:nil callback:^(TDFResponseModel * _Nullable model) {
        if (model.error) {
            failureBlock(model.sessionDataTask,model.error);
        }else
        {
            NSInteger code = [model.responseObject[@"code"] integerValue];
            if (code == 1) {
                successBlock(model.sessionDataTask,model.responseObject);
            }else
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:model.responseObject[@"message"] forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"TDF" code:code userInfo:userInfo];
                failureBlock(model.sessionDataTask,error);
            }
        }
    }];
    return task;
    
}

-  (nullable NSURLSessionDataTask *) getAreaPrinterListSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entity_id"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"print/v1/get_print_list" params:param];
    NSURLSessionDataTask *task = [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:successBlock failure:failureBlock];
    return task;
}

-  (nullable NSURLSessionDataTask *) getAreaPrinterById:(NSString *_Nonnull)printerId success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:[[Platform Instance] getkey:ENTITY_ID] forKey:@"entity_id"];
    [param setObject:printerId forKey:@"id"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"print/v1/get_print_by_id" params:param];
    NSURLSessionDataTask *task = [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:successBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)listDicSysItems:(NSString*_Nonnull)code success:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:code forKey:@"dic_code"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sys_mobile/v1/list_dic_sys_item" params:param];
    NSURLSessionDataTask *task = [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:successBlock failure:failureBlock];
    return task;
}

- (nullable NSURLSessionDataTask *)getPrintTypeNameSuccess:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, id _Nonnull data))successBlock failure:(nonnull void(^)(NSURLSessionDataTask *_Nonnull task, NSError *_Nonnull error))failureBlock
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"PRINTER_TYPE" forKey:@"dic_code"];
    TDFRequestModel *requestModel = [self getRequestModelWithPath:@"sys_mobile/v1/list_dic_sys_item" params:param];
    NSURLSessionDataTask *task = [self getRequestSessionDataTaskWithRequestModel:requestModel sucess:successBlock failure:failureBlock];
    return task;
    
}


@end
